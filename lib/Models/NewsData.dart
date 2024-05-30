import 'dart:developer';
import 'dart:ui';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';



class NewsListData {
  NewsListData({
    this.descTxt = '',
    this.startColor = '',
    this.endColor = '',
    this.source = '',
    this.status= '',
    this.full='',
    this.photo,
  });

  String descTxt;
  String startColor;
  String endColor;
  String source;
  String status;
  String full;
  ImageProvider? photo;

  static List<NewsListData> tabIconsList = <NewsListData>[
    NewsListData(
      descTxt: 'Rio Ferdinand slams Man United\'s lack of concentration for Cole Palmer\'s 101st-minute winner for Chelsea as he points',
      startColor: '#FA7D82',
      endColor: '#FFB295',
      full: "Ferdinand was astounded by the freedom Palmer was afforded for his winner and slammed the player's focus.\n\n 'Concentration plays a huge part at the end of these games.\' He said on TNT Sports post-match. There\'s a lot riding on these games, huge pressure, I know that. In the madness and chaos, you have to have people who are really on top of their game, concentrating, pointing, yelling. Pushing people about. The corner comes for the winner.",
      photo: AssetImage("assets/images/rior.jpg"),
      source: "Mail Online",
      status: "Hoax"
    ),
    NewsListData(
        descTxt: 'Rio Ferdinand slams Man United\'s lack of concentration for Cole Palmer\'s 101st-minute winner for Chelsea as he points',
        startColor: '#FA7D82',
        endColor: '#FFB295',
        photo: AssetImage("assets/images/rior.jpg"),
        full: "Ferdinand was astounded by the freedom Palmer was afforded for his winner and slammed the player's focus.\n\n 'Concentration plays a huge part at the end of these games.\' He said on TNT Sports post-match. There\'s a lot riding on these games, huge pressure, I know that. In the madness and chaos, you have to have people who are really on top of their game, concentrating, pointing, yelling. Pushing people about. The corner comes for the winner.",
        source: "Mail Online",
        status: "Hoax"
    ),
    NewsListData(
        descTxt: 'Rio Ferdinand slams Man United\'s lack of concentration for Cole Palmer\'s 101st-minute winner for Chelsea as he points',
        startColor: '#FA7D82',
        endColor: '#FFB295',
        photo: AssetImage("assets/images/rior.jpg"),
        full: "Ferdinand was astounded by the freedom Palmer was afforded for his winner and slammed the player's focus.\n\n 'Concentration plays a huge part at the end of these games.\' He said on TNT Sports post-match. There\'s a lot riding on these games, huge pressure, I know that. In the madness and chaos, you have to have people who are really on top of their game, concentrating, pointing, yelling. Pushing people about. The corner comes for the winner.",

        source: "Mail Online",
        status: "Valid"
    ),
    NewsListData(
        descTxt: 'Rio Ferdinand slams Man United\'s lack of concentration for Cole Palmer\'s 101st-minute winner for Chelsea as he points',
        startColor: '#FA7D82',
        endColor: '#FFB295',
        photo: AssetImage("assets/images/rior.jpg"),
        full: "Ferdinand was astounded by the freedom Palmer was afforded for his winner and slammed the player's focus.\n\n 'Concentration plays a huge part at the end of these games.\' He said on TNT Sports post-match. There\'s a lot riding on these games, huge pressure, I know that. In the madness and chaos, you have to have people who are really on top of their game, concentrating, pointing, yelling. Pushing people about. The corner comes for the winner.",

        source: "Mail Online",
        status: "Hoax"
    ),
    NewsListData(
        descTxt: 'Rio Ferdinand slams Man United\'s lack of concentration for Cole Palmer\'s 101st-minute winner for Chelsea as he points',
        startColor: '#FA7D82',
        endColor: '#FFB295',
        photo: AssetImage("assets/images/rior.jpg"),
        full: "Ferdinand was astounded by the freedom Palmer was afforded for his winner and slammed the player's focus.\n\n 'Concentration plays a huge part at the end of these games.\' He said on TNT Sports post-match. There\'s a lot riding on these games, huge pressure, I know that. In the madness and chaos, you have to have people who are really on top of their game, concentrating, pointing, yelling. Pushing people about. The corner comes for the winner.",

        source: "Mail Online",
        status: "Hoax"
    ),
    NewsListData(
        descTxt: 'Rio Ferdinand slams Man United\'s lack of concentration for Cole Palmer\'s 101st-minute winner for Chelsea as he points',
        startColor: '#FA7D82',
        endColor: '#FFB295',
        photo: AssetImage("assets/images/rior.jpg"),
        full: "Ferdinand was astounded by the freedom Palmer was afforded for his winner and slammed the player's focus.\n\n 'Concentration plays a huge part at the end of these games.\' He said on TNT Sports post-match. There\'s a lot riding on these games, huge pressure, I know that. In the madness and chaos, you have to have people who are really on top of their game, concentrating, pointing, yelling. Pushing people about. The corner comes for the winner.",

        source: "Mail Online",
        status: "Hoax"
    ),
    NewsListData(
        descTxt: 'Rio Ferdinand slams Man United\'s lack of concentration for Cole Palmer\'s 101st-minute winner for Chelsea as he points',
        startColor: '#FA7D82',
        endColor: '#FFB295',
        photo: AssetImage("assets/images/rior.jpg"),
        full: "Ferdinand was astounded by the freedom Palmer was afforded for his winner and slammed the player's focus.\n\n 'Concentration plays a huge part at the end of these games.\' He said on TNT Sports post-match. There\'s a lot riding on these games, huge pressure, I know that. In the madness and chaos, you have to have people who are really on top of their game, concentrating, pointing, yelling. Pushing people about. The corner comes for the winner.",

        source: "Mail Online",
        status: "Hoax"
    )
  ];
}


 

