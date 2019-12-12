import 'package:d20_dice_roller/core/named_multi_collection_model.dart';
import 'package:flutter/cupertino.dart';

class ViewNamedCollectionsRowCN extends ChangeNotifier{
  NamedMultiCollectionModel model;
  int numberToAdd = 0;
  bool add = false;
  bool roll = false;
  final Function onDismiss;


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