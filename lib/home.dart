import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swy_novel/pages/shelf.dart';
import 'package:swy_novel/pages/classify.dart';
import 'package:swy_novel/pages/search.dart';

class BookReaderHomePage extends StatefulWidget {
  BookReaderHomePage({Key key}) : super(key: key);

  @override
  createState() => _BookReaderHomePageState();
}

class _BookReaderHomePageState extends State<BookReaderHomePage> {
  int _tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        body: IndexedStack(
            children: <Widget>[
              ShelfPage(),
              ClassifyPage(),
              SearchPage()
            ],
            index: _tabIndex),
        bottomNavigationBar: CupertinoTabBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Image.asset('images/icon_tab_bookshelf_n.png'),
                  activeIcon:
                  Image.asset('images/icon_tab_bookshelf_p.png'),
                  title: Text('书架', style: TextStyle(fontSize: 14))),
              BottomNavigationBarItem(
                  icon: Image.asset('images/icon_tab_home_n.png'),
                  activeIcon: Image.asset('images/icon_tab_home_p.png'),
                  title: Text('书城', style: TextStyle(fontSize: 14))),
              BottomNavigationBarItem(
                  icon: Image.asset('images/icon_tab_me_n.png'),
                  activeIcon: Image.asset('images/icon_tab_me_p.png'),
                  title: Text('我的', style: TextStyle(fontSize: 14)))
            ],
            backgroundColor: Colors.white,
            inactiveColor: Color(0xFF333333),
            activeColor: Color(0xFF33C3A5),
            currentIndex: _tabIndex,
            onTap: (index) => setState(() => _tabIndex = index)));
  }
}
