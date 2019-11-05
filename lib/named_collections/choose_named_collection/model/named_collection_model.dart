import 'package:d20_dice_roller/roller/model/single_type_collection_model.dart';
import 'package:flutter/material.dart';

class NamedMultiCollectionModel {
  final String name;
  final List<NamedCollectionModel> parts;

  NamedMultiCollectionModel({
    @required this.name,
    @required this.parts,
  });
}

class NamedCollectionModel {
  final String name;
  final List<SingleTypeCollectionModel> singleTypeCollections;

  NamedCollectionModel({
    @required this.name,
    @required this.singleTypeCollections,
  });
}
