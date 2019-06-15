import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import '../provide/counter.dart';
import '../provide/age.dart';

class CartPage extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		return Scaffold(
				body: Center(
					child: Column(
						children: <Widget>[
							Number(),
							MyButton(),
						],
					),
		));
	}
}

class Number extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		return Container(
			margin: EdgeInsets.only(top: 200),
			child: Provide<Counter>(
				builder: (BuildContext context, child, counter) {
					return Column(
						children: <Widget>[
							Text('${counter.value}', style: Theme.of(context).textTheme.display1,),
							Provide<Age>(
                builder: (context, child, age) {
                  print(age.age);
                  print('!!');
                  return Text('${age.age}', style: Theme.of(context).textTheme.display1,);
                },
              )
						],
					);
				},
			)
		);
	}
}

class MyButton extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		return Container(
			child: RaisedButton(
				onPressed: () {
					Provide.value<Counter>(context).increment();
					print('button');
				}, 
				child: Text('递增'),
			),
		);
	}
}