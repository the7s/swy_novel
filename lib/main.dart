import 'package:flutter/material.dart';
import 'package:swy_novel/home.dart';

// void main() {
//   runApp(MyApp());
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './pages/shelf.dart';
import './pages/classify.dart';
import './pages/search.dart';

void main() {
  runApp(MaterialApp(
    title: 'SWY阅读',
    initialRoute: '/',
    routes: {
      '/': (BuildContext context) => ShelfPage(),
      '/shelf': (BuildContext context) => ShelfPage(),
      '/classify': (BuildContext context) => ClassifyPage(),
      '/search': (BuildContext context) => SearchPage(),
    },
  ));

  // 设置状态栏背景颜色透明
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SWY小说',
      /// 右上角显示一个debug的图标
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: BookReaderHomePage(),
    );
  }
}
