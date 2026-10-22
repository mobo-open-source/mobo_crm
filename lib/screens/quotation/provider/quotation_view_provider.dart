import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobo_crm/global_methods/services/isar_caching_service.dart';
import 'package:mobo_crm/global_methods/widgets/custom_filters.dart';
import 'package:mobo_crm/global_methods/widgets/group_by_dropdown.dart';
import 'package:mobo_crm/models/LoginPage/session_model.dart';
import 'package:mobo_crm/models/quotation_model/quotation_model.dart';
import 'package:mobo_crm/global_methods/services/global_error_handler.dart';
import 'package:mobo_crm/screens/quotation/isar/quotation_group_data_isar.dart';
import 'package:mobo_crm/screens/quotation/isar/quotation_model_isar.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../initilisation.dart';

import '../../../core/company/session/company_session_manager.dart';
import '../../../services/app_install_check.dart';

/// Provider to manage the state and data of Quotations in the CRM app.
///
/// This class handles fetching quotations from Odoo, caching in Isar,
/// applying filters and groupings, pagination, and exposing data for UI.
class QuotationViewProvider extends ChangeNotifier {
  bool isLoading = true;

  bool _isSearchPending = false;

  /// True from the keystroke that starts a search until the matching fetch
  /// finishes — covering both the debounce and the request itself.
  ///
  /// Search deliberately runs without a loading state so the search field
  /// stays usable while typing, which left [isLoading] false for that whole
  /// window. The list read "not loading + no rows" and rendered its "nothing
  /// found" placeholder over data that simply had not come back yet.
  bool get isSearchPending => _isSearchPending;

  /// What a list should treat as "still working": a fetch that asked for a
  /// loading state, or a search that has not landed yet.
  bool get isBusy => isLoading || _isSearchPending;

  /// Called from the search field on every keystroke, before the debounce, so
  /// the list switches to its skeleton immediately instead of after the wait.
  void markSearchPending() {
    if (_isSearchPending) return;
    _isSearchPending = true;
    notifyListeners();
  }

  AppError? quoteError;
  bool moduleError = false;
  bool hasError = false;
  List<Map<dynamic, dynamic>> tempQuotation = [];
  List<Map<dynamic, dynamic>> allQuotation = [];

  Map<String, dynamic> _customFilters = {};
  bool _hasCustomFilters = false;

  Map<String, dynamic> get customFilters => _customFilters;

  bool get hasCustomFilters => _hasCustomFilters;

  List<Map<String, dynamic>> _quoteData = [];

  List<Map<String, dynamic>>? get quoteData => _quoteData;
  TextEditingController searchController = TextEditingController();
  final List<Map<String, dynamic>> _mailResponse = [];

  List<Map<String, dynamic>>? get mailResponse => _mailResponse;

  String selectedFilterQuotation = 'Count';

  List<String> activityNames = [];

  /// Maps activity states to colors for UI display.
  final Map<String, Color> activityStateColors = {
    "overdue": Colors.red,
    "today": Colors.orange,
    "planned": Colors.green,
  };

  Map<int, String> currencyIdToSymbol = {};

  Map<int, String> get currencySymbolMap => currencyIdToSymbol;

  GroupByOption _currentGroupBy = GroupByOption.none;
  Map<String, List<Map<dynamic, dynamic>>> _groupedQuotations = {};
  Map<String, bool> _groupExpansionState = {};

  int _currentPage = 0;
  int _limit = 40;
  int _totalCount = 0;
  bool _hasMoreData = false;
  int _graphViewIndex = 0;

  int get graphViewIndex => _graphViewIndex;

  void setGraphViewIndex(int index) {
    _graphViewIndex = index;
    notifyListeners();
  }

  bool _currentIsQuotation = false;
  bool _currentIsSale = false;
  bool _currentIsPipeline = true;
  bool _currentShowCreationDate = false;
  bool _currentMonth = false;
  bool _previousMonth = false;
  bool _twoMonthsBefore = false;
  String _currentSearchText = '';

  /// Id of the newest [getQuotationsAndReport] request; see the guard there.
  int _fetchSeq = 0;

  int get currentPage => _currentPage;

  int get limit => _limit;

  int get totalCount => _totalCount;

  bool get hasMoreData => _hasMoreData;

  bool get hasPreviousPage => _currentPage > 0;
  bool isSaleInstalled = false;

  bool get isDefaultPipelineFilterActive => _currentIsPipeline;

  bool _showOnlyMyPipeline = true;

  bool get showOnlyMyPipeline => _showOnlyMyPipeline;

  set showOnlyMyPipeline(bool value) {
    _showOnlyMyPipeline = value;
    notifyListeners();
  }

  /// Whether [isSaleInstalled] came from a definite server answer.
  bool _saleCheckConfirmed = false;

  Future<void> checkSaleModuleInstallation(OdooClient client) async {
    try {
      final checker = AppInstallCheck();
      bool isSaleManagementInstalled =
      await checker.isModuleInstalled('sale_management');
      bool isSaleModuleInstalled =
      await checker.isModuleInstalled('sale');

      isSaleInstalled = isSaleManagementInstalled || isSaleModuleInstalled;
      _saleCheckConfirmed = true;
    } on ModuleAccessDeniedException {
      isSaleInstalled = false;
      _saleCheckConfirmed = true;
    } catch (e) {
      // Couldn't tell (expired session, offline): let the quotation fetch run
      // and show its own error rather than claiming the module is missing.
      isSaleInstalled = true;
      _saleCheckConfirmed = false;
    }
    notifyListeners();
  }

  bool get hasNextPage {
    if (_currentGroupBy != GroupByOption.none) {
      return (_currentPage + 1) * _limit < _groupedQuotations.keys.length;
    }
    return _hasMoreData;
  }

  int get totalPages {
    if (_currentGroupBy != GroupByOption.none) {
      return (_groupedQuotations.keys.length / _limit).ceil();
    }
    return (_totalCount / _limit).ceil();
  }

  int get startRecord {
    if (_totalCount == 0) return 0;
    if (_currentGroupBy != GroupByOption.none) {
      return (_currentPage * _limit) + 1;
    }
    return _currentPage * _limit + 1;
  }

  int get endRecord {
    if (_totalCount == 0) return 0;
    if (_currentGroupBy != GroupByOption.none) {
      final groupCount = _groupedQuotations.keys.length;
      final startGroup = _currentPage * _limit;
      final endGroup = ((startGroup + _limit).clamp(0, groupCount));
      return endGroup;
    }
    return ((_currentPage + 1) * _limit > _totalCount
        ? _totalCount
        : (_currentPage + 1) * _limit);
  }

  GroupByOption get currentGroupBy => _currentGroupBy;

  Map<String, List<Map<dynamic, dynamic>>> get groupedQuotations =>
      _groupedQuotations;

  Map<String, bool> get groupExpansionState => _groupExpansionState;
  List<String> selectedFilters = [];

  /// Sets the group by option and applies grouping.
  void setGroupBy(GroupByOption option) {
    _currentGroupBy = option;
    _currentPage = 0;
    _applyGrouping();
    notifyListeners();
  }

  /// Toggles expansion state of a specific group in the UI.
  void toggleGroupExpansion(String groupKey) {
    _groupExpansionState[groupKey] = !(_groupExpansionState[groupKey] ?? true);
    notifyListeners();
  }

  /// Calculates total revenue for a group of quotations.
  double getGroupRevenue(List<Map<dynamic, dynamic>> groupQuotations) {
    return groupQuotations.fold(0.0, (sum, quotation) {
      final revenue = quotation['amount_total'];
      if (revenue is num) {
        return sum + revenue.toDouble();
      }
      return sum;
    });
  }

  @override
  void dispose() {
    searchController.dispose();

    allQuotation.clear();

    super.dispose();
  }

  /// Clears all quotation lists.
  void clearAll() {
    allQuotation.clear();
  }

  /// Fetches quotations from Odoo, applies filters, and stores in cache.
  Future<void> getQuotationsAndReport(
      {BuildContext? context,
      SessionModel? session,
      bool isQuotation = false,
      bool isSale = false,
      bool isPipeline = true,
      bool currentMonth = false,
      bool previousMonth = false,
      bool twoMonthsBefore = false,
      List? customFilters,
      Map<String, dynamic>? customFilterRules,
      String searchText = "",
      bool loading = false,
      bool showCreationDate = false,
      bool resetPagination = true,
      bool silent = false}) async {
    final prefs = await SharedPreferences.getInstance();
    final url = prefs.getString('url') ?? '';
    final odooClientManager =
        Provider.of<OdooClientManager>(context!, listen: false);

    if (!isSaleInstalled || !_saleCheckConfirmed) {
      await checkSaleModuleInstallation(odooClientManager.client!);
    }

    hasError = false;
    // The list on screen is the previous search's result, so clearing a search
    // must refetch rather than keep it or reload the cache.
    final bool wasSearching = _currentSearchText.isNotEmpty;
    if (searchText.isEmpty && customFilters == null && !wasSearching) {
      if (allQuotation.isNotEmpty && !loading) {
        _isSearchPending = false;
        notifyListeners();
        return;
      }
      final bool hasCacheData = await getQuotationDataFromIsar();
      if (hasCacheData && !loading) {
        isLoading = false;
        notifyListeners();
        // The cached list can contain records deleted (or moved out of the
        // current company's scope) server-side since it was written, which
        // otherwise only surfaces later as a false "not found" error when a
        // stale card is tapped. Reconcile with the server silently in the
        // background so the list is corrected before that can happen.
        unawaited(getQuotationsAndReport(
          context: context,
          session: session,
          isQuotation: isQuotation,
          isSale: isSale,
          isPipeline: isPipeline,
          currentMonth: currentMonth,
          previousMonth: previousMonth,
          twoMonthsBefore: twoMonthsBefore,
          showCreationDate: showCreationDate,
          loading: true,
          silent: true,
        ));
        return;
      }
    }

    if ((loading || allQuotation.isEmpty) && !silent) {
      isLoading = true;
      notifyListeners();
    }

    _currentIsQuotation = isQuotation;
    _currentIsSale = isSale;
    _currentIsPipeline = isPipeline;
    _currentShowCreationDate = showCreationDate;
    _currentMonth = currentMonth;
    _previousMonth = previousMonth;
    _twoMonthsBefore = twoMonthsBefore;
    _currentSearchText = searchText;
    // Search and clear can overlap; only the newest request may apply its
    // result, or a slow earlier search lands over the cleared list.
    final int fetchSeq = ++_fetchSeq;

    if (resetPagination) {
      _currentPage = 0;
    }

    // A silent refresh runs behind the cached list that is already on screen,
    // so that list stays until the response replaces it. Clearing it here left
    // the list empty, and the "No Quotations Found" placeholder up, for the
    // whole round trip after every app start.
    if (resetPagination && !silent) {
      allQuotation.clear();
    }

    List filters = [];

    if (customFilters != null) {
      filters = customFilters;
    }

    if (customFilterRules != null && customFilterRules.isNotEmpty) {
      final customDomainFilters =
          _convertCustomFiltersToOdooDomain(customFilterRules);
      filters.addAll(customDomainFilters);

      _customFilters = customFilterRules;
      _hasCustomFilters = true;
    } else {
      _customFilters = {};
      _hasCustomFilters = false;
    }

    if (isPipeline) {
      filters.add(['user_id', '=', session!.userId]);
    }

    if (isQuotation || isSale) {
      if (isQuotation && isSale == false) {
        filters.add([
          "state",
          "in",
          ["draft", "sent"]
        ]);
      }
      if (isQuotation == false && isSale) {
        filters.add(["state", "=", "sale"]);
      }
    }

    List<dynamic> createDateFilter = CustomFilters().getLeadDateFilters(
        leaddatefilters: showCreationDate,
        leadmonthNow: currentMonth,
        leadbeforeMonth: previousMonth,
        leadbeforetwoMonth: twoMonthsBefore);

    filters = [...filters, ...createDateFilter];

    if (searchText.isNotEmpty) {
      filters.add('|');
      filters.add('|');
      filters.add(['name', 'ilike', '%$searchText']);
      filters.add(['client_order_ref', 'ilike', '%$searchText']);
      filters.add(['partner_id', 'child_of', '%$searchText']);
    }

    try {
      final countResponse = await CompanySessionManager.callKwWithCompany({
        'model': 'sale.order',
        'method': 'search_count',
        'args': [filters],
        'kwargs': {},
      });

      _totalCount = countResponse as int;

      int fetchLimit = _limit;
      int fetchOffset = _currentPage * _limit;

      if (_currentGroupBy != GroupByOption.none) {
        fetchLimit = 0;
        fetchOffset = 0;
      }

      _hasMoreData = (_currentPage + 1) * _limit < _totalCount;

      final response = await CompanySessionManager.callKwWithCompany({
        'model': 'sale.order',
        'method': 'search_read',
        'args': [filters],
        'kwargs': {
          'fields': [
            'name',
            'activity_state',
            'activity_ids',
            'activity_type_id',
            'activity_user_id',
            'activity_summary',
            'activity_ids',
            'amount_total',
            'date_order',
            'partner_id',
            'state',
            'id',
            'invoice_status',
            'currency_id',
            'currency_rate',
            'prepayment_percent',
            'amount_tax',
            'amount_untaxed',
            'user_id',
            'activity_date_deadline'
          ],
          'limit': fetchLimit,
          'offset': fetchOffset,
          'order': 'id desc',
        },
      });

      // The cache is the offline copy of the full list and what the next
      // empty-search load reads, so it never holds search results. Best-effort:
      // a record it can't store must not abort showing the fetched list.
      if (searchText.isEmpty) {
        try {
          final List<QuotationModelIsar> quotationCacheObjects = response
              .map<QuotationModelIsar>((e) => QuotationModelIsar.fromJson(e))
              .toList();
          await IsarService.saveQuotations(quotationCacheObjects);
        } catch (_) {}
      }

      final Set<int> uniqueCurrencyIds = {};
      for (final q in response) {
        if (q['currency_id'] is List && q['currency_id'].isNotEmpty) {
          uniqueCurrencyIds.add(q['currency_id'][0] as int);
        }
      }

      if (uniqueCurrencyIds.isNotEmpty) {
        final currencyResponse = await CompanySessionManager.callKwWithCompany({
          'model': 'res.currency',
          'method': 'search_read',
          'args': [
            [
              ['id', 'in', uniqueCurrencyIds.toList()]
            ]
          ],
          'kwargs': {
            'fields': ['id', 'symbol', 'name'],
          },
        });

        currencyIdToSymbol = {
          for (final c in currencyResponse)
            if (c['id'] != null && c['symbol'] != null)
              c['id'] as int: c['symbol'] as String
        };

        List<CurrencySymbolIsar> currencySymbolObjects = <CurrencySymbolIsar>[
          ...currencyResponse.map((c) => CurrencySymbolIsar.fromJson(c))
        ];

        await IsarService.saveCurrencySymbols(currencySymbolObjects);
      }

      List<int> orderIds =
          response.map<int>((order) => order['id'] as int).toList();

      await CompanySessionManager.callKwWithCompany({
        'model': 'mail.activity',
        'method': 'search_read',
        'args': [
          [
            ['res_id', 'in', orderIds],
            ['res_model', '=', 'sale.order']
          ]
        ],
        'kwargs': {
          'fields': [
            'activity_type_id',
            'summary',
            'date_deadline',
            'state',
            'user_id',
            'res_name'
          ],
        },
      });

      final activityResponse = await CompanySessionManager.callKwWithCompany({
        'model': 'mail.activity.type',
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'fields': ['name']
        }
      });

      List<QuotationModel> quotations = response
          .map((data) {
            try {
              return QuotationModel.fromJson(data);
            } catch (e) {
              return null;
            }
          })
          .whereType<QuotationModel>()
          .toList();

      Map<String, int> counts = {};
      Map<String, double> currencyRate = {};
      Map<String, double> prepaymentPercent = {};
      Map<String, double> amountTax = {};
      Map<String, double> amountTotal = {};
      Map<String, double> amountUntaxed = {};

      for (var quote in quotations) {
        String groupKey;

        try {
          groupKey = quote.partnerName;
        } catch (e) {
          groupKey = "Invalid Date";
        }
        counts[groupKey] = (counts[groupKey] ?? 0) + 1;
        currencyRate[groupKey] =
            (currencyRate[groupKey] ?? 0) + quote.currencyRate;
        prepaymentPercent[groupKey] =
            (prepaymentPercent[groupKey] ?? 0) + quote.prepaymentPercent;
        amountTax[groupKey] = (amountTax[groupKey] ?? 0) + quote.amountTax;
        amountTotal[groupKey] =
            (amountTotal[groupKey] ?? 0) + quote.amountTotal;
        amountUntaxed[groupKey] =
            (amountUntaxed[groupKey] ?? 0) + quote.amountUntaxed;
      }

      _quoteData = counts.entries.map((e) {
        return {
          'name': e.key,
          'count': e.value,
          'currency_rate': currencyRate[e.key] ?? 0,
          'prepayment_percent': prepaymentPercent[e.key] ?? 0,
          'amount_tax': amountTax[e.key] ?? 0,
          'amount_total': amountTotal[e.key] ?? 0,
          'amount_untaxed': amountUntaxed[e.key] ?? 0,
        };
      }).toList();

      _quoteData.sort((a, b) {
        if (a['name'] == "None") return -1;
        if (b['name'] == "None") return 1;
        return a['name'].toString().compareTo(b['name'].toString());
      });

      final List<QuotationGroupDataIsar> graphDataList =
          _quoteData.map((e) => QuotationGroupDataIsar.fromMap(e)).toList();

      await IsarService.saveQuoteGroupData(graphDataList);

      if (activityResponse is List) {
        activityNames = activityResponse
            .whereType<Map<String, dynamic>>()
            .map((activity) => activity['name'].toString())
            .toList();
      }

      // A newer search/clear has started since this request went out.
      if (fetchSeq != _fetchSeq) return;

      if (response != null && response is List) {
        final qoutedetails = response.map((lead) {
          return lead.map(
              (key, value) => MapEntry(key, value == false ? null : value));
        }).toList();

        if (qoutedetails.isNotEmpty) {
          List<Map<dynamic, dynamic>> updatedQuote = [];

          for (var quote in qoutedetails) {
            quote['user_image'] = null;

            updatedQuote.add(quote);
          }

          allQuotation = updatedQuote;
          tempQuotation = updatedQuote;
          _applyGrouping();
          isLoading = false;

          notifyListeners();
        } else if (silent && resetPagination) {
          // The server has none left, and the cached rows kept on screen for
          // the refresh (see above) are stale: drop them.
          allQuotation = [];
          tempQuotation = [];
          _applyGrouping();
        } else {
          // Nothing matched: the list was cleared above, so the groups built
          // from the previous result have to go too.
          _applyGrouping();
        }
      }
      notifyListeners();
    } catch (e) {
      if (fetchSeq != _fetchSeq) return;
      final success = await getQuotationDataFromIsar();
      if (selectedFilters.isEmpty) {
        if (success == false) {
          quoteError = await ErrorHandler.handleException(e, uri: url);
          if (allQuotation.isEmpty) {
            Future.delayed(const Duration(seconds: 2), () {
              isLoading = false;
              hasError = true;
              notifyListeners();
            });
          }
        }
      } else {
        allQuotation = [];
        _applyGrouping();
      }
    } finally {
      // A superseded request leaves the flags to the newer one, which is
      // still running.
      if (fetchSeq == _fetchSeq) {
        isLoading = false;
        _isSearchPending = false;
        notifyListeners();
      }
    }
  }

  /// Applies grouping to the current list of quotations.
  void _applyGrouping() {
    _groupedQuotations.clear();
    if (_currentGroupBy == GroupByOption.none) {
      return;
    }

    for (var quotation in allQuotation) {
      String groupKey = _getGroupKey(quotation, _currentGroupBy);
      if (!_groupedQuotations.containsKey(groupKey)) {
        _groupedQuotations[groupKey] = [];
        if (!_groupExpansionState.containsKey(groupKey)) {
          _groupExpansionState[groupKey] = true;
        }
      }
      _groupedQuotations[groupKey]!.add(quotation);
    }

    final sortedKeys = _groupedQuotations.keys.toList()..sort();
    final sortedGroups = <String, List<Map<dynamic, dynamic>>>{};
    for (String key in sortedKeys) {
      sortedGroups[key] = _groupedQuotations[key]!;
    }
    _groupedQuotations = sortedGroups;
  }

  /// Determines the grouping key for a quotation based on GroupByOption.
  String _getGroupKey(Map<dynamic, dynamic> quotation, GroupByOption groupBy) {
    switch (groupBy) {
      case GroupByOption.stage:
        final state = quotation['state'];
        switch (state) {
          case 'draft':
            return 'Draft';
          case 'sent':
            return 'Quotation Sent';
          case 'sale':
            return 'Sales Order';
          case 'done':
            return 'Locked';
          case 'cancel':
            return 'Cancelled';
          default:
            return 'Unknown';
        }
      case GroupByOption.salesperson:
        if (quotation['user_id'] is List && quotation['user_id'].length > 1) {
          return quotation['user_id'][1].toString();
        }
        return 'Unassigned';
      case GroupByOption.partner:
        if (quotation['partner_id'] is List &&
            quotation['partner_id'].length > 1) {
          return quotation['partner_id'][1].toString();
        }
        return 'No Customer';
      case GroupByOption.createDate:
        final dateOrder = quotation['date_order'];
        if (dateOrder != null) {
          try {
            final date = DateTime.parse(dateOrder.toString());
            return '${date.year}-${date.month.toString().padLeft(2, '0')}';
          } catch (e) {
            return 'Invalid Date';
          }
        }
        return 'No Date';
      case GroupByOption.expectedRevenue:
        final revenue = quotation['amount_total'];
        if (revenue is num) {
          final revenueValue = revenue.toDouble();
          if (revenueValue == 0) return '\$0';
          if (revenueValue < 1000) return '< \$1K';
          if (revenueValue < 10000) return '\$1K - \$10K';
          if (revenueValue < 100000) return '\$10K - \$100K';
          return '> \$100K';
        }
        return '\$0';
      case GroupByOption.team:
        return _getGroupKey(quotation, GroupByOption.stage);
      case GroupByOption.priority:
        final invoiceStatus = quotation['invoice_status'];
        switch (invoiceStatus) {
          case 'upselling':
            return 'Upselling Opportunity';
          case 'invoiced':
            return 'Fully Invoiced';
          case 'to invoice':
            return 'To Invoice';
          case 'no':
            return 'Nothing to Invoice';
          default:
            return 'Unknown Status';
        }
      case GroupByOption.country:
        return _getGroupKey(quotation, GroupByOption.partner);
      case GroupByOption.probability:
        return _getGroupKey(quotation, GroupByOption.stage);
      case GroupByOption.none:
      default:
        return 'All';
    }
  }

  /// Retrieves quotation data from Isar cache if Odoo fetch fails.
  Future<bool> getQuotationDataFromIsar() async {
    try {
      final cachedQuotations = await IsarService.getCachedQuotations();

      allQuotation = cachedQuotations.map((item) {
        return {
          'id': item.serverId,
          'name': item.name,
          'state': item.state,
          'partner_id': item.partnerId != null
              ? [item.partnerId, item.partnerName]
              : null,
          'amount_total': item.amountTotal,
          'amount_tax': item.amountTax,
          'amount_untaxed': item.amountUntaxed,
          'currency_rate': item.currencyRate,
          'prepayment_percent': item.prepaymentPercent,
          'date_order': item.dateOrder,
          'invoice_status': item.invoiceStatus,
          'user_id': item.userId != null ? [item.userId, item.userName] : null,
          'activity_type_id': item.activityTypeId != null
              ? [item.activityTypeId, item.activityTypeName]
              : null,
          'activity_state': item.activityState,
          'activity_user_id': item.activityUserId != null
              ? [item.activityUserId, item.activityUserName]
              : null,
          'activity_summary': item.activitySummary,
          'activity_date_deadline': item.activityDateDeadline,
          'user_image': null,
          'currency_id': [item.currencyId, item.currencyname]
        };
      }).toList();

      final cachedGroupData = await IsarService.getCachedQuoteGroupData();
      currencyIdToSymbol = await IsarService.getCurrencySymbols();

      _quoteData = cachedGroupData.map((e) {
        return {
          'name': e.name ?? 'None',
          'count': e.count,
          'currency_rate': e.currencyRate,
          'prepayment_percent': e.prepaymentPercent,
          'amount_tax': e.amountTax,
          'amount_total': e.amountTotal,
          'amount_untaxed': e.amountUntaxed,
        };
      }).toList();

      _quoteData.sort((a, b) {
        if (a['name'] == "None") return -1;
        if (b['name'] == "None") return 1;
        return a['name'].toString().compareTo(b['name'].toString());
      });
      activityNames = await IsarService.getActivityNames();
      if (allQuotation.isNotEmpty && _totalCount == 0) {
        _totalCount = allQuotation.length;
      }
      _applyGrouping();
      notifyListeners();

      return allQuotation.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// Applies selected filter to the grouped quotation data.
  void applyFilter(String filter) {
    selectedFilterQuotation = filter;
    updateStageData();
    notifyListeners();
  }

  /// Converts custom filter rules into Odoo-compatible domain filters.
  List<dynamic> _convertCustomFiltersToOdooDomain(
      Map<String, dynamic> customFilters) {
    List<dynamic> domainFilters = [];

    if (customFilters['custom_filters'] != null) {
      Map<String, dynamic> rules = customFilters['custom_filters'];

      for (var ruleEntry in rules.entries) {
        Map<String, dynamic> rule = ruleEntry.value;
        String field = rule['field'];
        String operator = rule['operator'];
        dynamic value = rule['value'];

        if (field.isNotEmpty && value != null) {
          String odooOperator = _convertOperatorToOdoo(operator);
          domainFilters.add([field, odooOperator, value]);
        }
      }
    }

    return domainFilters;
  }

  /// Converts UI operator to Odoo operator.
  String _convertOperatorToOdoo(String uiOperator) {
    switch (uiOperator) {
      case 'equals':
      case '=':
        return '=';
      case 'not_equals':
      case '!=':
        return '!=';
      case 'contains':
      case 'ilike':
        return 'ilike';
      case 'not_contains':
      case 'not ilike':
        return 'not ilike';
      case 'greater_than':
      case '>':
        return '>';
      case 'greater_equal':
      case '>=':
        return '>=';
      case 'less_than':
      case '<':
        return '<';
      case 'less_equal':
      case '<=':
        return '<=';
      case 'in':
        return 'in';
      case 'not_in':
      case 'not in':
        return 'not in';
      case 'is_set':
        return '!=';
      case 'is_not_set':
        return '=';
      default:
        return '=';
    }
  }

  /// Clears custom filters applied to the data.
  void clearCustomFilters() {
    _customFilters.clear();
    _hasCustomFilters = false;
    notifyListeners();
  }

  /// Clears all data and resets provider state.
  void clearAllData() {
    allQuotation.clear();
    tempQuotation.clear();
    _quoteData.clear();
    _mailResponse.clear();

    _customFilters.clear();
    _hasCustomFilters = false;

    _groupedQuotations.clear();
    _groupExpansionState.clear();

    currencyIdToSymbol.clear();

    activityNames.clear();

    searchController.clear();

    // The applied filters and the paging that went with them belong to the
    // account that set them, not to whoever signs in next.
    selectedFilters = [];
    _currentMonth = false;
    _previousMonth = false;
    _twoMonthsBefore = false;
    _currentSearchText = '';
    _currentPage = 0;
    _totalCount = 0;

    isLoading = true;
    hasError = false;
    quoteError = null;
    selectedFilterQuotation = 'Count';
    _currentGroupBy = GroupByOption.none;

    notifyListeners();
  }

  /// Forces refresh by clearing and fetching fresh data from Odoo.
  Future<void> forceRefresh({
    required BuildContext context,
    required OdooClient? client,
    required SessionModel? session,
    bool isQuotation = true,
  }) async {
    if (client == null || session == null) {
      return;
    }

    allQuotation.clear();
    tempQuotation.clear();
    _quoteData.clear();

    isLoading = true;
    hasError = false;
    quoteError = null;

    notifyListeners();

    await getQuotationsAndReport(
      context: context,
      session: session,
      isQuotation: isQuotation,
    );
  }

  /// Moves to the next page in pagination.
  Future<void> goToNextPage({
    required BuildContext context,
    required OdooClient client,
    required SessionModel session,
    bool isQuotation = false,
    bool isSale = false,
    Map<String, dynamic>? customFilterRules,
  }) async {
    if (!hasNextPage || isLoading) return;

    _currentPage++;
    await getQuotationsAndReport(
      context: context,
      session: session,
      isQuotation: _currentIsQuotation,
      isSale: _currentIsSale,
      isPipeline: _currentIsPipeline,
      showCreationDate: _currentShowCreationDate,
      currentMonth: _currentMonth,
      previousMonth: _previousMonth,
      twoMonthsBefore: _twoMonthsBefore,
      searchText: _currentSearchText,
      customFilterRules: customFilterRules ?? _customFilters,
      loading: true,
      resetPagination: false,
    );
  }

  /// Moves to the previous page in pagination.
  Future<void> goToPreviousPage({
    required BuildContext context,
    required OdooClient client,
    required SessionModel session,
    bool isQuotation = false,
    bool isSale = false,
    Map<String, dynamic>? customFilterRules,
  }) async {
    if (!hasPreviousPage || isLoading) return;

    _currentPage--;
    await getQuotationsAndReport(
      context: context,
      session: session,
      isQuotation: _currentIsQuotation,
      isSale: _currentIsSale,
      isPipeline: _currentIsPipeline,
      showCreationDate: _currentShowCreationDate,
      currentMonth: _currentMonth,
      previousMonth: _previousMonth,
      twoMonthsBefore: _twoMonthsBefore,
      searchText: _currentSearchText,
      customFilterRules: customFilterRules ?? _customFilters,
      loading: true,
      resetPagination: false,
    );
  }

  /// Updates the stage data based on the selected filter for UI sorting.
  void updateStageData() {
    Map<String, String> filterKeyMap = {
      'Count': "count",
      'Currency Rate': 'currency_rate',
      'Prepayment Percent': 'prepayment_percent',
      'Amount Total': 'amount_total',
      'Amount Untaxed': 'amount_untaxed',
    };

    String dataKey = filterKeyMap[selectedFilterQuotation] ?? '';

    List<Map<String, dynamic>> stageDataToSort;
    stageDataToSort = _quoteData;
    if (dataKey.isNotEmpty) {
      stageDataToSort.sort((a, b) {
        var valueA = a[dataKey] ?? 0;
        var valueB = b[dataKey] ?? 0;
        return valueA.compareTo(valueB);
      });
    }
  }
}
