import 'package:nylo_framework/nylo_framework.dart';

/// Base API service for all Wasnaker actor apps.
/// Sets shared headers and provides auth token injection point.
abstract class WasnakerApiService extends NyApiService {
  WasnakerApiService({required super.decoders, super.baseOptions});

  Map<String, dynamic> get headers => {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        ...authHeaders,
      };

  /// Override in actor app services to inject bearer token.
  Map<String, dynamic> get authHeaders => {};
}
