import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:quick_log/quick_log.dart';

class ServerGate {
  Logger log = const Logger('***  Server Gate ***');
  Dio dio = Dio(
    BaseOptions(
      baseUrl: "https://mkhdoom.net/",
      // headers: {
      //   "X-Oc-Merchant-Id": merchantId,
      //   if (CacheHelper.getUserSession() != '')
      //     "X-Oc-Session": CacheHelper.getUserSession(),
      // },
      receiveDataWhenStatusError: true,
    ),
  );
  ServerGate() {
    addInterceptors();
  }
  void addInterceptors() {
    dio.interceptors.add(CustomApiInterceptor(log));
  }

  StreamController<double> onSingleReceive = StreamController.broadcast();
  Future<CustomResponse> sendToServer(
      {required String url,
      Map<String, dynamic>? body,
      Map<String, dynamic>? headers}) async {
    if (body != null) {
      body.removeWhere((key, value) => body[key] == null || body[key] == "");
    }
    if (body != null) {
      Map<String, String> logBody = {};
      body.forEach((key, value) {
        logBody.addAll({key.toString(): value.toString()});
      });
      log.info(body);
    }
    dio.options.headers = headers;
    try {
      Response response = await dio.post(
        url,
        data: body,
        onSendProgress: (received, total) {
          onSingleReceive.add((received / total) - 0.05);
        },
        options: Options(
          sendTimeout: Duration(milliseconds: 12000),
          receiveTimeout: Duration(milliseconds: 12000),
          contentType:
              "multipart/form-data; boundary=<calculated when request is sent>",
        ),
      );
      return CustomResponse(
        success: true,
        statusCode: 200,
        errType: null,
        error: null,
        msg: response.data["message"] ?? "Your request completed successfully",
        response: response,
      );
    } on DioError catch (err) {
      return handleServerError(err);
    }
  }

  Future<Response> postData({
    required String url,
    Map<String, dynamic>? body,
    Map<String, dynamic>? headers,
  }) async {
    dio.options.headers = headers;
    dio.options.sendTimeout = Duration(milliseconds: 12000);
    dio.options.receiveTimeout = Duration(milliseconds: 12000);
    return await dio.post(
      url,
      data: body,
    );
  }

  Future<Response> deleteData(
      {required String url,
      Map<String, dynamic>? body,
      Map<String, dynamic>? headrs}) async {
    // dio.options.headers = {
    //   "X-Oc-Merchant-Id": merchantId,
    //   "X-Oc-Session": CacheHelper.getUserSession(),
    // };
    dio.options.sendTimeout = Duration(milliseconds: 12000);
    dio.options.receiveTimeout = Duration(milliseconds: 12000);
    return await dio.delete(
      url,
      data: body,
    );
  }

  Future<Response> putToServer({
    required String url,
    Map<String, dynamic>? body,
  }) async {
    // dio.options.headers = {
    //   "X-Oc-Merchant-Id": merchantId,
    //   "X-Oc-Session": CacheHelper.getUserSession(),
    // };
    dio.options.sendTimeout = Duration(milliseconds: 12000);
    dio.options.receiveTimeout = Duration(milliseconds: 12000);
    return await dio.put(
      url,
      data: body,
    );
  }

  Future<CustomResponse> postAsPutToServer({
    required String url,
    Map<String, dynamic>? body,
  }) async {
    body?.addAll({"_method": "PUT"});
    try {
      Response response = await dio.post(
        url,
        data: FormData.fromMap(body ?? {}),
        onSendProgress: (received, total) {
          onSingleReceive.add((received / total) - 0.05);
        },
        options: Options(
          // headers: {
          //   "X-Oc-Session": CacheHelper.getUserSession(),
          // },
          sendTimeout: Duration(milliseconds: 12000),
          receiveTimeout: Duration(milliseconds: 12000),
          contentType:
              "multipart/form-data; boundary=<calculated when request is sent>",
        ),
      );

      return CustomResponse(
        success: true,
        statusCode: 200,
        errType: null,
        error: null,
        msg: response.data["message"] ?? "Your request completed successfully",
        response: response,
      );
    } on DioError catch (err) {
      return handleServerError(err);
    }
  }

  Future<CustomResponse> getFromServer({
    required String url,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? params,
    bool decodeData = false,
  }) async {
    if (params != null) {
      params.removeWhere(
          (key, value) => params[key] == null || params[key] == "");
    }
    try {
      Response response = await dio.get(
        url,
        options: Options(
          headers: headers,
          sendTimeout: Duration(milliseconds: 12000),
          receiveTimeout: Duration(milliseconds: 12000),
        ),
        queryParameters: params,
      );
      if (decodeData) response.data = jsonDecode(response.data);
      if ("${response.data}".startsWith("[")) {
        response.data = {"data": response.data};
      }
      return CustomResponse(
        success: true,
        statusCode: 200,
        errType: null,
        error: null,
        msg: (response.data["message"] ?? "Your request completed successfully")
            .toString(),
        response: response,
      );
    } on DioError catch (err) {
      return handleServerError(err);
    }
  }

  CustomResponse handleServerError(DioError err) {
    if (err.type == DioErrorType.badResponse) {
      if (err.response!.data.toString().contains("DOCTYPE") ||
          err.response!.data.toString().contains("<script>") ||
          err.response!.data["exception"] != null) {
        return CustomResponse(
          errType: 2,
          statusCode: err.response!.statusCode ?? 500,
          msg: 'LocaleKeys.serverError.tr()',
          response: null,
        );
      }
      if (err.response!.statusCode == 401) {
        /*navigateTo(navigator.currentContext, page: HomePage(), leaveHistory: false);*/
      }
      try {
        return CustomResponse(
          statusCode: err.response?.statusCode ?? 500,
          errType: 1,
          msg: (err.response!.data["errors"] as Map).values.first.first,
          error: null,
          response: err.response,
        );
      } catch (e) {
        return CustomResponse(
          statusCode: err.response?.statusCode ?? 500,
          errType: 1,
          msg: err.response?.data["message"],
          error: null,
          response: err.response,
        );
      }
    } else if (err.type == DioErrorType.receiveTimeout ||
        err.type == DioErrorType.sendTimeout) {
      return CustomResponse(
        statusCode: err.response?.statusCode ?? 500,
        errType: 0,
        msg: 'LocaleKeys.noConnection.tr()',
        error: null,
        response: null,
      );
    } else {
      if (err.response == null) {
        return CustomResponse(
          statusCode: 402,
          errType: 0,
          msg: ' LocaleKeys.noConnection.tr()',
          error: null,
          response: null,
        );
      }
      return CustomResponse(
        statusCode: 402,
        errType: 2,
        msg: ' LocaleKeys.serverError.tr()',
        error: null,
        response: null,
      );
    }
  }
}

class CustomApiInterceptor extends Interceptor {
  Logger log;
  CustomApiInterceptor(this.log);

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    log.error("\x1B[37m------ Current Error Response -----\x1B[0m");
    log.error("\x1B[31m${err.response?.data}\x1B[0m");
    return super.onError(err, handler);
  }

  @override
  Future<void> onResponse(
      Response response, ResponseInterceptorHandler handler) async {
    log.fine("------ Current Response ------");
    log.fine(jsonEncode(response.data));
    return super.onResponse(response, handler);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    log.info("------ Current Request Parameters Data -----");
    log.info("${options.queryParameters}");
    log.info("------ Current Request Headers -----");
    log.info("${options.headers}");
    log.info("------ Current Request Path -----");
    log.info("${options.path}  API METHOD : (${options.method})");
    return super.onRequest(options, handler);
  }
}

class CustomResponse {
  bool success;
  int? errType;

  // 0 => network error
  // 1 => error from the server
  // 2 => other error
  String msg;
  int statusCode;
  Response? response;
  dynamic error;

  CustomResponse({
    this.success = false,
    this.errType = 0,
    this.msg = "",
    this.statusCode = 0,
    this.response,
    this.error,
  });
}
