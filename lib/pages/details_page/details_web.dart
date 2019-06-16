import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../provide/detail_info.dart';
import 'package:flutter_html/flutter_html.dart';

class DetailsWeb extends StatelessWidget {
	@override
	Widget build(BuildContext context) {

		var goodsDetail = Provide.value<DetailInfoProvide>(context).goodsInfo.data.goodInfo.goodsDetail;
		print('---------------------->$goodsDetail');
		return Container(
			child: Html(
				// 不支持 100%這種單位  作者說在以後更改
				data: goodsDetail
			),
		);
	}
}