import 'dart:io';
import 'package:dio/dio.dart';

import '../model_factory.dart';

///http请求
class Api {
  Api._();

  static Dio dio = init();

  static Dio init() {
    Dio dio = Dio(BaseOptions(
      baseUrl: 'http://qbt.qubaotang.cn/',
        connectTimeout: 1000,
        receiveTimeout: 10000
    ));
    //打印请求日志和结果
//    dio.interceptors.add(LogInterceptor(responseBody: false));
    return dio;
  }

  ///get请求
  static Future<T> get<T>(String url, {Map<String, dynamic> params, Options options}) async {
    return _send<T>(url, params: params, options: options, method: 'get');
  }

  ///post请求
  static Future<T> post<T>(String url, {Map<String, dynamic> params, Options options}) async {
    return _send<T>(url, params: params, options: options, method: 'post');
  }

  ///发起请求
  static Future<T> _send<T>(String url, {Map<String, dynamic> params, Options options, String method = 'get'}) async {
    if(options==null){
      options = Options(
          headers: {"AUTHORIZATION":"1"},
          contentType: ContentType.parse("application/x-www-form-urlencoded")
      );
    }
    Response<Map<String,dynamic>> response;
    try {
      if (method == 'get') {
        response = await dio.get<Map<String,dynamic>>(url, queryParameters: params, options: options);
      } else {
        response = await dio.post<Map<String,dynamic>>(url, queryParameters: params, options: options);
      }
    } on DioError catch (e) {
      if(e.type==DioErrorType.DEFAULT){
        if (e.error is SocketException) {
          return Future.error(RequestErrorException(0,'远程计算机拒绝网络连接'));
        } else if (e.error is HandshakeException) {
          return Future.error(RequestErrorException(0,'请检查服务器是否支持http或者https'));
        } else if (e.error is RangeError){
          return Future.error(RequestErrorException(0,'请求url不合法，请以http://或者https://作为前缀'));
        }else{
          return Future.error(RequestErrorException(0,e.error));
        }
      }else if(e.type==DioErrorType.RESPONSE){
        String message;
        switch(e.response.statusCode){
          case 400:
            message='请求异常';
            break;
          case 404:
            message='请求地址不存在';
            break;
          case 500:
            message='服务器错误';
            break;
          case 502:
            message='服务器未启动';
            break;
          case 504:
            message='服务器没有响应';
            break;
          default:
            message='未知异常:${e.response.statusCode}';
            break;
        }
        throw RequestErrorException(e.response.statusCode,message);
      }
    }
    if (response.data==null) {
      return await Future.error(RequestErrorException(0,'返回结果为空'));
    } else {
      if(response.data['status']){
        if(response.data['data']is List<dynamic>){
          return await Future.value(response.data['data']);
        }else{
          return await Future.value(ModelFactory.generateOBJ<T>(response.data['data']));
        }
      }else{
        return await Future.error( RequestErrorException(response.data['code'],response.data['error']));
      }
    }
  }
}
class RequestErrorException{
  int code;
  String error;
  RequestErrorException(this.code,this.error);
}
