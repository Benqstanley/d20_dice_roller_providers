import 'package:d20_dice_roller/main.dart';
import 'package:d20_dice_roller/named_collections/choose_named_collection/model/view_named_collections_model.dart';
import 'package:d20_dice_roller/named_collections/choose_named_collection/ui/choose_named_collection_row.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ViewNamedCollections extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (context) => ViewNamedCollectionsModel(),
      child: ViewNamedCollectionsContent(),
    );
  }
}

class ViewNamedCollectionsContent extends StatefulWidget {
  @override
  _ViewNamedCollectionsContentState createState() =>
      _ViewNamedCollectionsContentState();
}

class _ViewNamedCollectionsContentState
    extends State<ViewNamedCollectionsContent> {
  ViewNamedCollectionsModel model;

  @override
  Widget build(BuildContext context) {
    if(model == null){
      model = Provider.of<ViewNamedCollectionsModel>(context);
      model.getSavedFiles();
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
    return ListView.builder(
      itemCount: itemsToDisplay.length,
      itemBuilder: (BuildContext context, int index) {
        return itemsToDisplay[index];
      },
    );
  }
}
