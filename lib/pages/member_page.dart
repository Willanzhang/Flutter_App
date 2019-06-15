import 'package:provide/provide.dart';
import 'package:flutter/material.dart';
import '../provide/counter.dart';
import '../provide/age.dart';

class MemberPage extends StatelessWidget {
  TextEditingController ageCount = TextEditingController();
  int age = 0;
  @override
  void initState () {
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
              Provide<Counter>(
                builder: (context, child, counter){
                  return Text('${counter.value}', style: Theme.of(context).textTheme.display1,);
                },
              ),
              TextField(
                controller: ageCount,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10.0),
                  labelText: '年龄',
                  helperText: '请输入年龄'
                ),
                autofocus: false,
              ),
              RaisedButton(
                onPressed: () {
                  age = int.parse(ageCount.text);
                  print('---------> $age');
                  Provide.value<Age>(context).setAge(age);
                },
                child: Text('点击改变年龄'),
              ),
              Text('${Provide.value<Age>(context).age}'),
              Provide<Age>(
                builder: (context, child, age) {
                  print(age.age);
                  print('!!');
                  return Text('${age.name}', style: Theme.of(context).textTheme.display1,);
                },
              )

              // Provide<Counter>(
              //   builder: (context, child, counter){
              //     return Text('${counter.value}', style: Theme.of(context).textTheme.display1,);
              //   },
              // ),
          ],
        )
      )
    );
  }
}