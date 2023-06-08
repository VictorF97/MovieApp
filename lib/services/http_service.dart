// @dart=2.9
// ignore_for_file: avoid_print, non_constant_identifier_names

import '../models/app_config.dart';
//Packages
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

class HHTPService {
  final Dio dio = Dio();
  final GetIt getIt = GetIt.instance;

  String _base_url;
  String _api_key;

  HHTPService() {
    AppConfig config = getIt.get<AppConfig>();
    _base_url = config.BASE_API_URL;
    _api_key = config.API_KEY;
  }

  // ignore: missing_return
  Future<Response> get(String path, {Map<String, dynamic> query}) async {
    try {
      String url = '$_base_url$path';
      Map<String, dynamic> query = {
        'api_key': _api_key,
        'language': 'pt-BR',
      };
      if (query != null) {
        query.addAll(query);
      }
      return await dio.get(url, queryParameters: query);
    } on DioError catch (e) {
      print('Unable to perform get request');
      print('DioError:$e');
    }
  }
}
