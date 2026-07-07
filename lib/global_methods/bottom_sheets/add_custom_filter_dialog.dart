import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:mobo_crm/utils/date_picker_utils.dart';
import 'package:mobo_crm/utils/snackbar.dart';
import 'package:odoo_rpc/odoo_rpc.dart';

import '../../core/company/session/company_session_manager.dart';
import '../../models/LoginPage/session_model.dart';
import '../../utils/globals.dart';

/// A custom filter rule representing one condition in an advanced filter.
///
/// Used to build domain-like filters for Odoo models (e.g. sale.order, crm.lead, etc.).
class CustomFilterRule {
  String field;
  String operator;
  dynamic value;
  String fieldType;
  List<Map<String, dynamic>>? fieldOptions;

  CustomFilterRule({
    required this.field,
    required this.operator,
    this.value,
    this.fieldType = 'char',
    this.fieldOptions,
  });
}

/// A dialog that allows users to create one or more custom filter rules
/// to be applied to an Odoo model list view (similar to Odoo's "Add Custom Filter").
///
/// Features:
///   • Select fields from the model
///   • Choose appropriate operators per field type
///   • Input values (text, number, date picker, dropdown for relations/selection)
///   • Support for ALL / ANY logic between rules
///   • Visual feedback and loading states
///
/// Usage example:
/// ```dart
/// AddCustomFilterDialog.show(
///   context: context,
///   client: odooClient,
///   session: currentSession,
///   model: 'sale.order',
///   primaryColor: Theme.of(context).primaryColor,
///   onApply: (rules) {
///     // convert rules to Odoo domain and apply filter
///     final domain = rules.map((r) => [r.field, r.operator, r.value]).toList();
///     // ...
///   },
/// );
/// ```
class AddCustomFilterDialog extends StatefulWidget {
  /// Callback invoked when user presses "Apply Filter" with valid rules
  final Function(List<CustomFilterRule>) onApply;

  final OdooClient client;
  final SessionModel session;
  final Color primaryColor;
  final String model;

  const AddCustomFilterDialog({
    Key? key,
    required this.onApply,
    required this.client,
    required this.session,
    this.primaryColor = AppStyle.primaryColor,
    this.model = 'sale.order',
  }) : super(key: key);

  /// Convenience static method to show the dialog
  static void show({
    required BuildContext context,
    required Function(List<CustomFilterRule>) onApply,
    required OdooClient client,
    required SessionModel session,
    Color primaryColor = AppStyle.primaryColor,
    String model = 'sale.order',
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AddCustomFilterDialog(
          onApply: onApply,
          client: client,
          session: session,
          primaryColor: primaryColor,
          model: model,
        );
      },
    );
  }

  @override
  State<AddCustomFilterDialog> createState() => _AddCustomFilterDialogState();
}

class _AddCustomFilterDialogState extends State<AddCustomFilterDialog> {
  /// List of currently defined filter rules
  List<CustomFilterRule> _filterRules = [];

  /// All readable fields of the target model (from fields_get)
  List<Map<String, dynamic>> _availableFields = [];
  bool _isLoadingFields = false;
  String _matchType = 'all';

  final Map<String, List<Map<String, String>>> _operatorsByType = {
    'char': [
      {'value': 'ilike', 'label': 'contains'},
      {'value': '=', 'label': 'is equal to'},
      {'value': '!=', 'label': 'is not equal to'},
      {'value': 'in', 'label': 'is in'},
      {'value': 'not in', 'label': 'is not in'},
    ],
    'text': [
      {'value': 'ilike', 'label': 'contains'},
      {'value': '=', 'label': 'is equal to'},
      {'value': '!=', 'label': 'is not equal to'},
    ],
    'integer': [
      {'value': '=', 'label': 'is equal to'},
      {'value': '!=', 'label': 'is not equal to'},
      {'value': '>', 'label': 'is greater than'},
      {'value': '>=', 'label': 'is greater than or equal to'},
      {'value': '<', 'label': 'is less than'},
      {'value': '<=', 'label': 'is less than or equal to'},
      {'value': 'in', 'label': 'is in'},
      {'value': 'not in', 'label': 'is not in'},
    ],
    'float': [
      {'value': '=', 'label': 'is equal to'},
      {'value': '!=', 'label': 'is not equal to'},
      {'value': '>', 'label': 'is greater than'},
      {'value': '>=', 'label': 'is greater than or equal to'},
      {'value': '<', 'label': 'is less than'},
      {'value': '<=', 'label': 'is less than or equal to'},
    ],
    'monetary': [
      {'value': '=', 'label': 'is equal to'},
      {'value': '!=', 'label': 'is not equal to'},
      {'value': '>', 'label': 'is greater than'},
      {'value': '>=', 'label': 'is greater than or equal to'},
      {'value': '<', 'label': 'is less than'},
      {'value': '<=', 'label': 'is less than or equal to'},
    ],
    'date': [
      {'value': '=', 'label': 'is equal to'},
      {'value': '!=', 'label': 'is not equal to'},
      {'value': '>', 'label': 'is after'},
      {'value': '>=', 'label': 'is after or equal to'},
      {'value': '<', 'label': 'is before'},
      {'value': '<=', 'label': 'is before or equal to'},
    ],
    'datetime': [
      {'value': '=', 'label': 'is equal to'},
      {'value': '!=', 'label': 'is not equal to'},
      {'value': '>', 'label': 'is after'},
      {'value': '>=', 'label': 'is after or equal to'},
      {'value': '<', 'label': 'is before'},
      {'value': '<=', 'label': 'is before or equal to'},
    ],
    'boolean': [
      {'value': '=', 'label': 'is'},
    ],
    'selection': [
      {'value': '=', 'label': 'is'},
      {'value': '!=', 'label': 'is not'},
      {'value': 'in', 'label': 'is in'},
      {'value': 'not in', 'label': 'is not in'},
    ],
    'many2one': [
      {'value': '=', 'label': 'is'},
      {'value': '!=', 'label': 'is not'},
      {'value': 'in', 'label': 'is in'},
      {'value': 'not in', 'label': 'is not in'},
      {'value': 'ilike', 'label': 'contains'},
    ],
    'many2many': [
      {'value': 'in', 'label': 'contains'},
      {'value': 'not in', 'label': 'does not contain'},
    ],
    'one2many': [
      {'value': 'in', 'label': 'contains'},
      {'value': 'not in', 'label': 'does not contain'},
    ],
  };

  @override
  void initState() {
    super.initState();
    _loadAvailableFields();
    _addNewRule();
  }

  /// Loads available fields using Odoo's `fields_get` method
  Future<void> _loadAvailableFields() async {
    setState(() {
      _isLoadingFields = true;
    });

    try {
      final fieldsResponse = await CompanySessionManager.callKwWithCompany({
        'model': widget.model,
        'method': 'fields_get',
        'args': [],
        'kwargs': {
          'attributes': ['string', 'type', 'selection', 'relation'],
        },
      });

      List<Map<String, dynamic>> fields = [];

      fieldsResponse.forEach((fieldName, fieldInfo) {
        if (!fieldName.toString().startsWith('__') &&
            !fieldName.toString().contains('_count') &&
            fieldInfo['string'] != null) {
          Map<String, dynamic> field = {
            'name': fieldName,
            'string': fieldInfo['string'],
            'type': fieldInfo['type'],
          };

          if (fieldInfo['selection'] != null) {
            field['selection'] = fieldInfo['selection'];
          }

          if (fieldInfo['relation'] != null) {
            field['relation'] = fieldInfo['relation'];
          }

          fields.add(field);
        }
      });

      fields.sort(
          (a, b) => a['string'].toString().compareTo(b['string'].toString()));

      setState(() {
        _availableFields = fields;
        _isLoadingFields = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingFields = false;
      });
    }
  }

  /// Adds a new empty filter rule to the list
  void _addNewRule() {
    setState(() {
      _filterRules.add(CustomFilterRule(
        field: '',
        operator: '=',
        fieldType: 'char',
      ));
    });
  }

  /// Removes the rule at the given index
  void _removeRule(int index) {
    setState(() {
      _filterRules.removeAt(index);
    });
  }

  /// Updates one or more properties of a rule and handles side-effects
  /// (field type change → reset operator & value, load options if needed)
  void _updateRule(int index,
      {String? field,
      String? operator,
      dynamic value,
      String? fieldType}) async {
    setState(() {
      if (field != null) {
        _filterRules[index].field = field;

        final fieldInfo = _availableFields.firstWhere(
          (f) => f['name'] == field,
          orElse: () => {'type': 'char'},
        );
        _filterRules[index].fieldType = fieldInfo['type'] ?? 'char';

        final availableOps = _operatorsByType[_filterRules[index].fieldType] ??
            _operatorsByType['char']!;
        _filterRules[index].operator = availableOps.first['value']!;

        _filterRules[index].value = null;
        _filterRules[index].fieldOptions = null;
      }
      if (operator != null) {
        _filterRules[index].operator = operator;
      }
      if (value != null) {
        _filterRules[index].value = value;
      }
      if (fieldType != null) {
        _filterRules[index].fieldType = fieldType;
      }
    });

    if (field != null) {
      await _loadFieldOptions(index, field);
    }
  }

  /// Loads selectable options for selection, many2one, many2many, boolean fields
  Future<void> _loadFieldOptions(int index, String fieldName) async {
    final fieldInfo = _availableFields.firstWhere(
      (f) => f['name'] == fieldName,
      orElse: () => {},
    );

    if (fieldInfo.isEmpty) return;

    try {
      List<Map<String, dynamic>> options = [];

      switch (fieldInfo['type']) {
        case 'selection':
          if (fieldInfo['selection'] != null) {
            final selectionList = fieldInfo['selection'] as List;
            options = selectionList
                .map((item) => {
                      'id': item[0],
                      'name': item[1],
                    })
                .toList();
          }
          break;

        case 'many2one':
          if (fieldInfo['relation'] != null) {
            final relatedModel = fieldInfo['relation'];
            options = await _fetchRelatedRecords(relatedModel);
          }
          break;

        case 'many2many':
        case 'one2many':
          if (fieldInfo['relation'] != null) {
            final relatedModel = fieldInfo['relation'];
            options = await _fetchRelatedRecords(relatedModel);
          }
          break;

        case 'boolean':
          options = [
            {'id': true, 'name': 'True'},
            {'id': false, 'name': 'False'},
          ];
          break;

        default:
          options = [];
          break;
      }

      setState(() {
        _filterRules[index].fieldOptions = options;
      });
    } catch (_) {}
  }

  /// Fetches records from related models to populate many2one / many2many dropdowns
  Future<List<Map<String, dynamic>>> _fetchRelatedRecords(String model) async {
    try {
      List<String> fieldsToFetch = ['id', 'name'];

      switch (model) {
        case 'res.partner':
          fieldsToFetch = ['id', 'name', 'email'];
          break;
        case 'res.users':
          fieldsToFetch = ['id', 'name', 'login'];
          break;
        case 'res.company':
          fieldsToFetch = ['id', 'name'];
          break;
        case 'res.currency':
          fieldsToFetch = ['id', 'name', 'symbol'];
          break;
        case 'crm.team':
          fieldsToFetch = ['id', 'name'];
          break;
        case 'res.country':
          fieldsToFetch = ['id', 'name', 'code'];
          break;
      }

      final response = await CompanySessionManager.callKwWithCompany({
        'model': model,
        'method': 'search_read',
        'args': [[]],
        'kwargs': {
          'fields': fieldsToFetch,
          'limit': 100,
          'order': 'name asc',
        },
      });

      List<Map<String, dynamic>> records = [];
      for (var record in response) {
        String displayName = record['name'] ?? 'Unknown';

        switch (model) {
          case 'res.partner':
            if (record['email'] != null &&
                record['email'].toString().isNotEmpty) {
              displayName = '${record['name']} (${record['email']})';
            }
            break;
          case 'res.users':
            if (record['login'] != null &&
                record['login'].toString().isNotEmpty) {
              displayName = '${record['name']} (${record['login']})';
            }
            break;
          case 'res.currency':
            if (record['symbol'] != null) {
              displayName = '${record['name']} (${record['symbol']})';
            }
            break;
          case 'res.country':
            if (record['code'] != null) {
              displayName = '${record['name']} (${record['code']})';
            }
            break;
        }

        records.add({
          'id': record['id'],
          'name': displayName,
        });
      }

      return records;
    } catch (e) {
      return [];
    }
  }

  List<Map<String, String>> _getOperatorsForField(String fieldType) {
    return _operatorsByType[fieldType] ?? _operatorsByType['char']!;
  }

  bool _shouldShowOptionsForField(String fieldType) {
    return ['selection', 'many2one', 'many2many', 'one2many', 'boolean']
        .contains(fieldType);
  }

  Widget _buildFieldSelector(int index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border.all(color: const Color(0x4DC03355)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          value: _filterRules[index].field.isEmpty
              ? null
              : _filterRules[index].field,
          isExpanded: true,
          buttonStyleData: const ButtonStyleData(
            height: 48,
            padding: EdgeInsets.symmetric(horizontal: 12),
          ),
          dropdownStyleData: DropdownStyleData(
            maxHeight: 250,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.grey[300]!,
                width: 1,
              ),
              color: Colors.white,
            ),
          ),
          iconStyleData: IconStyleData(
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: Colors.grey[700],
            ),
          ),
          hint: Text(
            'Select a field',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 15,
            ),
          ),
          items: _availableFields.map((field) {
            return DropdownMenuItem<String>(
              value: field['name'],
              child: Text(
                field['string'],
                style: const TextStyle(fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              _updateRule(index, field: value);
            }
          },
        ),
      ),
    );
  }

  Widget _buildOperatorSelector(int index) {
    final operators = _getOperatorsForField(_filterRules[index].fieldType);

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border.all(color: const Color(0x4DC03355)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          value: _filterRules[index].operator,
          isExpanded: true,
          buttonStyleData: const ButtonStyleData(
            height: 48,
            padding: EdgeInsets.symmetric(horizontal: 12),
          ),
          dropdownStyleData: DropdownStyleData(
            maxHeight: 250,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.grey[300]!,
                width: 1,
              ),
              color: Colors.white,
            ),
          ),
          iconStyleData: IconStyleData(
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: Colors.grey,
            ),
          ),
          style: TextStyle(
            fontSize: 15,
            color: Colors.grey[800],
          ),
          items: operators.map((op) {
            return DropdownMenuItem<String>(
              value: op['value'],
              child: Text(
                op['label'] ?? '',
                style: const TextStyle(fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              _updateRule(index, operator: value);
            }
          },
        ),
      ),
    );
  }

  Widget _buildValueInput(int index) {
    final rule = _filterRules[index];

    if (rule.field.isEmpty) {
      return Container(
        height: 48,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0x4DC03355)),
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey[100],
        ),
        child: Center(
          child: Text(
            'Select field first',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
        ),
      );
    }

    if (rule.fieldOptions != null && rule.fieldOptions!.isNotEmpty) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.grey[50],
          border: Border.all(color: const Color(0x4DC03355)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton2<dynamic>(
            value: rule.value,
            isExpanded: true,
            buttonStyleData: const ButtonStyleData(
              height: 48,
              padding: EdgeInsets.symmetric(horizontal: 12),
            ),
            dropdownStyleData: DropdownStyleData(
              maxHeight: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.grey[300]!,
                  width: 1,
                ),
                color: Colors.white,
              ),
            ),
            iconStyleData: IconStyleData(
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: Colors.grey,
              ),
            ),
            hint: Text(
              'Select value',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 15,
              ),
            ),
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[800],
            ),
            items: rule.fieldOptions!.map((option) {
              return DropdownMenuItem<dynamic>(
                value: option['id'],
                child: Text(
                  option['name'].toString(),
                  style: const TextStyle(fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
            onChanged: (value) {
              _updateRule(index, value: value);
            },
          ),
        ),
      );
    }

    if (_shouldShowOptionsForField(rule.fieldType) &&
        rule.fieldOptions == null) {
      return Container(
        height: 48,
        decoration: BoxDecoration(
          color: Colors.grey[50],
          border: Border.all(color: const Color(0x4DC03355)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(widget.primaryColor),
                ),
              ),
              SizedBox(width: 8),
              Text(
                'Loading options...',
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
            ],
          ),
        ),
      );
    }

    final fieldInfo = _availableFields.firstWhere(
      (f) => f['name'] == rule.field,
      orElse: () => {'type': 'char'},
    );

    switch (rule.fieldType) {
      case 'boolean':
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0x4DC03355)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonFormField<bool>(
            value: rule.value,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            items: [
              DropdownMenuItem(value: true, child: Text('Yes')),
              DropdownMenuItem(value: false, child: Text('No')),
            ],
            onChanged: (value) {
              _updateRule(index, value: value);
            },
          ),
        );

      case 'selection':
        final selections = fieldInfo['selection'] as List? ?? [];
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0x4DC03355)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonFormField<String>(
            value: rule.value,
            decoration: InputDecoration(
              hintText: 'Select value',
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            items: selections.map((selection) {
              return DropdownMenuItem<String>(
                value: selection[0].toString(),
                child: Text(selection[1].toString()),
              );
            }).toList(),
            onChanged: (value) {
              _updateRule(index, value: value);
            },
          ),
        );

      case 'date':
      case 'datetime':
        return InkWell(
          onTap: () async {
            final date = await DatePickerUtils.showStandardDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
            );
            if (date != null) {
              _updateRule(index, value: date.toIso8601String().split('T')[0]);
            }
          },
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0x4DC03355)),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    rule.value?.toString() ?? 'Select date',
                    style: TextStyle(
                      fontSize: 14,
                      color:
                          rule.value != null ? Colors.black : Colors.grey[600],
                    ),
                  ),
                ),
                Icon(Icons.calendar_today, size: 20, color: Colors.grey[600]),
              ],
            ),
          ),
        );

      case 'integer':
      case 'float':
      case 'monetary':
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            border: Border.all(color: const Color(0x4DC03355)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextFormField(
            decoration: InputDecoration(
              hintText: 'Enter value',
              hintStyle: TextStyle(
                fontWeight: FontWeight.w400,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: const Color(0xff000000),
            ),
            keyboardType: TextInputType.numberWithOptions(
                decimal: rule.fieldType != 'integer'),
            onChanged: (value) {
              if (rule.fieldType == 'integer') {
                _updateRule(index, value: int.tryParse(value));
              } else {
                _updateRule(index, value: double.tryParse(value));
              }
            },
          ),
        );

      default:
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            border: Border.all(color: const Color(0x4DC03355)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextFormField(
            decoration: InputDecoration(
              hintText: 'Enter value',
              hintStyle: TextStyle(
                fontWeight: FontWeight.w400,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: const Color(0xff000000),
            ),
            onChanged: (value) {
              _updateRule(index, value: value);
            },
          ),
        );
    }
  }

  Widget _buildRuleRow(int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 18),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Text(
                  'Rule ${index + 1}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[900],
                    letterSpacing: -0.3,
                  ),
                ),
              ),
              Spacer(),
              if (_filterRules.length > 1)
                IconButton(
                  onPressed: () => _removeRule(index),
                  icon: Icon(Icons.close, color: Colors.red[400], size: 20),
                  constraints: BoxConstraints(minWidth: 32, minHeight: 32),
                  padding: EdgeInsets.zero,
                ),
            ],
          ),
          Divider(
            height: 1,
            color: Colors.grey[200],
          ),
          SizedBox(height: 15),
          Text(
            'Field',
            style: TextStyle(
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 10),
          _buildFieldSelector(index),
          SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Operator',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 4),
              Flexible(child: _buildOperatorSelector(index)),
            ],
          ),
          SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Value',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 4),
              Flexible(child: _buildValueInput(index)),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: Colors.transparent,
        child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.65,
              maxWidth: MediaQuery.of(context).size.width * 0.95,
              minWidth: 300,
            ),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 20,
                    offset: Offset(0, 10),
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 12, bottom: 8),
                    child: Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: widget.primaryColor.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(24, 12, 24, 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Add Custom Filter',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey[800],
                                  letterSpacing: 0.5,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Create advanced filter rules',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: Icon(Icons.close, color: Colors.grey[600]),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shape: CircleBorder(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.grey[50],
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        padding: EdgeInsets.all(16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: 24),
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey[200]!),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.04),
                                    blurRadius: 8,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Filter Logic',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  SizedBox(
                                    width: double.infinity,
                                    child: Wrap(
                                      alignment: WrapAlignment.start,
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      spacing: 4,
                                      children: [
                                        Text(
                                          'Match',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                        Container(
                                          padding:
                                              EdgeInsets.symmetric(vertical: 8),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                  color: Colors.black26)),
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton2<String>(
                                              dropdownStyleData:
                                                  const DropdownStyleData(
                                                maxHeight: 300,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(8)),
                                                ),
                                              ),
                                              value: _matchType,
                                              isDense: true,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black,
                                              ),
                                              items: [
                                                DropdownMenuItem(
                                                  value: 'all',
                                                  child: Text('ALL'),
                                                ),
                                                DropdownMenuItem(
                                                  value: 'any',
                                                  child: Text('ANY'),
                                                ),
                                              ],
                                              onChanged: (value) {
                                                setState(() {
                                                  _matchType = value!;
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                        Text(
                                          'of the following rules:',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (_isLoadingFields)
                              Center(
                                child: Padding(
                                  padding: EdgeInsets.all(20),
                                  child: CircularProgressIndicator(
                                      color: widget.primaryColor),
                                ),
                              )
                            else ...[
                              ...List.generate(_filterRules.length,
                                  (index) => _buildRuleRow(index)),
                              Container(
                                margin: EdgeInsets.only(top: 16),
                                width: double.infinity,
                                child: OutlinedButton.icon(
                                  onPressed: _addNewRule,
                                  icon:
                                      Icon(Icons.add_circle_outline, size: 20),
                                  label: Text(
                                    'Add Another Rule',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                    ),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: widget.primaryColor,
                                    side: BorderSide(
                                        color: widget.primaryColor, width: 1.5),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(24, 16, 24, 24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(top: BorderSide(color: Colors.grey[200]!)),
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(24)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.grey[700],
                              side: BorderSide(color: Colors.grey[300]!),
                              padding: EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed: _isLoadingFields
                                ? null
                                : () {
                                    final validRules = _filterRules
                                        .where((rule) =>
                                            rule.field.isNotEmpty &&
                                            rule.value != null)
                                        .toList();

                                    if (validRules.isNotEmpty) {
                                      widget.onApply(validRules);
                                      Navigator.of(context).pop();
                                    } else {
                                      CustomSnackbar.showWarning(context,
                                          'Please add at least one valid filter rule');
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: widget.primaryColor,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 14),
                              elevation: 0,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (_isLoadingFields)
                                  SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    ),
                                  )
                                else
                                  Icon(Icons.check_circle_outline, size: 20),
                                SizedBox(width: 8),
                                Text(
                                  _isLoadingFields
                                      ? 'Loading...'
                                      : 'Apply Filter',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )));
  }
}
