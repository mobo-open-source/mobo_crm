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
import '../../../global_methods/widgets/forms/mobo_dropdown_styles.dart';
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

  /// Set when the chatter failed to load, so the Messages screen can show a
  /// retry instead of silently looking like an empty, message-free chatter.
  String? messageError;
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

  /// Bumped whenever the form switches record (load or reset), so a failed
  /// load's delayed error state can't land on a form opened after it.
  int _loadGeneration = 0;

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
  String? assignmentDate;
  String? closingDate;
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
    if (assignmentDate != data['dateOpen']) return true;
    if (closingDate != data['dateClosed']) return true;

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
      // A new record has nothing to load, so an error left by an earlier
      // record must not replace the create form.
      hasError = false;
      leadError = null;
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
    assignmentDate = null;
    closingDate = null;
    initialState = "New";
    _currentStageName = "New";
    isloading = false;
    hasError = false;
    leadError = null;
    _loadGeneration++;
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

  /// The picked customer as an item for the Customer dropdown.
  ///
  /// The loaded customer list can miss it — archived, another company's, or
  /// created after the list was fetched (e.g. by a lead conversion) — so it
  /// falls back to the record's own name for it rather than showing whoever
  /// happens to be first in the list.
  CustomerItem? selectedPartnerItem(List<CustomerItem> items) {
    final id = selectedPartnerId;
    if (id == null) return null;
    for (final item in items) {
      if (item.id == id) return item;
    }
    final partner = _data['partnerId'];
    final name = partner is List && partner.length > 1 && partner[0] == id
        ? partner[1].toString()
        : 'Unknown';
    return CustomerItem(id: id, name: name, fullname: name, email: '');
  }

  /// Why the typed probability can't be saved, or null when it can. Empty is
  /// allowed and saved as 0.
  String? get probabilityError {
    final text = probablityController.text.trim();
    if (text.isEmpty) return null;
    final value = double.tryParse(text);
    if (value == null) return 'Enter a valid number';
    if (value < 0 || value > 100) {
      return 'Probability must be between 0 and 100';
    }
    return null;
  }

  /// Why the lead's Analysis dates can't be saved, or null when they can.
  ///
  /// Only once the user has picked one of them on this form: dates Odoo set
  /// itself (e.g. on a restored, reassigned lead) shouldn't lock every other
  /// edit. Compared by day, as the form only shows the date: the stored
  /// datetimes can carry a time of day the user never picked.
  String? get analysisDateError {
    final touched = _data['id'] == null ||
        assignmentDate != _data['dateOpen'] ||
        closingDate != _data['dateClosed'];
    if (!touched) return null;
    final open = DateTime.tryParse(assignmentDate ?? '');
    final closed = DateTime.tryParse(closingDate ?? '');
    if (open == null || closed == null) return null;
    final openDay = DateTime(open.year, open.month, open.day);
    final closedDay = DateTime(closed.year, closed.month, closed.day);
    if (closedDay.isBefore(openDay)) {
      return 'Assignment Date must be earlier than the Closing Date';
    }
    return null;
  }

  /// Whether the record is lost, as Odoo records it: archived with its
  /// probability at 0. An archived record that kept its probability is not.
  bool get isLost => _active == false && (_probablity ?? 0.0) == 0.0;

  /// Whether the record is won, as Odoo's `won_status` has it: open at 100%
  /// in a won stage. The stage is matched by its name and by the 100% it
  /// carries, since the won flag itself isn't fetched.
  bool get isWon =>
      _active != false &&
      (initialState == 'Won' || (_probablity ?? 0.0) >= 100.0);

  /// Why the lead can't be converted to an opportunity, judged on the record
  /// as it was last loaded, or null when it can. Unsaved edits don't count:
  /// a conversion acts on the saved record. [conversionBlockedReasonOnServer]
  /// is the same check against what the server holds now.
  String? get conversionBlockedReason => _conversionBlock(
        active: _active,
        probability: _probablity,
        closedOn: _data['dateClosed'] is String ? _data['dateClosed'] : null,
        expectedClosing: _data['deadline'] is String ? _data['deadline'] : null,
      );

  /// The rules that keep a dead or closed lead from being converted.
  ///
  /// A dead lead (lost or archived) is refused as Odoo does: its conversion
  /// skips inactive leads, which the app used to report as a success. A
  /// closed lead is refused too, once its Closing Date has been reached: Odoo
  /// stamps that date when a lead is won or lost. A lead whose Expected
  /// Closing date is already behind it is refused as well; Odoo itself lets
  /// that through, but a lead that overdue should be re-dated, not converted.
  ///
  /// A lead at 100% is refused with Odoo's own message. Odoo's conversion
  /// skips such a lead, and the wizard's check of it never runs when the lead
  /// is handed to the wizard, so the app reported a success for a record that
  /// stayed a lead.
  String? _conversionBlock({
    required bool? active,
    required double? probability,
    required String? closedOn,
    required String? expectedClosing,
  }) {
    if (active == false) {
      return 'A lost or archived lead cannot be converted to an opportunity. '
          'Restore it first.';
    }
    if ((probability ?? 0.0) >= 100.0) {
      return 'Closed/Dead leads cannot be converted into opportunities.';
    }
    final closed = DateTime.tryParse(closedOn ?? '');
    if (closedOn != null && closed != null && !closed.isAfter(DateTime.now())) {
      return 'This lead was closed on ${closedOn.split(' ').first}, so it '
          'cannot be converted to an opportunity.';
    }
    final expected = DateTime.tryParse(expectedClosing ?? '');
    if (expectedClosing != null && expected != null) {
      // Whole days: a lead expected to close today is still on time.
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final expectedDay = DateTime(expected.year, expected.month, expected.day);
      if (expectedDay.isBefore(today)) {
        return 'The expected closing date (${expectedClosing.split(' ').first}) '
            'has passed, so this lead cannot be converted to an opportunity. '
            'Update the Expected Closing date first.';
      }
    }
    return null;
  }

  /// [conversionBlockedReason] against the lead as the server holds it now,
  /// for when the form on screen is out of date: the lead may have been lost
  /// or closed since it loaded, and the Leads list now includes archived ones.
  ///
  /// Null when the lead can be converted, and also when it can't be read, so
  /// that an unreachable server shows its own error from the conversion
  /// rather than a verdict made without the record.
  Future<String?> conversionBlockedReasonOnServer(int leadId) async {
    try {
      final rows = await CompanySessionManager.callKwWithCompany({
        'model': 'crm.lead',
        'method': 'search_read',
        'args': [
          [
            ['id', '=', leadId],
            ['active', 'in', [true, false]],
          ]
        ],
        'kwargs': {
          'fields': ['active', 'date_closed', 'date_deadline', 'probability'],
          'limit': 1,
        },
      });
      if (rows is! List || rows.isEmpty || rows.first is! Map) return null;
      final row = rows.first as Map;
      // Odoo sends `false` for an empty date.
      String? text(String field) =>
          row[field] is String ? row[field] as String : null;
      return _conversionBlock(
        active: row['active'] is bool ? row['active'] as bool : null,
        probability: row['probability'] is num
            ? (row['probability'] as num).toDouble()
            : null,
        closedOn: text('date_closed'),
        expectedClosing: text('date_deadline'),
      );
    } catch (e) {
      debugPrint('[LeadFormProvider] conversion check for $leadId failed: $e');
      return null;
    }
  }

  /// The first field-level problem that blocks saving, or null. The
  /// Analysis dates only count on a lead, the only form that edits them.
  String? get _formValidationError =>
      probabilityError ??
      (_data['type'] != 'opportunity' ? analysisDateError : null);

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
      messageError = null;
      notifyListeners();
    }
    try {
      await _fetchMessagesWithTracking(client, redModel, resId);
    } catch (e, stack) {
      if (e.toString().contains('tracking_value_ids')) {
        try {
          await _fetchMessagesWithoutTracking(client, redModel, resId);
          return;
        } catch (e2, stack2) {
          debugPrint(
              '[LeadFormProvider] fetchMessages($redModel, $resId) without-tracking fallback failed: $e2\n$stack2');
        }
      } else {
        debugPrint(
            '[LeadFormProvider] fetchMessages($redModel, $resId) failed: $e\n$stack');
      }
      // Keep whatever was already on screen rather than wiping it out from
      // under the user — only report that the refresh itself failed.
      messageError = 'Could not load messages.';
      isMessageLoading = false;
      notifyListeners();
    }
  }

  /// Descriptions of the subtypes of messages that have no text of their
  /// own. Odoo logs a lead's creation with an empty body and its chatter
  /// shows the subtype's description instead ("Lead/Opportunity created");
  /// without it a new record's only message was hidden and its chatter
  /// looked empty. Enrichment only: on failure those messages stay hidden.
  Future<Map<int, String>> _subtypeDescriptions(List response) async {
    final ids = <int>{};
    for (final msg in response) {
      if (msg is! Map) continue;
      final body = msg['body'];
      final hasText =
          body is String && parseHtmlString(body).trim().isNotEmpty;
      final tracking = msg['tracking_value_ids'];
      final hasTracking = tracking is List && tracking.isNotEmpty;
      final subtype = msg['subtype_id'];
      if (!hasText && !hasTracking && subtype is List && subtype.isNotEmpty) {
        ids.add(subtype[0] as int);
      }
    }
    if (ids.isEmpty) return {};
    try {
      final rows = await CompanySessionManager.callKwWithCompany({
        'model': 'mail.message.subtype',
        'method': 'read',
        'args': [
          ids.toList(),
          ['description', 'name'],
        ],
        'kwargs': {},
      });
      final result = <int, String>{};
      for (final row in rows is List ? rows : const []) {
        if (row is! Map || row['id'] is! int) continue;
        final description = row['description'];
        final name = row['name'];
        final text = description is String && description.trim().isNotEmpty
            ? description.trim()
            : (name is String ? name : '');
        if (text.isNotEmpty) result[row['id'] as int] = text;
      }
      return result;
    } catch (e) {
      debugPrint('[LeadFormProvider] subtype descriptions failed: $e');
      return {};
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

    final descriptions = await _subtypeDescriptions(response);
    messageList = List<Message>.from(
      response.map((json) =>
          Message.fromJson(json, subtypeDescriptions: descriptions)),
    );

    trackingValueList.clear();
    messageAlreadyLoaded = true;
    isMessageLoading = false;
    messageError = null;
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
      // Enrichment only: a server that can't answer this (an unsupported
      // field, a model-access quirk) must not cost us the messages the
      // first call already fetched successfully.
      try {
        final trackingResponse =
            await CompanySessionManager.callKwWithCompany({
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
      } catch (e, stack) {
        debugPrint(
            '[LeadFormProvider] tracking value enrichment failed, showing messages without it: $e\n$stack');
        trackingValueList = [];
      }
    }

    final descriptions = await _subtypeDescriptions(response);
    messageList = List<Message>.from(
      response.map((json) => Message.fromJson(json,
          trackingMap: trackingMap, subtypeDescriptions: descriptions)),
    );

    messageAlreadyLoaded = true;
    isMessageLoading = false;
    messageError = null;
    notifyListeners();
  }

  /// Main fetch method — loads lead/opportunity + tags + messages
  Future<void> fetchStatus(OdooClient client, dynamic lead,
      {bool loading = false}) async {
    final generation = ++_loadGeneration;
    final leadId = lead is Map ? lead['id'] : null;
    // A record that does not exist yet (the create form) has nothing to load.
    if (leadId is! int) {
      hasError = false;
      leadError = null;
      isloading = false;
      notifyListeners();
      return;
    }

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
            ['id', '=', leadId],
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
        // Odoo sends `false` for a record without a stage.
        _stageid =
            result['stage_id'] is List ? result['stage_id'][0] as int? : null;
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
      assignmentDate = _data['dateOpen'];
      closingDate = _data['dateClosed'];

      initialState = _data['stage'] is List && _data['stage'].length > 1
          ? _data['stage'][1]
          : "";
      _currentStageName = initialState;

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
    } catch (e, stack) {
      debugPrint('[LeadFormProvider] fetchStatus($leadId) failed: $e\n$stack');
      final error = await ErrorHandler.handleException(e);
      // The form moved on to another record (or a new one) meanwhile.
      if (generation != _loadGeneration) return;
      leadError = error;
      // The cache is only a stand-in for an unreachable server. When the
      // server refuses this user the record, showing cached data would
      // just lead to edits that can never be saved.
      final accessDenied = e.toString().contains('AccessError');
      if (accessDenied) {
        leadError = AppError(
          type: ErrorType.server,
          message: "You don't have access to this record.",
        );
      }
      final success = !accessDenied && await loadLeadFormDataById(leadId);
      if (success == false) {
        Future.delayed(const Duration(seconds: 2), () {
          if (generation != _loadGeneration) return;
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
      'stage': _relation(model.stageId, model.stageName),
      'name': model.name,
      'phone': model.phone,
      if (version <= 18) 'mobile': model.mobile,
      'emailFrom': model.emailFrom,
      'city': model.city,
      'type': model.type,
      'countryId': _relation(model.countryId, model.countryName),
      'teamId': _relation(model.teamId, model.teamName),
      'userId': _relation(model.userId, model.userName),
      'function': model.jobPosition,
      'partnerId': _relation(model.partnerId, model.partnerName),
      'priority': null,
      'tagIds': model.tagIds,
      'dateOpen': model.dateOpen,
      'dateClosed': model.dateClosed,
      'description': model.description,
      'contactName': model.contactName,
      'campaign_id': _relation(model.campaignId, model.campaignName),
      'medium_id': _relation(model.mediumId, model.mediumName),
      'source_id': _relation(model.sourceId, model.sourceName),
      'referred': model.referred,
      'company_id': _relation(model.companyId, model.companyName),
      'street': model.street,
      'state_id': _relation(model.stateId, model.stateName),
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
    assignmentDate = model.dateOpen;
    closingDate = model.dateClosed;
    initialState = model.stageName ?? "";
    _currentStageName = initialState;

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

  /// A many2one as the cache stores it, rebuilt into the `[id, name]` pair
  /// Odoo returns, or null when it is unset, as the live fetch gives it.
  /// The cache keeps id and name in separate columns, so an unset relation
  /// used to come back as `[null, null]`: that passes the `length > 1` checks
  /// of a set one, and its null name then reached a String parameter.
  List<dynamic>? _relation(int? id, String? name) =>
      id == null ? null : [id, name ?? ''];

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
  /// Writes the edited lead and reloads it.
  ///
  /// Stays in edit mode with the user's input intact when the write fails,
  /// and reports the server's reason itself; returns whether it saved.
  Future<bool> saveChanges(
      OdooClient client, BuildContext context, dynamic lead) async {
    if (isloading) return false;
    final validationError = _formValidationError;
    if (validationError != null) {
      CustomSnackbar.showWarning(context, validationError);
      return false;
    }
    isloading = true;
    notifyListeners();
    // Whether the main write has gone through, so a failure of the date write
    // after it is reported as such rather than as nothing having been saved.
    var mainSaved = false;
    try {
      final prefs = await SharedPreferences.getInstance();
      int version = prefs.getInt('version') ?? 0;

      messageAlreadyLoaded = false;

      // Odoo's crm.lead write() recomputes both dates itself whenever the same
      // call also carries one of the fields they follow, and this form always
      // sends all of them: any probability between 0 and 100 resets
      // `date_closed` to empty, 100 or an archived record stamps it with now,
      // and a missing or changed salesperson does the same to `date_open`. A
      // date picked here was silently thrown away that way, on some records
      // and not others. They are written on their own after the main write,
      // where nothing overrides them.
      final dateValues = <String, dynamic>{
        if (assignmentDate != _data['dateOpen']) 'date_open': assignmentDate,
        if (closingDate != _data['dateClosed']) 'date_closed': closingDate,
      };

      final dynamic response = await CompanySessionManager.callKwWithCompany({
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

      if (response != true) {
        if (context.mounted) {
          CustomSnackbar.showError(context, 'Could not save the changes.');
        }
        return false;
      }
      mainSaved = true;

      if (dateValues.isNotEmpty) {
        final dynamic datesResponse =
            await CompanySessionManager.callKwWithCompany({
          'model': 'crm.lead',
          'method': 'write',
          'args': [
            [lead['id']],
            dateValues,
          ],
          'kwargs': {},
        });
        if (datesResponse != true) {
          if (context.mounted) {
            CustomSnackbar.showError(context,
                'The changes were saved, but the dates could not be.');
          }
          return false;
        }
      }

      isEdit = false;
      isChanged = true;
      _formEdited = false;
      await fetchStatus(client, lead);
      if (context.mounted) {
        CustomSnackbar.showSuccess(context, 'Changes saved successfully');
      }
      return true;
    } catch (e, stack) {
      debugPrint('[LeadFormProvider] saveChanges failed: $e\n$stack');
      if (context.mounted) {
        final reason = _odooErrorReason(e);
        CustomSnackbar.showError(
            context,
            mainSaved
                ? 'The changes were saved, but the dates could not be: $reason'
                : 'Could not save the changes: $reason');
      }
      return false;
    } finally {
      isloading = false;
      notifyListeners();
    }
  }

  /// The user-facing reason inside an Odoo error (e.g. an access or
  /// validation message) rather than the generic "Odoo Server Error".
  String _odooErrorReason(Object error) {
    final text = error.toString();
    final match = RegExp(r'message: (.+?), arguments:', dotAll: true)
        .firstMatch(text);
    final reason = match?.group(1)?.trim();
    if (reason != null && reason.isNotEmpty) return reason;
    if (error is! OdooException) return text;
    return 'Please try again.';
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
    final validationError = _formValidationError;
    if (validationError != null) {
      if (context.mounted) {
        CustomSnackbar.showWarning(context, validationError);
      }
      return false;
    }
    if (isloading) {
      return false;
    }
    isloading = true;
    notifyListeners();
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
            if (assignmentDate != null) 'date_open': assignmentDate,
            if (closingDate != null) 'date_closed': closingDate,
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
        return true;
      }
      if (context.mounted) {
        CustomSnackbar.showError(context, 'Error creating $type');
      }
      return false;
    } catch (e, stack) {
      debugPrint('[LeadFormProvider] createOpportunity failed: $e\n$stack');
      if (context.mounted) {
        CustomSnackbar.showError(
            context, 'Could not create the $type: ${_odooErrorReason(e)}');
      }
      return false;
    } finally {
      isloading = false;
      notifyListeners();
    }
  }

  /// Show dialog → convert lead to opportunity (create/merge customer)
  void showConversionPopup(BuildContext context, lead) {
    // Every entry point ends up here, so a dead or closed lead is refused
    // whichever menu it was opened from.
    final blockedReason = conversionBlockedReason;
    if (blockedReason != null) {
      CustomSnackbar.showWarning(context, blockedReason);
      return;
    }

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

    // Both choices are provider state that outlives a single conversion, so
    // they are re-derived from this lead instead of carrying over the answers
    // given for the previous one. This mirrors Odoo's _compute_action: link
    // the customer the lead already has, otherwise offer to create one.
    _conversionAction = 'convert';
    _customerOption = selectedPartnerId != null ? 'exist' : 'create';

    final ScrollController _chipScrollController = ScrollController();
    // The dialog is height-capped and its body scrolls, so what a Customer
    // choice reveals (the picker for "Existing", the name box for "New") sits
    // below the fold. Choosing an option scrolls that part into view, or it
    // looks as if nothing happened.
    final ScrollController _contentScrollController = ScrollController();
    final GlobalKey _customerDetailKey = GlobalKey();
    void revealCustomerDetail() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final detailContext = _customerDetailKey.currentContext;
        if (detailContext == null || !detailContext.mounted) return;
        Scrollable.ensureVisible(
          detailContext,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtEnd,
        );
      });
    }

    final _mergeSearchController = TextEditingController();
    final _mergeDropdownKey = GlobalKey<DropdownSearchState<LeadItem>>();

    // Odoo builds the new customer from the lead's contact name, falling back
    // to the company name and then the lead name, so the box starts on the
    // same value the server would have used.
    final newCustomerNameController = TextEditingController(
      text: [
        contactNameController.text.trim(),
        compnayNameController.text.trim(),
        nameController.text.trim(),
      ].firstWhere((value) => value.isNotEmpty, orElse: () => ''),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        bool _isLoading = false;
        String? newCustomerError;
        final isDark = Theme.of(context).brightness == Brightness.dark;

        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              elevation: 16,
              backgroundColor: isDark ? Colors.grey[900] : Colors.white,
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: 900,
                  maxHeight: MediaQuery.of(context).size.height * 0.8,
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
                              color: isDark ? Colors.grey[400] : Colors.grey[600],
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
                          controller: _contentScrollController,
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
                                    color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
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
                                              : (isDark ? Colors.grey[800] : Colors.grey[100]),
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
                                                  : (isDark ? Colors.grey[400] : Colors.grey[600]),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              "Convert",
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                                color: _conversionAction == "convert"
                                                    ? Colors.white
                                                    : (isDark ? Colors.grey[400] : Colors.grey[600]),
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
                                              : (isDark ? Colors.grey[800] : Colors.grey[100]),
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
                                                  : (isDark ? Colors.grey[400] : Colors.grey[600]),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              "Merge",
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                                color: _conversionAction == "merge"
                                                    ? Colors.white
                                                    : (isDark ? Colors.grey[400] : Colors.grey[600]),
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
                                Text(
                                  "Select Leads to Merge",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: isDark ? Colors.white : Colors.black,
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
                                                  color: isDark ? Colors.grey[400] : Colors.grey[600],
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
                                                        color: isDark ? Colors.grey[700] : Colors.grey[200],
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
                                                          color: isDark
                                                              ? Colors.grey[300]
                                                              : Colors.grey[700],
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
                                        backgroundColor: isDark ? Colors.grey[850] : Colors.white,
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
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                                color: isDark ? Colors.grey[700]! : const Color(0xFFE0E0E0),
                                                width: 0.8),
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(
                                                  16, 12, 16, 8),
                                              child: Text(
                                                'Select Leads to Merge',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: isDark ? Colors.white : Colors.black87,
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
                                                  fillColor: isDark
                                                      ? Colors.grey[800]
                                                      : const Color(0xFFF3F4F6),
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
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: isDark ? Colors.white : Colors.black87,
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
                                        fillColor: isDark
                                            ? Colors.grey[800]
                                            : const Color(0xFFF2F4F6),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide: BorderSide(
                                            color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                                            width: 1,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide: BorderSide(
                                            color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
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
                                  color: isDark ? Colors.white : Colors.black,
                                ),
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                width: double.infinity,
                                child: DropdownSearch<SalesPersonItem>(
                                  items: {for (final s in allsalesperson) s.id: s}.values.toList(),
                                  selectedItem: initialSalesPersonItem,
                                  clearButtonProps:
                                      MoboDropdownStyles.clearButton(isDark),
                                  popupProps: PopupProps.menu(
                                    showSearchBox: true,
                                    fit: FlexFit.loose,
                                    menuProps: MenuProps(
                                      backgroundColor: isDark ? Colors.grey[850] : Colors.white,
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
                                        fillColor: isDark
                                            ? Colors.grey[800]
                                            : const Color(0xFFF3F4F6),
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
                                              color: isDark ? Colors.white : Colors.black87,
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
                                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                                        fontStyle: FontStyle.italic,
                                      ),
                                      filled: true,
                                      fillColor: isDark
                                          ? Colors.grey[800]
                                          : const Color(0xFFF2F4F6),
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
                                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                                          fontStyle: FontStyle.italic,
                                        ),
                                      );
                                    }
                                    return Text(
                                      selectedItem.name,
                                      style: TextStyle(
                                        color: isDark ? Colors.white : Colors.black87,
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
                                Text(
                                  "Sales Team",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: isDark ? Colors.white : Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _teamname!,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: isDark ? Colors.grey[300] : Colors.grey[800],
                                  ),
                                ),
                              ],
                              const SizedBox(height: 20),
                              if (_conversionAction == "convert") ...[
                                Text(
                                  "Customer",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: isDark ? Colors.white : Colors.black,
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
                                      // Clearing the partner matters: it is
                                      // provider state that still holds the
                                      // lead's (or a previously converted
                                      // lead's) customer, and Odoo links that
                                      // one instead of creating a new record.
                                      onChanged: (v) {
                                        setState(() {
                                          _customerOption = v!;
                                          selectedPartnerId = null;
                                        });
                                        revealCustomerDetail();
                                      },
                                    ),
                                    const SizedBox(height: 10),
                                    _buildCustomerOption(
                                      context: context,
                                      title: "Existing",
                                      value: "exist",
                                      groupValue: _customerOption,
                                      onChanged: (v) {
                                        setState(() => _customerOption = v!);
                                        revealCustomerDetail();
                                      },
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
                                if (_customerOption == "create")
                                  Column(
                                    key: _customerDetailKey,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 12),
                                      Text(
                                        "Customer Name",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: isDark
                                              ? Colors.grey[400]
                                              : Colors.grey[600],
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                          color: isDark
                                              ? Colors.grey[850]
                                              : const Color(0xFFF2F4F6),
                                          border: Border.all(
                                            color: newCustomerError != null
                                                ? Colors.red
                                                : Colors.transparent,
                                            width: 1,
                                          ),
                                        ),
                                        child: TextField(
                                          controller: newCustomerNameController,
                                          textCapitalization:
                                              TextCapitalization.words,
                                          onChanged: (_) {
                                            if (newCustomerError != null) {
                                              setState(
                                                  () => newCustomerError = null);
                                            }
                                          },
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: isDark
                                                ? Colors.white
                                                : Colors.black87,
                                          ),
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 12, vertical: 12),
                                            hintText: 'Name of the new customer',
                                            hintStyle: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontStyle: FontStyle.italic,
                                              color: isDark
                                                  ? Colors.grey[400]
                                                  : Colors.grey[600],
                                            ),
                                          ),
                                        ),
                                      ),
                                      if (newCustomerError != null)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 4, left: 4),
                                          child: Text(
                                            newCustomerError!,
                                            style: const TextStyle(
                                                color: Colors.red, fontSize: 12),
                                          ),
                                        ),
                                    ],
                                  ),
                                if (_customerOption == "exist")
                                  Column(
                                    key: _customerDetailKey,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 12),
                                      SizedBox(
                                        width: double.infinity,
                                        child: DropdownSearch<dynamic>(
                                          items: allcustomer,
                                          // The lead's own customer is what
                                          // gets linked when nothing else is
                                          // picked, so it has to show here.
                                          selectedItem: selectedPartnerId ==
                                                  null
                                              ? null
                                              : allcustomer
                                                  .where((customer) =>
                                                      customer.id ==
                                                      selectedPartnerId)
                                                  .firstOrNull,
                                          clearButtonProps:
                                              MoboDropdownStyles.clearButton(
                                                  isDark),
                                          popupProps: PopupProps.menu(
                                            showSearchBox: true,
                                            fit: FlexFit.loose,
                                            menuProps: MenuProps(
                                              backgroundColor: isDark ? Colors.grey[850] : Colors.white,
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
                                                fillColor: isDark
                                                    ? Colors.grey[800]
                                                    : const Color(0xFFF3F4F6),
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
                                                      color: isDark ? Colors.white : Colors.black87,
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
                                                color: isDark ? Colors.grey[400] : Colors.grey[600],
                                                fontStyle: FontStyle.italic,
                                              ),
                                              filled: true,
                                              fillColor: isDark
                                                  ? Colors.grey[800]
                                                  : const Color(0xFFF2F4F6),
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
                                                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                                                  fontStyle: FontStyle.italic,
                                                ),
                                              );
                                            }
                                            return Text(
                                              selectedItem.name ?? '',
                                              style: TextStyle(
                                                color: isDark ? Colors.white : Colors.black87,
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
                                  ),
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
                                    final isConvert =
                                        _conversionAction == "convert";
                                    final customerName =
                                        newCustomerNameController.text.trim();

                                    if (isConvert &&
                                        _customerOption == "create" &&
                                        customerName.isEmpty) {
                                      setState(() => newCustomerError =
                                          'Enter a name for the new customer');
                                      return;
                                    }
                                    if (isConvert &&
                                        _customerOption == "exist" &&
                                        selectedPartnerId == null) {
                                      CustomSnackbar.showWarning(context,
                                          'Select the customer to link');
                                      return;
                                    }

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
                                          'customer_name': customerName,
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

  /// Restores a lost lead or opportunity as Odoo's own Restore button does.
  ///
  /// That button runs `action_restore`, which unarchives the record and resets
  /// its probability for the stage it is in. Odoo 20 no longer has
  /// `toggle_active`, which is what this used to call — hence "Failed to
  /// restore" there — so earlier versions that lack `action_restore` fall back
  /// to `action_unarchive`, then `toggle_active`.
  Future<void> _restoreRecord(int id) async {
    Object? lastError;
    for (final method in const [
      'action_restore',
      'action_unarchive',
      'toggle_active'
    ]) {
      try {
        await CompanySessionManager.callKwWithCompany({
          'model': 'crm.lead',
          'method': method,
          'args': [
            [id]
          ],
          'kwargs': {},
        });
        return;
      } catch (e) {
        lastError = e;
      }
    }
    throw lastError ?? Exception('Could not restore lead $id');
  }

  void restore(OdooClient client, dynamic lead, BuildContext context) async {
    try {
      await _restoreRecord(lead['id']);
    } catch (e) {
      debugPrint('[LeadFormProvider] restore failed: $e');
      if (context.mounted) {
        CustomSnackbar.showError(context, 'Failed to restore lead');
      }
      return;
    }

    // The record is restored by now; refreshing what is on screen is best
    // effort and must not turn a successful restore into a failure message.
    try {
      await fetchStatus(client, lead);

      if (context.mounted) {
        // loading: true, or getLeads sees a list already on screen and
        // returns without refetching, leaving the restored lead as it was.
        Provider.of<LeadDataProvider>(context, listen: false)
            .initlead(context, loading: true);
        await Provider.of<OpportunityDataProvider>(context, listen: false)
            .refreshOpportunities(context);
      }
    } catch (e) {
      debugPrint('[LeadFormProvider] refresh after restore failed: $e');
    }

    if (context.mounted) {
      CustomSnackbar.showSuccess(context, 'Lead restored successfully');
    }
  }

  static const _singleConvertWizard = 'crm.lead2opportunity.partner';
  static const _massConvertWizard = 'crm.lead2opportunity.partner.mass';

  /// Odoo 20 dropped the single-lead conversion wizard; only the mass one
  /// is left, and it takes the lead from the context instead of `lead_id`.
  Future<bool> _hasSingleConvertWizard() async {
    try {
      await CompanySessionManager.callKwWithCompany({
        'model': _singleConvertWizard,
        'method': 'fields_get',
        'args': [],
        'kwargs': {
          'attributes': ['type']
        },
      });
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> getDuplicatedLeads(int leadId, BuildContext context) async {
    try {
      final single = await _hasSingleConvertWizard();
      final wizardModel = single ? _singleConvertWizard : _massConvertWizard;
      final responseWrite = await CompanySessionManager.callKwWithCompany({
        'model': wizardModel,
        'method': 'create',
        'args': [
          single
              ? {'lead_id': leadId, 'name': 'merge'}
              : {'name': 'convert_and_merge'}
        ],
        'kwargs': {
          'context': {
            'active_model': 'crm.lead',
            'active_id': leadId,
            'active_ids': [leadId],
          }
        },
      });

      final response = await CompanySessionManager.callKwWithCompany({
        'model': wizardModel,
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

  /// Creates the customer for "New customer" from the lead's contact details,
  /// named as typed in the conversion dialog. Returns the new partner's id.
  Future<int> _createCustomerFromLead(
      int leadId, String name, int? userId, int? teamId) async {
    final leads = await CompanySessionManager.callKwWithCompany({
      'model': 'crm.lead',
      'method': 'read',
      'args': [
        [leadId]
      ],
      'kwargs': {
        'fields': [
          'email_from',
          'phone',
          'street',
          'street2',
          'city',
          'zip',
          'country_id',
          'state_id',
          'website',
          'function',
          'partner_name',
        ],
      },
    });
    final lead = (leads is List && leads.isNotEmpty) ? leads.first : {};
    // Odoo reads empty fields back as `false`.
    dynamic text(String field) => lead[field] == false ? null : lead[field];
    int? relation(String field) =>
        lead[field] is List && lead[field].isNotEmpty ? lead[field][0] : null;

    final partnerId = await CompanySessionManager.callKwWithCompany({
      'model': 'res.partner',
      'method': 'create',
      'args': [
        {
          'name': name,
          'email': text('email_from'),
          'phone': text('phone'),
          'street': text('street'),
          'street2': text('street2'),
          'city': text('city'),
          'zip': text('zip'),
          'country_id': relation('country_id'),
          'state_id': relation('state_id'),
          'website': text('website'),
          'function': text('function'),
          // Kept as text rather than creating a company record, which
          // could duplicate one that already exists.
          'company_name': text('partner_name'),
          if (userId != null) 'user_id': userId,
          if (teamId != null) 'team_id': teamId,
        }
      ],
      'kwargs': {},
    });
    if (partnerId is! int) {
      throw Exception('the server did not return the new customer');
    }
    return partnerId;
  }

  Future<bool> _convertOpportunity(int id, Map<String, dynamic> opportunityList,
      BuildContext context) async {
    int? createdPartnerId;
    try {
      final client =
          Provider.of<OdooClientManager>(context, listen: false).client;
      if (client == null) {
        return false;
      }

      // The last line of defence, whichever way the dialog was reached: the
      // lead may have been lost or closed since the form loaded, and Odoo's
      // wizard would skip it without an error.
      final blocked = await conversionBlockedReasonOnServer(id);
      if (blocked != null) {
        if (context.mounted) CustomSnackbar.showWarning(context, blocked);
        return false;
      }

      String action = opportunityList['action'] ?? 'nothing';
      final String conversionAction = opportunityList['name'] ?? 'convert';
      int? partnerId = opportunityList['partner_id'];

      // "New customer" is created here and then linked like an existing
      // one. Left to the wizard, 'create' only creates a customer when the
      // lead has none — it resolves `self.partner_id or lead.partner_id`, so
      // a lead that already had a customer was linked straight back to it —
      // and the mass wizard links any customer matching the lead's email.
      final String customerName =
          (opportunityList['customer_name'] as String? ?? '').trim();
      if (action == 'create' &&
          conversionAction == 'convert' &&
          customerName.isNotEmpty) {
        createdPartnerId = await _createCustomerFromLead(id, customerName,
            opportunityList['user_id'], opportunityList['team_id']);
        partnerId = createdPartnerId;
        action = 'exist';
      }

      // Every action goes through crm.lead2opportunity.partner, the
      // same wizard the Odoo web client applies, so the conversion also
      // gets the stage, probability and conversion date it sets.
      final createFields = <String, dynamic>{
        'lead_id': id,
        'action': action,
        'name': conversionAction,
      };
      if (opportunityList['user_id'] != null) {
        createFields['user_id'] = opportunityList['user_id'];
      }
      if (opportunityList['team_id'] != null) {
        createFields['team_id'] = opportunityList['team_id'];
      }
      // Only a linked customer (picked, or just created above) may carry a
      // partner. The wizard resolves the customer as
      // `self.partner_id or lead.partner_id`, so a partner sent alongside
      // 'nothing' would win over the choice and silently link that contact.
      if (action == 'exist' && partnerId != null) {
        createFields['partner_id'] = partnerId;
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

      String wizardModel = _singleConvertWizard;
      if (!await _hasSingleConvertWizard()) {
        wizardModel = _massConvertWizard;
        // The mass wizard has no partner choice of its own, so the linked
        // customer (picked, or just created above) is set on the lead first.
        if (action == 'exist' && partnerId != null) {
          await CompanySessionManager.callKwWithCompany({
            'model': 'crm.lead',
            'method': 'write',
            'args': [
              [id],
              {'partner_id': partnerId},
            ],
            'kwargs': {},
          });
        }
        createFields
          ..clear()
          ..addAll({
            'name':
                conversionAction == 'merge' ? 'convert_and_merge' : 'convert',
            'link_to_matching_customer': action == 'create',
            if (opportunityList['user_id'] != null) ...{
              'user_ids': [
                [6, 0, [opportunityList['user_id']]]
              ],
              'force_assignment': true,
            },
            if (opportunityList['team_id'] != null)
              'team_id': opportunityList['team_id'],
            if (duplicatedIds.isNotEmpty)
              'duplicated_lead_ids': [
                [6, 0, duplicatedIds]
              ],
          });
      }

      final wizardId = await CompanySessionManager.callKwWithCompany({
        'model': wizardModel,
        'method': 'create',
        'args': [createFields],
        'kwargs': {
          'context': {
            'active_model': 'crm.lead',
            'active_id': id,
            'active_ids': [id],
          }
        },
      });

      if (wizardId == null || wizardId is! int) {
        await _discardCreatedCustomer(createdPartnerId);
        return false;
      }

      await CompanySessionManager.callKwWithCompany({
        'model': wizardModel,
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
      // The opportunity owns the new customer from here on.
      createdPartnerId = null;

      if (context.mounted) {
        Provider.of<LeadDataProvider>(context, listen: false)
            .getLeads(context: context, loading: true);
        Provider.of<OpportunityDataProvider>(context, listen: false)
            .refreshOpportunities(context);
      }

      return true;
    } catch (e) {
      await _discardCreatedCustomer(createdPartnerId);
      if (context.mounted) {
        CustomSnackbar.showError(
            context, 'Failed to convert lead to opportunity');
      }
      return false;
    }
  }

  /// Removes the customer created for a conversion that then failed, so a
  /// retry doesn't leave a duplicate behind. Best effort.
  Future<void> _discardCreatedCustomer(int? partnerId) async {
    if (partnerId == null) return;
    try {
      await CompanySessionManager.callKwWithCompany({
        'model': 'res.partner',
        'method': 'unlink',
        'args': [
          [partnerId]
        ],
        'kwargs': {},
      });
    } catch (_) {}
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
      final isDark = Theme.of(context).brightness == Brightness.dark;
      final result = await showModalBottomSheet<bool>(
        backgroundColor:
            isDark ? const Color(0xFF181A20) : AppColors().backGround,
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
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return GestureDetector(
    onTap: () => onChanged(value),
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(
            color: isDark ? Colors.grey[700]! : Colors.grey.shade200,
            width: 1),
        borderRadius: BorderRadius.circular(8),
        color: isDark ? Colors.grey[850] : Colors.white,
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
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white : Colors.black,
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
