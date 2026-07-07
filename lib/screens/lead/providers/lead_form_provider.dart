import 'dart:async';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:mobo_crm/global_methods/services/isar_caching_service.dart';
import 'package:mobo_crm/screens/lead/isar/lead_form_data_model.dart';
import 'package:mobo_crm/global_methods/services/global_error_handler.dart';
import 'package:mobo_crm/initilisation.dart';
import 'package:mobo_crm/models/models.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:mobo_crm/global_methods/const.dart';
import 'package:mobo_crm/models/chat_models/chat_model.dart';
import 'package:mobo_crm/screens/lead/components/bottomsheet_lost.dart';
import 'package:mobo_crm/screens/lead/providers/lead_data_provider.dart';
import 'package:mobo_crm/screens/opportunity/providers/opportunity_data_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/company/services/company_session_service.dart';
import '../../../core/company/session/company_session_manager.dart';
import '../../../utils/snackbar.dart';

/// Provider (ChangeNotifier) that manages the state and business logic
/// for the Lead / Opportunity creation and detail screen in an Odoo-based CRM app.
///
/// Responsibilities:
///   - Load / save / create leads & opportunities via Odoo RPC
///   - Handle form fields (name, email, phone, probability, expected revenue, tags, UTM, address...)
///   - Manage edit/view mode + change detection
///   - Convert lead → opportunity (with merge / create customer options)
///   - Fetch & display chatter messages (with tracking values)
///   - Mark lead as won / lost
///   - Cache form data in Isar for offline fallback
///
/// This provider is typically used together with a form UI that consumes its
/// TextEditingControllers, selected* fields, and loading/error states.
class LeadFormProvider extends ChangeNotifier {
  final CompanySessionService sessionService;
  final IsarService isarService;

  LeadFormProvider({
    required this.sessionService,
    required this.isarService,
  });

  int? _userId;

  final String _url = "";
  List<LeadTag> _leadTags = [];

  String _conversionAction = "convert";
  String _customerOption = "create";
  final List<String> _availableLeadNames = [];
  final List<int> _availableLeadIds = [];
  bool isloading = true;
  bool isMessageLoading = false;
  bool messageAlreadyLoaded = false;
  final List<int> _customerIds = [];
  bool? _active;
  double? _probablity;
  int? _personValue;
  int? _teamValue;
  String? _selectedCustomer;
  String? _otherDetails;
  String? _errorMessage;
  final Map<String, dynamic> _data = {};

  Map<String, dynamic> get data => _data;
  int? _stageid;
  AppError? leadError;
  bool hasError = false;

  int? get stageId => _stageid;
  List<LeadItem> selectedLeads = [];
  bool isEdit = false;

  int? get userId => _userId;

  double? get probablity => _probablity;

  String get url => _url;
  String? initialState = 'New';
  String? _teamname;
  List<Message> messageList = [];

  List<LeadTag> get leadTags => _leadTags;

  String get conversionAction => _conversionAction;

  String get customerOption => _customerOption;

  bool? get active => _active;

  List<String> get availableLeadNames => _availableLeadNames;

  List<int> get availableLeadIds => _availableLeadIds;

  List<int> get customerIds => _customerIds;

  int get personValue => _personValue!;

  int get teamValue => _teamValue!;

  String? get selectedCustomer => _selectedCustomer;
  double expectedRevenue = 0;
  int? selectedSalespersonId;
  int? selectedSalesTeamId;
  int? selectedPartnerId;
  Country? selectedCountryId;
  List<Map<String, dynamic>> trackingValueList = [];
  StateClass? selectedStateId;
  bool isChanged = false;
  TextEditingController phoneController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController jobPositionController = TextEditingController();
  TextEditingController contactNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  TextEditingController referredController = TextEditingController();
  TextEditingController expectedRevenueController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController zipController = TextEditingController();
  TextEditingController websiteController = TextEditingController();
  TextEditingController languageController = TextEditingController();
  TextEditingController probablityController = TextEditingController();
  TextEditingController compnayNameController = TextEditingController();
  TextEditingController dayOpenController = TextEditingController();
  TextEditingController dayCloseController = TextEditingController();
  TextEditingController messageBounceController = TextEditingController();
  final TextEditingController searchcontroller = TextEditingController();
  List<int> selectedTagIds = [];
  int? selectedCampaignId;

  int? selectedMediumId;
  int? selectedSourceId;
  String? expectedClosing;
  Campaign? selectedCampaign;
  Medium? selectedMedium;
  Source? selectedSource;
  List campaignList = [];
  List countries = [];
  List stateList = [];
  List stagesList = [];
  List mediumList = [];
  List sourceList = [];

  /// Compares current form values against original loaded data
  bool hasFormChanged() {
    if (nameController.text.trim() != (data['name'] ?? '').trim()) return true;
    if (mobileController.text.trim() != (data['mobile'] ?? '').trim())
      return true;
    if (phoneController.text.trim() != (data['phone'] ?? '').trim())
      return true;
    if (emailController.text.trim() != (data['emailFrom'] ?? '').trim())
      return true;
    if (contactNameController.text.trim() != (data['contactName'] ?? '').trim())
      return true;
    if (descriptionController.text.trim() != (data['description'] ?? '').trim())
      return true;
    if (jobPositionController.text.trim() != (data['function'] ?? '').trim())
      return true;
    if (streetController.text.trim() != (data['street'] ?? '').trim())
      return true;
    if (cityController.text.trim() != (data['city'] ?? '').trim()) return true;
    if (zipController.text.trim() != (data['zip'] ?? '').trim()) return true;
    if (websiteController.text.trim() != (data['website'] ?? '').trim())
      return true;
    if (referredController.text.trim() != (data['referred'] ?? '').trim())
      return true;
    if (compnayNameController.text.trim() != (data['companyName'] ?? '').trim())
      return true;

    final currentProb = double.tryParse(probablityController.text) ?? 0.0;
    if (currentProb != (probablity ?? 0.0)) return true;

    final currentRevenue =
        double.tryParse(expectedRevenueController.text) ?? 0.0;
    if (currentRevenue != expectedRevenue) return true;

    if (selectedSalespersonId !=
        ((data['userId'] is List && data['userId'].isNotEmpty)
            ? data['userId'][0] as int?
            : null)) return true;
    if (selectedSalesTeamId !=
        ((data['teamId'] is List && data['teamId'].isNotEmpty)
            ? data['teamId'][0] as int?
            : null)) return true;
    if (selectedPartnerId !=
        ((data['partnerId'] is List && data['partnerId'].isNotEmpty)
            ? data['partnerId'][0] as int?
            : null)) return true;
    if (selectedCountryId?.id !=
        ((data['country'] is List && data['country'].isNotEmpty)
            ? data['country'][0] as int?
            : null)) return true;
    if (selectedStateId?.id !=
        ((data['state'] is List && data['state'].isNotEmpty)
            ? data['state'][0] as int?
            : null)) return true;
    if (selectedCampaign?.id !=
        ((data['campaign_id'] is List && data['campaign_id'].isNotEmpty)
            ? data['campaign_id'][0] as int?
            : null)) return true;
    if (selectedMedium?.id !=
        ((data['medium_id'] is List && data['medium_id'].isNotEmpty)
            ? data['medium_id'][0] as int?
            : null)) return true;
    if (selectedSource?.id !=
        ((data['source_id'] is List && data['source_id'].isNotEmpty)
            ? data['source_id'][0] as int?
            : null)) return true;

    if (stageId !=
        ((data['stage'] is List && data['stage'].isNotEmpty)
            ? data['stage'][0] as int?
            : null)) return true;

    if (expectedClosing != data['deadline']) return true;

    final originalTags = List<int>.from(data['tagIds'] ?? []);
    if (selectedTagIds.length != originalTags.length) return true;
    for (final tagId in selectedTagIds) {
      if (!originalTags.contains(tagId)) return true;
    }

    return false;
  }

  /// Initialize provider for new lead or existing record
  Future<void> init(dynamic lead, BuildContext context, bool isNew) async {
    final client =
        Provider.of<OdooClientManager>(context, listen: false).client;

    if (isNew == false) {
      try {
        _probablity = null;
        isChanged = false;
        _formEdited = false;
        stopTrackingChanges();
        isloading = true;
        isEdit = false;
        selectedLeads.clear();
        selectedTagIds.clear();

        await Future.wait([
          fetchStages(client!),
          fetchStatus(client, lead),
        ]);

        _formEdited = false;
        startTrackingChanges();
        notifyListeners();
      } catch (_) {}
    } else {
      _formEdited = false;
      isEdit = true;
      isloading = false;
      fetchStages(client!);
      startTrackingChanges();
      notifyListeners();
    }
  }

  /// Reset all form fields and state (used when creating new record)
  bool clearAll(String type) {
    messageBounceController.text = "";
    compnayNameController.text = "";
    probablityController.text = "";
    streetController.text = "";
    cityController.text = "";
    zipController.text = "";
    websiteController.text = "";
    phoneController.text = "";
    mobileController.text = "";
    emailController.text = "";
    dayOpenController.text = "";
    dayCloseController.text = "";
    contactNameController.text = "";
    descriptionController.text = "";
    expectedRevenueController.text = "";
    referredController.text = "";
    nameController.text = "";
    jobPositionController.text = "";
    _active = null;
    _stageid = 1;
    _probablity = null;
    _userId = null;
    _personValue = null;
    _teamValue = null;

    _selectedCustomer = null;

    selectedSalespersonId = null;
    selectedSalesTeamId = null;
    selectedPartnerId = null;
    selectedCountryId = null;
    selectedStateId = null;
    selectedCampaignId = null;
    selectedMediumId = null;
    selectedSourceId = null;
    selectedCampaign = null;
    selectedMedium = null;
    selectedSource = null;

    _data.clear();
    _data['type'] = type;
    _data['name'] = 'No Name';

    selectedTagIds.clear();
    _leadTags.clear();
    expectedRevenue = 0;
    expectedClosing = null;
    initialState = "New";
    isloading = false;
    notifyListeners();
    return true;
  }

  String? _currentStageName;

  String? get currentStageName => _currentStageName;

  void updateStageId(int id) {
    _stageid = id;

    final stage = stagesList.firstWhere(
      (s) => s['id'] == id,
      orElse: () => {'name': 'Unknown'},
    );
    _currentStageName = stage['name'] as String?;

    markFormEdited();
    notifyListeners();
  }

  @override
  void dispose() {
    stopTrackingChanges();
    nameController.dispose();
    phoneController.dispose();
    mobileController.dispose();
    emailController.dispose();
    contactNameController.dispose();
    descriptionController.dispose();
    searchcontroller.dispose();

    jobPositionController.dispose();
    referredController.dispose();
    expectedRevenueController.dispose();
    streetController.dispose();
    cityController.dispose();
    zipController.dispose();
    compnayNameController.dispose();
    dayCloseController.dispose();
    dayOpenController.dispose();

    super.dispose();
  }

  void changeToEdit() {
    isEdit = true;
    notifyListeners();
  }

  bool _formEdited = false;
  bool _listenersActive = false;
  bool get formEdited => _formEdited;

  /// Call this whenever any form field is changed by the user
  void markFormEdited() {
    if (!_formEdited) {
      _formEdited = true;
      notifyListeners();
    }
  }

  /// Controllers tracked for form change detection
  List<TextEditingController> get _formControllers => [
        nameController,
        phoneController,
        mobileController,
        emailController,
        jobPositionController,
        contactNameController,
        descriptionController,
        referredController,
        expectedRevenueController,
        streetController,
        cityController,
        zipController,
        websiteController,
        probablityController,
        compnayNameController,
      ];

  void _onFieldEdited() {
    if (_listenersActive) {
      markFormEdited();
      notifyListeners();
    }
  }

  /// Start listening for form changes (call AFTER data is loaded)
  void startTrackingChanges() {
    _listenersActive = false;
    for (final c in _formControllers) {
      c.removeListener(_onFieldEdited);
      c.addListener(_onFieldEdited);
    }
    Future.microtask(() {
      _listenersActive = true;
    });
  }

  void stopTrackingChanges() {
    _listenersActive = false;
    for (final c in _formControllers) {
      c.removeListener(_onFieldEdited);
    }
  }

  void updateProbability(double newValue) {
    _probablity = newValue;
    notifyListeners();
  }

  /// Load stages list (usually called once per session)
  Future<void> fetchStages(OdooClient client) async {
    try {
      final stages = await CompanySessionManager.callKwWithCompany({
        'model': 'crm.stage',
        'method': 'search_read',
        'args': [[]],
        'kwargs': {
          'fields': ['id', 'name']
        },
      });
      stagesList = stages;
      notifyListeners();
    } catch (_) {}
  }

  /// Load chatter messages (with fallback when tracking_value_ids fails)
  Future<void> fetchMessages(OdooClient client, String redModel, int resId,
      {bool loading = false}) async {
    if (loading) {
      isMessageLoading = true;
      notifyListeners();
    }
    try {
      await _fetchMessagesWithTracking(client, redModel, resId);
    } catch (e) {
      if (e.toString().contains('tracking_value_ids')) {
        await _fetchMessagesWithoutTracking(client, redModel, resId);
      } else {
        messageList.clear();
        isMessageLoading = false;
        notifyListeners();
      }
    }
  }

  Future<void> _fetchMessagesWithoutTracking(
      OdooClient client, String redModel, int resId) async {
    final response = await CompanySessionManager.callKwWithCompany({
      'model': 'mail.message',
      'method': 'search_read',
      'args': [
        [
          ["res_id", "=", resId],
          ["model", "=", redModel],
          ["message_type", "!=", "user_notification"],
        ]
      ],
      'kwargs': {
        'fields': [
          'author_id',
          'body',
          'create_date',
          'create_uid',
          'date',
          'display_name',
          'email_from',
          'id',
          'res_id',
          'message_type',
          'parent_id',
          'notification_ids',
          'partner_ids',
          'subject',
          'subtype_id',
        ],
        'limit': 100,
      },
    });

    messageList = List<Message>.from(
      response.map((json) => Message.fromJson(json)),
    );

    trackingValueList.clear();
    messageAlreadyLoaded = true;
    isMessageLoading = false;
    notifyListeners();
  }

  Future<void> _fetchMessagesWithTracking(
      OdooClient client, String redModel, int resId) async {
    final response = await CompanySessionManager.callKwWithCompany({
      'model': 'mail.message',
      'method': 'search_read',
      'args': [
        [
          ["res_id", "=", resId],
          ["model", "=", redModel],
          ["message_type", "!=", "user_notification"],
        ]
      ],
      'kwargs': {
        'fields': [
          'author_id',
          'body',
          'create_date',
          'create_uid',
          'date',
          'display_name',
          'email_from',
          'id',
          'res_id',
          'message_type',
          'parent_id',
          'notification_ids',
          'partner_ids',
          'subject',
          'subtype_id',
          'tracking_value_ids',
        ],
        'limit': 100,
      },
    });

    final Set<int> allTrackingIds = {};
    for (var msg in response) {
      if (msg['tracking_value_ids'] is List) {
        allTrackingIds.addAll(List<int>.from(msg['tracking_value_ids']));
      }
    }

    Map<int, TrackingValue> trackingMap = {};
    if (allTrackingIds.isNotEmpty) {
      final trackingResponse = await CompanySessionManager.callKwWithCompany({
        'model': 'mail.tracking.value',
        'method': 'search_read',
        'args': [
          [
            ['id', 'in', allTrackingIds.toList()],
          ]
        ],
        'kwargs': {
          'fields': [
            'id',
            'field_id',
            'old_value_char',
            'old_value_float',
            'new_value_float',
            'new_value_char',
            'field_info',
          ],
        },
      });

      trackingMap = {
        for (var item in trackingResponse)
          item['id']: TrackingValue.fromJson(item)
      };

      trackingValueList = List<Map<String, dynamic>>.from(trackingResponse);
    }

    messageList = List<Message>.from(
      response.map((json) => Message.fromJson(json, trackingMap: trackingMap)),
    );

    messageAlreadyLoaded = true;
    isMessageLoading = false;
    notifyListeners();
  }

  /// Main fetch method — loads lead/opportunity + tags + messages
  Future<void> fetchStatus(OdooClient client, dynamic lead,
      {bool loading = false}) async {
    final prefs = await SharedPreferences.getInstance();
    int version = prefs.getInt('version') ?? 0;

    try {
      hasError = false;
      if (loading) {
        isloading = true;

        notifyListeners();
      }
      isEdit = false;
      messageAlreadyLoaded = false;
      final response = await CompanySessionManager.callKwWithCompany({
        'model': 'crm.lead',
        'method': 'search_read',
        'args': [
          [
            [
              "active",
              "=",
              [true, false]
            ],
            ['id', '=', lead['id']],
          ]
        ],
        'kwargs': {
          'fields': [
            'active',
            'probability',
            'name',
            'phone',
            if (version <= 18) 'mobile',
            'type',
            'email_from',
            'city',
            'country_id',
            'team_id',
            'user_id',
            'partner_id',
            'priority',
            'tag_ids',
            'date_open',
            'function',
            'day_close',
            'date_closed',
            'date_deadline',
            'description',
            'contact_name',
            'stage_id',
            'campaign_id',
            'medium_id',
            'source_id',
            'referred',
            'day_open',
            'message_bounce',
            'expected_revenue',
            'company_id',
            'partner_name',
            'street',
            'city',
            'zip',
            'state_id',
            'website',
          ],
        },
      });

      if (response.isNotEmpty) {
        final result = response[0];

        _active = result['active'];
        _stageid = result['stage_id'][0];
        _probablity = result['probability'] != null
            ? (result['probability'] as num).toDouble()
            : null;

        _data.clear();
        _data.addAll({
          'id': result['id'],
          'messageBounce': _sanitize(result['message_bounce']),
          'companyName': _sanitize(result['partner_name']),
          'stage': _sanitize(result['stage_id']),
          'name': _sanitize(result['name']),
          'phone': _sanitize(result['phone']),
          if (version <= 18) 'mobile': _sanitize(result['mobile']),
          'emailFrom': _sanitize(result['email_from']),
          'city': _sanitize(result['city']),
          'type': _sanitize(result['type']),
          'countryId': _sanitize(result['country_id']),
          'teamId': _sanitize(result['team_id']),
          'userId': _sanitize(result['user_id']),
          'function': _sanitize(result['function']),
          'partnerId': _sanitize(result['partner_id']),
          'priority': _sanitize(result['priority']),
          'tagIds': _sanitize(result['tag_ids']),
          'dateOpen': _sanitize(result['date_open']),
          'dateClosed': _sanitize(result['date_closed']),
          'description': _sanitize(result['description']),
          'contactName': _sanitize(result['contact_name']),
          'campaign_id': _sanitize(result['campaign_id']),
          'medium_id': _sanitize(result['medium_id']),
          'source_id': _sanitize(result['source_id']),
          'referred': _sanitize(result['referred']),
          'company': _sanitize(result['company_id']),
          'street': _sanitize(result['street']),
          'state': _sanitize(result['state_id']),
          'zip': _sanitize(result['zip']),
          'country': _sanitize(result['country_id']),
          'website': _sanitize(result['website']),
          'lang': _sanitize(result['lang']),
          'expected_revenue': result['expected_revenue'],
          'dayOpen': _sanitize(result['day_open']),
          'dayClose': _sanitize(result['day_close']),
          'deadline': _sanitize(result['date_deadline']),
        });

        final model = LeadFormDataModel.fromJson(result);
        await isarService.saveLeadFormData(model);
      }

      expectedClosing = _data['deadline'];

      initialState = _data['stage'] is List && _data['stage'].length > 1
          ? _data['stage'][1]
          : "";

      messageBounceController.text = _data['messageBounce'].toString();
      compnayNameController.text = _data['companyName'] ?? '';
      probablityController.text = _probablity.toString();
      streetController.text = _data['street'] ?? '';
      cityController.text = _data['city'] ?? '';
      zipController.text = _data['zip'] ?? '';
      websiteController.text = _data['website'] ?? '';
      phoneController.text = _data['phone'] ?? '';
      if (version <= 18) mobileController.text = _data['mobile'] ?? '';
      emailController.text = _data['emailFrom'] ?? '';
      dayOpenController.text = _data['dayOpen'].toString();
      dayCloseController.text = _data['dayClose'].toString();
      contactNameController.text = _data['contactName'] ?? '';
      descriptionController.text = _data['description'] ?? '';
      expectedRevenue = _data['expected_revenue'] ?? 0;
      expectedRevenueController.text = expectedRevenue.toString();

      referredController.text = _data['referred']?.toString() ?? '';
      selectedSalespersonId =
          _data['userId'] is List && _data['userId'].length > 1
              ? _data['userId'][0]
              : null;
      selectedPartnerId =
          _data['partnerId'] is List && _data['partnerId'].length > 0
              ? _data['partnerId'][0]
              : null;

      selectedCountryId =
          _data['country'] is List && _data['country'].length > 1
              ? Country(id: _data['country'][0], name: _data['country'][1])
              : null;
      selectedStateId = _data['state'] is List && _data['state'].length > 1
          ? StateClass(id: _data['state'][0], name: _data['state'][1])
          : null;

      selectedSalesTeamId =
          _data['teamId'] is List && _data['teamId'].length > 1
              ? _data['teamId'][0]
              : null;

      selectedTagIds = List<int>.from(_data['tagIds']);
      selectedCampaign = _data['campaign_id'] is List &&
              _data['campaign_id'].length > 0
          ? Campaign(id: _data['campaign_id'][0], name: _data['campaign_id'][1])
          : null;

      selectedMedium =
          _data['medium_id'] is List && _data['medium_id'].length > 0
              ? Medium(id: _data['medium_id'][0], name: _data['medium_id'][1])
              : null;
      selectedSource =
          _data['source_id'] is List && _data['source_id'].length > 0
              ? Source(id: _data['source_id'][0], name: _data['source_id'][1])
              : null;
      nameController.text = _data['name'] ?? "";
      jobPositionController.text = _data['function'] ?? "";

      selectedCampaignId =
          _data['campaign_id'] is List && _data['campaign_id'].length > 0
              ? _data['campaign_id'][0]
              : null;

      selectedMediumId =
          _data['medium_id'] is List && _data['medium_id'].length > 0
              ? _data['medium_id'][0]
              : null;
      selectedSourceId =
          _data['source_id'] is List && _data['source_id'].length > 0
              ? _data['source_id'][0]
              : null;

      final tagResponse = await CompanySessionManager.callKwWithCompany({
        'model': 'crm.tag',
        'method': 'search_read',
        'args': [
          [
            ['id', 'in', selectedTagIds]
          ]
        ],
        'kwargs': {
          'fields': ['id', 'name'],
        },
      });

      if (tagResponse != null && tagResponse is List) {
        _leadTags = tagResponse
            .map((tag) => LeadTag.fromJson(tag as Map<String, dynamic>))
            .toList();
      }
      isloading = false;
      notifyListeners();
    } catch (e) {
      leadError = await ErrorHandler.handleException(e);
      final success = await loadLeadFormDataById(lead['id']);
      if (success == false) {
        Future.delayed(const Duration(seconds: 2), () {
          isloading = false;
          hasError = true;
          notifyListeners();
        });
      }
    }
  }

  /// Fallback: load previously cached data from Isar
  Future<bool> loadLeadFormDataById(int leadId) async {
    final prefs = await SharedPreferences.getInstance();
    int version = prefs.getInt('version') ?? 0;

    final model = await IsarService.getLeadFormData(leadId);

    if (model == null) {
      return false;
    }

    _data.clear();
    _data.addAll({
      'id': model.leadId,
      'messageBounce': null,
      'companyName': model.companyName,
      'stage': [model.stageId, model.stageName],
      'name': model.name,
      'phone': model.phone,
      if (version <= 18) 'mobile': model.mobile,
      'emailFrom': model.emailFrom,
      'city': model.city,
      'type': model.type,
      'countryId': [model.countryId, model.countryName],
      'teamId': [model.teamId, model.teamName],
      'userId': [model.userId, model.userName],
      'function': model.jobPosition,
      'partnerId': [model.partnerId, model.partnerName],
      'priority': null,
      'tagIds': model.tagIds,
      'dateOpen': model.dateOpen,
      'dateClosed': model.dateClosed,
      'description': model.description,
      'contactName': model.contactName,
      'campaign_id': [model.campaignId, model.campaignName],
      'medium_id': [model.mediumId, model.mediumName],
      'source_id': [model.sourceId, model.sourceName],
      'referred': model.referred,
      'company_id': [model.companyId, model.companyName],
      'street': model.street,
      'state_id': [model.stateId, model.stateName],
      'zip': model.zip,
      'website': model.website,
      'expected_revenue': model.expectedRevenue,
      'dayOpen': model.dayOpen,
      'dayClose': model.dayClose,
      'date_deadline': model.deadline,
    });

    _stageid = model.stageId;
    _active = model.active;
    _probablity = model.probability;

    expectedClosing = model.deadline;
    initialState = model.stageName ?? "";

    nameController.text = model.name ?? '';
    jobPositionController.text = model.jobPosition ?? '';
    streetController.text = model.street ?? '';
    cityController.text = model.city ?? '';
    zipController.text = model.zip ?? '';
    websiteController.text = model.website ?? '';
    phoneController.text = model.phone ?? '';
    mobileController.text = model.mobile ?? '';
    emailController.text = model.emailFrom ?? '';
    dayOpenController.text = model.dayOpen ?? '';
    dayCloseController.text = model.dayClose ?? '';
    contactNameController.text = model.contactName ?? '';
    descriptionController.text = model.description ?? '';
    expectedRevenueController.text = model.expectedRevenue?.toString() ?? '0';
    probablityController.text = model.probability?.toString() ?? '';
    referredController.text = model.referred ?? '';
    compnayNameController.text = model.companyName ?? '';

    selectedSalespersonId = model.userId;
    selectedPartnerId = model.partnerId;

    selectedCountryId = model.countryId != null
        ? Country(id: model.countryId!, name: model.countryName ?? '')
        : null;

    selectedStateId = model.stateId != null
        ? StateClass(id: model.stateId!, name: model.stateName ?? '')
        : null;

    selectedSalesTeamId = model.teamId;
    selectedCampaignId = model.campaignId;
    selectedMediumId = model.mediumId;
    selectedSourceId = model.sourceId;

    selectedCampaign = model.campaignId != null
        ? Campaign(id: model.campaignId!, name: model.campaignName ?? '')
        : null;

    selectedMedium = model.mediumId != null
        ? Medium(id: model.mediumId!, name: model.mediumName ?? '')
        : null;

    selectedSource = model.sourceId != null
        ? Source(id: model.sourceId!, name: model.sourceName ?? '')
        : null;
    final tagResponse = await IsarService.getCachedLeadTagsById(model.tagIds);

    _leadTags = tagResponse
        .map((tag) => LeadTag(id: tag.serverId!, name: tag.name ?? ''))
        .toList();

    isloading = false;
    notifyListeners();
    return true;
  }

  dynamic _sanitize(dynamic value) {
    return value == false ? null : value;
  }

  void updatePriority(int newPriority) {
    _data['priority'] = newPriority.toString();
    notifyListeners();
  }

  Future<List<Campaign>> fetchCampaigns(OdooClient client) async {
    try {
      final response = await CompanySessionManager.callKwWithCompany({
        'model': 'utm.campaign',
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'fields': ['id', 'name'],
        },
      });

      return (response as List<dynamic>)
          .map((item) => Campaign.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<Medium>> fetchMediums(OdooClient client) async {
    try {
      final response = await CompanySessionManager.callKwWithCompany({
        'model': 'utm.medium',
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'fields': ['id', 'name'],
        },
      });

      return (response as List<dynamic>)
          .map((item) => Medium.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<Source>> fetchSources(OdooClient client) async {
    try {
      final response = await CompanySessionManager.callKwWithCompany({
        'model': 'utm.source',
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'fields': ['id', 'name'],
        },
      });

      return (response as List<dynamic>)
          .map((item) => Source.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<Country>> fetchCountries(OdooClient client) async {
    try {
      final countrylist = await CompanySessionManager.callKwWithCompany({
        'model': 'res.country',
        'method': 'search_read',
        'args': [[]],
        'kwargs': {
          'fields': ['id', 'name']
        },
      });

      return (countrylist as List<dynamic>)
          .map((item) => Country.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<bool> markLeadAsWon(
      int leadId, BuildContext context, dynamic lead) async {
    try {
      final client =
          Provider.of<OdooClientManager>(context, listen: false).client;
      var result = await CompanySessionManager.callKwWithCompany({
        'model': 'crm.stage',
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'domain': [
            ['name', '=', 'Won']
          ],
          'fields': ['id'],
          'limit': 1,
        }
      });

      if (result.isEmpty) {
        return false;
      }

      int wonStageId = result[0]['id'];

      await CompanySessionManager.callKwWithCompany({
        'model': 'crm.lead',
        'method': 'write',
        'args': [
          [leadId],
          {'stage_id': wonStageId}
        ],
        'kwargs': {}
      });
      await fetchStatus(client!, lead);
      return true;
    } catch (e) {
      return false;
    }
  }

  void clear() {
    _probablity = null;
    _stageid = null;
    _data.clear();
    _active = null;
    notifyListeners();
  }

  /// Save changes to existing lead/opportunity
  Future<bool> saveChanges(
      OdooClient client, BuildContext context, dynamic lead) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      int version = prefs.getInt('version') ?? 0;

      isEdit = false;

      messageAlreadyLoaded = false;

      notifyListeners();

      final dynamic response = await sessionService.callKwWithCompanyUpdate({
        'model': 'crm.lead',
        'method': 'write',
        'args': [
          [lead['id']],
          {
            'user_id': selectedSalespersonId,
            'team_id': selectedSalesTeamId,
            'name': nameController.text,
            'phone': phoneController.text,
            if (version <= 18) 'mobile': mobileController.text,
            'email_from': emailController.text,
            'contact_name': contactNameController.text,
            'description': descriptionController.text,
            'probability': double.tryParse(probablityController.text) ?? 0.0,
            'active': _active,
            'tag_ids': selectedTagIds,
            'date_deadline': expectedClosing,
            'function': jobPositionController.text,
            'campaign_id': selectedCampaign?.id,
            'medium_id': selectedMedium?.id,
            'source_id': selectedSource?.id,
            'referred': referredController.text,
            'street': streetController.text,
            'city': cityController.text,
            'zip': zipController.text,
            'stage_id': _stageid,
            'country_id': selectedCountryId?.id,
            'partner_id': selectedPartnerId,
            'partner_name': compnayNameController.text,
            'state_id': selectedStateId?.id,
            'priority': _data['priority'],
            'website': websiteController.text,
            'expected_revenue':
                double.tryParse(expectedRevenueController.text) ?? 0.0,
            'day_open': double.tryParse(dayOpenController.text) ?? 0.0,
            'day_close': double.tryParse(dayCloseController.text) ?? 0.0,
          }
        ],
        'kwargs': {},
      });

      if (context.mounted) {
        CustomSnackbar.showSuccess(context, 'Changes saved successfully');
      }

      if (response) {
        isEdit = false;
        isChanged = true;
        await fetchStatus(client, lead);

        return true;
      } else {
        return false;
      }
    } catch (e) {
      rethrow;
    } finally {
      isloading = false;
      notifyListeners();
    }
  }

  String parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    return document.body?.text ?? '';
  }

  /// Create brand new lead or opportunity
  Future<bool> createOpportunity(
      OdooClient client, BuildContext context, String type) async {
    final prefs = await SharedPreferences.getInstance();
    int version = prefs.getInt('version') ?? 0;

    if (nameController.text.trim().isEmpty) {
      CustomSnackbar.showWarning(context, 'Name cant be empty');

      return false;
    }
    try {
      final response = await sessionService.callKwWithCompany({
        'model': 'crm.lead',
        'method': 'create',
        'args': [
          {
            'user_id': selectedSalespersonId,
            'team_id': selectedSalesTeamId,
            'name': nameController.text,
            'phone': phoneController.text,
            if (version <= 18) 'mobile': mobileController.text,
            'email_from': emailController.text,
            'contact_name': contactNameController.text,
            'description': descriptionController.text,
            'probability': double.tryParse(probablityController.text) ?? 0.0,
            'active': true,
            'tag_ids': selectedTagIds,
            'date_deadline': expectedClosing,
            'function': jobPositionController.text,
            'campaign_id': selectedCampaign?.id,
            'medium_id': selectedMedium?.id,
            'source_id': selectedSource?.id,
            'stage_id': _stageid,
            'referred': referredController.text,
            'street': streetController.text,
            'city': cityController.text,
            'zip': zipController.text,
            'country_id': selectedCountryId?.id,
            'partner_id': selectedPartnerId,
            'partner_name': compnayNameController.text,
            'state_id': selectedStateId?.id,
            'type': type,
            'website': websiteController.text,
            'expected_revenue':
                double.tryParse(expectedRevenueController.text) ?? 0.0,
            'day_open': double.tryParse(dayOpenController.text) ?? 0.0,
            'day_close': double.tryParse(dayCloseController.text) ?? 0.0,
          }
        ],
        'kwargs': {},
      });

      if (response != null && response is int) {
        if (context.mounted) {
          CustomSnackbar.showSuccess(context, 'New $type Created successfully');
        }
        isChanged = true;
        await fetchStatus(client, {'id': response});
        notifyListeners();
      }
      return true;
    } catch (e) {
      return false;
    } finally {
      isloading = false;
      notifyListeners();
    }
  }

  /// Show dialog → convert lead to opportunity (create/merge customer)
  void showConversionPopup(BuildContext context, lead) {
    _teamValue = lead['team_id'] is List && lead['team_id'].length > 1
        ? lead['team_id'][0]
        : null;

    _personValue = lead['user_id'] is List && lead['user_id'].length > 1
        ? lead['user_id'][0]
        : null;

    SalesPersonItem? initialSalesPersonItem;
    final odoomanagerprovider =
        Provider.of<OdooClientManager>(context, listen: false);

    final dropdownitems = odoomanagerprovider.leadItems;
    final allcustomer = odoomanagerprovider.customerItems;
    final allsalesperson = odoomanagerprovider.salesPersonItem;

    if (_personValue != null && allsalesperson.isNotEmpty) {
      final initialSalesPerson = allsalesperson.firstWhere(
        (item) => item.id == _personValue,
      );
      initialSalesPersonItem = initialSalesPerson;
    }
    selectedPartnerId =
        lead['partner_id'] is List && lead['partner_id'].length > 1
            ? lead['partner_id'][0]
            : null;

    final ScrollController _chipScrollController = ScrollController();
    final _mergeSearchController = TextEditingController();
    final _mergeDropdownKey = GlobalKey<DropdownSearchState<LeadItem>>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        bool _isLoading = false;
        final isDark = Theme.of(context).brightness == Brightness.dark;

        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              elevation: 16,
              backgroundColor: Colors.white,
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: 900,
                  maxHeight: MediaQuery.of(context).size.height * 0.6,
                ),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[900] : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              "Convert to Opportunity",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.close_rounded,
                              color: Colors.grey[600],
                            ),
                            onPressed: () => Navigator.pop(context),
                            style: IconButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Flexible(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Conversion Action",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: isDark ? Colors.white : Colors.black,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Container(
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? Colors.grey[800]
                                      : Colors.grey[100],
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.grey[300]!,
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextButton(
                                        onPressed: () {
                                          setState(() {
                                            _conversionAction = "convert";
                                          });
                                        },
                                        style: TextButton.styleFrom(
                                          backgroundColor: _conversionAction == "convert"
                                              ? Colors.black
                                              : Colors.grey[100],
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10)),
                                          padding: const EdgeInsets.all(13),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.transform_rounded,
                                              size: 18,
                                              color: _conversionAction == "convert"
                                                  ? Colors.white
                                                  : Colors.grey[600],
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              "Convert",
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                                color: _conversionAction == "convert"
                                                    ? Colors.white
                                                    : Colors.grey[600],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: TextButton(
                                        onPressed: () {
                                          setState(() {
                                            _conversionAction = "merge";
                                          });
                                        },
                                        style: TextButton.styleFrom(
                                          backgroundColor: _conversionAction == "merge"
                                              ? Colors.black
                                              : Colors.grey[100],
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10)),
                                          padding: const EdgeInsets.all(13),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.merge_rounded,
                                              size: 18,
                                              color: _conversionAction == "merge"
                                                  ? Colors.white
                                                  : Colors.grey[600],
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              "Merge",
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                                color: _conversionAction == "merge"
                                                    ? Colors.white
                                                    : Colors.grey[600],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              if (_conversionAction == "merge") ...[
                                const Text(
                                  "Select Leads to Merge",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                ConstrainedBox(
                                  constraints:
                                      const BoxConstraints(maxHeight: 300),
                                  child: DropdownSearch<LeadItem>.multiSelection(
                                    key: _mergeDropdownKey,
                                    compareFn: (a, b) => a.id == b.id,
                                    items: () {
                                      final seen = <int>{};
                                      final unique = dropdownitems.where((item) => item.id != null && seen.add(item.id!)).toList();
                                      return [
                                        ...unique.where((item) => selectedLeads.any((s) => s.id == item.id)),
                                        ...unique.where((item) => !selectedLeads.any((s) => s.id == item.id)),
                                      ];
                                    }(),
                                    selectedItems: selectedLeads,
                                    dropdownBuilder: (context, selectedItems) {
                                      return Container(
                                        constraints: const BoxConstraints(
                                            minHeight: 32),
                                        child: selectedItems.isEmpty
                                            ? Text(
                                                "Select Leads",
                                                style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontStyle: FontStyle.italic,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 14,
                                                ),
                                              )
                                            : Wrap(
                                                spacing: 6,
                                                runSpacing: 6,
                                                children: [
                                                  ...selectedItems
                                                      .take(2)
                                                      .map((item) {
                                                  return Container(
                                                    constraints: BoxConstraints(
                                                      maxWidth: MediaQuery.of(context).size.width * 0.55,
                                                    ),
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 10,
                                                        vertical: 4),
                                                    decoration: BoxDecoration(
                                                      color: const Color(
                                                          0xFFFCE7EE),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      border: Border.all(
                                                        color: const Color(
                                                                0xFFC03355)
                                                            .withOpacity(0.35),
                                                        width: 1,
                                                      ),
                                                    ),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Flexible(
                                                          child: Text(
                                                            item.name ?? '',
                                                            overflow: TextOverflow.ellipsis,
                                                            style: const TextStyle(
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight.w500,
                                                              color: Color(
                                                                  0xFFC03355),
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            width: 4),
                                                        GestureDetector(
                                                          behavior:
                                                              HitTestBehavior
                                                                  .opaque,
                                                          onTap: () {
                                                            setState(() {
                                                              selectedLeads
                                                                  .removeWhere(
                                                                      (s) =>
                                                                          s.id ==
                                                                          item.id);
                                                            });
                                                          },
                                                          child: const Icon(
                                                            Icons.close,
                                                            size: 14,
                                                            color: Color(
                                                                0xFFC03355),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                  }).toList(),
                                                  if (selectedItems.length > 2)
                                                    Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 10,
                                                          vertical: 4),
                                                      decoration: BoxDecoration(
                                                        color: Colors.grey[200],
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                      ),
                                                      child: Text(
                                                        '+${selectedItems.length - 2} more',
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color:
                                                              Colors.grey[700],
                                                        ),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                      );
                                    },
                                    popupProps: PopupPropsMultiSelection.menu(
                                      showSearchBox: false,
                                      searchFieldProps: TextFieldProps(
                                          controller: _mergeSearchController),
                                      showSelectedItems: true,
                                      menuProps: MenuProps(
                                        backgroundColor: Colors.white,
                                        elevation: 4,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                      validationWidgetBuilder:
                                          (context, __) =>
                                              const SizedBox.shrink(),
                                      selectionWidget:
                                          (context, item, isSelected) =>
                                              const SizedBox.shrink(),
                                      onItemAdded: (items, _) {
                                        setState(() {
                                          selectedLeads =
                                              List<LeadItem>.from(items);
                                        });
                                      },
                                      onItemRemoved: (items, _) {
                                        setState(() {
                                          selectedLeads =
                                              List<LeadItem>.from(items);
                                        });
                                      },
                                      title: Container(
                                        decoration: const BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                                color: Color(0xFFE0E0E0),
                                                width: 0.8),
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  16, 12, 16, 8),
                                              child: Text(
                                                'Select Leads to Merge',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12),
                                              child: TextField(
                                                controller:
                                                    _mergeSearchController,
                                                decoration: InputDecoration(
                                                  hintText: 'Search...',
                                                  filled: true,
                                                  fillColor: const Color(
                                                      0xFFF3F4F6),
                                                  prefixIcon: const Icon(
                                                      Icons.search,
                                                      size: 20),
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 12,
                                                          vertical: 10),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    borderSide: BorderSide.none,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      16, 6, 16, 10),
                                              child: Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    _mergeSearchController
                                                        .clear();
                                                    _mergeDropdownKey
                                                        .currentState
                                                        ?.closeDropDownSearch();
                                                  },
                                                  child: const Text(
                                                    'Done',
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Color(0xFFC03355),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      itemBuilder: (context, item, isSelected) {
                                        return Container(
                                          color: Colors.transparent,
                                          padding: const EdgeInsets.only(
                                              left: 16,
                                              right: 4,
                                              top: 4,
                                              bottom: 4),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  item.name ?? "N/A",
                                                  style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                              ),
                                              IgnorePointer(
                                                child: Checkbox(
                                                  value: isSelected,
                                                  onChanged: null,
                                                  checkColor: Colors.white,
                                                  fillColor:
                                                      WidgetStateProperty
                                                          .resolveWith<Color>(
                                                    (states) => states.contains(
                                                            WidgetState
                                                                .selected)
                                                        ? const Color(
                                                            0xFFC03355)
                                                        : Colors.transparent,
                                                  ),
                                                  side: const BorderSide(
                                                      color: Color(0xFFC03355),
                                                      width: 1.5),
                                                  shape:
                                                      RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      4)),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      constraints:
                                          const BoxConstraints(maxHeight: 380),
                                    ),
                                    dropdownDecoratorProps:
                                        DropDownDecoratorProps(
                                      dropdownSearchDecoration: InputDecoration(
                                        isDense: true,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 12),
                                        filled: true,
                                        fillColor: const Color(0xFFF2F4F6),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide: BorderSide(
                                            color: Colors.grey[300]!,
                                            width: 1,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide: BorderSide(
                                            color: Colors.grey[300]!,
                                            width: 1,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide: const BorderSide(
                                            color: Color(0xFFC03355),
                                            width: 1,
                                          ),
                                        ),
                                      ),
                                    ),
                                    onChanged: (values) {
                                      setState(() {
                                        selectedLeads = values;
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(height: 20),
                              ],
                              Text(
                                "Assign to Salesperson",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                width: double.infinity,
                                child: DropdownSearch<SalesPersonItem>(
                                  items: {for (final s in allsalesperson) s.id: s}.values.toList(),
                                  selectedItem: initialSalesPersonItem,
                                  popupProps: PopupProps.menu(
                                    showSearchBox: true,
                                    fit: FlexFit.loose,
                                    menuProps: MenuProps(
                                      backgroundColor: Colors.white,
                                      elevation: 4,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16),
                                      ),
                                    ),
                                    searchFieldProps: TextFieldProps(
                                      decoration: InputDecoration(
                                        hintText: "Search...",
                                        filled: true,
                                        fillColor:
                                            const Color(0xFFF3F4F6),
                                        prefixIcon:
                                            const Icon(Icons.search),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 12,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide.none,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: BorderSide(
                                            color: const Color(0xFFC03355),
                                            width: 1,
                                          ),
                                        ),
                                      ),
                                    ),
                                    constraints: const BoxConstraints(
                                        maxHeight: 320),
                                    itemBuilder:
                                        (context, item, isSelected) {
                                      final isCurrent =
                                          initialSalesPersonItem?.id ==
                                              item.id;
                                      return Container(
                                        color: isCurrent
                                            ? Theme.of(context).primaryColor
                                                .withOpacity(0.1)
                                            : Colors.transparent,
                                        child: ListTile(
                                          title: Text(
                                            item.name,
                                            style: TextStyle(
                                              color: Colors.black87,
                                              fontWeight: isCurrent
                                                  ? FontWeight.w600
                                                  : FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  dropdownDecoratorProps:
                                      DropDownDecoratorProps(
                                    dropdownSearchDecoration:
                                        InputDecoration(
                                      hintText: "Select Salesperson",
                                      hintStyle: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: Colors.grey[600],
                                        fontStyle: FontStyle.italic,
                                      ),
                                      filled: true,
                                      fillColor:
                                          const Color(0xFFF2F4F6),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                          color: const Color(0xFFC03355),
                                          width: 1,
                                        ),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 12),
                                    ),
                                  ),
                                  dropdownBuilder:
                                      (context, selectedItem) {
                                    if (selectedItem == null) {
                                      return Text(
                                        "Select Salesperson",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 15,
                                          color: Colors.grey[600],
                                          fontStyle: FontStyle.italic,
                                        ),
                                      );
                                    }
                                    return Text(
                                      selectedItem.name,
                                      style: const TextStyle(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    );
                                  },
                                  onChanged: (value) {
                                    setState(() {
                                      _personValue = value?.id;
                                      initialSalesPersonItem = value;
                                    });
                                  },
                                ),
                              ),
                              if (_personValue != null && _teamname != null) ...[
                                const SizedBox(height: 12),
                                const Text(
                                  "Sales Team",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _teamname!,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ],
                              const SizedBox(height: 20),
                              if (_conversionAction == "convert") ...[
                                Text(
                                  "Customer",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Column(
                                  children: [
                                    _buildCustomerOption(
                                      context: context,
                                      title: "New",
                                      value: "create",
                                      groupValue: _customerOption,
                                      onChanged: (v) => setState(
                                          () => _customerOption = v!),
                                    ),
                                    const SizedBox(height: 10),
                                    _buildCustomerOption(
                                      context: context,
                                      title: "Existing",
                                      value: "exist",
                                      groupValue: _customerOption,
                                      onChanged: (v) => setState(
                                          () => _customerOption = v!),
                                    ),
                                    const SizedBox(height: 10),
                                    _buildCustomerOption(
                                      context: context,
                                      title: "None",
                                      value: "nothing",
                                      groupValue: _customerOption,
                                      onChanged: (v) => setState(() {
                                        _customerOption = v!;
                                        selectedPartnerId = null;
                                      }),
                                    ),
                                  ],
                                ),
                                if (_customerOption == "exist") ...[
                                  const SizedBox(height: 12),
                                  SizedBox(
                                    width: double.infinity,
                                    child: DropdownSearch<dynamic>(
                                      items: allcustomer,
                                      popupProps: PopupProps.menu(
                                        showSearchBox: true,
                                        fit: FlexFit.loose,
                                        menuProps: MenuProps(
                                          backgroundColor: Colors.white,
                                          elevation: 4,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                        ),
                                        searchFieldProps: TextFieldProps(
                                          decoration: InputDecoration(
                                            hintText: "Search...",
                                            filled: true,
                                            fillColor:
                                                const Color(0xFFF3F4F6),
                                            prefixIcon:
                                                const Icon(Icons.search),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 12,
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide.none,
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              borderSide: BorderSide(
                                                color: const Color(0xFFC03355),
                                                width: 1,
                                              ),
                                            ),
                                          ),
                                        ),
                                        constraints: BoxConstraints(
                                            maxHeight: MediaQuery.of(context).size.height * 0.25),
                                        itemBuilder:
                                            (context, item, isSelected) {
                                          final isCurrent =
                                              selectedPartnerId != null &&
                                                  selectedPartnerId ==
                                                      item?.id;
                                          return Container(
                                            color: isCurrent
                                                ? Theme.of(context)
                                                    .primaryColor
                                                    .withOpacity(0.1)
                                                : Colors.transparent,
                                            child: ListTile(
                                              title: Text(
                                                item?.name ?? '',
                                                style: TextStyle(
                                                  color: Colors.black87,
                                                  fontWeight: isCurrent
                                                      ? FontWeight.w600
                                                      : FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      dropdownDecoratorProps:
                                          DropDownDecoratorProps(
                                        dropdownSearchDecoration:
                                            InputDecoration(
                                          hintText: "Select Customer",
                                          hintStyle: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            color: Colors.grey[600],
                                            fontStyle: FontStyle.italic,
                                          ),
                                          filled: true,
                                          fillColor:
                                              const Color(0xFFF2F4F6),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: BorderSide.none,
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: BorderSide.none,
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                              color: const Color(0xFFC03355),
                                              width: 1,
                                            ),
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 12,
                                                  vertical: 12),
                                        ),
                                      ),
                                      dropdownBuilder:
                                          (context, selectedItem) {
                                        if (selectedItem == null) {
                                          return Text(
                                            "Select Customer",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 15,
                                              color: Colors.grey[600],
                                              fontStyle: FontStyle.italic,
                                            ),
                                          );
                                        }
                                        return Text(
                                          selectedItem.name ?? '',
                                          style: const TextStyle(
                                            color: Colors.black87,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                          ),
                                        );
                                      },
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedCustomer = value?.name;
                                          selectedPartnerId = value?.id;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ],
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 24, 8, 16),
                        child: SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: ElevatedButton(
                            onPressed: _isLoading
                                ? null
                                : () {
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    void handleConvertOpportunity() async {
                                      final nav = Navigator.of(context);
                                      final duplicatedLeadIds = selectedLeads
                                          .map((item) => item.id)
                                          .toList();
                                      final success = await _convertOpportunity(
                                        lead['id'],
                                        {
                                          'partner_id': selectedPartnerId,
                                          'user_id': _personValue,
                                          'team_id': _teamValue,
                                          'name': _conversionAction,
                                          'action': _customerOption,
                                          'duplicated_lead_ids':
                                              duplicatedLeadIds,
                                        },
                                        context,
                                      );
                                      if (success) {
                                        nav.pop();
                                        if (nav.canPop()) nav.pop();
                                        if (context.mounted) {
                                          WidgetsBinding.instance
                                              .addPostFrameCallback((_) {
                                            if (context.mounted) {
                                              CustomSnackbar.showSuccess(
                                                  context,
                                                  'Lead converted to opportunity successfully');
                                            }
                                          });
                                        }
                                      } else if (context.mounted) {
                                        setState(() {
                                          _isLoading = false;
                                        });
                                      }
                                    }

                                    handleConvertOpportunity();
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                              shadowColor: Colors.transparent,
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(Icons.check_circle_outline, size: 22),
                                      SizedBox(width: 10),
                                      Text(
                                        "Create Opportunity",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void restore(OdooClient client, dynamic lead, BuildContext context) async {
    try {
      await CompanySessionManager.callKwWithCompany({
        'model': 'crm.lead',
        'method': 'toggle_active',
        'args': [
          [lead['id']]
        ],
        'kwargs': {},
      });

      await fetchStatus(client, lead);

      if (context.mounted) {
        Provider.of<LeadDataProvider>(context, listen: false).initlead(context);
        await Provider.of<OpportunityDataProvider>(context, listen: false)
            .getOpportunities(
          context: context,
          isLead: false,
          isOpportunity: true,
          isPop: false,
          loading: true,
        );

        CustomSnackbar.showSuccess(context, 'Lead restored successfully');
      }
    } catch (e) {
      if (context.mounted) {
        CustomSnackbar.showError(context, 'Failed to restore lead');
      }
    }
  }

  Future<bool> getDuplicatedLeads(int leadId, BuildContext context) async {
    try {
      final responseWrite = await CompanySessionManager.callKwWithCompany({
        'model': 'crm.lead2opportunity.partner',
        'method': 'create',
        'args': [
          {'lead_id': leadId, 'name': 'merge'}
        ],
        'kwargs': {},
      });

      final response = await CompanySessionManager.callKwWithCompany({
        'model': 'crm.lead2opportunity.partner',
        'method': 'read',
        'args': [responseWrite],
        'kwargs': {
          'fields': ['duplicated_lead_ids'],
        },
      });

      selectedLeads.clear();

      final duplicatedIds = response[0]['duplicated_lead_ids'];
      final leadDetails = await CompanySessionManager.callKwWithCompany({
        'model': 'crm.lead',
        'method': 'read',
        'args': [duplicatedIds],
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

      selectedLeads = leadDetails.map<LeadItem>((lead) {
        return LeadItem(
            contactname:
                lead['partner_id'] == false ? null : lead['partner_id'][1],
            id: lead['id'],
            name: lead['name'] == false ? null : lead['name'],
            email: lead['email_from'] == false ? null : lead['email_from'],
            createdon: lead['create_date'],
            salesperson: lead['user_id'] == false ? null : lead['user_id'][1],
            stage: lead['stage_id'][1]);
      }).toList();
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> _convertOpportunity(int id, Map<String, dynamic> opportunityList,
      BuildContext context) async {
    try {
      final client =
          Provider.of<OdooClientManager>(context, listen: false).client;
      if (client == null) {
        return false;
      }

      final String action = opportunityList['action'] ?? 'nothing';

      if (action == 'nothing') {
        final writeVals = <String, dynamic>{'type': 'opportunity'};
        if (opportunityList['user_id'] != null) {
          writeVals['user_id'] = opportunityList['user_id'];
        }
        if (opportunityList['team_id'] != null) {
          writeVals['team_id'] = opportunityList['team_id'];
        }
        await CompanySessionManager.callKwWithCompany({
          'model': 'crm.lead',
          'method': 'write',
          'args': [
            [id],
            writeVals,
          ],
          'kwargs': {},
        });
      } else {
        final createFields = <String, dynamic>{
          'lead_id': id,
          'action': action,
          'name': opportunityList['name'],
        };
        if (opportunityList['user_id'] != null) {
          createFields['user_id'] = opportunityList['user_id'];
        }
        if (opportunityList['team_id'] != null) {
          createFields['team_id'] = opportunityList['team_id'];
        }
        if (opportunityList['partner_id'] != null) {
          createFields['partner_id'] = opportunityList['partner_id'];
        }
        final duplicatedIds =
            (opportunityList['duplicated_lead_ids'] as List? ?? [])
                .whereType<int>()
                .toList();
        if (duplicatedIds.isNotEmpty) {
          createFields['duplicated_lead_ids'] = [
            [6, 0, duplicatedIds]
          ];
        }

        final wizardId = await CompanySessionManager.callKwWithCompany({
          'model': 'crm.lead2opportunity.partner',
          'method': 'create',
          'args': [createFields],
          'kwargs': {
            'context': {
              'active_model': 'crm.lead',
              'active_id': id,
            }
          },
        });

        if (wizardId == null || wizardId is! int) {
          return false;
        }

        await CompanySessionManager.callKwWithCompany({
          'model': 'crm.lead2opportunity.partner',
          'method': 'action_apply',
          'args': [
            [wizardId]
          ],
          'kwargs': {
            'context': {
              'active_model': 'crm.lead',
              'active_id': id,
              'active_ids': [id],
            },
          },
        });
      }

      if (context.mounted) {
        Provider.of<LeadDataProvider>(context, listen: false)
            .getLeads(context: context, loading: true);
      }

      return true;
    } catch (e) {
      if (context.mounted) {
        CustomSnackbar.showError(
            context, 'Failed to convert lead to opportunity');
      }
      return false;
    }
  }

  final List<String> options = [
    "Too expensive",
    "We don't have people/skills",
    "Not enough stock",
    "Technical reasons",
    "Something else"
  ];
  String? selectedValue;
  TextEditingController searchController = TextEditingController();
  bool isCustomInput = false;

  Future<bool> showBottomSheet(BuildContext context, dynamic leadData) async {
    try {
      final result = await showModalBottomSheet<bool>(
        backgroundColor: AppColors().backGround,
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        isScrollControlled: true,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
            ),
            child: SingleChildScrollView(
              child: CustomDropdownLost(
                lead: leadData,
                isLead: leadData['type'] == 'lead',
              ),
            ),
          );
        },
      );

      return result ?? false;
    } catch (e) {
      if (context.mounted) {
        CustomSnackbar.showError(context, 'Failed to mark as lost');
      }
      return false;
    }
  }
}

/// Small stateless tile used in merge-lead selection dropdown
class OpportunityTile extends StatelessWidget {
  final String? opportunity;
  final String? contactName;
  final String? email;
  final Color cardColor;
  final String? salesperson;
  final bool close;
  final void Function()? onPressed;

  const OpportunityTile({
    super.key,
    required this.close,
    required this.onPressed,
    required this.opportunity,
    required this.contactName,
    required this.email,
    required this.cardColor,
    required this.salesperson,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Stack(
        children: [
          Container(
            color: cardColor,
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    opportunity!,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 4),
                Text("Name: $contactName",
                    style: const TextStyle(fontSize: 12)),
                Text("$email", style: const TextStyle(fontSize: 12)),
                Text("Salesperson: $salesperson",
                    style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
          if (close) ...[
            Positioned(
                top: -11,
                right: -11,
                child: IconButton(
                    onPressed: onPressed, icon: const Icon(Icons.close)))
          ]
        ],
      ),
    );
  }
}

/// Builds a radio-style toggle option matching the Create Invoice dialog design.
Widget _buildCustomerOption({
  required BuildContext context,
  required String title,
  required String value,
  required String groupValue,
  required ValueChanged<String?> onChanged,
}) {
  final isSelected = groupValue == value;
  return GestureDetector(
    onTap: () => onChanged(value),
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200, width: 1),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Radio<String>(
            value: value,
            groupValue: groupValue,
            onChanged: onChanged,
            fillColor: WidgetStatePropertyAll(
              isSelected
                  ? Theme.of(context).primaryColor
                  : Colors.grey.shade400,
            ),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

/// Builds a single equal-width pill/capsule toggle button used in the
/// "Customer" section of the Convert to Opportunity dialog.
Widget _buildCapsuleBtn(
  String label,
  String value,
  String selectedValue,
  bool isDark,
  VoidCallback onTap,
) {
  final isSelected = selectedValue == value;
  return Expanded(
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF000000)
              : (isDark ? Colors.grey[800] : Colors.white),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF000000)
                : (isDark ? Colors.grey[600]! : Colors.grey[300]!),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected
                ? Colors.white
                : (isDark ? Colors.grey[300] : Colors.grey[700]),
          ),
        ),
      ),
    ),
  );
}
