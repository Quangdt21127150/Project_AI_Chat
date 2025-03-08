import 'package:dio/dio.dart';
import 'package:project_ai_chat/utils/dio/interceptor.dart/auth_interceptor_kb.dart';

class DioKnowledgeBase {
  static final DioKnowledgeBase _instance = DioKnowledgeBase._internal();
  late Dio dio;

  factory DioKnowledgeBase() {
    return _instance;
  }

  DioKnowledgeBase._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://knowledge-api.jarvis.cx/kb-core/v1',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Thêm interceptor để log request/response
    dio.interceptors.add(LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      error: true,
    ));

    dio.interceptors.add(AuthInterceptorKnowledgeBase(dio: dio));
  }
}
