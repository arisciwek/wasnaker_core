import 'package:nylo_framework/nylo_framework.dart';

/// Authenticated staff — mirrors tblstaff + apps module _staff_resource().
/// - [staffid]  = tblstaff.staffid (person)
/// - [userid]   = tblclients.userid (company/actor entity)
class AuthUser extends Model {
  final int staffid;
  final String firstname;
  final String lastname;
  final String email;
  final String? phonenumber;
  final String? profileImage;
  final String? position;
  final String clientType;
  final int? userid;
  final String? role;
  final String? companyName;
  final int active;
  final int isNotStaff;
  final int isEntityOwner;
  final int isBranchOwner;

  /// Capabilities per feature — e.g. {'inspections': ['view_own'], 'quotations': ['view_own','create']}
  final Map<String, List<String>> capabilities;

  AuthUser({
    required this.staffid,
    required this.firstname,
    required this.lastname,
    required this.email,
    this.phonenumber,
    this.profileImage,
    this.position,
    required this.clientType,
    this.userid,
    this.role,
    this.companyName,
    this.active = 0,
    this.isNotStaff = 1,
    this.isEntityOwner = 0,
    this.isBranchOwner = 0,
    this.capabilities = const {},
  });

  String get fullName => '$firstname $lastname';

  /// Returns true if user has [capability] on [feature].
  bool can(String feature, String capability) =>
      capabilities[feature]?.contains(capability) ?? false;

  /// Returns true if user can view [feature] (view OR view_own).
  bool canView(String feature) => can(feature, 'view') || can(feature, 'view_own');

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    final rawCaps = json['capabilities'] as Map<String, dynamic>? ?? {};
    final caps = rawCaps.map((k, v) =>
        MapEntry(k, List<String>.from(v as List)));

    return AuthUser(
      staffid: json['staffid'] is int
          ? json['staffid']
          : int.parse(json['staffid'].toString()),
      firstname: json['firstname'] ?? '',
      lastname: json['lastname'] ?? '',
      email: json['email'] ?? '',
      phonenumber: json['phonenumber'],
      profileImage: json['profile_image'],
      position: json['position'],
      clientType: json['client_type'] ?? '',
      userid: json['userid'] != null
          ? (json['userid'] is int ? json['userid'] : int.parse(json['userid'].toString()))
          : null,
      role: json['role'],
      companyName: json['company_name'],
      active: json['active'] ?? 0,
      isNotStaff: json['is_not_staff'] ?? 1,
      isEntityOwner: json['is_entity_owner'] ?? 0,
      isBranchOwner: json['is_branch_owner'] ?? 0,
      capabilities: caps,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'staffid': staffid,
        'firstname': firstname,
        'lastname': lastname,
        'email': email,
        'phonenumber': phonenumber,
        'profile_image': profileImage,
        'position': position,
        'client_type': clientType,
        'userid': userid,
        'role': role,
        'company_name': companyName,
        'active': active,
        'is_not_staff': isNotStaff,
        'is_entity_owner': isEntityOwner,
        'is_branch_owner': isBranchOwner,
        'capabilities': capabilities,
      };
}
