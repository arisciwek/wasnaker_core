import 'package:nylo_framework/nylo_framework.dart';


/// PHP: get_option($name)
Future<T?> getOption<T>(String name) => NyStorage.read<T>(name);

/// PHP: update_option($name, $value)
Future<void> updateOption(String name, dynamic value) =>
    NyStorage.save(name, value);

/// PHP: add_option($name, $value)
Future<void> addOption(String name, dynamic value) =>
    NyStorage.save(name, value);
