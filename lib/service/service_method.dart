import 'package:dio/dio.dart';
import 'dart:async';
import 'dart:io'; // 要使用io包的一个对象 ContentType
import '../config/service_url.dart';


// 封装 dio
Future request(String url, formData) async {
  try{
    var c = '123';
    print('开始获取数据...${c}');
    Response response;
    Dio dio = new Dio();
    // io 中的 ContentType 使用 改变 contentType 
    dio.options.contentType = ContentType.parse('application/x-www-form-urlencoded');
    if (formData == null) {
      response = await dio.post(servicePath[url]);
    } else {
      response = await dio.post(servicePath[url], data: formData);
    }
    // 经纬度~
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('后端接口异常');
    }
  } catch(e) {
    return print('ERROR:===============>${e}');
  }
}
