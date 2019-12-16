import 'package:d20_dice_roller/core/base_collection_models/named_collection_base.dart';
import 'package:d20_dice_roller/core/base_collection_models/named_multi_collection_model.dart';
import 'package:d20_dice_roller/core/base_collection_rows/collection_row.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NamedMultiCollectionRow extends CollectionRow {
  final Function onDismissed;
  final Function handleIncrement;
  final Function handleDecrement;
  final Function handleCheckboxChanged;
  final TrailingSelector selector;

  @override
  factory NamedMultiCollectionRow.forCreate(
      NamedMultiCollectionModel collectionModel,
      Function onDismissed,
      ) {
    NamedMultiCollectionRow toReturn =
    CollectionRow<NamedMultiCollectionModel>(
      collectionModel,
      onDismissed,
      TrailingSelector.none,
    ) as NamedMultiCollectionRow;
    return toReturn;
  }

  @override
  factory NamedMultiCollectionRow.forRoller(
      NamedMultiCollectionModel collectionModel,
      Function onDismissed,
      ) {
    collectionModel.checkBox = true;
    NamedMultiCollectionRow toReturn =
    CollectionRow<NamedMultiCollectionModel>(
      collectionModel,
      onDismissed,
      TrailingSelector.checkbox,
      handleCheckboxChanged: collectionModel.changeCheckbox,
    ) as NamedMultiCollectionRow;
    return toReturn;
  }

  @override
  factory NamedMultiCollectionRow.forChoose(
      NamedMultiCollectionModel collectionModel,
      Function onDismissed,
      ) {
    collectionModel.checkBox = false;
    NamedMultiCollectionRow toReturn =
    CollectionRow<NamedMultiCollectionModel>(
      collectionModel,
      onDismissed,
      TrailingSelector.checkboxToCounter,
      handleCheckboxChanged: collectionModel.changeCheckbox,
      handleIncrement: collectionModel.increment,
      handleDecrement: collectionModel.decrement,
    ) as NamedMultiCollectionRow;
    return toReturn;
  }

}
