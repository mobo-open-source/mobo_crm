import 'package:flutter/material.dart';
import 'package:odoo_rpc/odoo_rpc.dart';

import '../../../core/company/session/company_session_manager.dart';

/// A provider that manages active filters and filter options for quotations.
///
/// This class handles fetching filter options from the Odoo backend, applying
/// and clearing filters, building Odoo-compatible domain filters, and providing
/// summary information about active filters. Designed to work with
/// `ChangeNotifier` for Flutter state management.
class QuotationFilterProvider extends ChangeNotifier {
  Map<String, dynamic> _activeFilters = {};
  List<Map<String, dynamic>> _customFilterOptions = [];
  bool _isLoadingFilters = false;

  Map<String, dynamic> get activeFilters => _activeFilters;

  List<Map<String, dynamic>> get customFilterOptions => _customFilterOptions;

  bool get isLoadingFilters => _isLoadingFilters;

  /// Clears all active filters.
  void clearAllFilters() {
    _activeFilters.clear();
    notifyListeners();
  }

  /// Sets or updates a filter value.
  ///
  /// If [value] is `null`, an empty string, or `false` (for booleans),
  /// the filter is removed instead.
  void setFilter(String key, dynamic value) {
    if (value == null ||
        (value is bool && !value) ||
        (value is String && value.isEmpty)) {
      _activeFilters.remove(key);
    } else {
      _activeFilters[key] = value;
    }
    notifyListeners();
  }

  /// Removes a specific filter by key.
  void removeFilter(String key) {
    _activeFilters.remove(key);
    notifyListeners();
  }

  /// Fetches available filter options from Odoo for sales teams, users,
  /// companies, currencies, payment terms, countries, and tags.
  ///
  /// The fetched options are stored in [_customFilterOptions].
  /// Sets [_isLoadingFilters] to `true` while fetching.
  Future<void> fetchFilterOptions({
    required OdooClient client,
    required OdooSession session,
  }) async {
    _isLoadingFilters = true;
    notifyListeners();

    try {
      final salesTeamsResponse = await CompanySessionManager.callKwWithCompany({
        'model': 'crm.team',
        'method': 'search_read',
        'args': [[]],
        'kwargs': {
          'fields': ['id', 'name'],
          'order': 'name asc',
        },
      });

      final usersResponse = await CompanySessionManager.callKwWithCompany({
        'model': 'res.users',
        'method': 'search_read',
        'args': [
          [
            ['active', '=', true]
          ]
        ],
        'kwargs': {
          'fields': ['id', 'name'],
          'order': 'name asc',
        },
      });

      final companiesResponse = await CompanySessionManager.callKwWithCompany({
        'model': 'res.company',
        'method': 'search_read',
        'args': [[]],
        'kwargs': {
          'fields': ['id', 'name'],
          'order': 'name asc',
        },
      });

      final currenciesResponse = await CompanySessionManager.callKwWithCompany({
        'model': 'res.currency',
        'method': 'search_read',
        'args': [
          [
            ['active', '=', true]
          ]
        ],
        'kwargs': {
          'fields': ['id', 'name', 'symbol'],
          'order': 'name asc',
        },
      });

      final paymentTermsResponse =
          await CompanySessionManager.callKwWithCompany({
        'model': 'account.payment.term',
        'method': 'search_read',
        'args': [[]],
        'kwargs': {
          'fields': ['id', 'name'],
          'order': 'name asc',
        },
      });

      final countriesResponse = await CompanySessionManager.callKwWithCompany({
        'model': 'res.country',
        'method': 'search_read',
        'args': [[]],
        'kwargs': {
          'fields': ['id', 'name'],
          'order': 'name asc',
        },
      });

      final tagsResponse = await CompanySessionManager.callKwWithCompany({
        'model': 'crm.tag',
        'method': 'search_read',
        'args': [[]],
        'kwargs': {
          'fields': ['id', 'name', 'color'],
          'order': 'name asc',
        },
      });

      _customFilterOptions = [
        {
          'key': 'sales_teams',
          'title': 'Sales Teams',
          'type': 'multi_select',
          'options': salesTeamsResponse
              .map((team) => {
                    'id': team['id'],
                    'name': team['name'],
                  })
              .toList(),
        },
        {
          'key': 'salespersons',
          'title': 'Salespersons',
          'type': 'multi_select',
          'options': usersResponse
              .map((user) => {
                    'id': user['id'],
                    'name': user['name'],
                  })
              .toList(),
        },
        {
          'key': 'companies',
          'title': 'Companies',
          'type': 'multi_select',
          'options': companiesResponse
              .map((company) => {
                    'id': company['id'],
                    'name': company['name'],
                  })
              .toList(),
        },
        {
          'key': 'currencies',
          'title': 'Currencies',
          'type': 'multi_select',
          'options': currenciesResponse
              .map((currency) => {
                    'id': currency['id'],
                    'name': '${currency['name']} (${currency['symbol']})',
                  })
              .toList(),
        },
        {
          'key': 'payment_terms',
          'title': 'Payment Terms',
          'type': 'multi_select',
          'options': paymentTermsResponse
              .map((term) => {
                    'id': term['id'],
                    'name': term['name'],
                  })
              .toList(),
        },
        {
          'key': 'countries',
          'title': 'Countries',
          'type': 'multi_select',
          'options': countriesResponse
              .map((country) => {
                    'id': country['id'],
                    'name': country['name'],
                  })
              .toList(),
        },
        {
          'key': 'tags',
          'title': 'Tags',
          'type': 'multi_select',
          'options': tagsResponse
              .map((tag) => {
                    'id': tag['id'],
                    'name': tag['name'],
                    'color': tag['color'] ?? 0,
                  })
              .toList(),
        },
        {
          'key': 'amount_range',
          'title': 'Amount Range',
          'type': 'range',
          'min': 0.0,
          'max': 1000000.0,
        },
        {
          'key': 'date_range',
          'title': 'Order Date Range',
          'type': 'date_range',
        },
        {
          'key': 'states',
          'title': 'Status',
          'type': 'multi_select',
          'options': [
            {'id': 'draft', 'name': 'Quotation'},
            {'id': 'sent', 'name': 'Quotation Sent'},
            {'id': 'sale', 'name': 'Sales Order'},
            {'id': 'done', 'name': 'Locked'},
            {'id': 'cancel', 'name': 'Cancelled'},
          ],
        },
        {
          'key': 'invoice_status',
          'title': 'Invoice Status',
          'type': 'multi_select',
          'options': [
            {'id': 'upselling', 'name': 'Upselling Opportunity'},
            {'id': 'invoiced', 'name': 'Fully Invoiced'},
            {'id': 'to invoice', 'name': 'To Invoice'},
            {'id': 'no', 'name': 'Nothing to Invoice'},
          ],
        },
      ];
    } catch (_) {
    } finally {
      _isLoadingFilters = false;
      notifyListeners();
    }
  }

  /// Builds a list of Odoo-compatible domain filters based on [_activeFilters].
  ///
  /// Returns a `List<dynamic>` suitable for passing as the `domain` parameter
  /// in Odoo RPC calls.
  List<dynamic> buildOdooFilters() {
    List<dynamic> filters = [];

    _activeFilters.forEach((key, value) {
      switch (key) {
        case 'sales_teams':
          if (value is List && value.isNotEmpty) {
            filters.add(['team_id', 'in', value]);
          }
          break;
        case 'salespersons':
          if (value is List && value.isNotEmpty) {
            filters.add(['user_id', 'in', value]);
          }
          break;
        case 'companies':
          if (value is List && value.isNotEmpty) {
            filters.add(['company_id', 'in', value]);
          }
          break;
        case 'currencies':
          if (value is List && value.isNotEmpty) {
            filters.add(['currency_id', 'in', value]);
          }
          break;
        case 'payment_terms':
          if (value is List && value.isNotEmpty) {
            filters.add(['payment_term_id', 'in', value]);
          }
          break;
        case 'countries':
          if (value is List && value.isNotEmpty) {
            filters.add(['partner_id.country_id', 'in', value]);
          }
          break;
        case 'tags':
          if (value is List && value.isNotEmpty) {
            filters.add(['tag_ids', 'in', value]);
          }
          break;
        case 'states':
          if (value is List && value.isNotEmpty) {
            filters.add(['state', 'in', value]);
          }
          break;
        case 'invoice_status':
          if (value is List && value.isNotEmpty) {
            filters.add(['invoice_status', 'in', value]);
          }
          break;
        case 'amount_range':
          if (value is Map) {
            if (value['min'] != null && value['min'] > 0) {
              filters.add(['amount_total', '>=', value['min']]);
            }
            if (value['max'] != null && value['max'] < 1000000) {
              filters.add(['amount_total', '<=', value['max']]);
            }
          }
          break;
        case 'date_range':
          if (value is Map) {
            if (value['start'] != null) {
              filters.add(['date_order', '>=', value['start']]);
            }
            if (value['end'] != null) {
              filters.add(['date_order', '<=', value['end']]);
            }
          }
          break;
        case 'has_activities':
          if (value == true) {
            filters.add(['activity_ids', '!=', false]);
          }
          break;
        case 'overdue_activities':
          if (value == true) {
            filters.add([
              'activity_date_deadline',
              '<',
              DateTime.now().toIso8601String().split('T')[0]
            ]);
          }
          break;
        case 'my_quotations':
          break;
      }
    });

    return filters;
  }

  /// Returns a human-readable summary of active filters.
  ///
  /// Example: "Sales Teams (2), Status (1), Date Range"
  String getFilterSummary() {
    if (_activeFilters.isEmpty) return 'No filters applied';

    List<String> summaryParts = [];

    _activeFilters.forEach((key, value) {
      switch (key) {
        case 'sales_teams':
          if (value is List && value.isNotEmpty) {
            summaryParts.add('Sales Teams (${value.length})');
          }
          break;
        case 'salespersons':
          if (value is List && value.isNotEmpty) {
            summaryParts.add('Salespersons (${value.length})');
          }
          break;
        case 'states':
          if (value is List && value.isNotEmpty) {
            summaryParts.add('Status (${value.length})');
          }
          break;
        case 'amount_range':
          if (value is Map) {
            summaryParts.add('Amount Range');
          }
          break;
        case 'date_range':
          if (value is Map) {
            summaryParts.add('Date Range');
          }
          break;
        default:
          if (value is List && value.isNotEmpty) {
            summaryParts.add(
                '${key.replaceAll('_', ' ').toUpperCase()} (${value.length})');
          } else if (value == true) {
            summaryParts.add(key.replaceAll('_', ' ').toUpperCase());
          }
      }
    });

    return summaryParts.join(', ');
  }

  /// Returns the count of currently active filters.
  int getActiveFilterCount() {
    int count = 0;
    _activeFilters.forEach((key, value) {
      if (value is List && value.isNotEmpty) {
        count++;
      } else if (value is bool && value) {
        count++;
      } else if (value is Map && value.isNotEmpty) {
        count++;
      }
    });
    return count;
  }
}
