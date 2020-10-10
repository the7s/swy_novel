import 'package:flutter/material.dart';
import './intro.dart';
import '../models/Classify.dart';
import '../models/Novel.dart';
import '../components/BottomAppBar.dart';
import '../components/NovelItem.dart';
import '../components/LoadingView.dart';
import '../utils/color.dart';
import '../utils/novelApi.dart';

class ClassifyPage extends StatefulWidget {
  @override
  State createState() => _ClassifyPageState();
}

class _ClassifyPageState extends State<ClassifyPage> {
  List<Classify> _classifyList = []; // 分类列表
  List<Novel> _novelList = []; // 小说列表
  int _selectedClassifyId = 1; // 选中分类ID
  bool _whetherNovelLoading = true;

  @override
  void initState() {
    _fetchClassifyList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Container(
        color: MyColor.bgColor,
        child: Row(children: [
          _buildClassifyList(),
          _buildNovelList(),
        ]),
      ),
      bottomNavigationBar: MyBottomAppBar(
        currentIndex: 1,
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: Text(
        '书屋',
        style: TextStyle(color: MyColor.appBarTitle),
      ),
      backgroundColor: MyColor.bgColor,
      brightness: Brightness.light,
      elevation: 0,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.search),
          color: MyColor.iconColor,
          onPressed: () {
            Navigator.pushNamed(context, '/search');
          },
        ),
      ],
    );
  }

  Widget _buildClassifyList() {
    return Expanded(
      flex: 1,
      child: ListView(
        children: List.generate(_classifyList.length, (index) {
          return _buildClassifyItem(item: _classifyList[index], index: index);
        }),
      ),
    );
  }

  Widget _buildClassifyItem({item, index}) {
    bool _isCurrent = _selectedClassifyId == item.id;
    return Container(
      child: FlatButton(
        onPressed: () {
          setState(() {
            _selectedClassifyId = item.id;
          });
          _fetchNovelList(item.id,item.path);
        },
        child: Text(
          _classifyList[index].desc,
          style: _isCurrent
              ? TextStyle(
                  color: Color.fromRGBO(44, 131, 245, 1.0),
                )
              : TextStyle(
                  color: Color.fromRGBO(128, 128, 128, 100),
                ),
        ),
      ),
    );
  }

  Widget _buildNovelList() {
    Widget content = Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 20.0, // 垂直间距
        crossAxisSpacing: 20.0, // 水平间距
        childAspectRatio: 0.75, // 宽 / 高 = 0.7
        children: List.generate(_novelList.length, (index) {
          Novel novel = _novelList[index];
          return GestureDetector(
            child: NovelItem(
              bookName: novel.bookName,
              authorName: novel.authorName,
              bookImageUrl:novel.bookImageUrl,
            ),
            onTap: () {
              String bookUrl = novel.bookUrl;
              Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                //跳转到小说详情页
                return IntroPage(url: bookUrl);
              }));
            },
          );
        }),
      ),
    );

    if (_whetherNovelLoading) {
      content = Center(child: LoadingView());
    }

    return Expanded(
      flex: 3,
      child: content,
    );
  }

  _fetchClassifyList() async {
    try {
      List<Classify> classifyModelList = await get_classify_data();
      int selectedClassifyId = classifyModelList[0].id;
      String classifyUrl = classifyModelList[0].path;
      _fetchNovelList(selectedClassifyId,classifyUrl);

      setState(() {
        _classifyList = classifyModelList;
        _selectedClassifyId = selectedClassifyId;
      });
    } catch (e) {
      print(e);
    }
  }

  _fetchNovelList(classifyId,url) async {
    setState(() {
      _whetherNovelLoading = true;
    });

    try {
      var novelResult = await getNovelListByClassifyId(classifyId, url);
      setState(() {
        _novelList = novelResult;
      });
    } catch (e) {
      print(e);
    }

    setState(() {
      _whetherNovelLoading = false;
    });
  }
}
