import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {

  List<String> testList = [];

  @override
  Widget build(BuildContext context) {
    // 進入的時候是要查詢的
    _show();
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            height: 500,
            child: ListView.builder(
              itemCount: testList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(testList[index]),
                );
              },
            ),
          ),
          RaisedButton(
            onPressed: () {
              _add();
            },
            child: Text('增加'),
          ),
          RaisedButton(
            onPressed: () {
              _remove();
            },
            child: Text('清空'),
          ),
        ],
      ),
    );
  }

  // 增加方法  必須使用異步方法
  void _add() async {
    // 初始化時需要時間的
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String temp = '要做最靚的'; // 每點一次加一個臨時的變量
    testList.add(temp);
    // 設置set
    prefs.setStringList('testInfo', testList);
    _show();
  }

  // 查詢
  void _show() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // 獲取 get
    if (prefs.getStringList('testInfo') != null) {
      setState(() {
        testList = prefs.getStringList('testInfo');
      });
    }
  }

  // 刪除
  void _remove() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.clear() 清空所有 的值，  包括 key=testInfo
    prefs.remove('testInfo');
    setState(() {
      testList = [];
    });
  }

  // 清空
  // void _clear() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   //  清空所有
  //   prefs.clear();
  //   setState(() {
  //     testList = [];
  //   });
  //   // prefs.remove('testInfo');
  // }
}