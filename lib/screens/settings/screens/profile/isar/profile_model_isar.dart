import 'package:isar_community/isar.dart';

part 'profile_model_isar.g.dart';

/// Represents a user's profile stored in Isar database.
///
/// Includes Odoo-specific fields (userId, partnerId), contact info,
/// address details, and optional base64-encoded profile image.
@collection
class ProfileModelIsar {
  Id id = Isar.autoIncrement;
  int? userId;
  int? partnerId;
  String? username;

  String? name;
  String? phone;
  String? email;
  String? function;

  String? street;
  String? city;
  int? stateId;
  String? stateName;
  int? countryId;
  String? countryName;
  String? mobile;
  String? website;
  String? address;
  String? imageBase64;

  ProfileModelIsar({
    this.userId,
    this.partnerId,
    this.username,
    this.name,
    this.phone,
    this.email,
    this.function,
    this.street,
    this.city,
    this.stateId,
    this.stateName,
    this.countryId,
    this.countryName,
    this.mobile,
    this.website,
    this.address,
    this.imageBase64,
  });

  /// Creates a [ProfileModelIsar] from a JSON map returned by Odoo.
  ///
  /// Optional [imageBase64] can be provided to store the profile image.
  factory ProfileModelIsar.fromJson(Map<String, dynamic> json,
      {String? imageBase64}) {
    return ProfileModelIsar(
      userId: json['id'] is int ? json['id'] : null,
      partnerId: json['partner_id'] != null && json['partner_id'] != false
          ? (json['partner_id'] is List
              ? json['partner_id'][0]
              : (json['partner_id'] is int ? json['partner_id'] : null))
          : null,
      username: _asString(json['login']),
      name: _asString(json['name']),
      phone: _asString(json['phone']),
      email: _asString(json['email']),
      function: _asString(json['function']),
      street: _asString(json['street']),
      city: _asString(json['city']),
      stateId: json['state_id'] != null &&
              json['state_id'] is List &&
              json['state_id'].length > 1
          ? json['state_id'][0]
          : null,
      stateName: json['state_id'] != null &&
              json['state_id'] is List &&
              json['state_id'].length > 1
          ? json['state_id'][1]
          : null,
      countryId: json['country_id'] != null &&
              json['country_id'] is List &&
              json['country_id'].length > 1
          ? json['country_id'][0]
          : null,
      countryName: json['country_id'] != null &&
              json['country_id'] is List &&
              json['country_id'].length > 1
          ? json['country_id'][1]
          : null,
      mobile: _asString(json['mobile']),
      website: _asString(json['website']),
      address: _asString(json['address']),
      imageBase64: imageBase64,
    );
  }

  /// Converts this object to JSON, suitable for sending back to Odoo.
  Map<String, dynamic> toJson() {
    return {
      'id': userId,
      'partner_id': partnerId != null ? [partnerId, ''] : false,
      'login': username ?? 'N/A',
      'name': name ?? 'N/A',
      'phone': phone ?? 'N/A',
      'email': email ?? 'N/A',
      'function': function ?? 'N/A',
      'street': street ?? 'N/A',
      'city': city ?? 'N/A',
      'state_id': stateId != null ? [stateId, stateName ?? ''] : false,
      'country_id': countryId != null ? [countryId, countryName ?? ''] : false,
      'mobile': mobile ?? 'N/A',
      'website': website ?? 'N/A',
      'address': address ?? 'N/A',
      'image_1920': imageBase64 ?? 'N/A',
    };
  }
}

/// Helper function to safely convert a dynamic value to a non-empty String.
///
/// Returns `null` if the value is `false`, `null`, or an empty string.
String? _asString(dynamic val) {
  if (val == false || val == null) return null;
  if (val is String && val.trim().isNotEmpty) return val.trim();
  return null;
}
