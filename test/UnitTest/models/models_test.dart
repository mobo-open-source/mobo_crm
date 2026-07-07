import 'package:flutter_test/flutter_test.dart';
import 'package:mobo_crm/models/models.dart';

/// Unit tests for the data models in `lib/models/models.dart`.
///
/// These focus on `fromJson` parsing of raw Odoo JSON-RPC responses,
/// including Odoo's convention of returning `false` for empty fields and
/// `[id, name]` pairs for relational (many2one) fields.
void main() {
  group('CustomerItem', () {
    test('fromJson maps all fields', () {
      final c = CustomerItem.fromJson({
        'id': 501,
        'name': 'Acme',
        'complete_name': 'Acme Corporation',
        'email': 'acme@test.com',
      });
      expect(c.id, 501);
      expect(c.name, 'Acme');
      expect(c.fullname, 'Acme Corporation');
      expect(c.email, 'acme@test.com');
    });

    test('fromJson defaults missing string fields to empty string', () {
      final c = CustomerItem.fromJson({'id': 502});
      expect(c.name, '');
      expect(c.fullname, '');
      expect(c.email, '');
    });

    test('toString returns the name', () {
      final c = CustomerItem.fromJson({'id': 1, 'name': 'Beta'});
      expect(c.toString(), 'Beta');
    });
  });

  group('SalesPersonItem', () {
    test('fromJson parses relational sale_team_id [id, name]', () {
      final s = SalesPersonItem.fromJson({
        'id': 7,
        'name': 'John Doe',
        'sale_team_id': [3, 'Direct Sales'],
      });
      expect(s.id, 7);
      expect(s.name, 'John Doe');
      expect(s.teamid, 3);
      expect(s.teamName, 'Direct Sales');
    });

    test('fromJson handles sale_team_id == false', () {
      final s = SalesPersonItem.fromJson({
        'id': 8,
        'name': 'No Team',
        'sale_team_id': false,
      });
      expect(s.teamid, isNull);
      expect(s.teamName, isNull);
    });
  });

  group('SalesTeam', () {
    test('fromJson maps id and name', () {
      final t = SalesTeam.fromJson({'id': 3, 'name': 'Direct Sales'});
      expect(t.id, 3);
      expect(t.name, 'Direct Sales');
      expect(t.toString(), 'Direct Sales');
    });

    test('fromJson defaults missing name to empty string', () {
      expect(SalesTeam.fromJson({'id': 4}).name, '');
    });
  });

  group('Tax', () {
    test('fromMap parses numeric amount to double', () {
      final tax = Tax.fromMap({
        'id': 1,
        'name': 'VAT 15%',
        'amount': 15,
        'type_tax_use': 'sale',
      });
      expect(tax.id, 1);
      expect(tax.name, 'VAT 15%');
      expect(tax.amount, 15.0);
      expect(tax.typeTaxUse, 'sale');
    });
  });

  group('LeadCrmModel', () {
    test('fromJson parses stage, dates and revenue', () {
      final m = LeadCrmModel.fromJson({
        'id': 10,
        'create_date': '2024-01-15 10:00:00',
        'stage_id': [2, 'Qualified'],
        'day_close': 5,
        'expected_revenue': 2500.5,
        'probability': 60,
      });
      expect(m.id, 10);
      expect(m.stageName, 'Qualified');
      expect(m.dayClose, 5.0);
      expect(m.expectedRevenue, 2500.5);
      expect(m.probability, 60.0);
      expect(m.createDate.year, 2024);
    });

    test('fromJson falls back to "Unknown" stage when stage_id missing', () {
      final m = LeadCrmModel.fromJson({
        'id': 11,
        'create_date': '2024-02-01 00:00:00',
        'day_close': 0,
      });
      expect(m.stageName, 'Unknown');
      expect(m.expectedRevenue, 0.0);
    });
  });

  group('OpportunityModel', () {
    test('fromJson parses stage and revenue metrics', () {
      final o = OpportunityModel.fromJson({
        'id': 20,
        'create_date': '2024-03-10 09:30:00',
        'stage_id': [4, 'Won'],
        'day_close': 12,
        'expected_revenue': 9000,
        'recurring_revenue': 300.75,
      });
      expect(o.id, 20);
      expect(o.stageName, 'Won');
      expect(o.dayClose, 12.0);
      expect(o.expectedRevenue, 9000.0);
      expect(o.recurringRevenue, 300.75);
    });
  });

  group('ForecastModel', () {
    test('fromJson maps stage, revenue and deadline', () {
      final f = ForecastModel.fromJson({
        'id': 30,
        'stage_id': [5, 'Proposition'],
        'expected_revenue': 4000,
        'prorated_revenue': 2000,
        'date_deadline': '2024-06-30',
      });
      expect(f.id, 30);
      expect(f.stageName, 'Proposition');
      expect(f.expectedRevenue, 4000.0);
      expect(f.proratedRevenue, 2000.0);
      expect(f.dateDeadline, '2024-06-30');
    });

    test('fromJson defaults stage to "Unknown" when stage_id not a list', () {
      final f = ForecastModel.fromJson({
        'id': 31,
        'expected_revenue': 0,
        'prorated_revenue': 0,
      });
      expect(f.stageName, 'Unknown');
      expect(f.dateDeadline, isNull);
    });
  });

  group('Simple relational models (id + name)', () {
    test('LeadTag.fromJson', () {
      final t = LeadTag.fromJson({'id': 1, 'name': 'Hot'});
      expect(t.id, 1);
      expect(t.name, 'Hot');
    });

    test('Country.fromJson', () {
      final c = Country.fromJson({'id': 91, 'name': 'India'});
      expect(c.id, 91);
      expect(c.name, 'India');
    });

    test('StateClass.fromJson', () {
      final s = StateClass.fromJson({'id': 10, 'name': 'Kerala'});
      expect(s.id, 10);
      expect(s.name, 'Kerala');
    });

    test('Campaign / Medium / Source fromJson', () {
      expect(Campaign.fromJson({'id': 1, 'name': 'Summer'}).name, 'Summer');
      expect(Medium.fromJson({'id': 2, 'name': 'Email'}).name, 'Email');
      expect(Source.fromJson({'id': 3, 'name': 'Website'}).name, 'Website');
    });
  });

  group('Category', () {
    test('fromJson parses parent_id relation', () {
      final cat = Category.fromJson({
        'id': 5,
        'name': 'Retailers',
        'parent_id': [2, 'Partners'],
      });
      expect(cat.id, 5);
      expect(cat.name, 'Retailers');
      expect(cat.parentId, 2);
      expect(cat.parentName, 'Partners');
    });

    test('fromJson handles missing parent_id', () {
      final cat = Category.fromJson({'id': 6, 'name': 'Vendors'});
      expect(cat.parentId, isNull);
      expect(cat.parentName, isNull);
    });

    test('getFormattedName builds hierarchical path', () {
      final child = Category.fromJson({
        'id': 5,
        'name': 'Retailers',
        'parent_id': [2, 'Partners'],
      });
      final root = Category.fromJson({'id': 2, 'name': 'Partners'});
      expect(child.getFormattedName(), 'Partners/Retailers');
      expect(root.getFormattedName(), 'Partners');
    });
  });

  group('FiscalPosition', () {
    test('fromJson and toString', () {
      final fp = FiscalPosition.fromJson({'id': 1, 'name': 'Domestic'});
      expect(fp.id, 1);
      expect(fp.name, 'Domestic');
      expect(fp.toString(), 'FiscalPosition(id: 1, name: Domestic)');
    });

    test('fromJsonList parses a list of records', () {
      final list = FiscalPosition.fromJsonList([
        {'id': 1, 'name': 'Domestic'},
        {'id': 2, 'name': 'Export'},
      ]);
      expect(list.length, 2);
      expect(list[1].name, 'Export');
    });
  });

  group('AccountJournal', () {
    test('fromJson and toString', () {
      final j = AccountJournal.fromJson({'id': 9, 'name': 'Customer Invoices'});
      expect(j.id, 9);
      expect(j.name, 'Customer Invoices');
      expect(j.toString(), 'AccountJournal(id: 9, name: Customer Invoices)');
    });
  });

  group('MailActivity', () {
    test('fromJson maps fields and user_id relation', () {
      final a = MailActivity.fromJson({
        'id': 40,
        'res_model': 'crm.lead',
        'res_id': 12,
        'summary': 'Call client',
        'date_deadline': '2024-05-01',
        'user_id': [5, 'Administrator'],
      });
      expect(a.id, 40);
      expect(a.resModel, 'crm.lead');
      expect(a.resId, 12);
      expect(a.summary, 'Call client');
      expect(a.dateDeadline, '2024-05-01');
      expect(a.userId, 5);
    });

    test('fromJson handles Odoo false summary and missing user_id', () {
      final a = MailActivity.fromJson({
        'id': 41,
        'res_model': 'res.partner',
        'res_id': 3,
        'summary': false,
        'date_deadline': '2024-05-02',
      });
      expect(a.summary, '');
      expect(a.userId, 0);
    });
  });

  group('LeadItem', () {
    LeadItem make(int id, String name) => LeadItem(
          id: id,
          contactname: 'Contact',
          name: name,
          createdon: '2024-01-01',
          email: 'x@y.com',
          salesperson: 'Rep',
          stage: 'New',
        );

    test('equality is based on id', () {
      expect(make(1, 'A'), equals(make(1, 'B')));
      expect(make(1, 'A'), isNot(equals(make(2, 'A'))));
    });

    test('toString returns the name', () {
      expect(make(1, 'Lead One').toString(), 'Lead One');
    });

    test('filter matches by suffix of the name (case-insensitive)', () {
      final item = make(1, 'Acme Corporation');
      expect(item.filter('corporation'), isTrue);
      expect(item.filter('acme'), isFalse);
    });
  });
}
