import 'package:nylo_framework/nylo_framework.dart';


/// PHP: is_staff_logged_in()
bool isStaffLoggedIn() => Auth.data() != null;

/// PHP: get_staff_user_id()
int? getStaffUserId() {
  final id = Auth.data()?['staff']?['staffid'];
  if (id == null) return null;
  return id is int ? id : int.tryParse(id.toString());
}

/// PHP: _l($line)
/// Prefer using .tr() extension directly in widgets.
String l(String key) => key.tr();
