import 'package:nylo_framework/nylo_framework.dart';

/// Authenticated staff — mirrors tblstaff fields from Perfex.
/// - [staffid]       = tblstaff.staffid (person)
/// - [userid]        = tblclients.userid (company/actor entity)
/// - [isEntityOwner] = is the company owner/admin
/// - [isBranchOwner] = manages a branch
class AuthUser extends Model {
  final int staffid;
  final String firstname;
  final String lastname;
  final String email;
  final String? phonenumber;
  final String? profileImage;
  final String? position;

  /// Actor type: 'surveyor' | 'customer' | 'association' | 'institution'
  final String clientType;

  /// tblclients.userid — the company/actor entity ID
  final int userid;

  final String? role;
  final String? companyName;
  final int active;
  final int isNotStaff;
  final int isEntityOwner;
  final int isBranchOwner;

  AuthUser({
    required this.staffid,
    required this.firstname,
    required this.lastname,
    required this.email,
    this.phonenumber,
    this.profileImage,
    this.position,
    required this.clientType,
    required this.userid,
    this.role,
    this.companyName,
    this.active = 0,
    this.isNotStaff = 1,
    this.isEntityOwner = 0,
    this.isBranchOwner = 0,
  });

  String get fullName => '$firstname $lastname';

  factory AuthUser.fromJson(Map<String, dynamic> json) => AuthUser(
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
        userid: json['userid'] is int
            ? json['userid']
            : int.parse(json['userid'].toString()),
        role: json['role'],
        companyName: json['company_name'],
        active: json['active'] ?? 0,
        isNotStaff: json['is_not_staff'] ?? 1,
        isEntityOwner: json['is_entity_owner'] ?? 0,
        isBranchOwner: json['is_branch_owner'] ?? 0,
      );

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
      };
}
