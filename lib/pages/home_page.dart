import 'package:flutter/material.dart';
import '../service/service_method.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
// 使用字符串转换
import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// 拨打号码 email等
import 'package:url_launcher/url_launcher.dart';
// 上拉加载
import 'package:flutter_easyrefresh/easy_refresh.dart';
import '../routers/application.dart';


class HomePage extends StatefulWidget {
  
	@override
	_HomePageState createState() => _HomePageState();
}

// 保存页面转态要混入 AutomaticKeepAliveClientMixin
class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  int page = 1;
  List<Map> hotGoodsList = [];
  bool flag = false;

	@override
	bool get wantKeepAlive => true;

	@override
	void initState() {
		super.initState();
	}

  // GlobalKey<EasyRefreshState> _easyRefreshKey = new GlobalKey<EasyRefreshState>();
  //使用上拉加载必须需要一个footer的key
  GlobalKey<RefreshFooterState> _footerKey = new GlobalKey<RefreshFooterState>();

	@override
	Widget build(BuildContext context) {
    // ???!!!! 这个是什么鬼
    super.build(context);
    var formData = {'lon': '115.02932', 'lat': '35.73322'};
		return Scaffold(
			appBar: AppBar(title: Text('百姓生活+')),
			body: FutureBuilder(
				future: request('homePageContext', formData: formData),
				// 异步进行的是时候组件是如何操作的 context snapshot
				builder: (context, snapshot) {
					if (snapshot.hasData) {
						// str 转 对象 
						var data = json.decode(snapshot.data.toString());
						List<Map> swipter = (data['data']['slides'] as List).cast();
						List<Map> navigatorList = (data['data']['category'] as List).cast();
						String adPicture = data['data']['advertesPicture']['PICTURE_ADDRESS'].toString();
						String  leaderImage = data['data']['shopInfo']['leaderImage'];
						String  leaderPhone = data['data']['shopInfo']['leaderPhone'];
						List<Map> recommendList = (data['data']['recommend'] as List).cast();
            String floor1Title = data['data']['floor1Pic']['PICTURE_ADDRESS'];
            List<Map> floor1 = (data['data']['floor1'] as List).cast();
            String floor2Title = data['data']['floor2Pic']['PICTURE_ADDRESS'];
            List<Map> floor2 = (data['data']['floor2'] as List).cast();
            String floor3Title = data['data']['floor3Pic']['PICTURE_ADDRESS'];
            List<Map> floor3 = (data['data']['floor3'] as List).cast();
						// List swipter = [{'image': 'http://images.baixingliangfan.cn/advertesPicture/20190116/20190116173351_2085.jpg', 'goodsId': '6fe4fe0fb5394c0d9b9b4792a827e029'},{'image': 'http://images.baixingliangfan.cn/advertesPicture/20190116/20190116173351_2085.jpg', 'goodsId': '6fe4fe0fb5394c0d9b9b4792a827e029'}];
						return EasyRefresh(
              // key: _easyRefreshKey,
              // 自定义样式
              refreshFooter: ClassicsFooter(
                key: _footerKey,
                bgColor: Colors.white,
                textColor: Colors.pink,
                moreInfoColor: Colors.pink,
                showMore: true,
                noMoreText: '',
                moreInfo: '加载中',
                loadReadyText: '上拉加载',
              ),
						  child: ListView(
						    	children: <Widget>[
						    		SwiperDiy(swiperDateList:swipter),
						    		TopNavigator(navigatorList: navigatorList),
						    		AdBanner(advertesPicture: adPicture),
						    		LeaderPhone(leaderImage: leaderImage, leaderPhone: leaderPhone),
						  			Recommend(recommendList: recommendList),
                    FloorTitle(pictureAddress: floor1Title),
                    FloorContext(floorGoodsList: floor1),
                    FloorTitle(pictureAddress: floor2Title),
                    FloorContext(floorGoodsList: floor2),
                    FloorTitle(pictureAddress: floor3Title),
                    FloorContext(floorGoodsList: floor3),
                    _hotGoods(),
						    	],
						  ),
              loadMore: () async {
                print('开始加载更过');
                var formPage = {'page': page};
                request('homePageBelowConten', formData: formPage).then((val){
                  var data = json.decode(val.toString());
                  List<Map> newGoodsList = (data['data'] as List).cast();
                  setState(() {
                    flag = true;
                    hotGoodsList.addAll(newGoodsList);
                    page++;
                  });
                });
              },
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

  // void _getHotGoods() {
  //   var formPage = {'page': page};
  //   request('homePageBelowConten', formData: formPage).then((val){
  //     var data = json.decode(val.toString());
  //     List<Map> newGoodsList = (data['data'] as List).cast();
  //     setState(() {
  //       hotGoodsList.addAll(newGoodsList);
  //       page++;
  //     });
  //   });
  // }

  Widget hotTitle = Container(
    margin: EdgeInsets.only(top:10.0),
    // 对齐方式
    alignment: Alignment.center,
    padding: EdgeInsets.all(5.0),
    color: Colors.transparent,
    child: Text('火爆专区'),
  );

  // 流式布局
  Widget _wrapList() {
    if (hotGoodsList.length != 0 ) {
      // 流式布局需要 是list<>
      List<Widget> listWidget = hotGoodsList.map((val){
        return InkWell(
          onTap: (){
            // 路由跳转 带参数
            Application.router.navigateTo(context, '/detail?id=${val['goodsId']}');
            // Router().navigateTo(context, '/detail?id=${val['goodsId']}');  无效
          },
          child: Container(
            width: ScreenUtil().setWidth(372),
            color: Colors.white,
            padding: EdgeInsets.all(5.0),
            margin: EdgeInsets.only(bottom: 3.0),
            child: Column(
              children: <Widget>[
                Image.network(val['image'], width: ScreenUtil().setWidth(370)),
                Text(
                  val['name'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.pink,
                    fontSize: ScreenUtil().setSp(26)
                  ),
                ),
                Row(
                  children: <Widget>[
                    Text('￥${val['mallPrice']}'),
                    Text(
                      "￥${val['price']}",
                      style: TextStyle(
                        color: Colors.black26,
                        decoration: TextDecoration.lineThrough
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      }).toList(); // !toList 最后还是要转化成列表
      return Wrap(
        // 流布局需要 几列
        spacing: 2,
        children: listWidget
      );
    } else {
      return Text('还没有哦');
    }

  }

  // 获取热销商品数据
  Widget _hotGoods () {
    return Container(
      child: Column(
        children: <Widget>[
          hotTitle,
          _wrapList()
        ],
      ),
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
		// 输出 设备像素密度
		// print('设备像素密度：${ScreenUtil.pixelRatio}');
		// print('设备的高：${ScreenUtil.screenHeight}');
		// print('设备像宽：${ScreenUtil.screenWidth}');
		return Container(
			// 使用ScreenUtil转换过的 数值    ScreenUtil().setSp(28, false)  字体大小 
			height: ScreenUtil().setHeight(333.0),
			width: ScreenUtil().setWidth(750.0),
			child: Swiper(
				// itemBuilder 就是遍历 列表 渲染图像 当前页面显示才执行 itemBuilder
				itemBuilder: (BuildContext context, int index) {
					return InkWell(
            onTap: () {
              Application.router.navigateTo(context, '/detail?id=${swiperDateList[index]['goodsId']}');
            },
            child: Image.network('${swiperDateList[index]['image']}', fit:BoxFit.fill));
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
        // 禁止回弹
        physics: NeverScrollableScrollPhysics(),
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

// 商品推介
class Recommend extends StatelessWidget {
	final List recommendList;
	Recommend({Key key, this.recommendList}) : super(key: key);

	// 标题方法
	Widget _titleWidget() {
		return Container(
			alignment: Alignment.centerLeft,
			padding: EdgeInsets.fromLTRB(10.0, 2.0, 0, 5.0),
			decoration: BoxDecoration(
				color: Colors.white,
				border: Border(
					bottom: BorderSide(width: 0.5, color: Colors.black12)
				)
			),
			child: Text(
				'商品推介',
				style: TextStyle(color: Colors.pink)
			),
		);
	}

	// 商品单独项
	Widget _item(context, index) {
		return InkWell(
			onTap: () {
            Application.router.navigateTo(context, '/detail?id=${recommendList[index]['goodsId']}');

      },
			child: Container(
				height: ScreenUtil().setHeight(360),
				width: ScreenUtil().setWidth(250),
				padding: EdgeInsets.all(8.0),
				decoration: BoxDecoration(
					color: Colors.white,
					border: Border(
						left: BorderSide(width: 0.5, color: Colors.black12)
					)
				),
				child: Column(
					children: <Widget>[
            //  height: ScreenUtil().setHeight(200),
						Image.network(recommendList[index]['image']),
						Text(
              '￥${recommendList[index]['mallPrice']}',
              style: TextStyle(
              ),
            ),
						Text(
							'￥${recommendList[index]['price']}',
							style: TextStyle(
								// 下划线
								decoration: TextDecoration.lineThrough,
								color: Colors.grey,
							),
						),
					],
				),
			),
		);
	}

	// 横向列表！
	Widget _recommentList() {
		return Container(
			height: ScreenUtil().setHeight(360),
			child: ListView.builder(
				scrollDirection: Axis.horizontal,
				itemCount: recommendList.length,
				itemBuilder: (context, index) {
					return _item(context, index);
				},
			)
		);
	}

	@override
	Widget build(BuildContext context) {
		return Container(
			height: ScreenUtil().setHeight(420),
			margin: EdgeInsets.only(top: 10.0),
			child: Column(
				children: <Widget>[
					_titleWidget(),
					_recommentList()
				],
			),
		);
	}
}

// 楼层标题
class FloorTitle extends StatelessWidget {
  final String pictureAddress;

  FloorTitle({Key key, this.pictureAddress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Image.network(pictureAddress),
    );
  }
}

// 楼层商品列表
class FloorContext extends StatelessWidget {
  final List floorGoodsList;
  FloorContext({Key key, this.floorGoodsList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          _fitstRow(context),
          _otherGoods(context)
        ],
      ),
    );
  }

  Widget _fitstRow(context) {
    return Row(
      children: <Widget>[
        _goodsItem(context, floorGoodsList[0]),
        Column(
          children: <Widget>[
            _goodsItem(context, floorGoodsList[1]),
            _goodsItem(context, floorGoodsList[2]),
          ],
        )
      ],
    );
  }

  Widget _otherGoods(context) {
    return Row(
      children: <Widget>[
        _goodsItem(context, floorGoodsList[3]),
        _goodsItem(context, floorGoodsList[4]),
      ],
    );
  }

  Widget _goodsItem(BuildContext context,Map goods) {
    return new Container(
      width: ScreenUtil().setWidth(375),
      child: InkWell(
        onTap: () {
            Application.router.navigateTo(context, '/detail?id=${goods['goodsId']}');
        },
        child: Image.network(goods['image']),
      ),
    );
  }
}

// 火爆专区是需要做下拉加载的
class HotGoods extends StatefulWidget {
  @override
  _HotGoodsState createState() => _HotGoodsState();
}

class _HotGoodsState extends State<HotGoods> {
  @override
    void initState() {
      super.initState();
      request('homePageBelowConten', formData: 1).then((val) {
        // print(val);
      });
    }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('hot goods'),
    );
  }
}