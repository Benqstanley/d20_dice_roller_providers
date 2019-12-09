import 'package:d20_dice_roller/main.dart';
import 'package:d20_dice_roller/named_collections/choose_named_collection/model/view_named_collections_model.dart';
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

class ViewNamedCollectionsContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var model = Provider.of<ViewNamedCollectionsModel>(context);
    model.printNamedMultis();
    return Center(child: RaisedButton(
      child: Text("Read Saved Files"),
      onPressed: () async {
        print(await model.getSavedFiles());
    },
    ),);
  }
}
