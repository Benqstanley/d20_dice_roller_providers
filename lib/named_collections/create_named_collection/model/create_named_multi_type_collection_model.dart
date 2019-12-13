import 'package:d20_dice_roller/core/base_collection_models/named_multi_collection_base_model.dart';
import 'package:d20_dice_roller/core/base_collection_models/single_type_collection_base_model.dart';
import 'package:d20_dice_roller/core/base_collection_rows/single_type_collection_base_row.dart';

class CreateNamedMultiTypeCollectionModel
    extends NamedMultiCollectionBaseModel {
  String name;
  List<SingleTypeCollectionBaseRow> singleTypeCollections = [];
  var dismissRow;

  CreateNamedMultiTypeCollectionModel(Function dismiss) {
    dismissRow = (SingleTypeCollectionBaseRow toBeDismissed) =>
        dismiss(toBeDismissed, model: this);
    addSingleTypeCollectionRow();
  }

  void resetList() {
    singleTypeCollections = [];
    addSingleTypeCollectionRow();
  }

  void addSingleTypeCollectionRow() {
    singleTypeCollections.add(SingleTypeCollectionBaseRow(
        dismissRow, SingleTypeCollectionBaseModel()));
  }

  @override
  String toString() {
    return name;
  }
}
