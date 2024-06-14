import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NewsData {
  final int id;
  final DateTime date;
  final String title;
  final String content;
  final String excerpt;
  final String author;
  final String imageUrl;
  final String selfUrl;
  final String category;
  final String authorpp;
  final String link;

  NewsData({
    required this.id,
    required this.date,
    required this.title,
    required this.content,
    required this.excerpt,
    required this.author,
    required this.imageUrl,
    required this.selfUrl,
    required this.category,
    required this.authorpp,
    required this.link
  });

  factory NewsData.fromJson(Map<String, dynamic> json) {
    String category = '';
    String authorpp = '';
    String author = '';
    String imageUrl = '';

    try {
      category = json['yoast_head_json']['schema']['@graph'][0]['keywords'][0] ?? '';
    } catch (e) {
      print('Error accessing category: $e');
    }

    try {
      authorpp = json['yoast_head_json']['schema']['@graph'][6]['image']['url'] ?? '';
    } catch (e) {
      print('Error accessing authorpp: $e');
    }

    try {
      author = json['yoast_head_json']['author'] ?? '';
    } catch (e) {
      print('Error accessing author: $e');
    }

    try {
      imageUrl = json['yoast_head_json']['schema']['@graph'][0]['thumbnailUrl'] ?? '';
    } catch (e) {
      print('Error accessing imageUrl: $e');
    }

    return NewsData(
      id: json['id'],
      date: DateTime.parse(json['date']),
      title: json['title']['rendered'],
      content: json['content']['rendered'],
      excerpt: json['excerpt']['rendered'],
      author: author,
      imageUrl: imageUrl,
      selfUrl: json['_links']['self'][0]['href'],
      category: category,
      authorpp: authorpp,
      link : json['link']
    );
  }
}
