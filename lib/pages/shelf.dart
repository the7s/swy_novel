import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:math';
import 'dart:convert';
// import 'package:dio/dio.dart';
import './read.dart';
import '../models/Novel.dart';
import '../utils/color.dart';
import '../components/BottomAppBar.dart';
import '../components/NovelItem.dart';
import '../components/LoadingView.dart';
// import '../components/ToastDialog.dart';

class ShelfPage extends StatefulWidget {
  @override
  State createState() => _ShelfPageState();
}

class _ShelfPageState extends State<ShelfPage> {
  List<Novel> _shelfList = []; // 书架列表
  bool _whetherDelete = false; // 是否删除
  bool _whetherLoading = true; //

  @override
  void initState() {
    // _fetchToken();
    _fetchShelfList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (_whetherLoading) {
      content = Center(child: LoadingView());
    } else {
      if (_shelfList.length > 0) {
        content = _buildShelfList();
      } else {
        content = _buildEmpty();
      }
    }

    return Scaffold(
      appBar: _buildAppBar(),
      body: Container(
        color: MyColor.bgColor,
        child: content,
      ),
      bottomNavigationBar: MyBottomAppBar(
        currentIndex: 0,
      ),
    );
  }

  Widget _buildAppBar() {
    List<Widget> actions = [];
    if (_shelfList.length > 0) {
      actions.add(FlatButton(
        child: Text(
          _whetherDelete ? '完成' : '编辑',
          style: TextStyle(color: Colors.black45),
        ),
        onPressed: () {
          setState(() {
            _whetherDelete = !_whetherDelete;
          });
        },
      ));
    }

    return AppBar(
      title: Text(
        '书架',
        style: TextStyle(color: MyColor.appBarTitle),
      ),
      backgroundColor: MyColor.bgColor,
      elevation: 0,
      actions: actions,
      brightness: Brightness.light,
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image(
            width: 150.0,
            height: 150.0,
            image: AssetImage("lib/images/empty.png"),
          ),
          FlatButton(
            child: Text(
              '书架空空，去书屋逛逛吧~~',
              style: TextStyle(color: MyColor.linkColor),
            ),
            padding: EdgeInsets.symmetric(vertical: 60.0),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/classify', (Route<dynamic> route) => false);
            },
          )
        ],
      ),
    );
  }

  Widget _buildShelfList() {
    return ListView(
      children: <Widget>[
        Card(
          margin: EdgeInsets.all(10.0),
          elevation: 0,
          child: Container(
              padding: EdgeInsets.all(20.0),
              child: GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 20.0,
                crossAxisSpacing: 20.0,
                childAspectRatio: 0.75, // 宽 / 高 = 0.7
                padding: EdgeInsets.all(5.0),
                children: List.generate(_shelfList.length, (index) {
                  Novel novel = _shelfList[index];
                  return _buildShelfItem(novel);
                }),
              )),
        ),
      ],
    );
  }

  Widget _buildShelfItem(Novel novel) {
    List<Widget> content = [];
    content.add(
      NovelItem(bookName: novel.bookName, authorName: novel.authorName,bookImageUrl: novel.bookImageUrl,),
    );
    if (_whetherDelete) {
      content.add(Align(
        alignment: Alignment.topRight,
        child: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            _deleteShelf(novel.novelId);
          },
        ),
      ));
    }

    return GestureDetector(
      child: Stack(
        children: content,
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReadPage(
              url: novel.recentChapterUrl,
              bookName: novel.bookName,
              novelId: novel.novelId,
            ),
          ),
        );
      },
    );
  }

  _fetchShelfList() async {
    setState(() {
      _whetherLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      String shelfListStr = prefs.getString('shelfList');
      List<Novel> shelfList = [];
      List data = jsonDecode(shelfListStr);
      data.forEach((item) {
        shelfList.add(Novel.fromJson(item));
      });
      
      setState(() {
        _shelfList = shelfList;
      });
    } catch (e) {
      print(e);
    }

    setState(() {
      _whetherLoading = false;
    });
  }


  _deleteShelf(String novelId) async {
    setState(() {
      _whetherLoading = true;
    });

    try {
      //删除本地缓存 ，删除全部(debug)
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String shelfListStr = prefs.getString('shelfList');
      List shelfList = [];
      List data = jsonDecode(shelfListStr);
      data.forEach((item) {
        if(item['novelId'] != novelId){
          shelfList.add(item);
        }
      });
      prefs.setString('shelfList',jsonEncode(shelfList));
      setState(() {
        _whetherDelete = false;
      });
      _fetchShelfList();
    } catch (e) {
      print(e);
    }
  }
}
