import 'package:flutter/material.dart';
import 'package:my_flutter/utils/toast_utils.dart';
import 'package:my_flutter/utils/application.dart';

import 'component/button.dart';

void main() {
  runApp(new MaterialApp(
    home: new MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Application.context = context;
    return Scaffold(
      body: Center(
          child: Button(
              onPressed: () {
                ToastUtils.show('这是一个弹出层');
              },
              child: Text('点击弹出提示')
          )
      )
    );
  }
}
