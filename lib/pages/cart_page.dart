import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:provide/provide.dart';
import '../provide/cart.dart';
import './cart_page/cart_item.dart';
import './cart_page/cart_bottom.dart';

class CartPage extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: Text('购物车'),
			),
			body: FutureBuilder(
				future: _getCartInfo(context),
				builder: (context, snapshot){
					if (snapshot.hasData) {
						// List cartList = Provide.value<CartProvide>(context).cartList;
						return Stack(
              alignment: Alignment.center,
							children: <Widget>[
                Provide<CartProvide>(
                  builder: (context, child, val) {
                    // List cartList = Provide.value<CartProvide>(context).cartList;
                    List cartList = val.cartList;
                    return ListView.builder(
                      itemCount: cartList.length,
                      itemBuilder: (context, index){
                        return CartItem(cartList[index]);
                      },
                    );
                  },
                ),
								// 定位父元素有点不是很清楚
								Positioned(
									bottom: 0,
									left: 0,
									child: CartBottom(),
								),
							],
							// pos
							// CartBottom
						);
					} else {
						return Text('正在加载');
					}
				},
			),
		);
	}

	Future<String> _getCartInfo(BuildContext context) async {
		await Provide.value<CartProvide>(context).getCartInfo();
		return 'end';
	}
}