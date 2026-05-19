import 'package:nylo_framework/nylo_framework.dart';

// CLIENT-SIDE only — UX gating.
// Server-side enforcement: Api_base::require_cap() in apps module.

/// PHP: staff_can($capability, $feature = null, $staff_id = '')
bool staffCan(String capability, [String? feature]) {
  final staff = Auth.data()?['staff'] as Map?;
  if (staff == null) return false;

  if ((staff['role'] as String?)?.toLowerCase() == 'administrator') return true;

  final rawCaps = staff['capabilities'];
  if (rawCaps == null || rawCaps is! Map) return false;

  if (feature == null) {
    for (final featureCaps in rawCaps.values) {
      if (featureCaps is List && featureCaps.contains(capability)) return true;
    }
    return false;
  }

  final featureCaps = rawCaps[feature];
  if (featureCaps == null || featureCaps is! List) return false;
  return featureCaps.contains(capability);
}

/// PHP: staff_cant($capability, $feature = null)
bool staffCant(String capability, [String? feature]) =>
    !staffCan(capability, feature);

/// PHP: is_admin($staffid = '')
bool isAdmin() {
  final role = Auth.data()?['staff']?['role'] as String?;
  return role?.toLowerCase() == 'administrator';
}
