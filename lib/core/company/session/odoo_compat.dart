import 'package:odoo_rpc/odoo_rpc.dart';

/// Base64 text of an Odoo binary field value, or '' when it holds none.
///
/// Up to 19 a binary field reads as a base64 string (or false); 20 returns
/// `{'content': <base64>, 'size': …, 'filename': …}` instead.
String odooBinaryToBase64(dynamic value) {
  if (value is String) return value;
  if (value is Map && value['content'] is String) {
    return value['content'] as String;
  }
  return '';
}

/// Adapts `call_kw` payloads to the schema of the connected Odoo server, so
/// the same app code works on 17, 18, 19 and 20 without per-version branches.
///
/// Decisions come from the server's own `fields_get` (cached per server,
/// database and model), never from the version number:
///   - `limit: 0` is dropped: up to 18 it meant "no limit", but 19+ honour
///     it literally and return zero rows.
///   - Fields the model doesn't have are stripped from read field lists and
///     from create/write values instead of failing the whole call.
///   - Renamed concepts are aliased both ways: `res.partner.company_type` ↔
///     `is_company`, and the `sale.order.option` /
///     `sale.order.template.option` models ↔ `is_optional` lines.
///   - Binary fields read back as base64 strings, as they did before 20.
class OdooCompat {
  /// Per server/db/model: field name → field type.
  static final Map<String, Future<Map<String, String>?>> _schemas = {};

  static const _optionAliases = {
    'sale.order.option': 'sale.order.line',
    'sale.order.template.option': 'sale.order.template.line',
  };

  /// Field renames applied when an option model is served by its line model.
  static const _optionFieldRenames = {'quantity': 'product_uom_qty'};

  static const _readMethods = {'search_read', 'read'};
  static const _domainMethods = {'search_read', 'search', 'search_count'};

  /// Returns the adapted payload and a function that maps the raw result back
  /// to the shape the caller asked for.
  static Future<(Map<String, dynamic>, dynamic Function(dynamic))> adapt(
      OdooClient client, Map<String, dynamic> payload) async {
    final model = payload['model'] as String?;
    final method = payload['method'] as String?;
    if (model == null || method == null || method == 'fields_get') {
      return (payload, _identity);
    }

    final map = Map<String, dynamic>.from(payload);
    final kwargs = Map<String, dynamic>.from(map['kwargs'] as Map? ?? {});
    final args = List<dynamic>.from(map['args'] as List? ?? []);
    if (kwargs['limit'] == 0) kwargs.remove('limit');

    final needsSchema = _readMethods.contains(method) ||
        _domainMethods.contains(method) ||
        method == 'create' ||
        method == 'write' ||
        _optionAliases.containsKey(model);
    if (!needsSchema) {
      map['kwargs'] = kwargs;
      return (map, _identity);
    }

    String targetModel = model;
    Map<String, String> renames = const {};
    dynamic optionalFlag;

    final aliasTarget = _optionAliases[model];
    if (aliasTarget != null && await _schema(client, model) == null) {
      final targetFields = await _schema(client, aliasTarget);
      if (targetFields != null && targetFields.contains('is_optional')) {
        targetModel = aliasTarget;
        renames = _optionFieldRenames;
        optionalFlag = true;
      }
    } else if (_optionAliases.containsValue(model) &&
        await _optionalLinesAreInline(client, model)) {
      // Regular line queries must not pick up the optional lines that newer
      // servers keep on the same model.
      optionalFlag = false;
    }

    final fieldTypes = await _fieldTypes(client, targetModel);
    if (fieldTypes == null) {
      map['kwargs'] = kwargs;
      return (map, _identity);
    }
    final fields = fieldTypes.keys.toSet();
    final derivesCompanyType = targetModel == 'res.partner' &&
        !fields.contains('company_type') &&
        fields.contains('is_company');

    if (_domainMethods.contains(method)) {
      _mapDomain(args, kwargs, renames, derivesCompanyType,
          optionalFlag: optionalFlag);
    }

    bool addedIsCompany = false;
    // Without an explicit field list Odoo returns every field.
    Iterable<String> readFields = fields;
    if (_readMethods.contains(method)) {
      List<dynamic>? requested;
      void Function(List<dynamic>)? store;
      if (kwargs['fields'] is List) {
        requested = kwargs['fields'] as List;
        store = (v) => kwargs['fields'] = v;
      } else if (method == 'read' && args.length > 1 && args[1] is List) {
        requested = args[1] as List;
        store = (v) => args[1] = v;
      }
      if (requested != null && store != null) {
        final wantsCompanyType = requested.contains('company_type');
        final mapped = <String>{};
        for (final f in requested.whereType<String>()) {
          final name = renames[f] ?? f;
          if (fields.contains(name)) mapped.add(name);
        }
        if (derivesCompanyType && wantsCompanyType) {
          addedIsCompany = mapped.add('is_company');
        }
        // An empty list means "all fields" to Odoo, so keep at least the id.
        store(mapped.isEmpty ? ['id'] : mapped.toList());
        readFields = mapped;
      }
    }
    final binaryFields = _readMethods.contains(method)
        ? readFields.where((f) => fieldTypes[f] == 'binary').toSet()
        : const <String>{};

    if (method == 'create' && args.isNotEmpty) {
      Map<String, dynamic> fix(dynamic vals) => _mapValues(
          vals, fields, renames, derivesCompanyType,
          optionalFlag: optionalFlag == true ? true : null);
      args[0] = args[0] is List
          ? (args[0] as List).map(fix).toList()
          : fix(args[0]);
    } else if (method == 'write' && args.length > 1) {
      args[1] = _mapValues(args[1], fields, renames, derivesCompanyType);
    }

    map['model'] = targetModel;
    map['args'] = args;
    map['kwargs'] = kwargs;

    if (!_readMethods.contains(method) ||
        (renames.isEmpty && !derivesCompanyType && binaryFields.isEmpty)) {
      return (map, _identity);
    }
    return (
      map,
      (dynamic result) => _mapRows(result, renames,
          derivesCompanyType: derivesCompanyType,
          dropIsCompany: addedIsCompany,
          binaryFields: binaryFields)
    );
  }

  static dynamic _identity(dynamic result) => result;

  /// Field names of [model] on this server, or null if it has no such model.
  static Future<Set<String>?> _schema(OdooClient client, String model) async =>
      (await _fieldTypes(client, model))?.keys.toSet();

  /// Field types of [model] on this server, or null if it has no such model
  /// (or the schema couldn't be read, in which case nothing is adapted).
  static Future<Map<String, String>?> _fieldTypes(
      OdooClient client, String model) {
    final key = '${client.baseURL}|${client.sessionId?.dbName}|$model';
    return _schemas[key] ??= () async {
      try {
        final res = await client.callKw({
          'model': model,
          'method': 'fields_get',
          'args': [],
          'kwargs': {
            'attributes': ['type']
          },
        });
        if (res is! Map) return null;
        return {
          for (final e in res.entries)
            e.key.toString():
                e.value is Map ? (e.value['type']?.toString() ?? '') : '',
        };
      } catch (e) {
        // Only a missing model is a stable answer; anything else (network,
        // expired session) must be retried on the next call.
        if (!_isMissingModel(e)) _schemas.remove(key);
        return null;
      }
    }();
  }

  static bool _isMissingModel(Object e) {
    final msg = e.toString().toLowerCase();
    return msg.contains('404') ||
        msg.contains("doesn't exist") ||
        msg.contains('does not exist') ||
        msg.contains('keyerror') ||
        msg.contains('unknown model');
  }

  static Future<bool> _optionalLinesAreInline(
      OdooClient client, String lineModel) async {
    final optionModel = _optionAliases.entries
        .firstWhere((e) => e.value == lineModel)
        .key;
    if (await _schema(client, optionModel) != null) return false;
    return (await _schema(client, lineModel))?.contains('is_optional') ??
        false;
  }

  static void _mapDomain(List<dynamic> args, Map<String, dynamic> kwargs,
      Map<String, String> renames, bool derivesCompanyType,
      {dynamic optionalFlag}) {
    final fromKwargs = kwargs['domain'] is List;
    final source = fromKwargs
        ? kwargs['domain'] as List
        : (args.isNotEmpty && args[0] is List ? args[0] as List : null);
    if (source == null && optionalFlag == null) return;

    final domain = (source ?? []).map((leaf) {
      if (leaf is! List || leaf.length != 3 || leaf[0] is! String) return leaf;
      final field = leaf[0] as String;
      if (derivesCompanyType && field == 'company_type') {
        return _companyTypeLeaf(leaf[1], leaf[2]);
      }
      final renamed = renames[field];
      return renamed == null ? leaf : [renamed, leaf[1], leaf[2]];
    }).toList();

    final mentionsOptional = domain
        .any((leaf) => leaf is List && leaf.isNotEmpty && leaf[0] == 'is_optional');
    if (optionalFlag != null && !mentionsOptional) {
      domain.add(['is_optional', '=', optionalFlag]);
      // Option models never held section/note rows; their line stand-ins do.
      if (optionalFlag == true) domain.add(['display_type', '=', false]);
    }

    if (fromKwargs) {
      kwargs['domain'] = domain;
    } else if (args.isNotEmpty) {
      args[0] = domain;
    } else {
      args.add(domain);
    }
  }

  static List<dynamic> _companyTypeLeaf(dynamic op, dynamic value) {
    if (op == 'in' || op == 'not in') {
      final values = (value as List? ?? []).toSet();
      final wantsCompany = values.contains('company');
      final wantsPerson = values.contains('person');
      if (wantsCompany == wantsPerson) {
        // Both or neither: matches every partner, or none.
        final matchAll = (op == 'in') == wantsCompany;
        return matchAll ? [1, '=', 1] : [0, '=', 1];
      }
      return ['is_company', op == 'in' ? '=' : '!=', wantsCompany];
    }
    return ['is_company', op, value == 'company'];
  }

  static Map<String, dynamic> _mapValues(
      dynamic vals,
      Set<String> fields,
      Map<String, String> renames,
      bool derivesCompanyType,
      {bool? optionalFlag}) {
    if (vals is! Map) return vals;
    final out = <String, dynamic>{};
    vals.forEach((key, value) {
      final name = renames[key] ?? key.toString();
      if (derivesCompanyType && name == 'company_type') {
        out['is_company'] = value == 'company';
      } else if (fields.contains(name)) {
        out[name] = value;
      }
    });
    if (optionalFlag != null) out['is_optional'] = optionalFlag;
    return out;
  }

  static dynamic _mapRows(dynamic result, Map<String, String> renames,
      {required bool derivesCompanyType,
      required bool dropIsCompany,
      Set<String> binaryFields = const {}}) {
    if (result is! List) return result;
    return result.map((row) {
      if (row is! Map) return row;
      final out = Map<String, dynamic>.from(row);
      for (final f in binaryFields) {
        // Empty values stay `false`, which the existing callers check for.
        if (out[f] is Map) out[f] = odooBinaryToBase64(out[f]);
      }
      renames.forEach((original, served) {
        if (out.containsKey(served)) out[original] = out.remove(served);
      });
      if (derivesCompanyType && out.containsKey('is_company')) {
        out['company_type'] = out['is_company'] == true ? 'company' : 'person';
        if (dropIsCompany) out.remove('is_company');
      }
      return out;
    }).toList();
  }
}
