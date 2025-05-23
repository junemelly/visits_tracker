import 'package:dio/dio.dart';
import 'api_constants.dart';

class NetworkClient {
  late final Dio _dio;

  NetworkClient() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      headers: {
        'apikey': ApiConstants.apiKey,
        'Authorization': 'Bearer ${ApiConstants.apiKey}',
        'Content-Type': 'application/json',
      },
    ));
  }

  Dio get dio => _dio;
}