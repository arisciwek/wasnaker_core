import 'package:nylo_framework/nylo_framework.dart';

/// Base API service for all Wasnaker actor apps.
/// - baseUrl reads API_BASE_URL from .env
/// - Subclasses inject X-Api-Key via baseOptions and Bearer token via interceptor
abstract class WasnakerApiService extends NyApiService {
  WasnakerApiService({
    required super.decoders,
    super.baseOptions,
    super.useNetworkLogger,
  });

  @override
  String get baseUrl => getEnv('API_BASE_URL');
}
