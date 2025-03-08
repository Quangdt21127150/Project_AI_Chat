import 'dart:developer';
import 'package:project_ai_chat/models/response/subscription_response.dart';
import 'package:project_ai_chat/models/response/token_usage_response.dart';
import 'package:project_ai_chat/utils/dio/dio_client.dart';
import 'package:project_ai_chat/utils/dio/dio_knowledge_base.dart';
import 'package:project_ai_chat/utils/exceptions/chat_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../models/response/api_response.dart';
import 'package:dio/dio.dart';

class AuthService {
  final dio = DioClient().dio;
  final dioKB = DioKnowledgeBase().dio;

  Future<ApiResponse> register(User user) async {
    try {
      final response = await dio.post(
        '/auth/sign-up',
        data: user.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse(
          success: true,
          message: 'Đăng ký thành công',
          data: response.data,
          statusCode: response.statusCode ?? 200,
        );
      } else {
        log('data: ${response.data}');
        return ApiResponse(
          success: false,
          message: 'Đăng ký thất bại: ${response.data}',
          statusCode: response.statusCode ?? 400,
        );
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final errorData = e.response!.data;
        String errorMessage = 'Đăng ký thất bại';

        // Check for custom error messages in the response data
        if (errorData['details'] != null && errorData['details'].isNotEmpty) {
          // Collect all issues in `details` into a single message
          log('errorData: ${errorData['details']}');
          List<String> issues = (errorData['details'] as List<dynamic>)
              .map<String>((detail) => detail['issue'] ?? 'Unknown issue')
              .toList();
          errorMessage = issues.join(', ');
        }

        return ApiResponse(
          success: false,
          message: errorMessage,
          statusCode: e.response!.statusCode ?? 400,
        );
      }
      return ApiResponse(
        success: false,
        message: 'Lỗi kết nối: $e',
        statusCode: 500,
      );
    }
  }

  Future<ApiResponse> login(String email, String password) async {
    try {
      final response = await dio.post(
        '/auth/sign-in',
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        return ApiResponse(
          success: true,
          data: response.data,
          message: 'Đăng nhập thành công',
          statusCode: response.statusCode ?? 200,
        );
      } else {
        return ApiResponse(
          success: false,
          message: 'Đăng nhập thất bại',
          statusCode: response.statusCode ?? 400,
        );
      }
    } on DioException catch (e) {
      String errorMessage = 'Đăng nhập thất bại';
      if (e.response != null) {
        final errorData = e.response!.data;

        // Check for custom error messages in the response data
        if (errorData['details'] != null && errorData['details'].isNotEmpty) {
          // Collect all issues in `details` into a single message
          log('errorData: ${errorData['details']}');
          List<String> issues = (errorData['details'] as List<dynamic>)
              .map<String>((detail) => detail['issue'] ?? 'Unknown issue')
              .toList();
          errorMessage = issues.join(', ');
        }

        return ApiResponse(
          success: false,
          message: errorMessage,
          statusCode: e.response!.statusCode ?? 400,
        );
      }

      return ApiResponse(
        success: false,
        message: errorMessage,
        statusCode: e.response?.statusCode ?? 500,
      );
    }
  }

  Future<ApiResponse> getCurrentUser(String accessToken) async {
    try {
      final response = await dio.get('/auth/me');
      if (response.statusCode == 200) {
        return ApiResponse(
          success: true,
          data: response.data,
          message: 'Lấy thông tin user thành công',
          statusCode: response.statusCode ?? 200,
        );
      } else {
        return ApiResponse(
          success: false,
          message: 'Lấy thông tin user thất bại',
          statusCode: response.statusCode ?? 400,
        );
      }
    } on DioException catch (e) {
      String errorMessage = 'Unauthorized';
      if (e.response != null) {
        final errorData = e.response!.data;

        // Check for custom error messages in the response data
        if (errorData['details'] != null && errorData['details'].isNotEmpty) {
          // Collect all issues in `details` into a single message
          log('errorData: ${errorData['details']}');
          List<String> issues = (errorData['details'] as List<dynamic>)
              .map<String>((detail) => detail['issue'] ?? 'Unknown issue')
              .toList();
          errorMessage = issues.join(', ');
        }

        return ApiResponse(
          success: false,
          message: errorMessage,
          statusCode: e.response!.statusCode ?? 400,
        );
      }

      return ApiResponse(
        success: false,
        message: errorMessage,
        statusCode: e.response?.statusCode ?? 500,
      );
    }
  }

  Future<ApiResponse> logout() async {
    try {
      final response = await dio.get('/auth/sign-out');
      if (response.statusCode == 200) {
        return ApiResponse(
          success: true,
          data: response.data,
          message: 'Logout thành công',
          statusCode: response.statusCode ?? 200,
        );
      } else {
        return ApiResponse(
          success: false,
          message: 'Logout thất bại',
          statusCode: response.statusCode ?? 400,
        );
      }
    } on DioException catch (e) {
      String errorMessage = 'Unauthorized';
      if (e.response != null) {
        final errorData = e.response!.data;

        // Check for custom error messages in the response data
        if (errorData['details'] != null && errorData['details'].isNotEmpty) {
          // Collect all issues in `details` into a single message
          log('errorData: ${errorData['details']}');
          List<String> issues = (errorData['details'] as List<dynamic>)
              .map<String>((detail) => detail['issue'] ?? 'Unknown issue')
              .toList();
          errorMessage = issues.join(', ');
        }
      }

      return ApiResponse(
        success: false,
        message: errorMessage,
        statusCode: e.response?.statusCode ?? 500,
      );
    }
  }

  Future<SubscriptionResponse> fetchSubscriptionDetails() async {
    try {
      final response = await dio.get('/subscriptions/me');
      print('✅ RESPONSE DATA SUBSCRIPTION: ${response.data}');
      if (response.statusCode == 200) {
        return SubscriptionResponse.fromJson(response.data);
      } else {
        throw ChatException(
          message: 'Lỗi không xác định từ server',
          statusCode: response.statusCode ?? 500,
        );
      }
    } on DioException catch (e) {
      throw ChatException(
        message: e.response?.data?['message'] ??
            e.message ??
            'Lỗi kết nối tới server',
        statusCode: e.response?.statusCode ?? 500,
      );
    }
  }

  Future<TokenUsageResponse> fetchTokenUsage() async {
    try {
      final response = await dio.get(
        '/tokens/usage',
      );

      if (response.statusCode == 200) {
        return TokenUsageResponse.fromJson(response.data);
      } else {
        throw ChatException(
          message: 'Lỗi không xác định từ server',
          statusCode: response.statusCode ?? 500,
        );
      }
    } on DioException catch (e) {
      throw ChatException(
        message: e.response?.data?['message'] ??
            e.message ??
            'Lỗi kết nối tới server',
        statusCode: e.response?.statusCode ?? 500,
      );
    }
  }

  Future<ApiResponse> loginFromExternalClient(String accessToken) async {
    try {
      final response = await dioKB.post(
        '/auth/external-sign-in',
        data: {
          'token': accessToken,
        },
      );

      if (response.statusCode == 200) {
        return ApiResponse(
          success: true,
          data: response.data,
          message: 'Đăng nhập knowledge base server thành công',
          statusCode: response.statusCode ?? 200,
        );
      } else {
        return ApiResponse(
          success: false,
          message: 'Đăng nhập knowledge base server thất bại',
          statusCode: response.statusCode ?? 400,
        );
      }
    } on DioException catch (e) {
      String errorMessage = 'Đăng nhập knowledge base server thất bại';
      if (e.response != null) {
        final errorData = e.response!.data;

        // Check for custom error messages in the response data
        if (errorData['details'] != null && errorData['details'].isNotEmpty) {
          // Collect all issues in `details` into a single message
          log('errorData: ${errorData['details']}');
          List<String> issues = (errorData['details'] as List<dynamic>)
              .map<String>((detail) => detail['issue'] ?? 'Unknown issue')
              .toList();
          errorMessage = issues.join(', ');
        }

        return ApiResponse(
          success: false,
          message: errorMessage,
          statusCode: e.response!.statusCode ?? 400,
        );
      }

      return ApiResponse(
        success: false,
        message: errorMessage,
        statusCode: e.response?.statusCode ?? 500,
      );
    }
  }
}
