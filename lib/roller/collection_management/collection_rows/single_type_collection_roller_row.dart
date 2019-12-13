import 'package:d20_dice_roller/core/base_collection_rows/single_type_collection_base_row.dart';
import 'package:d20_dice_roller/roller/collection_management/collection_models/single_type_collection_roller_model.dart';

class SingleTypeCollectionRollerRow extends SingleTypeCollectionBaseRow {
  SingleTypeCollectionRollerRow(
      Function onDismissed, SingleTypeCollectionRollerModel collectionModel)
      : super(onDismissed, collectionModel,
            handleCheckbox: collectionModel.changeCheckbox);
}
