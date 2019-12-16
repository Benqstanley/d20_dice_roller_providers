import 'package:flutter/cupertino.dart';

class NamedCollectionBaseModel extends ChangeNotifier {
  final String path;
  final String name;
  bool checkBox;
  int counterState = 1;

  NamedCollectionBaseModel(this.name, {this.path});

  void changeCheckbox(bool newValue) {
    checkBox = newValue;
    notifyListeners();
  }

  void increment() {
    counterState++;
    notifyListeners();
  }

  void decrement() {
    if (counterState > 1) {
      counterState--;
    } else {
      counterState = 1;
      checkBox = false;
    }
    notifyListeners();
  }
}
