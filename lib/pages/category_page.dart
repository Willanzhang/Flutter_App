import 'package:flutter/material.dart';
import '../service/service_method.dart';
// 装换data数据格式
import 'dart:convert';
// 引入数据模型
import '../model/category.dart';

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    _getCategory();
    return Container(
      child: Center(
        child: Text('分类页面'),
      ),
    );
  }

  void _getCategory() async{
    print('=======> 这里是第二个页面');
    await request('getCategory').then((val) {
      var data = json.decode(val.toString());
      CategoryListModel list = CategoryListModel.fromJson(data['data']);
      list.data.forEach((item) => print(item.mallCategoryName));
    });
  }
}