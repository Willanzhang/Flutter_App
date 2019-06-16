import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import '../provide/detail_info.dart';

class DetailsPage extends StatelessWidget {
  final String goodsId;
  DetailsPage(this.goodsId);
  @override
  Widget build(BuildContext context) {
    _getBackInfo(context);
    return Container(
      child: Center(
        child: Text('商品ID:$goodsId'),
      ),
    );
  }

  void _getBackInfo (BuildContext context) async {
    await Provide.value<DetailInfoProvide>(context).getGoodsInfo(goodsId);
    print('商品详情加载完成---------------');
  }
}