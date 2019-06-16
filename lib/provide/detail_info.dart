import 'package:flutter/material.dart';
import '../model/detail.dart';
import '../service/service_method.dart';
import 'dart:convert';

class DetailInfoProvide with ChangeNotifier {
  DetailModel goodsInfo;

  // 从后台获取商品数据
  getGoodsInfo(String id) {
    var formData = {'goodId': id};
    request('getGoodDetailById', formData: formData).then((val){
      var data = json.decode(val.toString());
      print('-------data>>$data');
      goodsInfo = DetailModel.fromJson(data);
      notifyListeners();
    });
  }
}