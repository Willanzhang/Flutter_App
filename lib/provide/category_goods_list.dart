import 'package:flutter/material.dart';
import '../model/category_goodsList.dart';

class CategoryGoodsListProvide with ChangeNotifier{
  List<CategoryListDate> goodsList = [];

  // 点击大类时更改商品列表

  getGoodsList(List<CategoryListDate> list) {
    goodsList = list;
    notifyListeners();
  }
}