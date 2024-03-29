import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:english_words/english_words.dart';
import 'secondPage.dart';
import './pages/index_page.dart';
import 'package:provide/provide.dart';
import './provide/counter.dart';
import './provide/age.dart';
import './provide/child_category.dart';
import './provide/category_goods_list.dart';
import './provide/detail_info.dart';
import './provide/cart.dart';
import './provide/currentIndex.dart';

import 'package:oktoast/oktoast.dart';
import 'package:fluro/fluro.dart';
import './routers/routes.dart';
import './routers/application.dart';

// 顶层注入 Provide
void main(){
	var counter = Counter();
	var childCategory = ChildCategory();
	var categoryGoodsListProvide = CategoryGoodsListProvide();
	var detailInfoProvide = DetailInfoProvide();
	var cartProvide = CartProvide();
	var currentIndexProvide = CurrentIndexProvide();
	var providers = Providers();
	

	providers
	// ..provide(Provider<Counter>.value(counter)) // 多个状态
	// ..provide(Provider.function((context) => Age(2))) // 多个状态
	..provide(Provider<Age>.value(Age(2)))
	..provide(Provider<Counter>.value(counter))
	..provide(Provider<ChildCategory>.value(childCategory))
	..provide(Provider<DetailInfoProvide>.value(detailInfoProvide))
	..provide(Provider<CartProvide>.value(cartProvide))
	..provide(Provider<CurrentIndexProvide>.value(currentIndexProvide))
	..provide(Provider<CategoryGoodsListProvide>.value(categoryGoodsListProvide));
	// runApp(new MyApp());
	runApp(ProviderNode(child: MyApp(), providers: providers));
}

class MyApp extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		// final wordPair = new WordPair.random();

		// 路由注入
		final router = Router();
		Routes.configureRoutes(router);
		Application.router = router; // 这里才完成了静态化定义

		return OKToast(
			child: new MaterialApp(
				title: '百姓生活+',
				// 注入路由 flutter自带
				onGenerateRoute: Application.router.generator,
				theme: new ThemeData(
					primaryColor: Colors.pink,
				),
				// home: new RandomWords(),
				// home: new MyScaffold(),
				home: new IndexPage(),
			),
		);
	}
}


// 创建一个 有状态的wordRandomState widget
// 创建一个 无限滚动ListView

class RandomWords extends StatefulWidget {
	@override
	createState() => new RandomWordsState();
}

// 创建一个 无限滚动ListView 也是在
class RandomWordsState extends State<RandomWords> {
	final _suggestions = <WordPair>[];

	final _saved = new Set<WordPair>();

	final _biggerFont = const TextStyle(fontSize: 18.0);
	void __pushSaved() {
		Navigator.of(context).push(
			new MaterialPageRoute(
				builder: (context) {
					final tiles = _saved.map(
						(pair) => new ListTile(
						 title: new Text(
							 pair.asPascalCase,
							 style: _biggerFont,
							 ), 
						)
					);
					final divided = ListTile
						.divideTiles(
							context: context,
							tiles: tiles
						)
						.toList();
					return new Scaffold(
						appBar: new AppBar(
							title: new Text('Saved Suggestions'),
						),
						body: new ListView(children: divided), 
					);
				},
			),
		);
	}
	@override
	Widget build(BuildContext context) {

		// final wordPair = new WordPair.random();
		// return new Text(wordPair.asPascalCase);
		return new Scaffold(
		 appBar: new AppBar(
			 title: new Text('Starup Name Generator'),
			 actions: <Widget>[
				 new IconButton(icon: new Icon(Icons.list), onPressed: __pushSaved,)
			 ],
		 ), 
		 body: _buildSuggestions()
		);
	}
	
	Widget _buildSuggestions() {
		return new ListView.builder(
			padding: const EdgeInsets.all(16.0),
			itemBuilder: (context, i) {
				if (i.isOdd) return new Divider();
				final index = i ~/ 2;
				if (index >= _suggestions.length) {
					_suggestions.addAll(generateWordPairs().take(10));
				}
				return _buildRow(_suggestions[index]);
			}
		);
	}

	Widget _buildRow(WordPair pair) {
		final alreadySaved = _saved.contains(pair);

		return new ListTile(
			title: new Text(
				pair.asPascalCase,
				style: _biggerFont,        
			),
			trailing: new Icon(
				alreadySaved ? Icons.favorite : Icons.favorite_border,
				color: alreadySaved ? Colors.red : null,
			),
			onTap: () {
				setState(() {
					if (alreadySaved) {
						_saved.remove(pair);
					} else {
						_saved.add(pair);
					}
				});
			},
		);
	}
}

class MyAppBar extends StatelessWidget {
	// 这就是参数
	MyAppBar({this.title});
	// Widget子类中的字段往往都会定义为"final"
	
	final Widget title;

	@override
	Widget build(BuildContext context) {
		return new Container(
			height: 56.0, // 单位是逻辑上的像素（并非真实的像素，类似于浏览器中的像素）
			padding: const EdgeInsets.symmetric(horizontal: 8.0),
			// decoration: new BoxDecoration(color: Colors.blue[500]),
			// Row 是水平方向的线性布局（linear layout）
			child: new Row(
				//列表项的类型是 <Widget>
				children: <Widget>[
					new IconButton(
						icon: new Icon(Icons.menu),
						tooltip: 'Navigation menu',
						onPressed: null, // null 会禁用 button
					),
					// Expanded expands its child to fill the available space.
					new Expanded(
						child: title,
					),
					new IconButton(
						icon: new Icon(Icons.search),
						tooltip: 'Search',
						onPressed: null,
					),
				],
			),
		);
	}
}

class MyScaffold extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		// Material 是UI呈现的“一张纸”
		return new Material(
			// Column is 垂直方向的线性布局.
			
			child: new Column(
				children: <Widget>[
					new MyAppBar(
						title: new Text(
							'Example title',
							style: Theme.of(context).primaryTextTheme.title,
						),
					),
					new Expanded(
						child: new Center(
							child: new Text('Hello, world!'),
						),
					),
					new ButtonRender(),
					new SecondPage()
				],
			),
		);
	}
}


class ButtonRender extends StatefulWidget {
	ButtonRender({this.key});
	final GlobalKey key;
	@override
	State<StatefulWidget> createState() {
		// TODO: implement createState
		return new MyButton();
	}
}

class MyButton extends State<ButtonRender> {
	void _turnPage () {
		Navigator.of(context).push(
			new MaterialPageRoute(
				builder: (context) {
					return new Scaffold(
						appBar: new AppBar(
							title: new Text('Saved Suggestions'),
						),
						body: new Center(
							child: new Text('hello'),
						), 
					);
				},
			),
		);
	}

	@override
	Widget build(BuildContext context) {
		// 手势
		return new GestureDetector(
			onTap: _turnPage,
			child: new Container(
				height: 36.0,
				width: 750.0,
				padding: const EdgeInsets.all(8.0),
				margin: const EdgeInsets.symmetric(horizontal: 8.0),
				// 装饰
				decoration: new BoxDecoration(
					borderRadius: new BorderRadius.circular(5.0),
					color: Colors.red[500],
					// color: Theme.of(context).colorScheme.background
				),
				child: new Container(child: new Text('Engage',textAlign: TextAlign.right)),
			),
		);
	}
}


// void main() {
//   runApp(new MaterialApp(
//     title: 'Flutter Tutorial',
//     home: new TutorialHome(),
//   ));
// }

// class TutorialHome extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     //Scaffold是Material中主要的布局组件.
//     return new Scaffold(
//       appBar: new AppBar(
//         leading: new IconButton(
//           icon: new Icon(Icons.menu),
//           tooltip: 'Navigation menu',
//           onPressed: null,
//         ),
//         title: new Text('Example title'),
//         actions: <Widget>[
//           new IconButton(
//             icon: new Icon(Icons.search),
//             tooltip: 'Search',
//             onPressed: null,
//           ),
//         ],
//       ),
//       //body占屏幕的大部分
//       body: new Center(
//         child: new Text('Hello, world!'),
//       ),
//       // 全局浮动
//       floatingActionButton: new FloatingActionButton(
//         tooltip: 'Add', // used by assistive technologies
//         child: new Icon(Icons.add),
//         onPressed: null,
//       ),
//     );
//   }
// }