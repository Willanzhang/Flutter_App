import 'package:flutter/material.dart';

class Age with ChangeNotifier {
	int _age ;
	String _name = 'William';
	Age(this._age);

	int get age =>_age;
	String get name => _name;

	int setAge(age) {
		_age = age;
		notifyListeners();
	}
}