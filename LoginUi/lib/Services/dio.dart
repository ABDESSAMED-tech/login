import 'package:dio/dio.dart';

Dio dio() {
  Dio dio = new Dio();
  //l'@ IP de hotspot  ,i'm using real device
  dio.options.baseUrl = "http://192.168.43.22:8000/api";
  dio.options.headers['accepte'] = 'Application/Json';
  return dio;
}
