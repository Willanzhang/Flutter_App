import 'package:provide/provide.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import '../provide/counter.dart';
// import '../provide/age.dart';

class MemberPage extends StatelessWidget {
  
  final List<Map> tabs = [
    {'title': '领取优惠券', 'navigation': '/',},
    {'title': '已领取优惠券', 'navigation': '/',},
    {'title': '地址管理', 'navigation': '/',},
    {'title': '客服电话', 'navigation': '/',},
    {'title': '关于我们', 'navigation': '/',},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('会员中心'),
      ),
      body: ListView(
        children: <Widget>[
          _topHeader(),
          _orderTitle(),
          _orderType(),
          _actionList()
        ],
      ),
    );
  }

  Widget _topHeader() {
    return Container(
      width: ScreenUtil().setWidth(750),
      padding: EdgeInsets.all(20),
      color: Colors.pinkAccent,
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 30), 
            height: ScreenUtil().setHeight(100),
            width: ScreenUtil().setWidth(100),
            // 头像组件
            child: ClipOval(
              // child: Image.network('https://m.zhangbowen.club/static/upload/20190618/5e142b2cfaef494d9586fcc8e06cb9ae.jpg'),
              // child: Image.network('https://mloty.66jingcai.cn/pre_match_src.png'),
              child: Image.network('https://wx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTI34dJEjCTmuFPbibcyiaiavicFOCgyqc4VDff0Ph06Mb6GU9SdUoGibeliaFLZpzyGVdNYsiavqB6Hkv5WA/132'),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text(
              'william',
              style: TextStyle(
                color: Colors.black54,
                fontSize: ScreenUtil().setSp(36)
              ),
            ),
          )
        ],
      ),
    );
  }
  
  // 订单标题
  Widget _orderTitle() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(width: 1, color: Colors.black12)
        )
      ),
      child: ListTile(

        leading: Icon(Icons.list),
        title: Text('我的订单'),
        // 右边 后面
        trailing: Icon(Icons.arrow_right),
      ),
    );
  }

  // 订单类型
  Widget _orderType() {
    return Container(
      margin: EdgeInsets.only(top: 5),
      width: ScreenUtil().setWidth(750),
      height: ScreenUtil().setHeight(150),
      padding:EdgeInsets.only(top: 20),
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Container(
            width: ScreenUtil().setWidth(187),
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.party_mode,
                  size: 30
                ),
                Text('待付款')
              ],
            ),
          ),
          //-------------------------
          Container(
            width: ScreenUtil().setWidth(187),
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.query_builder,
                  size: 30
                ),
                Text('待发货')
              ],
            ),
          ),
          //-------------------------
          Container(
            width: ScreenUtil().setWidth(187),
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.directions_car,
                  size: 30
                ),
                Text('待发货')
              ],
            ),
          ),
          //-------------------------
          Container(
            width: ScreenUtil().setWidth(187),
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.content_paste,
                  size: 30
                ),
                Text('待评价')
              ],
            ),
          ),
          //-------------------------
        ],
      ),
    );
  }

  // 通用listTile
  Widget _myListTile(String title) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(
          color: Colors.black12,
          width: 1,
        )),
      ),
      child: InkWell(
        onTap: () {
          print('点击');
        },
        child: ListTile(
          leading: Icon(Icons.blur_circular),
          title: Text(title),
          trailing: Icon(Icons.arrow_right),
        ),
      ),
    );
  }


  Widget _actionList() {
    List<Widget> tabItem = tabs.map((item){
        print('------------------->>>>>>$item');
        return _myListTile(item['title']);
      }).toList();
    print('------------------->>>>>>$tabItem');
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Column(
        children: tabItem
      ),
    );
  }
}