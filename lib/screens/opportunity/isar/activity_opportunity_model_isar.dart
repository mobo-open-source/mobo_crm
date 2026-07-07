import 'package:isar_community/isar.dart';

part 'activity_opportunity_model_isar.g.dart';

/// Represents an activity opportunity stored locally in Isar.
///
/// This model is used to cache activity opportunities for offline access
/// and fast retrieval. Each record has an auto-incremented [id] and a
/// [name] representing the opportunity title.
@collection
class ActivityOpportunityModelIsar {
  /// The unique identifier for this record in the Isar database.
  ///
  /// This is automatically incremented by Isar.
   Id id = Isar.autoIncrement;
  late String name;

   /// Default constructor for creating a new empty instance.
   ///
   /// The [name] field should be set manually or via [fromJson].
  ActivityOpportunityModelIsar();

   /// Creates an [ActivityOpportunityModelIsar] instance from a JSON map.
   ///
   /// [json] – The JSON map containing data for the activity opportunity.
   /// Expects a key `'name'`. If the key is missing or null, [name] defaults to an empty string.
   ///
   /// Returns a fully initialized [ActivityOpportunityModelIsar] instance.
  factory ActivityOpportunityModelIsar.fromJson(Map<String, dynamic> json) {
    return ActivityOpportunityModelIsar()
      ..name = json['name']?.toString() ?? '';
  }
}
