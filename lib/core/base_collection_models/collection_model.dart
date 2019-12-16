import 'package:d20_dice_roller/core/base_collection_models/single_type_collection_model.dart';
import 'package:flutter/cupertino.dart';

import 'named_collection_model.dart';

class CollectionModel extends ChangeNotifier {
  final String path;
  final String name;
  final List<SingleTypeCollectionModel> singleTypeCollections;
  final List<NamedCollectionModel> parts;
  bool checkBox;
  int counterState = 1;

  CollectionModel(this.name,
      {this.path, this.singleTypeCollections, this.parts})
      : assert(parts == null || singleTypeCollections == null);

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

  CollectionModel copy() {
    return CollectionModel(
      name,
      path: path,
      parts: parts,
      singleTypeCollections: singleTypeCollections,
    );
  }
}
