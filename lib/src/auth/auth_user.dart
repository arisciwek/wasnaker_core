import 'package:nylo_framework/nylo_framework.dart';

/// Authenticated user — mirrors tblstaff / tblcustomers fields from Perfex.
class AuthUser extends Model {
  final int id;
  final String firstname;
  final String lastname;
  final String email;
  final String? phone;
  final String? profileImage;

  /// Actor type: 'surveyor' | 'customer' | 'association' | 'institution'
  final String clientType;

  /// Perfex clientid for this actor record.
  final int clientId;

  AuthUser({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.email,
    this.phone,
    this.profileImage,
    required this.clientType,
    required this.clientId,
  });

  String get fullName => '$firstname $lastname';

  factory AuthUser.fromJson(Map<String, dynamic> json) => AuthUser(
        id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
        firstname: json['firstname'] ?? '',
        lastname: json['lastname'] ?? '',
        email: json['email'] ?? '',
        phone: json['phone'],
        profileImage: json['profile_image'],
        clientType: json['client_type'] ?? '',
        clientId: json['client_id'] is int
            ? json['client_id']
            : int.parse(json['client_id'].toString()),
      );

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'firstname': firstname,
        'lastname': lastname,
        'email': email,
        'phone': phone,
        'profile_image': profileImage,
        'client_type': clientType,
        'client_id': clientId,
      };
}
