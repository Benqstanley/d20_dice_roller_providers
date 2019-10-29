import 'package:flutter/material.dart';

class SessionHistoryModel extends ChangeNotifier{
  static final List<Map<String, dynamic>> sessionResults = [];
  static void addSessionResult(List<Map<String, dynamic>> currentResults){
    sessionResults.addAll(currentResults);
  }
}