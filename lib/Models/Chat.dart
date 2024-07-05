import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatData {
  final String Response;

  ChatData({
    required this.Response,

  });

  factory ChatData.fromJson(Map<String, dynamic> json) {



    return ChatData(
      Response: json['generatedOutput'],
    );
  }
}
