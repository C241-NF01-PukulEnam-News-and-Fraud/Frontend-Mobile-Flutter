import 'dart:convert';
import 'package:flutter/material.dart';

const String menuJson = '''
{
  "menu": [
    {
      "text": "Daftar Sekarang",
      "url": "https://pukulenam.id/",
      "sub_menu": []
    },
    {
      "text": "Topik",
      "url": "https://pukulenam.id/category/harian/",
      "sub_menu": [
        {
          "text": "Kesehatan",
          "url": "https://pukulenam.id/tag/kesehatan/"
        },
        {
          "text": "Ekonomi",
          "url": "https://pukulenam.id/tag/ekonomi/"
        },
        {
          "text": "Finansial",
          "url": "https://pukulenam.id/tag/finansial/"
        },
        {
          "text": "Otomotif",
          "url": "https://pukulenam.id/tag/otomotif/"
        },
        {
          "text": "Teknologi",
          "url": "https://pukulenam.id/tag/teknologi/"
        },
        {
          "text": "Lifestyle",
          "url": "https://pukulenam.id/tag/lifestyle/"
        },
        {
          "text": "Politik",
          "url": "https://pukulenam.id/tag/politik/"
        },
        {
          "text": "Olahraga",
          "url": "https://pukulenam.id/tag/olahraga/"
        },
        {
          "text": "Hiburan",
          "url": "https://pukulenam.id/tag/hiburan/"
        },
        {
          "text": "Nasional",
          "url": "https://pukulenam.id/tag/nasional/"
        },
        {
          "text": "Internasional",
          "url": "https://pukulenam.id/tag/internasional/"
        }
      ]
    }
  ]
}
''';

class Menu {
  final String text;
  final String url;
  final List<Menu> subMenu;

  Menu({required this.text, required this.url, required this.subMenu});

  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
      text: json['text'],
      url: json['url'],
      subMenu: json['sub_menu'] != null
          ? (json['sub_menu'] as List).map((i) => Menu.fromJson(i)).toList()
          : [],
    );
  }
}