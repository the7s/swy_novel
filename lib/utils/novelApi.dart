import '../utils/NetworkManager.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';
import '../models/Classify.dart';
import '../models/Novel.dart';
import '../models/Intro.dart';
import '../models/Detail.dart';
import '../models/Chapter.dart';

get_classify_data() async {
  var response = await BqgNetworkManager.httpGet('/', null);
  List classifyList = html_parse(response);
  return classifyList;
}

getNovelListByClassifyId(int classifyId,String url) async{
  var response = await BqgNetworkManager.httpGet('/$url/', null);
  List<Novel> novelList = html_parse_novel_list(response,classifyId);
  return novelList;
}

getNovelInro(String url) async{
  if(url.contains('http://www.xbiquge.la')){
    url = url.replaceAll('http://www.xbiquge.la', '');
  }
  var response = await BqgNetworkManager.httpGet('/$url/', null);
  Novel novelIntro = html_parse_novel_intro(response,url);
  return novelIntro;
}

getNovelDetail(String url) async{
  if(url.contains('http://www.xbiquge.la')){
    url = url.replaceAll('http://www.xbiquge.la', '');
  }
  var response = await BqgNetworkManager.httpGet(url, null);
  Detail novelDetail = html_parse_novel_detail(response,url);
  return novelDetail;
}
getNovelChapterList(String url) async{
  if(url.contains('http://www.xbiquge.la')){
    url = url.replaceAll('http://www.xbiquge.la', '');
  }
  var response = await BqgNetworkManager.httpGet(url, null);
  List<Chapter> chapterList = html_parse_chapter_list(response);
  return chapterList;
}

getSearchNovelList(String keyword) async{
  var params ={
    'searchkey':keyword,
  };
  var paramsMap = new Map<String, dynamic>.from(params);
  var response = await BqgNetworkManager.httpGet('/modules/article/waps.php', paramsMap);
  Document document = parse(response.toString());
  // 这里使用css选择器语法提取数据
  List<Element> novels =
      document.querySelectorAll('#content table>tbody>tr');
  novels.removeAt(0);
  List<Novel> data = [];
  if (novels.isNotEmpty) {
    data = List.generate(novels.length, (i) {
      return Novel(
            novelId: novels[i].querySelectorAll('td')[0].querySelector('a').attributes['href'],
            // classifyId: classifyId,
            authorName: novels[i].querySelectorAll('td')[2].text,
            bookName:novels[i].querySelectorAll('td')[0].querySelector('a').text,
            bookDesc:'',
            bookImageUrl: null,
            bookUrl: novels[i].querySelectorAll('td')[0].querySelector('a').attributes['href'],
            lastUpdateAt: '0000-00-00'
      );});
  }
  return data;
}

List<Chapter> html_parse_chapter_list(html){
  Document document = parse(html.toString());
  // 这里使用css选择器语法提取数据
  List<Element> chapterList =
      document.querySelectorAll('.box_con')[1].querySelectorAll('#list>dl>dd');
  List<Chapter> data = [];

  data = List.generate(chapterList.length, (i) {
      return Chapter(
        uuid: chapterList[i].querySelector('a').attributes['href'],
        name: chapterList[i].querySelector('a').text,
        url: chapterList[i].querySelector('a').attributes['href'],
      );

    });

  return data;
}

Detail html_parse_novel_detail(html,url){
  Document document = parse(html.toString());
  // 这里使用css选择器语法提取数据
  Element detailElem =
      document.querySelector('.box_con');
  detailElem.querySelector('#content>p').remove();
  String data = detailElem.querySelector('#content').innerHtml;
  data = data.replaceAll('<br>&nbsp;','<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;').replaceAll('<br>','</p>');
  data = data.replaceAll('\n','');

  return Detail(
            novelId: url,
            title: detailElem.querySelector('.bookname>h1').text,
            content: data,
            prevUrl: detailElem.querySelectorAll('.bottem1>a')[1].attributes['href'],
            nextUrl: detailElem.querySelectorAll('.bottem1>a')[3].attributes['href'],
            );
}

Novel html_parse_novel_intro(html,url){
  Document document = parse(html.toString());
  // 这里使用css选择器语法提取数据
  Element novelElem =
      document.querySelector('.box_con');
  Element novelMainElem = novelElem.querySelector('#maininfo');
  return Novel(
            novelId:url,
            bookName: novelMainElem.querySelector('#info>h1').text,
            authorName: novelMainElem.querySelectorAll('#info>p:')[0].text,
            // classifyName: '玄幻小说',
            lastUpdateAt: novelMainElem.querySelectorAll('#info>p:')[2].text,
            bookDesc:novelMainElem.querySelector('#intro>p:last-child').text,
            recentChapterUrl: document.querySelectorAll('.box_con')[1].querySelectorAll('#list>dl>dd')[0].querySelector('a').attributes['href'],
            bookImageUrl:novelElem.querySelector('#sidebar>#fmimg>img').attributes['src'],
            );
}

// 数据的解析
html_parse(html) {
  Document document = parse(html.toString());
  // 这里使用css选择器语法提取数据
  List<Element> novels =
      document.querySelectorAll('.nav>ul>li:not(:last-child)');
  novels = novels.sublist(2, novels.length-1);
  List<Classify> data = [];
  if (novels.isNotEmpty) {
    data = List.generate(novels.length, (i) {
      print(novels[i].attributes['alt']);
      if (novels[i].querySelector('a') != null) {
        String path = novels[i].querySelector('a').attributes['href'].toString();
        path = path.substring(1,path.length-1);

        return Classify(
            id: i+1,
            desc: novels[i].querySelector('a').innerHtml,
            path: path);
      }
    });
  }
  return data;
}

// 数据的解析
html_parse_novel_list(html,classifyId) {
  Document document = parse(html.toString());
  // 这里使用css选择器语法提取数据
  List<Element> novels =
      document.querySelectorAll('#main>#content>#hotcontent>div>.item');
  List<Novel> data = [];
  if (novels.isNotEmpty) {
    data = List.generate(novels.length, (i) {

      return Novel(
            novelId: novels[i].querySelector('.image>a').attributes['href'],
            classifyId: classifyId,
            authorName: novels[i].querySelector('dl>dt>span').innerHtml,
            bookName:novels[i].querySelector('.image>a>img').attributes['alt'],
            bookDesc:'',
            bookImageUrl: novels[i].querySelector('.image>a>img').attributes['src'],
            bookUrl: novels[i].querySelector('.image>a').attributes['href'],
            lastUpdateAt: '0000-00-00'
            );

    });
  }
  return data;
}
