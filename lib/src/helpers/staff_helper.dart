import 'package:nylo_framework/nylo_framework.dart';


/// PHP: get_staff_full_name($userid = '')
String getStaffFullName() {
  final staff = Auth.data()?['staff'] as Map?;
  if (staff == null) return '';
  return '${staff['firstname'] ?? ''} ${staff['lastname'] ?? ''}'.trim();
}

/// PHP: staff_profile_image_url($staff_id)
String? staffProfileImageUrl() =>
    Auth.data()?['staff']?['profile_image'] as String?;
