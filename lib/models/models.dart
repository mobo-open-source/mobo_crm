import 'package:animated_custom_dropdown/custom_dropdown.dart';

/// Represents a lead item displayed inside a custom dropdown.
///
/// Implements [CustomDropdownListFilter] to enable
/// search filtering inside dropdown lists.
class LeadItem with CustomDropdownListFilter {
  final int? id;
  final String? contactname;
  final String? name;
  final String? email;
  final String? stage;
  final String? salesperson;
  final String? createdon;

  /// Creates a [LeadItem] instance.
  LeadItem(
      {required this.id,
      required this.contactname,
      required this.name,
      required this.createdon,
      required this.email,
      required this.salesperson,
      required this.stage});

  @override
  bool operator ==(Object other) => other is LeadItem && other.id == id;

  @override
  int get hashCode => id.hashCode;

  /// Returns the lead name for display.
  @override
  String toString() {
    return name!;
  }

  /// Filters leads by matching the end of the name.
  @override
  bool filter(String query) {
    return name!.toLowerCase().endsWith(query.toLowerCase());
  }
}

/// Represents a customer (partner) record.
class CustomerItem {
  final int id;
  final String name;
  final String fullname;
  final String email;

  /// Creates a [CustomerItem] instance.
  CustomerItem({
    required this.id,
    required this.name,
    required this.fullname,
    required this.email,
  });

  /// Creates a [CustomerItem] from JSON.
  factory CustomerItem.fromJson(Map<String, dynamic> json) {
    return CustomerItem(
      id: json['id'] as int,
      name: json['name']?.toString() ?? '',
      fullname: json['complete_name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
    );
  }

  @override
  String toString() => name;
}

/// Represents a salesperson user.
class SalesPersonItem {
  final int? id;
  final String name;
  final int? teamid;
  final String? teamName;

  /// Creates a [SalesPersonItem] instance.
  SalesPersonItem({
    required this.id,
    required this.name,
    required this.teamid,
    required this.teamName,
  });

  /// Creates a [SalesPersonItem] from JSON.
  ///
  /// Safely parses relational `sale_team_id`.
  factory SalesPersonItem.fromJson(Map<String, dynamic> json) {
    final team = json['sale_team_id'];
    int? parsedTeamId;
    String? parsedTeamName;

    if (team is List && team.length == 2 && team[1] != false) {
      parsedTeamId = team[0] is int ? team[0] : null;
      parsedTeamName = team[1] is String ? team[1] : null;
    }

    return SalesPersonItem(
      id: json['id'],
      name: json['name'] ?? '',
      teamid: parsedTeamId,
      teamName: parsedTeamName,
    );
  }

  @override
  String toString() => name;
}

/// Represents a sales team.
class SalesTeam {
  final int id;
  final String name;

  /// Creates a [SalesTeam] instance.
  SalesTeam({
    required this.id,
    required this.name,
  });

  factory SalesTeam.fromJson(Map<String, dynamic> json) {
    return SalesTeam(
      id: json['id'],
      name: json['name'] ?? '',
    );
  }

  @override
  String toString() => name;
}

/// Represents a tax configuration.
class Tax {
  final int id;
  final String name;
  final double amount;
  final String typeTaxUse;

  /// Creates a [Tax] instance.
  Tax({
    required this.id,
    required this.name,
    required this.amount,
    required this.typeTaxUse,
  });

  /// Creates a [Tax] from a map.
  factory Tax.fromMap(Map<String, dynamic> map) {
    return Tax(
      id: map['id'] as int,
      name: map['name'] as String,
      amount: (map['amount'] as num).toDouble(),
      typeTaxUse: map['type_tax_use'] as String,
    );
  }
}

/// Represents CRM lead analytics data.
class LeadCrmModel {
  final int id;
  final DateTime createDate;
  final String stageName;
  final double dayClose;
  final double expectedRevenue;
  final double recurringRevenueMonthly;
  final double probability;
  final double recurringRevenueMonthlyProrated;
  final double recurringRevenueProrated;
  final double proratedRevenue;
  final double recurringRevenue;

  /// Creates a [LeadCrmModel] instance.
  LeadCrmModel({
    required this.id,
    required this.createDate,
    required this.stageName,
    required this.dayClose,
    required this.expectedRevenue,
    required this.recurringRevenueMonthly,
    required this.probability,
    required this.recurringRevenueMonthlyProrated,
    required this.recurringRevenueProrated,
    required this.proratedRevenue,
    required this.recurringRevenue,
  });

  /// Creates a [LeadCrmModel] from JSON.
  factory LeadCrmModel.fromJson(Map<String, dynamic> json) {
    return LeadCrmModel(
      id: json['id'] ?? 0,
      createDate:
          DateTime.tryParse(json['create_date'] ?? '') ?? DateTime.now(),
      stageName: json['stage_id'] != null && json['stage_id'] is List
          ? json['stage_id'][1]
          : 'Unknown',
      dayClose: (json['day_close']).toDouble(),
      expectedRevenue: (json['expected_revenue'] ?? 0.0).toDouble(),
      recurringRevenueMonthly:
          (json['recurring_revenue_monthly'] ?? 0.0).toDouble(),
      probability: (json['probability'] ?? 0.0).toDouble(),
      recurringRevenueMonthlyProrated:
          (json['recurring_revenue_monthly_prorated'] ?? 0.0).toDouble(),
      recurringRevenueProrated:
          (json['recurring_revenue_prorated'] ?? 0.0).toDouble(),
      proratedRevenue: (json['prorated_revenue'] ?? 0.0).toDouble(),
      recurringRevenue: (json['recurring_revenue'] ?? 0.0).toDouble(),
    );
  }
}

/// Represents a CRM opportunity (`crm.lead`) with pipeline stage and revenue metrics.
class OpportunityModel {
  final int id;

  final DateTime createDate;
  final String stageName;
  final double dayClose;
  final double expectedRevenue;
  final double recurringRevenueMonthly;
  final double probability;
  final double recurringRevenueMonthlyProrated;
  final double recurringRevenueProrated;
  final double proratedRevenue;
  final double recurringRevenue;

  OpportunityModel({
    required this.id,
    required this.createDate,
    required this.stageName,
    required this.dayClose,
    required this.expectedRevenue,
    required this.recurringRevenueMonthly,
    required this.probability,
    required this.recurringRevenueMonthlyProrated,
    required this.recurringRevenueProrated,
    required this.proratedRevenue,
    required this.recurringRevenue,
  });

  factory OpportunityModel.fromJson(Map<String, dynamic> json) {
    return OpportunityModel(
      id: json['id'] ?? 0,
      createDate: DateTime.parse(json['create_date']),
      stageName: json['stage_id'] != null && json['stage_id'] is List
          ? json['stage_id'][1]
          : 'Unknown',
      dayClose: (json['day_close']).toDouble(),
      expectedRevenue: (json['expected_revenue'] ?? 0).toDouble(),
      recurringRevenueMonthly:
          (json['recurring_revenue_monthly'] ?? 0).toDouble(),
      probability: (json['probability'] ?? 0).toDouble(),
      recurringRevenueMonthlyProrated:
          (json['recurring_revenue_monthly_prorated'] ?? 0).toDouble(),
      recurringRevenueProrated:
          (json['recurring_revenue_prorated'] ?? 0).toDouble(),
      proratedRevenue: (json['prorated_revenue'] ?? 0).toDouble(),
      recurringRevenue: (json['recurring_revenue'] ?? 0).toDouble(),
    );
  }
}

/// Represents a forecasted opportunity grouped by stage, with expected and prorated revenue.
class ForecastModel {
  final int id;
  final String stageName;
  final double expectedRevenue;
  final double proratedRevenue;
  final String? dateDeadline;

  ForecastModel({
    required this.id,
    required this.stageName,
    required this.expectedRevenue,
    required this.proratedRevenue,
    this.dateDeadline,
  });

  factory ForecastModel.fromJson(Map<String, dynamic> json) {
    return ForecastModel(
      id: json['id'] ?? 0,
      stageName: json['stage_id'] is List
          ? json['stage_id'][1] ?? 'Unknown'
          : 'Unknown',
      expectedRevenue: (json['expected_revenue'] ?? 0).toDouble(),
      proratedRevenue: (json['prorated_revenue'] ?? 0).toDouble(),
      dateDeadline: json['date_deadline']
          ?.toString(),
    );
  }
}

/// A selectable filter option used to build list and kanban filter chips.
class FilterOption {
  final String label;
  final String key;
  final List? value;
  bool isSelected;
  String filtercategory;

  FilterOption(
      {required this.label,
      this.filtercategory = 'default',
      required this.key,
      this.isSelected = false,
      this.value});
}

/// Represents a CRM lead tag (`crm.tag`).
class LeadTag {
  final int id;
  final String name;

  LeadTag({required this.id, required this.name});

  factory LeadTag.fromJson(Map<String, dynamic> json) {
    return LeadTag(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }
}

/// Represents a country (`res.country`).
class Country {
  final int id;
  final String name;

  Country({required this.id, required this.name});

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }
}

/// Represents a state or province (`res.country.state`).
class StateClass {
  final int id;
  final String name;

  StateClass({required this.id, required this.name});

  factory StateClass.fromJson(Map<String, dynamic> json) {
    return StateClass(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }
}

/// Represents a marketing campaign (`utm.campaign`).
class Campaign {
  final int id;
  final String name;

  Campaign({required this.id, required this.name});

  factory Campaign.fromJson(Map<String, dynamic> json) {
    return Campaign(
      id: json['id'],
      name: json['name'],
    );
  }
}

/// Represents a UTM medium (`utm.medium`).
class Medium {
  final int id;
  final String name;

  Medium({required this.id, required this.name});

  factory Medium.fromJson(Map<String, dynamic> json) {
    return Medium(
      id: json['id'],
      name: json['name'],
    );
  }
}

/// Represents a UTM source (`utm.source`).
class Source {
  final int id;
  final String name;

  Source({required this.id, required this.name});

  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(
      id: json['id'],
      name: json['name'],
    );
  }
}

/// Represents a hierarchical product or partner category.
class Category {
  final int id;
  final String name;
  final int? parentId;
  final String? parentName;

  Category({
    required this.id,
    required this.name,
    this.parentId,
    this.parentName,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as int,
      name: json['name'] is String ? json['name'] : '',
      parentId: json['parent_id'] is List && json['parent_id'].isNotEmpty
          ? json['parent_id'][0] as int?
          : null,
      parentName: json['parent_id'] is List && json['parent_id'].isNotEmpty
          ? json['parent_id'][1] as String?
          : null,
    );
  }

  /// Returns formatted hierarchical name (e.g., Parent/Child).
  String getFormattedName() {
    if (parentName != null && parentName!.isNotEmpty) {
      return '$parentName/$name';
    }
    return name;
  }
}

/// Represents an accounting fiscal position (`account.fiscal.position`).
class FiscalPosition {
  final int id;
  final String name;

  FiscalPosition({required this.id, required this.name});

  factory FiscalPosition.fromJson(Map<String, dynamic> json) {
    return FiscalPosition(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }

  static List<FiscalPosition> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => FiscalPosition.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  String toString() => 'FiscalPosition(id: $id, name: $name)';
}

/// Represents an accounting journal (`account.journal`).
class AccountJournal {
  final int id;
  final String name;

  AccountJournal({
    required this.id,
    required this.name,
  });

  factory AccountJournal.fromJson(Map<String, dynamic> json) {
    return AccountJournal(
      id: json['id'],
      name: json['name'],
    );
  }

  @override
  String toString() => 'AccountJournal(id: $id, name: $name)';
}

/// Represents a scheduled activity (`mail.activity`) linked to a record.
class MailActivity {
  final int id;
  final String resModel;
  final int resId;
  final String summary;
  final String dateDeadline;
  final int userId;

  MailActivity({
    required this.id,
    required this.resModel,
    required this.resId,
    required this.summary,
    required this.dateDeadline,
    required this.userId,
  });

  factory MailActivity.fromJson(Map<String, dynamic> json) {
    return MailActivity(
      id: json['id'] as int,
      resModel: json['res_model'] as String? ?? '',
      resId: json['res_id'] as int? ?? 0,
      summary: json['summary'] != false ? json['summary'] : '' as String? ?? '',
      dateDeadline: json['date_deadline'] as String? ?? '',
      userId: (json['user_id'] as List?)?.first ?? 0,
    );
  }
}
