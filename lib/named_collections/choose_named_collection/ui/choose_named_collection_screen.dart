import 'package:d20_dice_roller/app_wide_strings.dart';
import 'package:d20_dice_roller/named_collections/choose_named_collection/bloc/view_named_collections_bloc.dart';
import 'package:d20_dice_roller/named_collections/choose_named_collection/collection_management/collection_rows/named_multi_collection_choose_row.dart';
import 'package:d20_dice_roller/roller/model/roller_screen_bloc.dart';
import 'package:d20_dice_roller/roller/ui/named_multi_collection_roller_row.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChooseNamedCollectionsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    ViewNamedCollectionsBloc model;
    RollerScreenModel rollerScreenModel;
    model = Provider.of<ViewNamedCollectionsBloc>(context);
    rollerScreenModel = Provider.of<RollerScreenModel>(context);
    List<dynamic> itemsToDisplay = [
      Container(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          "Saved Collections",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ),
      Divider()
    ];
    List<dynamic> savedCollectionRows =
        model.namedMultiCollections.map((collection) {
      return NamedMultiCollectionChooseRow(collection, model.deleteFile);
    }).toList();
    itemsToDisplay.addAll(savedCollectionRows);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: ListView.builder(
            itemCount: itemsToDisplay.length,
            itemBuilder: (BuildContext context, int index) {
              return itemsToDisplay[index];
            },
          ),
        ),
        Divider(),
        RaisedButton(
          child: Text("Add Selection To Roller"),
          onPressed: () {
            rollerScreenModel.namedMultiCollections.addAll(
                prepareRowsToAdd(savedCollectionRows, rollerScreenModel));
            Navigator.of(context)
                .pushReplacementNamed(AppWideStrings.rollerScreenPath);
          },
        )
      ],
    );
  }

  List<NamedMultiCollectionRollerRow> prepareRowsToAdd(
      List<dynamic> list, RollerScreenModel rollerScreenModel) {
    List<NamedMultiCollectionRollerRow> toAdd = [];
    list.forEach((row) {
      if (row is NamedMultiCollectionChooseRow) {
        if (row.collectionModel.checkBox) {
          for (int i = 0; i < row.collectionModel.counterState; i++) {
            toAdd.add(NamedMultiCollectionRollerRow.factory(
                row.collectionModel,
                rollerScreenModel.dismissNamedMultiCollectionRollerRow));
          }
        }
      }
    });
    return toAdd;
  }
}
