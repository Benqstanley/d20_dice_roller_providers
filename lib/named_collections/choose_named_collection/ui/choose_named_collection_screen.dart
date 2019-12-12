import 'package:d20_dice_roller/named_collections/choose_named_collection/model/view_named_collections_bloc.dart';
import 'package:d20_dice_roller/named_collections/choose_named_collection/ui/choose_named_collection_row.dart';
import 'package:d20_dice_roller/roller/model/roller_screen_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ViewNamedCollections extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (context) => ViewNamedCollectionsBloc(),
      child: ViewNamedCollectionsContent(),
    );
  }
}

class ViewNamedCollectionsContent
    extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    ViewNamedCollectionsBloc model;
    if (model == null) {
      model = Provider.of<ViewNamedCollectionsBloc>(context);
    }
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
      return ChooseNamedCollectionRow(collection, model.deleteFile);
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
          onPressed: (){

          },
        )
      ],
    );
  }
}
