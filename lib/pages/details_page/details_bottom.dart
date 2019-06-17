import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';
import '../../provide/cart.dart';
import '../../provide/detail_info.dart';
import '../../provide/currentIndex.dart';

class DeatilsBottom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    var goodsInfo = Provide.value<DetailInfoProvide>(context).goodsInfo.data.goodInfo;
    var goodsId = goodsInfo.goodsId;
    var goodsName = goodsInfo.goodsName;
    var count = 1;
    var price = goodsInfo.presentPrice;
    var images = goodsInfo.image1;
    return Container(
      width: ScreenUtil().setWidth(750),
      color: Colors.white,
      height: ScreenUtil().setHeight(80),
      child: Row(
        children: <Widget>[
          InkWell(
            onTap: () async {
              Provide.value<CurrentIndexProvide>(context).changeIndex(2);
              Navigator.pop(context);
            },
            child: Container(
              width: ScreenUtil().setWidth(110),
              alignment: Alignment.center,
              child: Icon(
                Icons.shopping_cart,
                size: 35,
                color: Colors.red
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              print('點擊購買');
              await Provide.value<CartProvide>(context).save(goodsId, goodsName, count, price, images);
            },
            child: Container(
              width: ScreenUtil().setWidth(320),
              height: ScreenUtil().setHeight(80),
              alignment: Alignment.center,
              color: Colors.green,
              child: Text(
                '加入購物車',
                style: TextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(28)),
              )
            ),
          ),
          InkWell(
            onTap: () async {
              print('清空購物車---');
              await Provide.value<CartProvide>(context).remove();
            },
            child: Container(
              width: ScreenUtil().setWidth(320),
              height: ScreenUtil().setHeight(80),
              alignment: Alignment.center,
              color: Colors.red,
              child: Text(
                '立即購買',
                style: TextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(28)),
              )
            ),
          )
        ],
      ),
    );
  }
}