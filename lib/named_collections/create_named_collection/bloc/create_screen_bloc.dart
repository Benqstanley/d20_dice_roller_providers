import 'package:flutter/material.dart';

class CreateScreenBloc extends ChangeNotifier{
  bool isMulti = false;

  void changeMultiStatus(bool newValue){
    isMulti = newValue;
    notifyListeners();
  }

}