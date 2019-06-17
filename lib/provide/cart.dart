import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../model/cartInfo.dart';

class CartProvide with ChangeNotifier {
  String cartString = '[]';
  List<CartInfoModel> cartList=[];

  save(goodsId, goodsName, count, price, images) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await getCartInfo();
    // 获取购物车信息
    cartString = prefs.getString('cartInfo');
    var temp = cartString == null ? []:json.decode(cartString.toString());
    List<Map> tempList = (temp as List).cast();
    bool isHave = false;
    int ival = 0;

    // 判断是否存在 存在就增加数量， 否则添加进持久化数据中
    tempList.forEach((item){
      if (item['goodsId'] == goodsId) {
        tempList[ival]['count'] = item['count'] + count;
        // if (ival < cartList.length) {  // 这里必须这么加一个判断 否则会出现索引超出范围的报错  主要问题就是，  一个持久化了（cartInfo） ，一个没有持久（cartList）
          cartList[ival].count =item['count'] + count;
        // }
        isHave = true;
      }
      ival++;
    });
    if (!isHave) {
      Map<String, dynamic> newGoods = {
        'goodsId': goodsId,
        'goodsName': goodsName,
        'count': count,
        'price': price,
        'images': images,
        'isCheck': true
      };
      tempList.add(newGoods);
      cartList.add(CartInfoModel.fromJson(newGoods));
    }
    cartString = json.encode(tempList).toString();
    print('--------------------->$cartString');
    prefs.setString('cartInfo', cartString);
  }

  remove() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('cartInfo');
    cartList = [];
    notifyListeners();
  }

  // 这种就可以将上面
  getCartInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartInfo');
    if (cartString == null) {
      cartList = [];
    } else {
      cartList = [];
      List<Map> tempList = (json.decode(cartString.toString()) as List).cast();
      tempList.forEach((item){
        cartList.add(CartInfoModel.fromJson(item));
      });
    }
    notifyListeners();
  }

  // 删除多个购物车商品
  deleteOneGods(String goodsId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartInfo');
    List<Map> tempList = (json.decode(cartString.toString()) as List).cast();
    int tempIndex = 0;
    int delIndex = 0;
    tempList.forEach((item){
      if (item['goodsId'] == goodsId) {
        delIndex = tempIndex;
      }
      tempIndex++;
    });

    tempList.removeAt(delIndex);
    cartString = json.encode(tempList).toString();
    prefs.setString('cartInfo', cartString);
    await getCartInfo();
  }
}