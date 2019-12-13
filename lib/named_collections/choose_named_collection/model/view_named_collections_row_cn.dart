import 'package:d20_dice_roller/core/base_collection_models/named_multi_collection_base_model.dart';
import 'package:flutter/material.dart';

class ViewNamedCollectionsRowCN extends ChangeNotifier{
  NamedMultiCollectionBaseModel model;
  int numberToAdd = 0;
  bool add = false;
  bool roll = false;
  final Function onDismiss;
  final Key key = UniqueKey();


  ViewNamedCollectionsRowCN(this.model, this.onDismiss);

  void increment(){
    numberToAdd++;
    notifyListeners();
  }

  void decrement(){
    if(numberToAdd >= 1) {
      numberToAdd--;
    }
    if(numberToAdd == 0){
      add = false;
    }
    notifyListeners();
  }

  void resetNum(){
    numberToAdd = 0;
    add = false;
    notifyListeners();
  }

  void changeAdd(bool value){
    add = value;
    numberToAdd = 1;
    notifyListeners();
  }

  void changeRoll(bool value){
    roll = value;
    notifyListeners();
  }
}