import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import './read.dart';
import '../utils/color.dart';
import '../models/Novel.dart';
import '../utils/DialogUtils.dart';
import '../components/NovelItem.dart';
import '../components/LoadingView.dart';
import '../utils/novelApi.dart';

class IntroPage extends StatefulWidget {
  final String url;
  IntroPage({this.url});

  @override
  State createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  Novel _intro;
  String _shelfId;

  @override
  void initState() {
    _fetchIntroInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (_intro == null) {
      content = Center(child: LoadingView());
    } else {
      content = ListView(
        children: <Widget>[
          _buildBookAndAuthor(),
          _buildTimeAndClassify(),
          _buildBookDesc(),
        ],
      );
    }

    return Scaffold(
      appBar: _buildAppBar(),
      body: Container(
        color: MyColor.bgColor,
        child: content,
      ),
      bottomSheet: _intro != null ? _buildBottomSheet() : null,
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      backgroundColor: MyColor.bgColor,
      brightness: Brightness.light,
      elevation: 0,
      title: Text('详情页', style: TextStyle(color: MyColor.appBarTitle)),
      leading: IconButton(
        icon: Icon(Icons.chevron_left),
        color: MyColor.iconColor,
        iconSize: 32,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _buildBottomSheet() {
    if (_shelfId != null) {
      return Row(
        children: <Widget>[
          GestureDetector(
            child: Container(
              child: Text(
                '去阅读',
                style: TextStyle(color: Colors.white),
              ),
              height: 48.0,
              width: MediaQuery.of(context).size.width / 2,
              decoration: BoxDecoration(
                color: Colors.blue,
                border: Border(top: BorderSide(color: Colors.black26)),
              ),
              alignment: Alignment.center,
            ),
            onTap: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReadPage(
                    url: _intro.recentChapterUrl,
                    bookName: _intro.bookName,
                    novelId: _shelfId,
                  ),
                ),
              );
            },
          ),
          Container(
            child: Text('在书架'),
            height: 48.0,
            width: MediaQuery.of(context).size.width / 2,
            alignment: Alignment.center,
          ),
        ],
      );
    }

    return Row(
      children: <Widget>[
        GestureDetector(
          child: Container(
            child: Text('试读'),
            height: 48.0,
            width: MediaQuery.of(context).size.width / 2,
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.black26)),
            ),
            alignment: Alignment.center,
          ),
          onTap: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ReadPage(
                  url: _intro.recentChapterUrl,
                  bookName: _intro.bookName,
                  fromPage: 'IntroPage',
                ),
              ),
            );
            if (result == 'join') {
              _postShelf();
            }
          },
        ),
        GestureDetector(
          child: Container(
            child: Text('加入书架', style: TextStyle(color: Colors.white)),
            height: 48.0,
            width: MediaQuery.of(context).size.width / 2,
            alignment: Alignment.center,
            color: Colors.blue,
          ),
          onTap: () async {
            final result = await _postShelf();
            // 跳转到首页
            if (result == true) {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/shelf', (Route<dynamic> route) => false);
            }
          },
        ),
      ],
    );
  }

  /* 第一行：小说名称和作者名称 */
  Widget _buildBookAndAuthor() {
    return Container(
      height: 180.0,
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child:
          NovelItem(authorName: _intro.authorName, bookName: _intro.bookName,bookImageUrl: _intro.bookImageUrl,),
    );
  }

  /* 第二行：更新时间和分类 */
  Widget _buildTimeAndClassify() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('小说名：' + _intro.bookName),
          Text(_intro.authorName),
        ],
      ),
    );
  }

  /* 第三行：小说简介 */
  Widget _buildBookDesc() {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.symmetric(vertical: 10.0),
      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 10.0),
            child: Text('简介', style: TextStyle(fontSize: 18.0)),
          ),
          Text(_intro.bookDesc, softWrap: true),
        ],
      ),
    );
  }

  _fetchIntroInfo() async {
    try {
      var result = await getNovelInro(widget.url);
      

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String shelfListStr = prefs.getString('shelfList');
      List shelfList  = [];
      if(shelfListStr != null && shelfListStr.length>0){
        shelfList = jsonDecode(shelfListStr);
      }
      
      Map shelf = shelfList.firstWhere(
          (item) =>
              item['novelId'] == result.novelId ,
          orElse: () {});

      if (shelf != null) {
        result.recentChapterUrl = shelf['recentChapterUrl'];
      }

      setState(() {
        _intro = result;
        _shelfId = shelf != null ? shelf['novelId'] : null;
      });
    } catch (e) {
      print(e);
    }
  }

  /* 加入书架 */
  Future<bool> _postShelf() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      String shelfListStr = prefs.getString('shelfList');
      List shelfList = [];
      if(shelfListStr != null && shelfListStr.length>0){
        shelfList = jsonDecode(shelfListStr);
      }

      var shelf_data =_intro.toJson();
      shelfList.add(shelf_data);
      prefs.setString('shelfList',jsonEncode(shelfList));
      DialogUtils.showToastDialog(context, text: '加入书架成功');
      return true;
    } catch (e) {
      DialogUtils.showToastDialog(context, text: '操作失败');
      return false;
    }

    
  }
}
