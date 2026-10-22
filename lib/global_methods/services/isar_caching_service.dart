import 'package:isar_community/isar.dart';
import 'package:mobo_crm/models/isar/lead_and_customer_models.dart';
import 'package:mobo_crm/models/isar/lead_tag_model_isar.dart';
import 'package:mobo_crm/screens/customers/isar/customer_form_isar_cache.dart';
import 'package:mobo_crm/screens/customers/isar/customer_list_data_isar.dart';
import 'package:mobo_crm/screens/lead/isar/lead_form_data_model.dart';
import 'package:mobo_crm/screens/lead/isar/lead_model_isar_graph.dart';
import 'package:mobo_crm/screens/lead/isar/leads_model_isar_cache.dart';
import 'package:mobo_crm/screens/opportunity/isar/activity_opportunity_model_isar.dart';
import 'package:mobo_crm/screens/opportunity/isar/opportunity_model_isar_graph.dart';
import 'package:mobo_crm/screens/opportunity/isar/opportunity_model_isar_cache.dart';
import 'package:mobo_crm/screens/quotation/isar/quotation_group_data_isar.dart';
import 'package:mobo_crm/screens/quotation/isar/quotation_model_isar.dart';
import 'package:mobo_crm/screens/quotation/isar/sale_order_models.dart';
import 'package:mobo_crm/screens/settings/screens/profile/isar/profile_model_isar.dart';
import 'package:path_provider/path_provider.dart';
import '../../screens/discuss/Isar/chat_model_isar.dart';
import '../../screens/myActivities/activities_main/isar/activity_model_isar.dart';
import '../../screens/myActivities/mail/Isar/mail_activity_model_isar.dart';

/// Centralized service for managing local persistent storage using Isar.
///
/// Responsibilities:
///   - Initialize Isar instance with all relevant schemas
///   - CRUD operations for offline caching of CRM entities:
///     - Profile, Activities, Mail Activities
///     - Leads (graph + cache + form data + tags)
///     - Opportunities (graph + cache + activities)
///     - Customers (list + form cache)
///     - Quotations / Sale Orders (header + lines + options)
///     - Discuss channels & chat messages
///     - Currency symbols
///
/// All write operations use transactions for atomicity.
/// Most read operations are lightweight and return cached data quickly.
///
/// Note: This is an offline-first cache layer. Data should be synced with Odoo
/// when online. Clearing methods are provided for logout / data reset scenarios.
class IsarService {
  static late Isar _isar;

  /// Initializes the Isar database instance.
  ///
  /// Must be called once early in app lifecycle (e.g. in main() before runApp).
  /// Opens Isar in the app documents directory with all required schemas.
  static Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      [
        ProfileModelIsarSchema,
        ActivityModelIsarSchema,
        OpportunityModelIsarGraphSchema,
        OpportunityModelIsarCacheSchema,
        ActivityOpportunityModelIsarSchema,
        LeadModelIsarGraphSchema,
        LeadsModelIsarCacheSchema,
        LeadFormDataModelSchema,
        LeadItemModelSchema,
        CustomerItemModelSchema,
        LeadTagModelIsarSchema,
        QuotationGroupDataIsarSchema,
        QuotationModelIsarSchema,
        CurrencySymbolIsarSchema,
        SaleOrderIsarCacheSchema,
        SaleOrderLineIsarCacheSchema,
        SaleOrderOptionIsarCacheSchema,
        CustomerListDataIsarSchema,
        CustomerFormIsarCacheSchema,
        MailActivityGroupIsarSchema,
        MailActivityIsarSchema,
        ChannelIsarSchema,
        ChatMessageIsarSchema,
      ],
      directory: dir.path,
    );
  }

  /// Saves or updates a list of chat channels.
  ///
  /// Upserts based on `serverId`.
  static Future<void> saveChannels(List<ChannelIsar> channels) async {
    await _isar.writeTxn(() async {
      for (var channel in channels) {
        final existing = await _isar.channelIsars
            .filter()
            .serverIdEqualTo(channel.serverId)
            .findFirst();
        if (existing != null) {
          channel.id = existing.id;
        }
        await _isar.channelIsars.put(channel);
      }
    });
  }

  /// Retrieves a single cached channel by its Odoo server ID.
  static Future<ChannelIsar?> getCachedChannel(int serverId) async {
    final data =
        await _isar.channelIsars.filter().serverIdEqualTo(serverId).findFirst();
    if (data != null) {
    } else {}
    return data;
  }

  /// Returns all cached channels.
  static Future<List<ChannelIsar>> getCachedChannels() async {
    final data = await _isar.channelIsars.where().findAll();
    return data;
  }

  /// Clears all cached channels.
  static Future<void> clearChannels() async {
    await _isar.writeTxn(() async {
      await _isar.channelIsars.clear();
    });
  }

  /// Saves or updates a batch of chat messages.
  ///
  /// Upserts based on `messageId`.
  /// Also ensures the related channel exists in cache.
  static Future<void> saveChatMessages(List<ChatMessageIsar> messages) async {
    await _isar.writeTxn(() async {
      for (var message in messages) {
        final existing = await _isar.chatMessageIsars
            .filter()
            .messageIdEqualTo(message.messageId)
            .findFirst();
        if (existing != null) {
          message.id = existing.id;
        }
        if (message.channel.value != null) {
          final channel = await _isar.channelIsars
              .filter()
              .serverIdEqualTo(message.channel.value!.serverId)
              .findFirst();
          if (channel == null) {
            await _isar.channelIsars.put(message.channel.value!);
          }
        }
        await _isar.chatMessageIsars.put(message);
        if (message.channel.value != null) {
          await message.channel.save();
        }
      }
    });
  }

  /// Retrieves the most recent cached message for a channel.
  static Future<ChatMessageIsar?> getCachedChatMessage(int channelId) async {
    final data = await _isar.chatMessageIsars
        .filter()
        .channelIdEqualTo(channelId)
        .sortByDateDesc()
        .findFirst();
    if (data != null) {
      await data.channel.load();
    } else {}
    return data;
  }

  /// Returns all cached chat messages (with channels loaded).
  static Future<List<ChatMessageIsar>> getCachedChatMessages() async {
    final data = await _isar.chatMessageIsars.where().findAll();
    await Future.wait(data.map((message) async {
      await message.channel.load();
      if (message.channel.value != null) {
      } else {}
    }));
    return data;
  }

  /// Clears all cached chat messages.
  static Future<void> clearChatMessages() async {
    await _isar.writeTxn(() async {
      await _isar.chatMessageIsars.clear();
    });
  }

  static Future<void> debugIsarContent() async {
    final messages = await _isar.chatMessageIsars.where().findAll();
    for (var message in messages) {
      await message.channel.load();
    }
  }

  /// Saves or updates the user profile.
  ///
  /// Upserts based on `userId`.
  static Future<void> saveProfile(ProfileModelIsar profile) async {
    await _isar.writeTxn(() async {
      final existing = await _isar.profileModelIsars
          .filter()
          .userIdEqualTo(profile.userId)
          .findFirst();

      if (existing != null) {
        profile.id = existing.id;
      }

      await _isar.profileModelIsars.put(profile);
    });
  }

  /// Retrieves the cached profile for a given user ID.
  static Future<ProfileModelIsar?> getCachedProfile(int userId) async {
    final data = await _isar.profileModelIsars
        .filter()
        .userIdEqualTo(userId)
        .findFirst();

    if (data != null) {
    } else {}

    return data;
  }

  /// Clears the cached profile.
  static Future<void> clearProfile() async {
    await _isar.writeTxn(() async {
      await _isar.profileModelIsars.clear();
    });
  }

  /// Replaces all cached activities with the provided list.
  static Future<void> saveActivities(List<ActivityModelIsar> activities) async {
    await _isar.writeTxn(() async {
      await _isar.activityModelIsars.clear();
      await _isar.activityModelIsars.putAll(activities);
    });
  }

  static Future<List<ActivityModelIsar>> getCachedActivities() async {
    final data = await _isar.activityModelIsars.where().findAll();
    return data;
  }

  static Future<void> clearActivities() async {
    await _isar.writeTxn(() async {
      await _isar.activityModelIsars.clear();
    });
  }

  static Future<void> saveMailActivityGroups(
      List<MailActivityGroupIsar> groups) async {
    await _isar.writeTxn(() async {
      await _isar.mailActivityGroupIsars.clear();
      await _isar.mailActivityGroupIsars.putAll(groups);
    });
  }

  static Future<List<MailActivityGroupIsar>>
      getCachedMailActivityGroups() async {
    final data = await _isar.mailActivityGroupIsars.where().findAll();
    return data;
  }

  static Future<void> clearMailActivityGroups() async {
    await _isar.writeTxn(() async {
      await _isar.mailActivityGroupIsars.clear();
    });
  }

  /// Replaces all mail activities for a given group.
  static Future<void> saveMailActivities(
      int groupId, List<MailActivityIsar> activities) async {
    await _isar.writeTxn(() async {
      await _isar.mailActivityIsars
          .filter()
          .groupIdEqualTo(groupId)
          .deleteAll();
      for (var activity in activities) {
        activity.groupId = groupId;
        await _isar.mailActivityIsars.put(activity);
      }
    });
  }

  static Future<List<MailActivityIsar>> getCachedMailActivities(
      int groupId) async {
    final data = await _isar.mailActivityIsars
        .filter()
        .groupIdEqualTo(groupId)
        .findAll();
    return data;
  }

  static Future<void> clearMailActivities(int groupId) async {
    await _isar.writeTxn(() async {
      await _isar.mailActivityIsars
          .filter()
          .groupIdEqualTo(groupId)
          .deleteAll();
    });
  }

  static Future<void> clearAllMailActivities() async {
    await _isar.writeTxn(() async {
      await _isar.mailActivityIsars.clear();
    });
  }

  static Future<void> saveOpportunitiesGraph(
      List<OpportunityModelIsarGraph> items) async {
    await _isar.writeTxn(() async {
      await _isar.opportunityModelIsarGraphs.clear();
      await _isar.opportunityModelIsarGraphs.putAll(items);
    });
  }

  static Future<List<OpportunityModelIsarGraph>>
      getCachedOpportunitiesGraph() async {
    final data = await _isar.opportunityModelIsarGraphs.where().findAll();
    return data;
  }

  static Future<void> clearOpportunities() async {
    await _isar.writeTxn(() async {
      await _isar.opportunityModelIsarGraphs.clear();
    });
  }

  static Future<void> saveLeadsGraph(List<LeadModelIsarGraph> items) async {
    await _isar.writeTxn(() async {
      await _isar.leadModelIsarGraphs.clear();
      await _isar.leadModelIsarGraphs.putAll(items);
    });
  }

  static Future<List<LeadModelIsarGraph>> getCachedLeadsGraph() async {
    final data = await _isar.leadModelIsarGraphs.where().findAll();
    return data;
  }

  static Future<void> clearLeads() async {
    await _isar.writeTxn(() async {
      await _isar.leadModelIsarGraphs.clear();
    });
  }

  static Future<void> saveOpportunitiesCache(
      List<OpportunityModelIsarCache> items) async {
    await _isar.writeTxn(() async {
      await _isar.opportunityModelIsarCaches.clear();
      await _isar.opportunityModelIsarCaches.putAll(items);
    });
  }

  static Future<List<OpportunityModelIsarCache>>
      getCachedOpportunitiesCache() async {
    final data = await _isar.opportunityModelIsarCaches.where().findAll();
    return data;
  }

  static Future<void> clearOpportunitiesCache() async {
    await _isar.writeTxn(() async {
      await _isar.opportunityModelIsarCaches.clear();
    });
  }

  static Future<void> saveLeadsCache(List<LeadsModelIsarCache> items) async {
    await _isar.writeTxn(() async {
      await _isar.leadsModelIsarCaches.clear();
      await _isar.leadsModelIsarCaches.putAll(items);
    });
  }

  static Future<List<LeadsModelIsarCache>> getLeadsCache() async {
    final data = await _isar.leadsModelIsarCaches.where().findAll();
    return data;
  }

  static Future<void> clearLeadsCache() async {
    await _isar.writeTxn(() async {
      await _isar.leadsModelIsarCaches.clear();
    });
  }

  static Future<void> saveActivityNames(List<String> activityNames) async {
    final activityObjects = activityNames
        .map((name) => ActivityOpportunityModelIsar()..name = name)
        .toList();

    await _isar.writeTxn(() async {
      await _isar.activityOpportunityModelIsars.clear();
      await _isar.activityOpportunityModelIsars.putAll(activityObjects);
    });
  }

  static Future<List<String>> getActivityNames() async {
    final data = await _isar.activityOpportunityModelIsars.where().findAll();
    final names = data.map((e) => e.name).toList();
    return names;
  }

  static Future<void> clearActivityNames() async {
    await _isar.writeTxn(() async {
      await _isar.activityOpportunityModelIsars.clear();
    });
  }

  /// Saves or updates a single lead form draft.
  ///
  /// Upserts based on `leadId`.
  Future<void> saveLeadFormData(LeadFormDataModel leadForm) async {
    await _isar.writeTxn(() async {
      final existing = await _isar.leadFormDataModels
          .filter()
          .leadIdEqualTo(leadForm.leadId)
          .findFirst();

      if (existing != null) {
        leadForm.id = existing.id;
      }

      await _isar.leadFormDataModels.put(leadForm);
    });
  }

  static Future<LeadFormDataModel?> getLeadFormData(int leadId) async {
    final data = await _isar.leadFormDataModels
        .filter()
        .leadIdEqualTo(leadId)
        .findFirst();

    if (data != null) {
    } else {}

    return data;
  }

  static Future<void> clearLeadFormData() async {
    await _isar.writeTxn(() async {
      await _isar.leadFormDataModels.clear();
    });
  }

  static Future<void> saveLeads(List<LeadItemModel> leads) async {
    await _isar.writeTxn(() async {
      await _isar.leadItemModels.clear();
      await _isar.leadItemModels.putAll(leads);
    });
  }

  static Future<void> saveCustomers(List<CustomerItemModel> customers) async {
    await _isar.writeTxn(() async {
      await _isar.customerItemModels.clear();
      await _isar.customerItemModels.putAll(customers);
    });
  }

  static Future<List<LeadItemModel>> getLeads() async {
    return await _isar.leadItemModels.where().findAll();
  }

  static Future<List<CustomerItemModel>> getCustomers() async {
    return await _isar.customerItemModels.where().findAll();
  }

  static Future<void> clearInitLeads() async {
    await _isar.writeTxn(() async {
      await _isar.leadItemModels.clear();
    });
  }

  static Future<void> clearCustomers() async {
    await _isar.writeTxn(() async {
      await _isar.customerItemModels.clear();
    });
  }

  static Future<void> saveLeadTags(List<LeadTagModelIsar> tags) async {
    await _isar.writeTxn(() async {
      await _isar.leadTagModelIsars.clear();
      await _isar.leadTagModelIsars.putAll(tags);
    });
  }

  static Future<List<LeadTagModelIsar>> getCachedLeadTags() async {
    final data = await _isar.leadTagModelIsars.where().findAll();
    return data;
  }

  static Future<List<LeadTagModelIsar>> getCachedLeadTagsById(
      List<int> serverIds) async {
    final results = await _isar.leadTagModelIsars
        .filter()
        .anyOf(serverIds, (q, id) => q.serverIdEqualTo(id))
        .findAll();
    return results;
  }

  static Future<void> clearLeadTags() async {
    await _isar.writeTxn(() async {
      await _isar.leadTagModelIsars.clear();
    });
  }

  static Future<void> saveQuoteGroupData(
      List<QuotationGroupDataIsar> items) async {
    await _isar.writeTxn(() async {
      await _isar.quotationGroupDataIsars.clear();
      await _isar.quotationGroupDataIsars.putAll(items);
    });
  }

  static Future<List<QuotationGroupDataIsar>> getCachedQuoteGroupData() async {
    final data = await _isar.quotationGroupDataIsars.where().findAll();
    return data;
  }

  static Future<void> clearQuoteGroupData() async {
    await _isar.writeTxn(() async {
      await _isar.quotationGroupDataIsars.clear();
    });
  }

  static Future<void> saveQuotations(List<QuotationModelIsar> items) async {
    await _isar.writeTxn(() async {
      await _isar.quotationModelIsars.clear();
      await _isar.quotationModelIsars.putAll(items);
    });
  }

  static Future<List<QuotationModelIsar>> getCachedQuotations() async {
    final data = await _isar.quotationModelIsars.where().findAll();
    return data;
  }

  static Future<void> clearQuotations() async {
    await _isar.writeTxn(() async {
      await _isar.quotationModelIsars.clear();
    });
  }

  static Future<void> saveCurrencySymbols(List<CurrencySymbolIsar> list) async {
    await _isar.writeTxn(() async {
      await _isar.currencySymbolIsars.clear();
      await _isar.currencySymbolIsars.putAll(list);
    });
  }

  static Future<Map<int, String>> getCurrencySymbols() async {
    final symbols = await _isar.currencySymbolIsars.where().findAll();
    return {
      for (var c in symbols)
        if (c.currencyId != null && c.symbol != null) c.currencyId!: c.symbol!
    };
  }

  static Future<void> saveSaleOrder(SaleOrderIsarCache saleOrder) async {
    await _isar.writeTxn(() async {
      final existing = await _isar.saleOrderIsarCaches
          .filter()
          .serverIdEqualTo(saleOrder.serverId)
          .findFirst();

      if (existing != null) {
        saleOrder.id = existing.id;
      }

      await _isar.saleOrderIsarCaches.put(saleOrder);
    });
  }

  static Future<SaleOrderIsarCache?> getSaleOrder(int saleOrderId) async {
    final data = await _isar.saleOrderIsarCaches
        .filter()
        .serverIdEqualTo(saleOrderId)
        .findFirst();

    if (data != null) {
    } else {}

    return data;
  }

  static Future<List<SaleOrderIsarCache>> getAllSaleOrders() async {
    final data = await _isar.saleOrderIsarCaches.where().findAll();
    return data;
  }

  static Future<void> clearSaleOrders() async {
    await _isar.writeTxn(() async {
      await _isar.saleOrderIsarCaches.clear();
    });
  }

  static Future<void> saveSaleOrderLines(
      int saleOrderId, List<SaleOrderLineIsarCache> orderLines) async {
    await _isar.writeTxn(() async {
      await _isar.saleOrderLineIsarCaches
          .filter()
          .saleOrderIdEqualTo(saleOrderId)
          .deleteAll();
      await _isar.saleOrderLineIsarCaches.putAll(orderLines);
    });
  }

  static Future<List<SaleOrderLineIsarCache>> getSaleOrderLines(
      int saleOrderId) async {
    final data = await _isar.saleOrderLineIsarCaches
        .filter()
        .saleOrderIdEqualTo(saleOrderId)
        .findAll();
    return data;
  }

  static Future<List<SaleOrderLineIsarCache>> getAllSaleOrderLines() async {
    final data = await _isar.saleOrderLineIsarCaches.where().findAll();
    return data;
  }

  static Future<void> clearSaleOrderLines(int saleOrderId) async {
    await _isar.writeTxn(() async {
      await _isar.saleOrderLineIsarCaches
          .filter()
          .saleOrderIdEqualTo(saleOrderId)
          .deleteAll();
    });
  }

  static Future<void> clearAllSaleOrderLines() async {
    await _isar.writeTxn(() async {
      await _isar.saleOrderLineIsarCaches.clear();
    });
  }

  static Future<void> saveSaleOrderOptions(
      int saleOrderId, List<SaleOrderOptionIsarCache> options) async {
    await _isar.writeTxn(() async {
      await _isar.saleOrderOptionIsarCaches
          .filter()
          .saleOrderIdEqualTo(saleOrderId)
          .deleteAll();
      await _isar.saleOrderOptionIsarCaches.putAll(options);
    });
  }

  static Future<List<SaleOrderOptionIsarCache>> getSaleOrderOptions(
      int saleOrderId) async {
    final data = await _isar.saleOrderOptionIsarCaches
        .filter()
        .saleOrderIdEqualTo(saleOrderId)
        .findAll();
    return data;
  }

  static Future<List<SaleOrderOptionIsarCache>> getAllSaleOrderOptions() async {
    final data = await _isar.saleOrderOptionIsarCaches.where().findAll();
    return data;
  }

  static Future<void> clearSaleOrderOptions(int saleOrderId) async {
    await _isar.writeTxn(() async {
      await _isar.saleOrderOptionIsarCaches
          .filter()
          .saleOrderIdEqualTo(saleOrderId)
          .deleteAll();
    });
  }

  static Future<void> clearAllSaleOrderOptions() async {
    await _isar.writeTxn(() async {
      await _isar.saleOrderOptionIsarCaches.clear();
    });
  }

  /// Saves a complete sale order (header + lines + options) atomically.
  static Future<void> saveSaleOrderComplete({
    required SaleOrderIsarCache saleOrder,
    required List<SaleOrderLineIsarCache> orderLines,
    required List<SaleOrderOptionIsarCache> options,
  }) async {
    final saleOrderId = saleOrder.serverId!;

    await _isar.writeTxn(() async {
      final existing = await _isar.saleOrderIsarCaches
          .filter()
          .serverIdEqualTo(saleOrderId)
          .findFirst();

      if (existing != null) {
        saleOrder.id = existing.id;
      }
      await _isar.saleOrderIsarCaches.put(saleOrder);

      await _isar.saleOrderLineIsarCaches
          .filter()
          .saleOrderIdEqualTo(saleOrderId)
          .deleteAll();
      await _isar.saleOrderLineIsarCaches.putAll(orderLines);

      await _isar.saleOrderOptionIsarCaches
          .filter()
          .saleOrderIdEqualTo(saleOrderId)
          .deleteAll();
      await _isar.saleOrderOptionIsarCaches.putAll(options);
    });
  }

  /// Retrieves a complete sale order (header + lines + options).
  ///
  /// Returns null if header is not found.
  static Future<Map<String, dynamic>?> getSaleOrderComplete(
      int saleOrderId) async {
    final saleOrder = await getSaleOrder(saleOrderId);
    if (saleOrder == null) {
      return null;
    }

    final orderLines = await getSaleOrderLines(saleOrderId);
    final options = await getSaleOrderOptions(saleOrderId);

    return {
      'saleOrder': saleOrder,
      'orderLines': orderLines,
      'options': options,
    };
  }

  static Future<void> clearSaleOrderComplete(int saleOrderId) async {
    await _isar.writeTxn(() async {
      await _isar.saleOrderIsarCaches
          .filter()
          .serverIdEqualTo(saleOrderId)
          .deleteAll();
      await _isar.saleOrderLineIsarCaches
          .filter()
          .saleOrderIdEqualTo(saleOrderId)
          .deleteAll();
      await _isar.saleOrderOptionIsarCaches
          .filter()
          .saleOrderIdEqualTo(saleOrderId)
          .deleteAll();
    });
  }

  static Future<void> clearAllSaleOrderData() async {
    await _isar.writeTxn(() async {
      await _isar.saleOrderIsarCaches.clear();
      await _isar.saleOrderLineIsarCaches.clear();
      await _isar.saleOrderOptionIsarCaches.clear();
    });
  }

  static Future<void> saveCustomersList(
      List<CustomerListDataIsar> items) async {
    await _isar.writeTxn(() async {
      for (final item in items) {
        final existing = await _isar.customerListDataIsars
            .filter()
            .serverIdEqualTo(item.serverId)
            .findFirst();

        if (existing != null) {
          item.id = existing.id;
        }
        await _isar.customerListDataIsars.put(item);
      }
    });
  }

  static Future<List<CustomerListDataIsar>> getCustomersList() async {
    final data = await _isar.customerListDataIsars.where().findAll();
    return data;
  }

  static Future<void> clearCustomersList() async {
    await _isar.writeTxn(() async {
      await _isar.customerListDataIsars.clear();
    });
  }

  static Future<void> saveCustomerFormData(
      CustomerFormIsarCache customer) async {
    await _isar.writeTxn(() async {
      final existing = await _isar.customerFormIsarCaches
          .filter()
          .serverIdEqualTo(customer.serverId)
          .findFirst();

      if (existing != null) {
        customer.id = existing.id;
      }

      await _isar.customerFormIsarCaches.put(customer);
    });
  }

  static Future<CustomerFormIsarCache?> getCustomerData(int customerId) async {
    final data = await _isar.customerFormIsarCaches
        .filter()
        .serverIdEqualTo(customerId)
        .findFirst();

    if (data != null) {
    } else {}

    return data;
  }

  static Future<void> clearCustomerData() async {
    await _isar.writeTxn(() async {
      await _isar.customerFormIsarCaches.clear();
    });
  }

  /// Clears **all** cached data across every schema.
  ///
  /// Use on logout, account switch, or when forcing full resync.
  static Future<void> clearAllData() async {
    await _isar.writeTxn(() async {
      await _isar.profileModelIsars.clear();
      await _isar.activityModelIsars.clear();
      await _isar.opportunityModelIsarGraphs.clear();
      await _isar.opportunityModelIsarCaches.clear();
      await _isar.activityOpportunityModelIsars.clear();
      await _isar.leadModelIsarGraphs.clear();
      await _isar.leadsModelIsarCaches.clear();
      await _isar.leadFormDataModels.clear();
      await _isar.leadItemModels.clear();
      await _isar.customerItemModels.clear();
      await _isar.leadTagModelIsars.clear();
      await _isar.quotationGroupDataIsars.clear();
      await _isar.quotationModelIsars.clear();
      await _isar.currencySymbolIsars.clear();
      await _isar.saleOrderIsarCaches.clear();
      await _isar.saleOrderLineIsarCaches.clear();
      await _isar.saleOrderOptionIsarCaches.clear();
      await _isar.customerListDataIsars.clear();
      await _isar.customerFormIsarCaches.clear();
      await _isar.mailActivityGroupIsars.clear();
      await _isar.mailActivityIsars.clear();
      await _isar.channelIsars.clear();
      await _isar.chatMessageIsars.clear();
    });
  }
}
