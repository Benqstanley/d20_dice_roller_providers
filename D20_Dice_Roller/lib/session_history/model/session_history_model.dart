import 'package:d20_dice_roller/roller/ui/roll_result.dart';
import 'package:flutter/material.dart';

class SessionHistoryModel extends ChangeNotifier{
  TextStyle historyStyle = TextStyle(fontSize: 22);
  final List<Map<String, dynamic>> sessionResults = [];
  void addSessionResult(List<Map<String, dynamic>> currentResults){
    sessionResults.insertAll(0, currentResults.reversed);
  }

  List<Widget> sessionResultsWidgets(){
    return sessionResults.map((result) {
      return RollResult(result, historyStyle);
    }).toList();
  }

  void clearHistory(){
    sessionResults.clear();
    notifyListeners();
  }

}