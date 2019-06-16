import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../provide/detail_info.dart';

class DetailsTabbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provide<DetailInfoProvide>(
      builder: (context, child, val) {
        var isLeft = Provide.value<DetailInfoProvide>(context).isLeft;
        var isRight = Provide.value<DetailInfoProvide>(context).isRight;
        return Container(
          child: Row(
            children: <Widget>[
              _myTabbarLeft(context, isLeft),
              _myTabbarRight(context, isRight)
            ],
          ),
        );
      },
    );
  }

  Widget _myTabbarLeft(BuildContext context, bool isLeft) {
    return InkWell(
      onTap: () {
        Provide.value<DetailInfoProvide>(context).changeLeftAndRight('left');
      },
      child: Container(
        padding: EdgeInsets.all(10.0),
        alignment: Alignment.center,
        width: ScreenUtil().setWidth(375),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(
              width: 1.0,
              color: isLeft? Colors.pink:Colors.black12,
            )
          )
        ),
        child: Text(
          '详情',
          style: TextStyle(color: isLeft? Colors.pink:Colors.black54),
        ),
      ),
    );
  }

  Widget _myTabbarRight(BuildContext context, bool isRight) {
    return InkWell(
      onTap: () {
        Provide.value<DetailInfoProvide>(context).changeLeftAndRight('right');
      },
      child: Container(
        padding: EdgeInsets.all(10.0),
        alignment: Alignment.center,
        width: ScreenUtil().setWidth(375),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(
              width: 1.0,
              color: isRight? Colors.pink:Colors.black12,
            )
          )
        ),
        child: Text(
          '评论',
          style: TextStyle(color: isRight? Colors.pink:Colors.black54),
        ),
      ),
    );
  }
}