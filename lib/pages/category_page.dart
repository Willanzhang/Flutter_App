import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../service/service_method.dart';
// 装换data数据格式
import 'dart:convert';
// 引入数据模型
import '../model/category.dart';

import '../model/category_goodsList.dart';
import 'package:provide/provide.dart';
import '../provide/child_category.dart';
import '../provide/category_goods_list.dart';

class CategoryPage extends StatefulWidget {
	@override
	_CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: Text('商品分类'),
			),
			body: Container(
				child: Row(
					children: <Widget>[
						LeftCategoryNav(),
						Column(
							children: <Widget>[
								RighCategoryNav(),
								CategoryGoodsList()
							],
						)
					],
				),
			),
		);
	}

}

// 左侧大类导航
class LeftCategoryNav extends StatefulWidget {
	@override
	_LeftCategoryNavState createState() => _LeftCategoryNavState();
}

class _LeftCategoryNavState extends State<LeftCategoryNav> {
	List list = [];
	var listIndex = 0;

	@override
	void initState() {
		// TODO: implement initState
		_getCategory();
		_getGoodsList();
		super.initState();
	}
	@override
	Widget build(BuildContext context) {
		return Container(
			width: ScreenUtil().setWidth(180),
			decoration: BoxDecoration(
				border: Border(
					right: BorderSide(color: Colors.black12, width: 1)
				)
			),
			child: ListView.builder(
				itemCount: list.length,
				itemBuilder: (BuildContext context, index) {
					return _leftInkWell(index);
				},
			),
		);
	}

	Widget _leftInkWell(int index) {
		bool isChick = false;
		isChick = (index == listIndex) ? true : false;
		return InkWell(
			onTap: () {
				setState(() {
					listIndex = index;
				});
				var childList = list[index].bxMallSubDto;
				var categoryId = list[index].mallCategoryId;
				Provide.value<ChildCategory>(context).getChildCategory(childList, categoryId);
				_getGoodsList(categoryId: categoryId);
			},
			child: Container(
				height: ScreenUtil().setHeight(100),
				padding: EdgeInsets.only(left: 10, top: 20),
				decoration: BoxDecoration(
					color: isChick? Color.fromRGBO(236, 236, 236, 1.0): Colors.white,
					border: Border(
						bottom: BorderSide(width: 1, color: Colors.black12)
					)
				),
				child: Text(list[index].mallCategoryName, style: TextStyle(fontSize: ScreenUtil().setSp(28)),),
			),
		);
	}


	void _getCategory() async{
		await request('getCategory').then((val) {
			var data = json.decode(val.toString());
			CategoryModel category = CategoryModel.fromJson(data);
			// print('-------------->${xx}');
			setState(() {
				list = category.data;
			});
			Provide.value<ChildCategory>(context).getChildCategory(list[listIndex].bxMallSubDto, list[listIndex].mallCategoryId);
			// category.data.forEach((item) => print(item.mallCategoryName));
		});
	}
	
	// 获取右侧商品数据
	void _getGoodsList({String categoryId}) async{
		var data = {
			'categoryId': categoryId == null? '4': categoryId,
			'categorySubId': '',
			'page': 1
		};
		request('getMallGoods', formData: data).then((val){
			var data = json.decode(val.toString());
			CategoryGoodsListModel goodsList = CategoryGoodsListModel.fromJson(data);
			Provide.value<CategoryGoodsListProvide>(context).getGoodsList(goodsList.data);
			// print('分类商品列表----------------->${goodsList.data[0].goodsName}');
		});
	}
}

// 右边的二级导航及内容
class RighCategoryNav extends StatefulWidget {
	@override
	_RighCategoryNavState createState() => _RighCategoryNavState();
}

class _RighCategoryNavState extends State<RighCategoryNav> {

	// List list = ['名酒', '宝丰', '北京二锅头', '茅台', '五粮液', '剑南春', '舍得', '劲酒'];

	Widget _rightInkWell(int index,BxMallSubDto item) {
		bool isClick = false;
		isClick = (index == Provide.value<ChildCategory>(context).childIndex) ? true : false;
		return InkWell(
			onTap: () {
				// Provide
				Provide.value<ChildCategory>(context).changeChildIndex(index);
				_getGoodsList(categorySubId:item.mallSubId);
			},
			child: Container(
				padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
				child: Center(
					child: Text(
						item.mallSubName,
						style: TextStyle(
							fontSize: ScreenUtil().setSp(28),
							color: isClick? Colors.pink : Colors.black
						),
					),
				),
			),
		);
	}
		// 获取右侧商品数据
	void _getGoodsList({String categorySubId}) async{
		var data = {
			'categoryId': Provide.value<ChildCategory>(context).categoryId,
			'categorySubId': categorySubId,
			'page': 1
		};
		request('getMallGoods', formData: data).then((val){
			var data = json.decode(val.toString());
			CategoryGoodsListModel goodsList = CategoryGoodsListModel.fromJson(data);
			Provide.value<CategoryGoodsListProvide>(context).getGoodsList(goodsList.data);
			// print('分类商品列表----------------->${goodsList.data[0].goodsName}');
		});
	}
	@override
	Widget build(BuildContext context) {
		return Provide<ChildCategory>(
			builder: (context, child, childCategory){
				return Container(
					height: ScreenUtil().setHeight(80),
					width: ScreenUtil().setWidth(570),
					decoration: BoxDecoration(
						color: Colors.white,
						border: Border(
							bottom: BorderSide(
								width: 1,
								color: Colors.black12
							)
						)
					),
					child: ListView.builder(
						scrollDirection: Axis.horizontal,
						itemCount: childCategory.childCategoryList.length,
						itemBuilder: (context, index) {
							return _rightInkWell(index, childCategory.childCategoryList[index]);
						},
					),
				);
			},
		);
	}
}

// 商品列表， 可以实现上拉加载
class CategoryGoodsList extends StatefulWidget {
	@override
	// 商品列表， 可以实现上拉加载
	_CategoryGoodsListState createState() => _CategoryGoodsListState();
}

// 商品列表， 可以实现上拉加载
class _CategoryGoodsListState extends State<CategoryGoodsList> {

	@override
	void initState() {
		super.initState();
	}
	@override
	Widget build(BuildContext context) {
		return Provide<CategoryGoodsListProvide>(
			builder: (BuildContext context, child, data) {
				// Expanded 解决高度溢出的bug  是flexible  伸缩布局
				return Expanded(
					child: Container(
						width: ScreenUtil().setWidth(570),
						child: ListView.builder(
							itemCount: data.goodsList.length,
							itemBuilder: (context, index) {
								return _listItem(data.goodsList, index);
							},  
						),
					)
				);
			},
		);
	}


	// 商品图片
	Widget _goodsImage(List newList,int index) {
		return Container(
			width: ScreenUtil().setWidth(200),
			child: Image.network(newList[index].image),
		);
	}

	// 商品名称
	Widget _goodsName(List newList,int index) {
		return Container(
			padding: EdgeInsets.all(5.0),
			width: ScreenUtil().setWidth(370),
			child: Text(
				newList[index].goodsName,
				maxLines: 2,
				overflow: TextOverflow.ellipsis,
				style: TextStyle(fontSize: ScreenUtil().setSp(28)),
			),
		);
	}

	// 商品价格
	Widget _goodsPrice(List newList,int index) {
		return Container(
			width: ScreenUtil().setWidth(370),
			margin: EdgeInsets.only(top: 20),
			child: Row(
				children: <Widget>[
					Text(
						'价格：￥${newList[index].presentPrice}',
						style: TextStyle(color: Colors.pink, fontSize: ScreenUtil().setSp(30)),
					),
					Text(
						'价格：￥${newList[index].oriPrice}',
						style: TextStyle(color: Colors.black26, decoration: TextDecoration.lineThrough),
					)
				],
			),
		);
	}

	// 组合右侧商品
	Widget _listItem(List newList,int index) {
		return InkWell(
			onTap: () {},
			child: Container(
				padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
				decoration: BoxDecoration(
					color: Colors.white,
					border: Border(
						bottom: BorderSide(width: 1, color: Colors.black12)
					)
				),
				// color: Colors.white,
				child: Row(
					children: <Widget>[
						_goodsImage(newList, index),
						Column(
							children: <Widget>[
								_goodsName(newList, index),
								_goodsPrice(newList, index)
							],
						)
					],
				),
			),
		);
	}
}