import 'package:dio/dio.dart';

/// Interceptor to log all requests and responses
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final headers = options.headers.toString();
    final queryParameters = options.queryParameters.toString();
    final data = options.data.toString();

    print('┌───────────────────────────────────────────────────────');
    print('│ REQUEST: ${options.method} ${options.uri}');
    print('│ Headers: $headers');
    if (options.queryParameters.isNotEmpty) {
      print('│ Query Parameters: $queryParameters');
    }
    if (options.data != null) {
      print('│ Body: $data');
    }
    print('└───────────────────────────────────────────────────────');

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final statusCode = response.statusCode;
    final data = response.data.toString();

    print('┌───────────────────────────────────────────────────────');
    print('│ RESPONSE: $statusCode ${response.requestOptions.uri}');
    print('│ Body: $data');
    print('└───────────────────────────────────────────────────────');

    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final statusCode = err.response?.statusCode;
    final errorMessage = err.message;
    final errorData = err.response?.data.toString();

    print('┌───────────────────────────────────────────────────────');
    print('│ ERROR: $statusCode ${err.requestOptions.uri}');
    print('│ Message: $errorMessage');
    if (errorData != null) {
      print('│ Data: $errorData');
    }
    print('└───────────────────────────────────────────────────────');

    super.onError(err, handler);
  }
}
