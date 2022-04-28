import 'dart:developer';
import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'api_endpoints.dart';

class BackendService {
  final Dio _dio;

  BackendService(this._dio) {
    initializeDio();
  }

  /// This allows you set [header] options outside the backend service class
  void setExtraHeaders(Map<String, dynamic> newHeaders) {
    Map<String, dynamic> existingHeaders = _dio.options.headers;
    newHeaders.forEach((key, value) =>
        existingHeaders.update(key, (_) => value, ifAbsent: () => value));
    _dio.options.headers = existingHeaders;
  }

  void initializeDio() {
    //
    _dio.options = BaseOptions(
      baseUrl: Endpoints.baseurl,
      connectTimeout: 100000,
      receiveTimeout: 100000,
      // set request headers
      headers: {
        "content-Type": "application/x-www-form-urlencoded",
      },
    );

    //
    if (!kIsWeb) {
      (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (client) {
        client.badCertificateCallback = (
          X509Certificate cert,
          String host,
          int port,
        ) {
          return true;
        };
      };
    }

    _dio.interceptors.add(
      InterceptorsWrapper(
          onRequest: onRequestInterceptors,
          onResponse: onResponseInterceptors,
          onError: onErrorInterceptorHandler),
    );
  }

  Future<void> setToken(RequestOptions option) async {
    String? token;
    token != null ? option.headers = {"Authorization": "Bearer $token"} : null;
  }

  onRequestInterceptors(RequestOptions options,
      RequestInterceptorHandler requestInterceptorHandler) async {
    await setToken(options);
    "======================================================================>";
    debugPrint("REQUEST URI ==============[🚀🚀🚀🚀]  ${options.uri}");
    debugPrint("REQUEST METHOD ==============[🚀🚀🚀🚀]  ${options.method}");
    debugPrint("REQUEST HEADERS ==============[🚀🚀🚀🚀] ${options.headers}");
    log("REQUEST DATA ==============[🚀🚀🚀🚀] ${options.data}");
    "======================================================================>";
    debugPrint("================================================>");
    debugPrint("=======[INFO]: ${options.data}");
    debugPrint("================================================>");

    return requestInterceptorHandler.next(options); //continue
  }

  onResponseInterceptors(
      Response<dynamic> response, ResponseInterceptorHandler handler) {
    "======================================================================>";
    debugPrint("RESPONSE DATA ==============>  ${response.data}");
    debugPrint("RESPONSE HEADERS ==============>  ${response.headers}");
    debugPrint("RESPONSE STATUSCODE ==============>  ${response.statusCode}");
    debugPrint(
        "RESPONSE STATUSMESSAGE ==============>  ${response.statusMessage}");
    "======================================================================>";
    return handler.next(response); // continue
  }

  onErrorInterceptorHandler(DioError e, handler) {
    return handler.next(e); //continue
  }

  /// This allows you change [baseurl] options outside the backend service class
  // void changeBaseUrl(String newBaseUrl) => _dio.options.baseUrl = newBaseUrl;

  apiResponse({dynamic message, dynamic? errorCode}) {
    return {
      "message": message ?? "an_error_occurred_please_try_again",
      "errorCode": errorCode ?? "000",
    };
  }

  Response? handleError(DioError? e) {
    Response? response;

    switch (e?.type) {
      case DioErrorType.cancel:
        response = Response(
          data: apiResponse(
            message: 'Request cancelled!',
          ),
          requestOptions: RequestOptions(path: ''),
        );
        break;
      case DioErrorType.connectTimeout:
        response = Response(
          data: apiResponse(
            message: "Network connection timed out!",
          ),
          requestOptions: RequestOptions(path: ''),
        );
        break;
      case DioErrorType.receiveTimeout:
        response = Response(
          data: apiResponse(
            message: "Something went wrong. Please try again later!",
          ),
          requestOptions: RequestOptions(path: ''),
        );
        break;
      case DioErrorType.sendTimeout:
        response = Response(
          data: apiResponse(
            message: "Something went wrong. Please try again later",
          ),
          requestOptions: RequestOptions(path: ''),
        );
        break;
      case DioErrorType.other:
        if (e?.error is SocketException) {
          response = Response(
            data: apiResponse(
              message: "Please check your network connection!",
            ),
            requestOptions: RequestOptions(path: ''),
          );
        } else if (e?.error is HttpException) {
          response = Response(
            data: apiResponse(
              message: "Network connection issue",
            ),
            requestOptions: RequestOptions(path: ''),
          );
        }
        break;
      default:
        if (e!.response!.data.runtimeType == String &&
            e.error.toString().contains("404")) {
          response = Response(
            data: apiResponse(
              message: "An error occurred, please try again",
              errorCode: '404',
            ),
            requestOptions: RequestOptions(path: ''),
          );
        } else if (e.response?.data.runtimeType == String &&
            e.error.toString().contains("400")) {
          response = Response(
            data: apiResponse(
              message: e.response?.data["description"] ??
                  "An error occurred, please try again",
              errorCode: '400',
            ),
            requestOptions: RequestOptions(path: ''),
          );
        } else {
          response = Response(
              data: apiResponse(
                  message:
                      e.response!.data.isNotEmpty ? e.response!.data : "NULL",
                  errorCode: e.response!.data.isNotEmpty
                      ? e.response!.data[0]
                      : "null"),
              statusCode: e.response?.statusCode ?? 000,
              requestOptions: RequestOptions(path: ''));
        }
    }
    return response;
  }

  //
  Dio get dio => _dio;

  // Returns the same instance of dio throughout the application
  BackendService clone() => BackendService(_dio);
}
