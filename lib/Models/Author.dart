import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthorData {
  final String imageUrl;
  final String selfUrl;
  AuthorData({
    required this.imageUrl,
    required this.selfUrl,
  });

  factory AuthorData.fromJson(Map<String, dynamic> json) {
    String imageUrl = '';
    String selfUrl = '';

      try {
        imageUrl = json['yoast_head_json']['schema']['@graph'][4]['image']['url'];
        if(imageUrl == null){
          imageUrl = json['avatar_urls']['96'];
        }
      } catch (e) {
        print('Error accessing authorpp: $e');
      }
    try {
      selfUrl = json['yoast_head_json']['schema']['@graph'][0]['url'] ?? json['link'];
    } catch (e) {
      print('Error accessing authorpp: $e');
    }



    return AuthorData(
      imageUrl: json['avatar_urls']['96'],
      selfUrl: json['link'],
    );
  }
}
