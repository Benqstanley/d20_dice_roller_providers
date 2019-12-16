import 'package:d20_dice_roller/app_wide_strings.dart';
import 'package:d20_dice_roller/core/base_collection_models/named_collection_model.dart';
import 'package:d20_dice_roller/core/base_collection_models/named_multi_collection_model.dart';
import 'package:d20_dice_roller/core/base_collection_rows/collection_row.dart';
import 'package:d20_dice_roller/named_collections/choose_named_collection/bloc/view_named_collections_bloc.dart';
import 'package:d20_dice_roller/roller/bloc/roller_screen_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChooseNamedCollectionsTop extends StatelessWidget {
  final ViewNamedCollectionsBloc viewNamedCollectionsBloc =
      ViewNamedCollectionsBloc();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: viewNamedCollectionsBloc,
      child: ChooseNamedCollectionsScreen(),
    );
  }
}

class ChooseNamedCollectionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ViewNamedCollectionsBloc bloc;
    RollerScreenBloc rollerScreenBloc;
    rollerScreenBloc = Provider.of<RollerScreenBloc>(context);
    bloc = Provider.of<ViewNamedCollectionsBloc>(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      bloc.requestCollectionsPipe.launch();
    });
    return StreamBuilder<List<ChangeNotifier>>(
        stream: bloc.collectionsPipe.receive,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            List<dynamic> itemsToDisplay = prepareChooseScreenRows(bloc);
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
                    rollerScreenBloc.collectionRows.addAll(
                        prepareRowsToAdd(itemsToDisplay, rollerScreenBloc));
                    Navigator.of(context)
                        .pushReplacementNamed(AppWideStrings.rollerScreenPath);
                  },
                )
              ],
            );
          } else {
            return Container();
          }
        });
  }

  List<dynamic> prepareChooseScreenRows(ViewNamedCollectionsBloc bloc) {
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
    List<dynamic> savedCollectionRows = bloc.collections.map((collection) {
      if (collection is NamedMultiCollectionModel) {
        return CollectionRow<NamedMultiCollectionModel>.forChoose(
            collection, bloc.deleteFile);
      } else {
        return CollectionRow<NamedCollectionModel>.forChoose(
            collection, bloc.deleteFile);
      }
    }).toList();
    itemsToDisplay.addAll(savedCollectionRows);
    return itemsToDisplay;
  }

  List<CollectionRow> prepareRowsToAdd(
      List<dynamic> list, RollerScreenBloc rollerScreenModel) {
    List<CollectionRow> toAdd = [];
    list.forEach((row) {
      if (row is CollectionRow) {
        if (row.collectionModel.checkBox) {
          if (row.collectionModel is NamedMultiCollectionModel) {
            for (int i = 0; i < row.collectionModel.counterState; i++) {
              toAdd.add(CollectionRow<NamedMultiCollectionModel>.forRoller(
                  row.collectionModel, rollerScreenModel.dismissCollectionRow));
            }
          } else {
            for (int i = 0; i < row.collectionModel.counterState; i++) {
              toAdd.add(CollectionRow<NamedCollectionModel>.forRoller(
                  row.collectionModel, rollerScreenModel.dismissCollectionRow));
            }
          }
        }
      }
    });
    return toAdd;
  }
}
