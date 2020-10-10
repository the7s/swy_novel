import 'package:flutter/material.dart';

class NovelItem extends StatelessWidget {
  final String bookName;
  final String authorName;
  final String bookImageUrl;

  NovelItem({this.bookName, this.authorName,this.bookImageUrl});

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        clipBehavior: Clip.antiAlias,
        child: AspectRatio(
          aspectRatio: 0.7,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Image(
                image: bookImageUrl != null ? NetworkImage(bookImageUrl) : AssetImage('lib/images/cover.png'),
                fit: BoxFit.cover,
              ),
            ],
          ),
        ));
  }
}
