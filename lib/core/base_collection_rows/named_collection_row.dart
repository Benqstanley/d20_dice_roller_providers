import 'package:d20_dice_roller/core/base_collection_models/named_collection_model.dart';
import 'package:d20_dice_roller/core/base_collection_rows/collection_row.dart';

class NamedCollectionRow extends CollectionRow {
  @override
  factory NamedCollectionRow.forCreate(
    NamedCollectionModel collectionModel,
    Function onDismissed,
  ) {
    NamedCollectionRow toReturn = CollectionRow<NamedCollectionModel>(
      collectionModel,
      onDismissed,
      TrailingSelector.none,
    ) as NamedCollectionRow;
    return toReturn;
  }

  @override
  factory NamedCollectionRow.forRoller(
    NamedCollectionModel collectionModel,
    Function onDismissed,
  ) {
    collectionModel.checkBox = true;
    NamedCollectionRow toReturn = CollectionRow<NamedCollectionModel>(
      collectionModel,
      onDismissed,
      TrailingSelector.checkbox,
      handleCheckboxChanged: collectionModel.changeCheckbox,
    ) as NamedCollectionRow;
    return toReturn;
  }

  @override
  factory NamedCollectionRow.forChoose(
    NamedCollectionModel collectionModel,
    Function onDismissed,
  ) {
    collectionModel.checkBox = false;
    NamedCollectionRow toReturn = CollectionRow<NamedCollectionModel>(
      collectionModel,
      onDismissed,
      TrailingSelector.checkboxToCounter,
      handleCheckboxChanged: collectionModel.changeCheckbox,
      handleIncrement: collectionModel.increment,
      handleDecrement: collectionModel.decrement,
    ) as NamedCollectionRow;
    return toReturn;
  }
}
