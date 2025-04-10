import 'package:dio/dio.dart';
import 'package:greanspherproj/data/api_manager/end_points.dart';
import 'package:injectable/injectable.dart';

@singleton
class ApiManager {
  late Dio dio;

  ApiManager() {
    dio = Dio();
  }

  Future<Response> getData(
    String api, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? body,
  }) {
    return dio.get(EndPoints.baseUrl + api,
        data: body,
        queryParameters: queryParameters,
        options: Options(headers: headers, validateStatus: (status) => true));
  }

  Future<Response> postData(String api,
      {Map<String, dynamic>? body, Map<String, dynamic>? headers}) {
    return dio.post(EndPoints.baseUrl + api,
        data: body,
        options: Options(headers: headers, validateStatus: (status) => true));
  }

  Future<Response> updateData(String api,
      {Map<String, dynamic>? body, Map<String, dynamic>? headers}) {
    return dio.put(EndPoints.baseUrl + api,
        data: body,
        options: Options(headers: headers, validateStatus: (status) => true));
  }
}
