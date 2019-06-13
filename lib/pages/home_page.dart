import 'package:flutter/material.dart';
import '../service/service_method.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
// 使用字符串转换
import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// 拨打号码 email等
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
	@override
	_HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
	String homePageContent = '正在获取数据...';
	
	@override
		void initState() {
			getHomePageContent().then((val){
				setState((){
					homePageContent = val.toString();
				});
			});
			super.initState();
		}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(title: Text('百姓生活+')),
			body: FutureBuilder(
				future: getHomePageContent(),
				// 异步进行的是时候组件是如何操作的 context snapshot
				builder: (context, snapshot) {
					if (snapshot.hasData) {
						// 就是str 转 对象 
						var data = json.decode(snapshot.data.toString());
						List<Map> swipter = (data['data']['slides'] as List).cast();
						List<Map> navigatorList = (data['data']['category'] as List).cast();
						String adPicture = data['data']['advertesPicture']['PICTURE_ADDRESS'].toString();
						String  leaderImage = data['data']['shopInfo']['leaderImage'];
						String  leaderPhone = data['data']['shopInfo']['leaderPhone'];
						// List swipter = [{'image': 'http://images.baixingliangfan.cn/advertesPicture/20190116/20190116173351_2085.jpg', 'goodsId': '6fe4fe0fb5394c0d9b9b4792a827e029'},{'image': 'http://images.baixingliangfan.cn/advertesPicture/20190116/20190116173351_2085.jpg', 'goodsId': '6fe4fe0fb5394c0d9b9b4792a827e029'}];
						return Column(
							children: <Widget>[
								SwiperDiy(swiperDateList:swipter),
								TopNavigator(navigatorList: navigatorList),
								AdBanner(advertesPicture: adPicture),
								LeaderPhone(leaderImage: leaderImage, leaderPhone: leaderPhone,)
							],
						);
					} else {
						return new Center(
							// 字体大小 ScreenUtil().setSp(28)
							child: Text('加载中...', style: TextStyle(fontSize: 28.0)),
						);
					}
				},
			)
		);
	}
}

// 首页轮播组件
class SwiperDiy extends StatelessWidget {
	final List swiperDateList;
	// 官方推荐写法  带上key
	SwiperDiy({Key key, this.swiperDateList}) : super(key: key);

	@override
	Widget build(BuildContext context) {
		// 适配屏幕！！配置设计稿大小
		// 输出 设备像素密度

		print('设备像素密度：${ScreenUtil.pixelRatio}');
		print('设备的高：${ScreenUtil.screenHeight}');
		print('设备像宽：${ScreenUtil.screenWidth}');
		return Container(
			// 使用ScreenUtil转换过的 数值    ScreenUtil().setSp(28, false)  字体大小 
			height: ScreenUtil().setHeight(333.0),
			width: ScreenUtil().setWidth(750.0),
			child: Swiper(
				// itemBuilder 就是遍历 列表 渲染图像 当前页面显示才执行 itemBuilder
				itemBuilder: (BuildContext context, int index) {
					return Image.network('${swiperDateList[index]['image']}', fit:BoxFit.fill);
				},
				itemCount: swiperDateList.length,
				pagination: SwiperPagination(),
				autoplay: true,
			),
		);
	}
}

// 导航  InkWell
class TopNavigator extends StatelessWidget {
	final List navigatorList;
	TopNavigator({Key key, this.navigatorList}) : super(key: key);

	Widget _gridViewItemUI(BuildContext context, item) {
		return InkWell(
			onTap: () {
				print('点击了导航');
			},
			child: Column(
				children: <Widget>[
					Image.network(item['image'], width: ScreenUtil().setWidth(95),),
					Text(item['mallCategoryName'], overflow: TextOverflow.ellipsis,)
				],
			), 
		);
	}

	@override
	Widget build(BuildContext context) {
		if (this.navigatorList.length > 10) {
			this.navigatorList.removeRange(10, this.navigatorList.length);
		}
		return Container(
			height: ScreenUtil().setHeight(320),
			padding: EdgeInsets.all(3.0),
			child: GridView.count(
				// 每行设置的数
				crossAxisCount: 5,
				padding: EdgeInsets.all(5.0),
				children: navigatorList.map((item){
					return _gridViewItemUI(context, item);
				}).toList(),
			),
		);
	}
}

// 小广告条（小banner）组件
class AdBanner extends StatelessWidget {
	final String advertesPicture;

	AdBanner({Key key, this.advertesPicture}) : super(key: key);

	@override
	Widget build(BuildContext context) {
		return Container(
			child: Image.network(advertesPicture),
		);
	}
}

// 店长电话模块  url_launch 拨打号码
class LeaderPhone extends StatelessWidget {
	final String leaderImage;
	final String leaderPhone;

	LeaderPhone({Key key, this.leaderImage, this.leaderPhone}) : super(key: key);
	@override
	Widget build(BuildContext context) {
		return Container(
			child: InkWell(
				onTap: launchURL,
				child: Image.network(leaderImage),
			),
		);
	}

	void launchURL() async {
		String url = 'tel:' + leaderPhone;
		print('=================>$url');
		if (await canLaunch(url)) {
			await launch(url);
		} else {
			throw 'Could not launch $url';
		}
	}
}
