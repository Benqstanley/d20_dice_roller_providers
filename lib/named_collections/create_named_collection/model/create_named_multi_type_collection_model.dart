
import 'package:d20_dice_roller/core/single_type_collection_row.dart';

class CreateNamedMultiTypeCollectionModel {
  String name;
  List<SingleTypeCollectionRow> singleTypeCollections = [];
  var dismissRow;

  CreateNamedMultiTypeCollectionModel(Function dismiss) {
    dismissRow = (SingleTypeCollectionRow toBeDismissed) =>
        dismiss(toBeDismissed, model: this);
    addSingleTypeCollectionRow();
  }

  void resetList() {
    singleTypeCollections = [];
    addSingleTypeCollectionRow();
  }

  void addSingleTypeCollectionRow() {
    singleTypeCollections.add(SingleTypeCollectionRow(
      dismissRow,
      needsCheckbox: false,
    ));
  }

  @override
  String toString() {
    return name;
  }
}