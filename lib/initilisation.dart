import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:mobo_crm/global_methods/services/isar_caching_service.dart';
import 'package:mobo_crm/models/isar/lead_and_customer_models.dart';
import 'package:mobo_crm/models/isar/lead_tag_model_isar.dart';
import 'package:mobo_crm/models/models.dart';
import 'package:mobo_crm/global_methods/services/global_error_handler.dart';
import 'package:mobo_crm/screens/login/server_setup_screen.dart';
import 'package:mobo_crm/services/storage_service.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/company/session/company_session_manager.dart';
import 'models/LoginPage/session_model.dart';

/// Central state manager and Odoo RPC client wrapper for the CRM mobile application.
///
/// Manages:
/// * Odoo RPC client lifecycle
/// * Authentication session
/// * Cached company/lead/customer/sales team data
/// * User profile picture
/// * Local storage synchronization (SharedPreferences + Isar)
///
/// This class is usually provided at app root via Provider / Riverpod / InheritedWidget.
class OdooClientManager extends ChangeNotifier {

  /// Currently active and authenticated Odoo RPC client.
  /// Usually initialized via [initializeOdooClient] or [ensureClient].
  OdooClient? _client;

  String? _url;
  AppError? initialError;
  bool hasError = false;
  int? currencycode;
  int? currentPartnerId;
  String? currencySymbol;
  final List<LeadItem> _leadItems = [];
  final List<CustomerItem> _customerItems = [];
  final List<SalesPersonItem> _salesPersonItems = [];
  final List<SalesTeam> _salesTeams = [];

  List<SalesTeam> get salesTeams => _salesTeams;
  List _companyDetails = [];
  List<LeadTag> _crmTagDetails = [];
  int? countryId;
  MemoryImage? companyPicUrl;
  Uint8List? logo;
  SessionModel? _currentsession;

  OdooClient? get client => _client;

  List<LeadTag> get crmTagDetails => _crmTagDetails;
  dynamic _userdetails;

  SessionModel? get currentsession => _currentsession;

  List get companyDetails => _companyDetails;

  List<LeadItem> get leadItems => _leadItems;

  List<CustomerItem> get customerItems => _customerItems;

  List<SalesPersonItem> get salesPersonItem => _salesPersonItems;

  dynamic get userDetails => _userdetails;
  bool isOdoo18 = true;

  String? get url => _url;
  bool? isLoading = true;
  OdooClient? _tempClient;

  OdooClient? get tempClient => _tempClient;
  List<Map<String, dynamic>> storedaccounts = [];
  List allproducts = [];
  String? _currentUserImageBase64;

  String? get currentUserImage => _currentUserImageBase64;

  /// Clears almost all in-memory state (used before dispose or reset)
  void clearvariables() {
    _url = null;
    currencycode = null;
    currencySymbol = null;
    companyPicUrl = null;
    logo = null;
    _userdetails = null;
    _currentsession = null;
    _leadItems.clear();
    _customerItems.clear();
    _salesPersonItems.clear();
    _salesTeams.clear();
    _companyDetails.clear();
    _crmTagDetails.clear();
    allproducts.clear();
    companyPicUrl = null;
    isLoading = true;
    notifyListeners();
  }

  @override
  void dispose() {
    _client = null;
    _tempClient = null;
    clearvariables();
    super.dispose();
  }

  Future<void> _initCurrentUserImage() async {
    await loadCurrentUserImage();
  }

  Future<void> loadCurrentUserImage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId') ?? 0;
      final storage = StorageService();
      final accounts = await storage.getAccounts();

      if (userId == 0) return;

      final currentAccount = accounts.firstWhere(
        (acc) => acc['userId'] == userId,
        orElse: () => {},
      );

      final imageValue = currentAccount['image'];

      if (imageValue == null ||
          imageValue == false ||
          imageValue == '' ||
          imageValue == 'false') {

        final response = await CompanySessionManager.callKwWithCompany({
          'model': 'res.users',
          'method': 'search_read',
          'args': [
            [
              ['id', '=', userId],
            ],
          ],
          'kwargs': {
            'fields': ['image_1920']
          },
        });
        final img = response[0]['image_1920'];

        if (img != null && img != false && img != 'false') {
          _currentUserImageBase64 = img;
        } else {
          _currentUserImageBase64 = null;
        }
      } else {
        _currentUserImageBase64 = currentAccount['image'] as String?;
      }
      notifyListeners();
    } catch (_) {}
  }

  Future<void> updateUserImage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId') ?? 0;

      if (userId == 0) return;

      final response = await CompanySessionManager.callKwWithCompany({
        'model': 'res.users',
        'method': 'search_read',
        'args': [
          [
            ['id', '=', userId],
          ],
        ],
        'kwargs': {
          'fields': ['image_1920']
        },
      });
      _currentUserImageBase64 = response[0]['image_1920'];

      notifyListeners();
    } catch (_) {}
  }

  /// Ensures that a valid authenticated [SessionModel] exists.
  Future<SessionModel> ensureSession() async {
    if (_currentsession != null) return _currentsession!;

    final session = await CompanySessionManager.getCurrentSession();

    _currentsession = session;

    notifyListeners();
    return session!;
  }

  /// Ensures that a valid [OdooClient] exists.
  /// Creates / re-uses client from [CompanySessionManager].
  ///
  /// Returns already existing client or freshly created one.
  Future<OdooClient> ensureClient() async {
    if (_client != null) return _client!;

    final client = await CompanySessionManager.getClientEnsured();
    _client = client;
    _url = client.baseURL;
    notifyListeners();
    return _client!;
  }

  /// Initializes client with a new URL (usually during first setup or server change).
  Future<void> initializeOdooClientWithUrl(String url) async {
    await CompanySessionManager.clearSessionCache();
    final client = await CompanySessionManager.getClientEnsured();

    _client = client;
    _url = url;
    notifyListeners();
  }

  /// Prepares temporary client when switching accounts (preview mode).
  Future<void> initializeOdooClientSwitchAccount(String url) async {
    _tempClient = await CompanySessionManager.getClientEnsured();
    notifyListeners();
  }

  /// Force update current session object and client.
  Future<bool> updateSession(SessionModel session) async {
    await CompanySessionManager.forceRefreshFromPrefs();
    _client = await CompanySessionManager.getClientEnsured();
    _currentsession = session;
    _url = _client?.baseURL;
    notifyListeners();
    return true;
  }

  /// Full application initialization flow after login / account switch.
  ///
  /// Sequence:
  /// 1. Loads session & client
  /// 2. Detects server version (18/19 flag)
  /// 3. Loads user profile picture
  /// 4. Loads company data (logo, currency, country)
  /// 5. Loads CRM leads, customers, tags, sales teams & persons
  /// 6. Loads full product catalog with attributes
  ///
  /// Sets [isLoading], [hasError], [initialError] accordingly.
  ///
  /// [context] is needed for some navigation & mounted checks
  /// [loading] whether to notify listeners during loading
  Future<bool> initializeOdooClient(BuildContext context,
      {bool loading = false}) async {
    isLoading = true;
    hasError = false;
    if (loading) notifyListeners();

    try {
      final session = await CompanySessionManager.getCurrentSession();
      if (session == null) {
        isLoading = false;
        notifyListeners();
        return false;
      }

      _client = await CompanySessionManager.getClientEnsured();
      _currentsession = session;
      _url = _client!.baseURL;
      currentPartnerId = session.partnerId;

      final versionInfo = await CompanySessionManager.callVersion();

      final serverVersion = versionInfo['server_version']?.toString() ?? '';
      isOdoo18 =
          serverVersion.startsWith('18.0') || serverVersion.startsWith('19.0');
      await _initCurrentUserImage();
      await getCompanyData(_client!);
      await getCrmLead();
      await getTags();
      await getSalesTeamsAndSalesperson();

      if (context.mounted) {
        await getFullProductData(_client!, _currentsession!, context);
      }

      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      await _initCurrentUserImage();
      initialError = await ErrorHandler.handleException(e, uri: _client?.baseURL);
      isLoading = false;
      hasError = true;
      notifyListeners();
      return false;
    }
  }

  Future<void> _addToNewStoredAccountsFormat(
    OdooSession session,
    String url,
    String password,
    String username,
    String userName,
    String imageBase64,
    SharedPreferences prefs,
  ) async {
    try {
      final accountsJson = prefs.getStringList('stored_accounts') ?? [];

      List<Map<String, dynamic>> storedAccountsList =
          accountsJson.map((accountStr) {
        return Map<String, dynamic>.from(jsonDecode(accountStr));
      }).toList();

      final newAccount = {
        'id': session.userId.toString(),
        'name': userName,
        'email': username,
        'url': url.trim(),
        'database': session.dbName,
        'username': username,
        'isCurrent': true,
        'lastLogin': DateTime.now().toIso8601String(),
        'imageBase64': imageBase64.isNotEmpty && imageBase64 != 'false'
            ? imageBase64
            : null,
      };

      for (var account in storedAccountsList) {
        account['isCurrent'] = false;
      }

      final existingIndex = storedAccountsList.indexWhere((account) =>
          account['id'] == newAccount['id'] &&
          account['url'] == newAccount['url'] &&
          account['database'] == newAccount['database']);

      if (existingIndex != -1) {
        storedAccountsList[existingIndex] = newAccount;
      } else {
        storedAccountsList.insert(0, newAccount);
      }

      final updatedAccountsJson =
          storedAccountsList.map((account) => jsonEncode(account)).toList();
      await prefs.setStringList('stored_accounts', updatedAccountsJson);
    } catch (_) {}
  }

  /// Stores user credentials, session and profile info after successful login.
  ///
  /// Saves to two formats:
  /// * legacy 'accounts' list
  /// * new normalized 'stored_accounts' list
  Future<void> storeUserSession(
    OdooSession session,
    String url,
    String password,
    String username,
    BuildContext context,
    bool login,
  ) async {
    await ensureClient();
    final prefs = await SharedPreferences.getInstance();
    final client = _client;

    if (client == null) {
      return;
    }

    try {
      int userId = prefs.getInt('userId') ?? session.userId;
      final userDetails = await CompanySessionManager.callKwWithCompany({
        'model': 'res.users',
        'method': 'search_read',
        'args': [
          [
            ['id', '=', userId]
          ]
        ],
        'kwargs': {
          'fields': ['name', 'phone', 'email', 'image_1920'],
        },
      });

      _userdetails = userDetails;

      String userName = session.userName;
      String imageBase64 = '';
      if (userDetails != null && userDetails.isNotEmpty) {
        final user = userDetails[0];
        userName = user['name']?.toString() ?? session.userName;
        imageBase64 = user['image_1920']?.toString() ?? '';
      }

      List<String> accounts = prefs.getStringList('accounts') ?? [];
      Map<String, dynamic> userData = {
        'url': url.trim(),
        'dbName': session.dbName,
        'imageurl':
            imageBase64.isNotEmpty && imageBase64 != 'false' ? imageBase64 : '',
        'password': password,
        'userName': userName,
        'user': username,
        'userId': session.userId,
      };

      accounts.removeWhere((account) {
        final acc = jsonDecode(account) as Map<String, dynamic>;
        return acc['userId'] == session.userId;
      });

      accounts.add(jsonEncode(userData));
      await prefs.setStringList('accounts', accounts);

      storedaccounts = accounts
          .map((account) => jsonDecode(account) as Map<String, dynamic>)
          .toList();

      await _addToNewStoredAccountsFormat(
          session, url, password, username, userName, imageBase64, prefs);

      List<String> servers = prefs.getStringList('servers') ?? [];
      String trimmedUrl = url.trim();
      if (!servers.contains(trimmedUrl)) {
        servers.add(trimmedUrl);
        await prefs.setStringList('servers', servers);
      }

      await prefs.setString('lastUsername', username);
      await prefs.setString('lastUrl', url.trim());

      await prefs.setString('password', password);
      await prefs.setString(
          'password_${session.userId}_${session.dbName}', password);
      await prefs.setString('password_${username}_${session.dbName}', password);

      if (username.contains('@')) {
        await prefs.setString(
            'password_${username}_${session.dbName}', password);
      }

      notifyListeners();

      if (login && context.mounted) {
        Navigator.pushNamedAndRemoveUntil(
            context, '/init', (Route<dynamic> route) => false);
      }
    } catch (_) {}
  }

  /// Returns all stored accounts from SharedPreferences ('accounts' key)
  Future<List<Map<String, dynamic>>> getStoredAccounts() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> accounts = prefs.getStringList('accounts') ?? [];
    List<Map<String, dynamic>> result = accounts
        .map((account) => jsonDecode(account) as Map<String, dynamic>)
        .toList();
    return result;
  }

  /// Returns list of known server URLs
  Future<List<String>> getStoredServers() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> servers = prefs.getStringList('servers') ?? [];
    return servers;
  }

  /// Filters stored accounts that belong to given server URL
  List<Map<String, dynamic>> getAccountsForServer(String serverUrl) {
    final accounts = storedaccounts
        .where((account) => account['url'] == serverUrl.trim())
        .toList();
    return accounts;
  }

  /// Removes all locally stored accounts and servers from SharedPreferences.
  Future<void> clear() async {
    companyPicUrl = null;
    storedaccounts = [];
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('accounts');
    await prefs.remove('servers');
    notifyListeners();
  }

  /// Removes almost all preferences related to active session (logout-like).
  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('sessionId');
    await prefs.remove('serverVersion');
    await prefs.remove('userLang');
    await prefs.remove('userId');
    await prefs.remove('companyId');
    await prefs.remove('isLoggedIn');
    await prefs.remove('modulesInstalled');
    _client = null;
    _currentsession = null;
    _userdetails = null;
    companyPicUrl = null;
    isLoading = true;
    notifyListeners();
  }

  /// Loads CRM tags (crm.tag) → falls back to Isar cache on failure
  Future<void> getTags() async {
    try {
      final response = await CompanySessionManager.callKwWithCompany({
        'model': 'crm.tag',
        'method': 'search_read',
        'args': [[]],
        'kwargs': {
          'fields': ['id', 'name'],
        },
      });

      _crmTagDetails = (response as List<dynamic>)
          .map((tag) => LeadTag.fromJson(tag as Map<String, dynamic>))
          .toList();

      final isarTags =
          response.map((tag) => LeadTagModelIsar.fromJson(tag)).toList();
      await IsarService.saveLeadTags(isarTags);
    } catch (e) {
      final cachedTags = await IsarService.getCachedLeadTags();
      _crmTagDetails = cachedTags
          .map((tag) => LeadTag(id: tag.serverId!, name: tag.name ?? ''))
          .toList();
    }

    notifyListeners();
  }

  Future<void> setstoreddata() async {
    storedaccounts = await getStoredAccounts();
    notifyListeners();
  }

  /// Loads company information (logo, currency, country)
  /// and prepares [companyPicUrl], [currencySymbol], etc.
  Future<void> getCompanyData(OdooClient client) async {
    await SharedPreferences.getInstance();
    try {
      final response = await CompanySessionManager.callKwWithCompany({
        'model': 'res.company',
        'method': 'read',
        'args': [
          [1]
        ],
        'kwargs': {
          'fields': ['logo', 'currency_id', 'country_id']
        },
      });
      currencycode = response[0]['currency_id'][0];
      final currencyresponse = await CompanySessionManager.callKwWithCompany({
        'model': 'res.currency',
        'method': 'search_read',
        'args': [
          [
            ['id', '=', currencycode]
          ]
        ],
        'kwargs': {
          'fields': [
            'symbol',
          ],
          'limit': 50
        },
      });
      currencySymbol = currencyresponse[0]['symbol'];
      final companyLogo = response[0]['logo'];
      countryId = response[0]['country_id'][0];
      if (companyLogo != null && companyLogo != 'false') {
        final imageData = base64Decode(companyLogo);
        logo = imageData;
        companyPicUrl = MemoryImage(Uint8List.fromList(imageData));
      }
    } catch (_) {}
  }

  /// Creates a new CRM opportunity/lead from voice command parameters.
  ///
  /// Returns `true` if creation was successful.
  Future<bool> createOpportunityFromVoice(
      Map<String, dynamic> parameters) async {
    try {
      if (client == null) {
        return false;
      }
      final response = await CompanySessionManager.callKwWithCompany({
        'model': 'crm.lead',
        'method': 'create',
        'args': [
          {
            'name': parameters['name'] ?? 'Lead from Voice',
            'phone': parameters['phone'] ?? '',
            'email_from': parameters['email'] ?? '',
            'partner_name': parameters['company'] ?? '',
            'description':
                parameters['description'] ?? 'Created via voice command',
            'probability':
                double.tryParse(parameters['probability']?.toString() ?? '0') ??
                    0.0,
            'expected_revenue': double.tryParse(
                    parameters['expected_revenue']?.toString() ?? '0') ??
                0.0,
            'active': true,
            'type': 'lead',
          }
        ],
        'kwargs': {},
      });
      return response != null && response is int;
    } catch (e) {
      return false;
    }
  }

  /// Loads CRM leads (crm.lead) and res.partner (customers)
  /// → falls back to Isar cache on failure
  Future<void> getCrmLead() async {
    _leadItems.clear();
    _customerItems.clear();

    try {
      final leadDetails = await CompanySessionManager.callKwWithCompany({
        'model': 'crm.lead',
        'method': 'search_read',
        'args': [[]],
        'kwargs': {
          'fields': [
            'name',
            'user_id',
            'email_from',
            'create_date',
            'stage_id',
            'partner_id'
          ],
        },
      });

      final List<LeadItemModel> leadModels = [];

      if (leadDetails != null && leadDetails is List) {
        for (var item in leadDetails) {
          final model = LeadItemModel.fromJson(item);
          leadModels.add(model);
          _leadItems.add(LeadItem(
            contactname: model.contactName,
            id: model.serverId!,
            name: model.name ?? "Unknown",
            email: model.email,
            createdon: model.createdOn ?? "Unknown",
            salesperson: model.salesperson,
            stage: model.stage ?? "Unknown",
          ));
        }
        await IsarService.saveLeads(leadModels);
      }

      final customerDetails = await CompanySessionManager.callKwWithCompany({
        'model': 'res.partner',
        'method': 'search_read',
        'args': [[]],
        'kwargs': {
          'fields': ['name', 'complete_name', 'email'],
        },
      });

      final List<CustomerItemModel> customerModels = [];

      if (customerDetails != null && customerDetails is List) {
        for (var item in customerDetails) {
          final model = CustomerItemModel.fromJson(item);
          customerModels.add(model);
          _customerItems.add(CustomerItem(
            email: model.email!,
            id: model.serverId!,
            name: model.name ?? "Unknown",
            fullname: model.fullName ?? model.name ?? "Unknown",
          ));
        }
        await IsarService.saveCustomers(customerModels);
      }
      notifyListeners();
    } catch (e) {
      final cachedLeads = await IsarService.getLeads();
      final cachedCustomers = await IsarService.getCustomers();

      for (var model in cachedLeads) {
        _leadItems.add(LeadItem(
          contactname: model.contactName,
          id: model.serverId!,
          name: model.name ?? "Unknown",
          email: model.email,
          createdon: model.createdOn ?? "Unknown",
          salesperson: model.salesperson,
          stage: model.stage ?? "Unknown",
        ));
      }

      for (var model in cachedCustomers) {
        _customerItems.add(CustomerItem(
          email: model.email!,
          id: model.serverId!,
          name: model.name ?? "Unknown",
          fullname: model.fullName ?? model.name ?? "Unknown",
        ));
      }

      notifyListeners();
    }
  }

  /// Loads complete product catalog including variant attributes and prices.
  /// Stores result in [allproducts].
  Future<void> getFullProductData(
      OdooClient client, SessionModel session, BuildContext context) async {
    try {
      final allProductResponse = await CompanySessionManager.callKwWithCompany({
        'model': 'product.product',
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'domain': [],
          'fields': [
            'id',
            'name',
            'list_price',
            'uom_id',
            'default_code',
            'product_tmpl_id',
            'combination_indices',
          ],
          'context': {
            'partner_id': session.userId,
            'company_id': session.companyId,
          },
        },
      });

      if (allProductResponse == null || allProductResponse.isEmpty) {
        throw Exception("No Products Found. Add some products first.");
      }
      List<Map<String, dynamic>> allproductsraw =
          List<Map<String, dynamic>>.from(allProductResponse);

      final allAttributeRelation =
          await CompanySessionManager.callKwWithCompany({
        'model': 'product.template.attribute.value',
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'domain': [],
          'fields': [
            'id',
            'product_attribute_value_id',
            'product_tmpl_id',
            'attribute_id',
            'price_extra',
          ],
        },
      });

      final allAttributeName = await CompanySessionManager.callKwWithCompany({
        'model': 'product.attribute',
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'domain': [],
          'fields': ['id', 'name', 'display_type'],
        },
      });

      Map<int, String> attributeDisplayTypeMap = {
        for (var attribute in allAttributeName)
          attribute['id']: attribute['display_type']
      };

      Map<int, Map<String, dynamic>> attributeMap = {
        for (var attr in allAttributeRelation)
          attr['id']: {
            'id': attr['id'],
            'extra_price': attr['price_extra'],
            'attribute': attr['product_attribute_value_id'][1],
            'display_type':
                attributeDisplayTypeMap[attr['attribute_id'][0]] ?? 'unknown',
          }
      };

      for (var product in allproductsraw) {
        String indicesStr = product['combination_indices']?.toString() ?? '';
        List<int> indices = indicesStr
            .split(',')
            .where((e) => e.isNotEmpty)
            .map((e) => int.tryParse(e) ?? -1)
            .where((e) => e != -1)
            .toList();

        product['attributes'] = indices
            .map((id) => attributeMap[id])
            .where((attr) => attr != null)
            .toList();
      }

      allproducts = allproductsraw;
      notifyListeners();
    } catch (e) {
      if (context.mounted) {}
    }
  }

  /// Loads sales teams (crm.team) and salespersons (res.users)
  Future<void> getSalesTeamsAndSalesperson() async {
    try {
      _salesPersonItems.clear();
      final salesPersonResponse =
          await CompanySessionManager.callKwWithCompany({
        'model': 'res.users',
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'fields': ['name', 'sale_team_id'],
        },
      });

      if (salesPersonResponse != null && salesPersonResponse is List) {
        for (var item in salesPersonResponse) {
          _salesPersonItems.add(
            SalesPersonItem(
              teamName: item['sale_team_id'] != false
                  ? item['sale_team_id'][1]
                  : null,
              teamid: item['sale_team_id'] != false
                  ? item['sale_team_id'][0]
                  : null,
              id: item['id'],
              name: item['name'],
            ),
          );
        }
      }

      _salesTeams.clear();
      final salesTeamResponse = await CompanySessionManager.callKwWithCompany({
        'model': 'crm.team',
        'method': 'search_read',
        'args': [
          [
            ['active', '=', true]
          ]
        ],
        'kwargs': {
          'fields': [
            'name',
          ],
        },
      });

      if (salesTeamResponse != null && salesTeamResponse is List) {
        for (var item in salesTeamResponse) {
          _salesTeams.add(
            SalesTeam(
              id: item['id'],
              name: item['name'],
            ),
          );
        }
      }
    } catch (_) {}
  }

  Future<void> getCompany() async {
    try {
      _companyDetails.clear();
      final companyresponse = await CompanySessionManager.callKwWithCompany({
        'model': 'res.company',
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'fields': ['name', 'id'],
        },
      });

      _companyDetails = companyresponse;
      notifyListeners();
    } catch (_) {}
  }

  /// Clears all sensitive data and navigates back to server setup screen.
  ///
  /// Used during logout / sign out flow.
  Future<bool> signOut(BuildContext context) async {
    try {
      await IsarService.clearAllData();
      final prefs = await SharedPreferences.getInstance();
      final lastUrl = prefs.getString('lastUrl');
      final lastDatabase = prefs.getString('lastDatabase');
      final lastUsername = prefs.getString('lastUsername');

      await prefs.remove('sessionId');
      await prefs.remove('modulesInstalled');
      await prefs.remove('serverVersion');
      await prefs.remove('userLang');
      await prefs.remove('userId');
      await prefs.remove('companyId');
      await prefs.remove('isLoggedIn');
      await prefs.remove('accounts');

      if (lastUrl != null) {
        await prefs.setString('lastUrl', lastUrl);
      }
      if (lastDatabase != null) {
        await prefs.setString('lastDatabase', lastDatabase);
      }
      if (lastUsername != null) {
        await prefs.setString('lastUsername', lastUsername);
      }

      await prefs.setBool('hasSeenGetStarted', true);
      storedaccounts = [];
      _client = null;
      _currentsession = null;
      _userdetails = null;
      companyPicUrl = null;
      isLoading = true;
      notifyListeners();

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => ServerSetupScreen(
            serverUrl: lastUrl,
            database: lastDatabase,
          ),
        ),
        (route) => false,
      );

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Checks whether 'crm' module is installed on the server.
  Future<bool> areCrmAndSaleInstalled() async {
    try {
      final result = await CompanySessionManager.callKwWithCompany({
        'model': 'ir.module.module',
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'domain': [
            ['state', '=', 'installed']
          ],
          'fields': ['name'],
          'limit': 100,
        },
      });

      final installedModules =
          (result as List).map((module) => module['name'] as String).toSet();

      return installedModules.contains('crm');
    } catch (e) {
      return false;
    }
  }
}
