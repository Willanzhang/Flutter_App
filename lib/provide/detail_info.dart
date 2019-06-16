import 'package:flutter/material.dart';
import '../model/detail.dart';
import '../service/service_method.dart';
import 'dart:convert';

class DetailInfoProvide with ChangeNotifier {
  DetailModel goodsInfo = null;

  bool isLeft = true;
  bool isRight = false;

  // tabbar 的切换方法
  changeLeftAndRight(String changeState) {
    if (changeState == 'left') {
      isLeft = true;
      isRight = false;
    } else {
      isLeft = false;
      isRight = true;
    }
    notifyListeners();
  }

  // 从后台获取商品数据
  getGoodsInfo(String id) {
    // goodsInfo = null;
    var formData = {'goodId': id};
    request('getGoodDetailById', formData: formData).then((val){
      var data = json.decode(val.toString());
      print('-------data>>$data');
      goodsInfo = DetailModel.fromJson(data);
      notifyListeners();
    });
  }
}