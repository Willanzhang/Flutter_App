import 'package:dio/dio.dart';
import 'dart:async';
import 'dart:io'; // 要使用io包的一个对象 ContentType
import '../config/service_url.dart';

// 获取首页主题内容
Future getHomePageContent() async {
  try{
    var c = '123';
    print('获取首页数据。。。。${c}');
    Response response;
    Dio dio = new Dio();
    // io 中的 ContentType
    dio.options.contentType = ContentType.parse('application/x-www-form-urlencoded');
    // 经纬度~
    var formData = {'lon': '115.02932', 'lat': '35.73322'};
    print(servicePath['homePageContext']);
    response = await dio.post(servicePath['homePageContext'], data: formData);
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('后端接口异常');
    }
  } catch(e) {
    return print('ERROR:===============>${e}');
  }
}