import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import './router_handler.dart';

class Routes {
	static String root = '/';
	static String detailsPage = '/detail';
	static void configureRoutes(Router router) {
		// 找不到路径时
		router.notFoundHandler = new Handler(
			handlerFunc: (BuildContext context, Map<String, List<String>> params) {
				print('ERROR ===> ROUTER WAS NOT FOUND');
			}
		);

		// 配置路由
		router.define(detailsPage, handler: detailsHandler);

	}
}