import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../model/cartInfo.dart';

class CartProvide with ChangeNotifier {
  String cartString = '[]';
  List<CartInfoModel> cartList=[];
  int allGoodsCount = 0; // 商品总数量
  double allPrize = 0; // 总价格
  bool isAllCheck = true; // 是否全选

  save(goodsId, goodsName, count, price, images) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // await getCartInfo();
    // 获取购物车信息
    cartString = prefs.getString('cartInfo');
    var temp = cartString == null ? []:json.decode(cartString.toString());
    List<Map> tempList = (temp as List).cast();
    bool isHave = false;
    int ival = 0;

    allPrize = 0;
    allGoodsCount = 0;
    // 判断是否存在 存在就增加数量， 否则添加进持久化数据中
    tempList.forEach((item){
      if (item['goodsId'] == goodsId) {
        tempList[ival]['count'] = item['count'] + count;
        // if (ival < cartList.length) {  // 这里必须这么加一个判断 否则会出现索引超出范围的报错  主要问题就是，  一个持久化了（cartInfo） ，一个没有持久（cartList）
          cartList[ival].count =item['count'] + count;
        // }
        isHave = true;
      }
      if (item['isCheck']) {
        // allPrize += (cartList[ival].price * cartList[ival].count);
        // allGoodsCount += cartList[ival].count;
        allPrize += (item['count'] * item['price']);
        allGoodsCount += item['count'];
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

      allPrize += (count * price);
      allGoodsCount += count;
    }
    cartString = json.encode(tempList).toString();
    print('--------------------->$cartString');
    prefs.setString('cartInfo', cartString);
    notifyListeners();
  }

  remove() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('cartInfo');
    cartList = [];
    allPrize = 0;
    allGoodsCount = 0;
    notifyListeners();
  }

  // 这种就是进入的时候将持久化的数据绑定在 provide上
  getCartInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartInfo');
    if (cartString == null) {
      cartList = [];
    } else {
      cartList = [];
      List<Map> tempList = (json.decode(cartString.toString()) as List).cast();
      allGoodsCount = 0;
      allPrize = 0;
      isAllCheck = true;
      tempList.forEach((item){
        if (item['isCheck']) {
          allPrize += (item['count'] * item['price']);
          allGoodsCount += item['count'];
        } else {
          isAllCheck = false;
        }
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

  // 改变选中状态
  changeCheckState(CartInfoModel cartItem) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartInfo');
    List<Map> tempList = (json.decode(cartString.toString()) as List).cast();
    int tempIndex = 0;
    int changeIndex = 0;
    tempList.forEach((item) {
      if (item['goodsId'] == cartItem.goodsId) {
        changeIndex = tempIndex;
      }
      tempIndex++;
    });
    tempList[changeIndex] = cartItem.toJson(); // model 转化为 Map 
    cartString = json.encode(tempList).toString(); //变成字符串 注意toString的执行位置！！！
    prefs.setString('cartInfo', cartString); //进行持久化
    await getCartInfo(); //重新读取列表
  }

  // 点击全选按钮操作
  changeAllCheck(bool isCheck) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartInfo');
    List<Map> tempList = (json.decode(cartString.toString()) as List).cast();
    List<Map> newList = [];
    for(var item in tempList) {
      var newItem = item;
      newItem['isCheck'] = isCheck;
      newList.add(newItem);
    }
    cartString = json.encode(newList).toString();
    prefs.setString('cartInfo', cartString);
    await getCartInfo();
  }

  // 商品数量加减
  addOrReduceAction(CartInfoModel cartItem, String todu) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartInfo');
    List<Map> tempList = (json.decode(cartString.toString()) as List).cast();
    int tempIndex = 0;
    int changeIndex = 0;
    tempList.forEach((item) {
      if (item['goodsId'] == cartItem.goodsId) {
        changeIndex = tempIndex;
      }
      tempIndex++;
    });
    if (todu == 'add') {
      cartItem.count++;
    } else if (todu == 'reduce' && cartItem.count > 1) {
      cartItem.count--;
    }
    tempList[changeIndex] = cartItem.toJson(); // model 转化为 Map 
    cartString = json.encode(tempList).toString(); //变成字符串 注意toString的执行位置！！！
    prefs.setString('cartInfo', cartString); //进行持久化
    await getCartInfo(); //重新读取列表
  }
}