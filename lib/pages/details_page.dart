import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import '../provide/detail_info.dart';
import './details_page/details_top_area.dart';
import './details_page/details_explain.dart';
import './details_page/details.tabbar.dart';
import './details_page/details_web.dart';
import './details_page/details_bottom.dart';

class DetailsPage extends StatelessWidget {
  final String goodsId;
  DetailsPage(this.goodsId);
  @override
  Widget build(BuildContext context) {
    _getBackInfo(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () { 
            // 返回上一级
            Navigator.pop(context);
          },
        ),
        title: Text('商品详细页')
      ),
      body: FutureBuilder(
        future: _getBackInfo(context),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return Stack(
							children: <Widget>[
                Container(
                  child: ListView(
                    children: <Widget>[
                      DetailsTopArea(),
                      DetailsExplain(),
                      DetailsTabbar(),
                      DetailsWeb(),
                    ],
                  ),
                ),
                // 定位相對上面
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: DeatilsBottom(),
                )
              ],
            );
          } else {
            return Text('加载中....');
          }
        },
      ),
    );
  }

  Future _getBackInfo (BuildContext context) async {
    await Provide.value<DetailInfoProvide>(context).getGoodsInfo(goodsId);
    return '完成加载';
  }
}