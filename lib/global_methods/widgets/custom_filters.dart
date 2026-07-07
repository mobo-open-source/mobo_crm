import 'package:intl/intl.dart';

/// A utility class containing static methods to generate complex Odoo domain filters
/// for various CRM views (leads, opportunities, invoices, activities, etc.).
///
/// All methods return Odoo-compatible domain lists (e.g. `[['field', 'operator', value], ...]`)
/// that can be passed directly to `search_read`, `search_count`, etc.
///
/// Key conventions:
///   - Methods return empty list `[]` when the corresponding filter flag is `false`
///   - OR conditions are added with `'|'` prefix
///   - AND conditions are added with `'&'` prefix
///   - Date filters use Odoo server timezone-aware format (`yyyy-MM-dd 18:30:00`)
class CustomFilters {
  /// Generates domain filters for leads based on ownership and assignment.
  ///
  /// Parameters:
  ///   - `leadfilter`: Main switch — if false, returns empty list
  ///   - `myactivities`: Filter leads where current user is activity assignee
  ///   - `unAssigned`: Include unassigned leads (`user_id = false`)
  ///   - `partnerassigned`: Include leads where partner is assigned to current user
  ///   - `userId`: Current user's ID (required for ownership filters)
  ///
  /// Returns: Domain list or `[]` if no filters applied
  List<dynamic> getLeadDataFilter({
    required bool leadfilter,
    required bool myactivities,
    required bool unAssigned,
    required bool partnerassigned,
    int? userId,
  }) {
    if (!leadfilter) return [];

    List<dynamic> leadfilters = [];

    if (myactivities) {
      leadfilters.add('|');
      leadfilters.add(['activity_user_id', '=', userId]);
    }
    if (unAssigned) {
      leadfilters.add('|');
      leadfilters.add(["user_id", "=", false]);
    }
    if (partnerassigned) {
      leadfilters.add('|');
      leadfilters.add(["partner_assigned_id.user_id", "=", userId]);
    }

    if (leadfilters.length > 2) {
      leadfilters.removeAt(leadfilters.length - 2);
    } else if (leadfilters.length == 2) {
      leadfilters.removeAt(0);
    }

    return leadfilters;
  }

  /// Generates domain filters to separate customer invoices vs vendor bills.
  ///
  /// Parameters:
  ///   - `hasInvoiceVendorFilter`: Main switch
  ///   - `filterCustomerInvoice`: Include partners with `customer_rank > 0`
  ///   - `filterVendorBills`: Include partners with `supplier_rank > 0`
  ///
  /// Returns: Domain list or `[]` if no filters applied
  List<dynamic> getInvoiceVendorFilters({
    required bool hasInvoiceVendorFilter,
    required bool filterCustomerInvoice,
    required bool filterVendorBills,
  }) {
    List<dynamic> filters = [];

    if (hasInvoiceVendorFilter) {
      if (filterCustomerInvoice && !filterVendorBills) {
        filters.add(["customer_rank", ">", 0]);
      }
      if (filterVendorBills && !filterCustomerInvoice) {
        filters.add(["supplier_rank", ">", 0]);
      }
      if (filterCustomerInvoice && filterVendorBills) {
        filters.add("|");
        filters.add(["customer_rank", ">", 0]);
        filters.add(["supplier_rank", ">", 0]);
      }
    }

    return filters;
  }

  /// Generates domain filters for company vs individual partners.
  ///
  /// Parameters:
  ///   - `hasCompanyTypeFilters`: Main switch
  ///   - `filterIndividual`: Include `is_company = false`
  ///   - `filterCompany`: Include `is_company = true`
  ///
  /// Returns: Domain list or `[]` if no filters applied
  List<dynamic> getCompanyTypeFilters({
    required bool hasCompanyTypeFilters,
    required bool filterIndividual,
    required bool filterCompany,
  }) {
    List<dynamic> filters = [];

    if (hasCompanyTypeFilters) {
      if (filterIndividual && !filterCompany) {
        filters.add(['is_company', '=', false]);
      }
      if (filterCompany && !filterIndividual) {
        filters.add(['is_company', '=', true]);
      }
      if (filterIndividual && filterCompany) {
        filters.add([
          'is_company',
          'in',
          [true, false]
        ]);
      }
    }

    return filters;
  }

  /// Generates domain filters for pipeline/opportunity views.
  ///
  /// Parameters:
  ///   - `pipelinefilters`: Main switch
  ///   - `isPipeline`: Filter by current user's assigned opportunities
  ///   - `unAssigned`: Include unassigned opportunities
  ///   - `partnerassigned`: Include opportunities where partner is assigned to user
  ///   - `opeopportunity`: Include only open/active opportunities (`probability < 100`)
  ///   - `userId`: Current user's ID
  ///
  /// Returns: Domain list or `[]` if no filters applied
  List<dynamic> getPipelineFilter(
      {required bool pipelinefilters,
      required bool isPipeline,
      required bool unAssigned,
      required bool partnerassigned,
      required bool opeopportunity,
      required int userId}) {
    List filterspipeline = [];

    if (!pipelinefilters) return [];
    if (pipelinefilters) {
      if (isPipeline == true) {
        filterspipeline.add('|');

        filterspipeline.add(['user_id', '=', userId]);
      }

      if (unAssigned) {
        filterspipeline.add('|');

        filterspipeline.add(["user_id", "=", false]);
      }
      if (partnerassigned) {
        filterspipeline.add('|');

        filterspipeline.add(["partner_assigned_id.user_id", "=", userId]);
      }

      final List<dynamic> open = [];
      if (opeopportunity) {
        open.add("&");
        open.add("&");
        open.add(
          ["probability", "<", 100],
        );

        open.add(["active", "=", true]);
        open.add(['type', '=', 'opportunity']);
        filterspipeline = [...filterspipeline, ...open];
      }

      if (filterspipeline.length >= 2 && opeopportunity == false) {
        filterspipeline.removeAt(filterspipeline.length - 2);
      }
    }
    return filterspipeline;
  }

  /// Generates domain filters for opportunity stage states (won, lost, ongoing).
  ///
  /// Parameters:
  ///   - `stagefilters`: Main switch
  ///   - `won`: Include won opportunities (`stage_id.is_won = true` + `active = true`)
  ///   - `lost`: Include lost opportunities (`active = false` + `probability = 0`)
  ///   - `onGoing`: Include ongoing opportunities (`active = true` + `is_won = false`)
  ///
  /// Returns: Domain list or `[]` if no filters applied
  List<dynamic> getStageFilters(
      {required bool stagefilters,
      required bool lost,
      required bool won,
      required bool onGoing}) {
    if (!stagefilters) return [];

    List<dynamic> stage = [];
    if (won) {
      stage.add("&");
      stage.add(["active", "=", true]);
      stage.add(["stage_id.is_won", "=", true]);
    }
    if (lost) {
      stage.add("&");
      stage.add(["active", "=", false]);
      stage.add(["probability", "=", 0]);
    }

    if (onGoing) {
      stage.add("&");
      stage.add(["active", "=", true]);
      stage.add(["stage_id.is_won", "=", false]);
    }

    if (stage.length == 6) {
      stage.insert(0, "|");
    } else if (stage.length == 9) {
      stage.insert(0, "|");
      stage.insert(4, "|");
    }

    return stage;
  }

  /// Generates domain filters for activity deadline categories.
  ///
  /// Parameters:
  ///   - `activitycatgoryfilter`: Main switch
  ///   - `lateactivity`: Activities overdue (`my_activity_date_deadline < today`)
  ///   - `todayactivity`: Activities due today
  ///   - `futureactivity`: Activities due in future
  ///
  /// Returns: Domain list or `[]` if no filters applied
  List<dynamic> getActivityFilters(
      {required bool activitycatgoryfilter,
      required bool lateactivity,
      required bool todayactivity,
      required bool futureactivity}) {
    if (!activitycatgoryfilter) return [];
    List<dynamic> activityFiltersList = [];

    if (activitycatgoryfilter) {
      String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

      if (lateactivity) {
        activityFiltersList.add(["my_activity_date_deadline", "<", todayDate]);
      }
      if (todayactivity) {
        activityFiltersList.add(["my_activity_date_deadline", "=", todayDate]);
      }
      if (futureactivity) {
        activityFiltersList.add(["my_activity_date_deadline", ">", todayDate]);
      }

      if (activityFiltersList.length == 2) {
        activityFiltersList.insert(0, "|");
      } else if (activityFiltersList.length == 3) {
        activityFiltersList.insert(0, "|");
        activityFiltersList.insert(2, "|");
      }
    }
    return activityFiltersList;
  }

  /// Generates domain filters for lead creation date (current month, last month, two months ago).
  ///
  /// Parameters:
  ///   - `leaddatefilters`: Main switch
  ///   - `leadmonthNow`: Leads created this month
  ///   - `leadbeforeMonth`: Leads created last month
  ///   - `leadbeforetwoMonth`: Leads created two months ago
  ///
  /// Returns: Domain list or `[]` if no filters applied
  List<dynamic> getLeadDateFilters({
    required bool leaddatefilters,
    required bool leadmonthNow,
    required bool leadbeforeMonth,
    required bool leadbeforetwoMonth,
  }) {
    if (!leaddatefilters) return [];

    List<dynamic> creationDatefilter = [];
    DateTime now = DateTime.now();

    String currentMonthStart = DateFormat('yyyy-MM-dd 18:30:00')
        .format(DateTime(now.year, now.month, 1));
    String currentMonthEnd = DateFormat('yyyy-MM-dd 18:29:59')
        .format(DateTime(now.year, now.month + 1, 0));
    String lastMonthStart = DateFormat('yyyy-MM-dd 18:30:00')
        .format(DateTime(now.year, now.month - 1, 1));
    String lastMonthEnd = DateFormat('yyyy-MM-dd 18:29:59')
        .format(DateTime(now.year, now.month, 0));
    String twoMonthsAgoStart = DateFormat('yyyy-MM-dd 18:30:00')
        .format(DateTime(now.year, now.month - 2, 1));
    String twoMonthsAgoEnd = DateFormat('yyyy-MM-dd 18:29:59')
        .format(DateTime(now.year, now.month - 1, 0));

    int selectedCount = 0;
    if (leadmonthNow) selectedCount++;
    if (leadbeforeMonth) selectedCount++;
    if (leadbeforetwoMonth) selectedCount++;

    if (selectedCount == 1) {
      if (leadmonthNow) {
        creationDatefilter.addAll([
          "&",
          ["create_date", ">=", currentMonthStart],
          ["create_date", "<=", currentMonthEnd]
        ]);
      } else if (leadbeforeMonth) {
        creationDatefilter.addAll([
          "&",
          ["create_date", ">=", lastMonthStart],
          ["create_date", "<=", lastMonthEnd]
        ]);
      } else if (leadbeforetwoMonth) {
        creationDatefilter.addAll([
          "&",
          ["create_date", ">=", twoMonthsAgoStart],
          ["create_date", "<=", twoMonthsAgoEnd]
        ]);
      }
    } else if (selectedCount == 2) {
      creationDatefilter.add("|");
      if (leadmonthNow && leadbeforeMonth) {
        creationDatefilter.addAll([
          "&",
          ["create_date", ">=", lastMonthStart],
          ["create_date", "<=", lastMonthEnd],
          "&",
          ["create_date", ">=", currentMonthStart],
          ["create_date", "<=", currentMonthEnd]
        ]);
      } else if (leadmonthNow && leadbeforetwoMonth) {
        creationDatefilter.addAll([
          "&",
          ["create_date", ">=", twoMonthsAgoStart],
          ["create_date", "<=", twoMonthsAgoEnd],
          "&",
          ["create_date", ">=", currentMonthStart],
          ["create_date", "<=", currentMonthEnd]
        ]);
      } else if (leadbeforeMonth && leadbeforetwoMonth) {
        creationDatefilter.addAll([
          "&",
          ["create_date", ">=", twoMonthsAgoStart],
          ["create_date", "<=", twoMonthsAgoEnd],
          "&",
          ["create_date", ">=", lastMonthStart],
          ["create_date", "<=", lastMonthEnd]
        ]);
      }
    } else if (selectedCount == 3) {
      creationDatefilter.addAll([
        "|",
        "&",
        ["create_date", ">=", twoMonthsAgoStart],
        ["create_date", "<=", twoMonthsAgoEnd],
        "|",
        "&",
        ["create_date", ">=", lastMonthStart],
        ["create_date", "<=", lastMonthEnd],
        "&",
        ["create_date", ">=", currentMonthStart],
        ["create_date", "<=", currentMonthEnd]
      ]);
    }
    return creationDatefilter;
  }

  /// Generates domain filters for activity completion date (similar to creation date).
  ///
  /// Parameters:
  ///   - `currentMonth`, `prevoiusMonth`, `twoMonthsbefore`: Time range flags
  ///
  /// Returns: Domain list or `[]` if no filters applied
  List<dynamic> getActivityCompletion({
    required bool currentMonth,
    required bool prevoiusMonth,
    required bool twoMonthsbefore,
  }) {
    if (!currentMonth && !prevoiusMonth && !twoMonthsbefore) return [];

    List<dynamic> completionDatefilter = [];
    DateTime now = DateTime.now();

    String currentMonthStart = DateFormat('yyyy-MM-dd 18:30:00')
        .format(DateTime(now.year, now.month, 1));
    String currentMonthEnd = DateFormat('yyyy-MM-dd 18:29:59')
        .format(DateTime(now.year, now.month + 1, 0));
    String lastMonthStart = DateFormat('yyyy-MM-dd 18:30:00')
        .format(DateTime(now.year, now.month - 1, 1));
    String lastMonthEnd = DateFormat('yyyy-MM-dd 18:29:59')
        .format(DateTime(now.year, now.month, 0));
    String twoMonthsAgoStart = DateFormat('yyyy-MM-dd 18:30:00')
        .format(DateTime(now.year, now.month - 2, 1));
    String twoMonthsAgoEnd = DateFormat('yyyy-MM-dd 18:29:59')
        .format(DateTime(now.year, now.month - 1, 0));

    int selectedCount = 0;
    if (currentMonth) selectedCount++;
    if (prevoiusMonth) selectedCount++;
    if (twoMonthsbefore) selectedCount++;

    if (selectedCount == 1) {
      if (currentMonth) {
        completionDatefilter.addAll([
          "&",
          ["date", ">=", currentMonthStart],
          ["date", "<=", currentMonthEnd]
        ]);
      } else if (prevoiusMonth) {
        completionDatefilter.addAll([
          "&",
          ["date", ">=", lastMonthStart],
          ["date", "<=", lastMonthEnd]
        ]);
      } else if (twoMonthsbefore) {
        completionDatefilter.addAll([
          "&",
          ["date", ">=", twoMonthsAgoStart],
          ["date", "<=", twoMonthsAgoEnd]
        ]);
      }
    } else if (selectedCount == 2) {
      completionDatefilter.add("|");
      if (currentMonth && prevoiusMonth) {
        completionDatefilter.addAll([
          "&",
          ["date", ">=", lastMonthStart],
          ["date", "<=", lastMonthEnd],
          "&",
          ["date", ">=", currentMonthStart],
          ["date", "<=", currentMonthEnd]
        ]);
      } else if (currentMonth && twoMonthsbefore) {
        completionDatefilter.addAll([
          "&",
          ["date", ">=", twoMonthsAgoStart],
          ["date", "<=", twoMonthsAgoEnd],
          "&",
          ["date", ">=", currentMonthStart],
          ["date", "<=", currentMonthEnd]
        ]);
      } else if (prevoiusMonth && twoMonthsbefore) {
        completionDatefilter.addAll([
          "&",
          ["date", ">=", twoMonthsAgoStart],
          ["date", "<=", twoMonthsAgoEnd],
          "&",
          ["date", ">=", lastMonthStart],
          ["date", "<=", lastMonthEnd]
        ]);
      }
    } else if (selectedCount == 3) {
      completionDatefilter.addAll([
        "|",
        "&",
        ["date", ">=", twoMonthsAgoStart],
        ["date", "<=", twoMonthsAgoEnd],
        "|",
        "&",
        ["date", ">=", lastMonthStart],
        ["date", "<=", lastMonthEnd],
        "&",
        ["date", ">=", currentMonthStart],
        ["date", "<=", currentMonthEnd]
      ]);
    }
    return completionDatefilter;
  }

  /// Generates domain filters for lead closing date (similar to creation date).
  ///
  /// Parameters:
  ///   - `leaddatefiltersclose`: Main switch
  ///   - `leadmonthNowclose`, `leadbeforeMonthclose`, `leadbeforetwoMonthclose`: Time ranges
  ///
  /// Returns: Domain list or `[]` if no filters applied
  List<dynamic> getLeadDateFiltersClose({
    required bool leaddatefiltersclose,
    required bool leadmonthNowclose,
    required bool leadbeforeMonthclose,
    required bool leadbeforetwoMonthclose,
  }) {
    if (!leaddatefiltersclose) return [];

    List<dynamic> creationDatefilterclose = [];
    DateTime now = DateTime.now();

    String currentMonthStart = DateFormat('yyyy-MM-dd 18:30:00')
        .format(DateTime(now.year, now.month, 1));
    String currentMonthEnd = DateFormat('yyyy-MM-dd 18:29:59')
        .format(DateTime(now.year, now.month + 1, 0));
    String lastMonthStart = DateFormat('yyyy-MM-dd 18:30:00')
        .format(DateTime(now.year, now.month - 1, 1));
    String lastMonthEnd = DateFormat('yyyy-MM-dd 18:29:59')
        .format(DateTime(now.year, now.month, 0));
    String twoMonthsAgoStart = DateFormat('yyyy-MM-dd 18:30:00')
        .format(DateTime(now.year, now.month - 2, 1));
    String twoMonthsAgoEnd = DateFormat('yyyy-MM-dd 18:29:59')
        .format(DateTime(now.year, now.month - 1, 0));

    int selectedCount = 0;
    if (leadmonthNowclose) selectedCount++;
    if (leadbeforeMonthclose) selectedCount++;
    if (leadbeforetwoMonthclose) selectedCount++;

    if (selectedCount == 1) {
      if (leadmonthNowclose) {
        creationDatefilterclose.addAll([
          "&",
          ["date_closed", ">=", currentMonthStart],
          ["date_closed", "<=", currentMonthEnd]
        ]);
      } else if (leadbeforeMonthclose) {
        creationDatefilterclose.addAll([
          "&",
          ["date_closed", ">=", lastMonthStart],
          ["date_closed", "<=", lastMonthEnd]
        ]);
      } else if (leadbeforetwoMonthclose) {
        creationDatefilterclose.addAll([
          "&",
          ["date_closed", ">=", twoMonthsAgoStart],
          ["date_closed", "<=", twoMonthsAgoEnd]
        ]);
      }
    } else if (selectedCount == 2) {
      creationDatefilterclose.add("|");
      if (leadmonthNowclose && leadbeforeMonthclose) {
        creationDatefilterclose.addAll([
          "&",
          ["date_closed", ">=", lastMonthStart],
          ["date_closed", "<=", lastMonthEnd],
          "&",
          ["date_closed", ">=", currentMonthStart],
          ["date_closed", "<=", currentMonthEnd]
        ]);
      } else if (leadmonthNowclose && leadbeforetwoMonthclose) {
        creationDatefilterclose.addAll([
          "&",
          ["date_closed", ">=", twoMonthsAgoStart],
          ["date_closed", "<=", twoMonthsAgoEnd],
          "&",
          ["date_closed", ">=", currentMonthStart],
          ["date_closed", "<=", currentMonthEnd]
        ]);
      } else if (leadbeforeMonthclose && leadbeforetwoMonthclose) {
        creationDatefilterclose.addAll([
          "&",
          ["date_closed", ">=", twoMonthsAgoStart],
          ["date_closed", "<=", twoMonthsAgoEnd],
          "&",
          ["date_closed", ">=", lastMonthStart],
          ["date_closed", "<=", lastMonthEnd]
        ]);
      }
    } else if (selectedCount == 3) {
      creationDatefilterclose.addAll([
        "|",
        "&",
        ["date_closed", ">=", twoMonthsAgoStart],
        ["date_closed", "<=", twoMonthsAgoEnd],
        "|",
        "&",
        ["date_closed", ">=", lastMonthStart],
        ["date_closed", "<=", lastMonthEnd],
        "&",
        ["date_closed", ">=", currentMonthStart],
        ["date_closed", "<=", currentMonthEnd]
      ]);
    }

    return creationDatefilterclose;
  }

  /// Generates domain filters for expected closing date (date_deadline).
  ///
  /// Parameters:
  ///   - `expectedClosingBool`: Main switch
  ///   - `leadmonthNowexpected`, `leadbeforeMonthexpected`, `leadbeforetwoexpected`: Time ranges
  ///
  /// Returns: Domain list or `[]` if no filters applied
  List<dynamic> getLeadExpectedClosing({
    required bool expectedClosingBool,
    required bool leadmonthNowexpected,
    required bool leadbeforeMonthexpected,
    required bool leadbeforetwoexpected,
  }) {
    if (!expectedClosingBool) return [];

    List<dynamic> creationDatefilterExpected = [];
    DateTime now = DateTime.now();

    String currentMonthStart = DateFormat('yyyy-MM-dd 18:30:00')
        .format(DateTime(now.year, now.month, 1));
    String currentMonthEnd = DateFormat('yyyy-MM-dd 18:29:59')
        .format(DateTime(now.year, now.month + 1, 0));
    String lastMonthStart = DateFormat('yyyy-MM-dd 18:30:00')
        .format(DateTime(now.year, now.month - 1, 1));
    String lastMonthEnd = DateFormat('yyyy-MM-dd 18:29:59')
        .format(DateTime(now.year, now.month, 0));
    String twoMonthsAgoStart = DateFormat('yyyy-MM-dd 18:30:00')
        .format(DateTime(now.year, now.month - 2, 1));
    String twoMonthsAgoEnd = DateFormat('yyyy-MM-dd 18:29:59')
        .format(DateTime(now.year, now.month - 1, 0));
    int selectedCount = 0;
    if (leadmonthNowexpected) selectedCount++;
    if (leadbeforeMonthexpected) selectedCount++;
    if (leadbeforetwoexpected) selectedCount++;

    if (selectedCount == 1) {
      if (leadmonthNowexpected) {
        creationDatefilterExpected.addAll([
          "&",
          ["date_deadline", ">=", currentMonthStart],
          ["date_deadline", "<=", currentMonthEnd]
        ]);
      } else if (leadbeforeMonthexpected) {
        creationDatefilterExpected.addAll([
          "&",
          ["date_deadline", ">=", lastMonthStart],
          ["date_deadline", "<=", lastMonthEnd]
        ]);
      } else if (leadbeforetwoexpected) {
        creationDatefilterExpected.addAll([
          "&",
          ["date_deadline", ">=", twoMonthsAgoStart],
          ["date_deadline", "<=", twoMonthsAgoEnd]
        ]);
      }
    } else if (selectedCount == 2) {
      creationDatefilterExpected.add("|");
      if (leadmonthNowexpected && leadbeforeMonthexpected) {
        creationDatefilterExpected.addAll([
          "&",
          ["date_deadline", ">=", lastMonthStart],
          ["date_deadline", "<=", lastMonthEnd],
          "&",
          ["date_deadline", ">=", currentMonthStart],
          ["date_deadline", "<=", currentMonthEnd]
        ]);
      } else if (leadmonthNowexpected && leadbeforetwoexpected) {
        creationDatefilterExpected.addAll([
          "&",
          ["date_closed", ">=", twoMonthsAgoStart],
          ["date_closed", "<=", twoMonthsAgoEnd],
          "&",
          ["date_closed", ">=", currentMonthStart],
          ["date_closed", "<=", currentMonthEnd]
        ]);
      } else if (leadbeforeMonthexpected && leadbeforetwoexpected) {
        creationDatefilterExpected.addAll([
          "&",
          ["date_deadline", ">=", twoMonthsAgoStart],
          ["date_deadline", "<=", twoMonthsAgoEnd],
          "&",
          ["date_deadline", ">=", lastMonthStart],
          ["date_deadline", "<=", lastMonthEnd]
        ]);
      }
    } else if (selectedCount == 3) {
      creationDatefilterExpected.addAll([
        "|",
        "&",
        ["date_deadline", ">=", twoMonthsAgoStart],
        ["date_deadline", "<=", twoMonthsAgoEnd],
        "|",
        "&",
        ["date_deadline", ">=", lastMonthStart],
        ["date_deadline", "<=", lastMonthEnd],
        "&",
        ["date_deadline", ">=", currentMonthStart],
        ["date_deadline", "<=", currentMonthEnd]
      ]);
    }

    return creationDatefilterExpected;
  }

  /// Merges multiple date-related filters with proper OR separators.
  ///
  /// Parameters:
  ///   - Flags to check which date filters are active
  ///   - Pre-computed date filter lists for each category
  ///
  /// Returns: Combined domain list (with '|' separators when needed)
  List<dynamic> mergeDateFilters({
    required bool leaddatefilters,
    required bool leaddatefiltersclose,
    required bool leaddatefilterExpected,
    required List<dynamic> leadDateFilters,
    required List<dynamic> leadDateFilterExpected,
    required List<dynamic> leadDateFiltersClose,
  }) {
    if (leaddatefilters && leaddatefiltersclose) {
      return ["|", ...leadDateFilters, ...leadDateFiltersClose];
    } else if (leaddatefilters && leaddatefilterExpected) {
      return ["|", ...leadDateFilters, ...leadDateFilterExpected];
    } else if (leaddatefiltersclose && leaddatefilterExpected) {
      return ["|", ...leadDateFiltersClose, ...leadDateFilterExpected];
    } else if (leaddatefilters &&
        leaddatefiltersclose &&
        leaddatefilterExpected) {
      return [
        "|",
        ...leadDateFiltersClose,
        "|",
        ...leadDateFilterExpected,
        ...leadDateFilterExpected
      ];
    }

    return [
      ...leadDateFilters,
      ...leadDateFiltersClose,
      ...leadDateFilterExpected
    ];
  }
}
