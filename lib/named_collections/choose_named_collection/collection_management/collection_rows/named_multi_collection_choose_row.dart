import 'package:d20_dice_roller/core/base_collection_rows/named_multi_collection_base_row.dart';
import 'package:d20_dice_roller/named_collections/choose_named_collection/collection_management/collection_models/named_multi_collection_choose_model.dart';

class NamedMultiCollectionChooseRow extends NamedMultiCollectionBaseRow {
  NamedMultiCollectionChooseRow(
      NamedMultiCollectionChooseModel collectionModel, Function onDismissed)
      : super(
          collectionModel,
          onDismissed,
          handleCheckboxChanged: collectionModel.changeCheckbox,
          handleIncrement: collectionModel.increment,
          handleDecrement: collectionModel.decrement,
        );
}
