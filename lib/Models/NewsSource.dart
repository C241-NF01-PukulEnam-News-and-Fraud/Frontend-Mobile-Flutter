import 'package:flutter/cupertino.dart';

class NewsSource {
  NewsSource({
    this.photo,
  });

  ImageProvider? photo;
  static List<NewsSource> tabIconsList = <NewsSource>[
    NewsSource(
      photo: AssetImage("assets/images/rior.jpg"),
    ),
    NewsSource(
      photo: AssetImage("assets/images/rior.jpg"),
    ),
    NewsSource(
      photo: AssetImage("assets/images/rior.jpg"),
    ),
    NewsSource(
      photo: AssetImage("assets/images/rior.jpg"),
    ),
    NewsSource(
      photo: AssetImage("assets/images/rior.jpg"),
    ),
    NewsSource(
      photo: AssetImage("assets/images/rior.jpg"),
    )
  ];
}
