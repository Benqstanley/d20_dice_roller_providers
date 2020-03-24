import 'package:flutter/material.dart';

class CreateNamedCollectionScreenKeys{
  static Key multiStatusBox = Key('multiStatusBox');
  static Key topLevelIncrementer = Key('topLevelIncrementer');
  static Key addPartKey = Key('addPartKey');
  static Key addRowKey = Key('addRowKey');
  static Key clearScreenKey = Key('clearScreenKey');
  static Key saveCollectionKey = Key('saveCollectionKey');
  static Key nameFieldKey = Key('nameFieldKey');
  static Key multiPartCreator = Key('multiPartCreator');
  static Key partCreator = Key('partCreator');

  static Key rowIncrementerKey(int index){
    return Key('rowIncrementerKey$index');
  }
}