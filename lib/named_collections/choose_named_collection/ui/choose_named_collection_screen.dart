import 'package:d20_dice_roller/app_wide_strings.dart';
import 'package:d20_dice_roller/core/base_collection_models/named_multi_collection_model.dart';
import 'package:d20_dice_roller/core/base_collection_rows/named_multi_collection_row.dart';
import 'package:d20_dice_roller/named_collections/choose_named_collection/bloc/view_named_collections_bloc.dart';
import 'package:d20_dice_roller/roller/bloc/roller_screen_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChooseNamedCollectionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ViewNamedCollectionsBloc model;
    RollerScreenBloc rollerScreenModel;
    model = Provider.of<ViewNamedCollectionsBloc>(context);
    rollerScreenModel = Provider.of<RollerScreenBloc>(context);
    return StreamBuilder<List<NamedMultiCollectionModel>>(
      stream: null,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<dynamic> itemsToDisplay = prepareChooseScreenRows(model);
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
                      prepareRowsToAdd(itemsToDisplay, rollerScreenModel));
                  Navigator.of(context)
                      .pushReplacementNamed(AppWideStrings.rollerScreenPath);
                },
              )
            ],
          );
        }else{
          return Container();
        }

    }
    );
  }

  List<dynamic> prepareChooseScreenRows(
      ViewNamedCollectionsBloc model) {
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
    List<dynamic> savedCollectionRows = model.namedMultiCollections.map((collection) {
      return NamedMultiCollectionRow.forChoose(collection, model.deleteFile);
    }).toList();
    itemsToDisplay.addAll(savedCollectionRows);
    return itemsToDisplay;
  }

  List<NamedMultiCollectionRow> prepareRowsToAdd(
      List<dynamic> list, RollerScreenBloc rollerScreenModel) {
    List<NamedMultiCollectionRow> toAdd = [];
    list.forEach((row) {
      if (row is NamedMultiCollectionRow) {
        if (row.collectionModel.checkBox) {
          for (int i = 0; i < row.collectionModel.counterState; i++) {
            toAdd.add(NamedMultiCollectionRow.forRoller(row.collectionModel,
                rollerScreenModel.dismissNamedMultiCollectionRollerRow));
          }
        }
      }
    });
    return toAdd;
  }
}
