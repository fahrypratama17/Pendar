import 'package:dio/dio.dart';
import 'package:pendar/config/constants.dart';
import 'package:pendar/services/network/auth_interceptor.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  factory DioClient() => _instance;
  
  late final Dio dio;
  
  DioClient._internal() {
    dio = Dio(BaseOptions(
      baseUrl: AppConstants.mlApiUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));
    
    dio.interceptors.addAll([
      AuthInterceptor(),
      LogInterceptor(
        requestHeader: true,
        requestBody: true,
        responseHeader: false,
        responseBody: true,
        error: true,
      ),
    ]);
  }
}
