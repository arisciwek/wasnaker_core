import 'package:flutter_modular/flutter_modular.dart';

/// Base class for all Wasnaker feature modules.
/// Each module repo extends this and registers its own routes + binds.
abstract class WasnakerModule extends Module {
  /// Module route prefix, e.g. '/landing', '/inspections'.
  String get routePrefix;
}
