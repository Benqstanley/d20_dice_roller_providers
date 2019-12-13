import 'package:d20_dice_roller/core/base_collection_rows/named_multi_collection_base_row.dart';
import 'package:d20_dice_roller/roller/collection_management/collection_models/named_multi_collection_roller_model.dart';

class NamedMultiCollectionRollerRow extends NamedMultiCollectionBaseRow {
  NamedMultiCollectionRollerRow(
      NamedMultiCollectionRollerModel collectionModel, Function onDismissed)
      : super(
          collectionModel,
          onDismissed,
          handleCheckboxChanged: collectionModel.changeCheckbox,
        );
}
