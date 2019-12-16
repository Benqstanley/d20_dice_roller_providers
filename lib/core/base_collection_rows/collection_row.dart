import 'package:d20_dice_roller/core/base_collection_models/named_collection_base.dart';
import 'package:flutter/material.dart';
enum TrailingSelector { checkbox, checkboxToCounter, none }
abstract class CollectionRow extends StatelessWidget {
  final NamedCollectionBaseModel collectionModel;

  CollectionRow(this.collectionModel);

}
