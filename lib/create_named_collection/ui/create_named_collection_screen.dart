import 'package:d20_dice_roller/app_wide_strings.dart';
import 'package:d20_dice_roller/create_named_collection/model/create_named_collection_model.dart';
import 'package:d20_dice_roller/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateNamedCollection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (ctx) {
        return NamedCollectionModel();
      },
      child: CreateNamedCollectionContents(),
    );
  }
}

class CreateNamedCollectionContents extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    NamedCollectionModel namedCollectionModel =
        Provider.of<NamedCollectionModel>(context);
    bool isMultiPart = namedCollectionModel.isMultiPart;
    return PageWrapper(
      appBar: AppBar(
        title: Text(AppWideStrings.createCollectionTitle),
        actions: <Widget>[
          if (isMultiPart)
            IconButton(
              icon: Icon(Icons.add_circle_outline),
              onPressed: () {},
            )
        ],
      ),
      child: Column(
        children: <Widget>[
          buildNameAndTypeRow(context),
          isMultiPart ? buildMultiPartCreator() : buildSinglePartCreator(),
        ],
      ),
    );
  }

  Widget buildNameAndTypeRow(BuildContext context) {
    NamedCollectionModel namedCollectionModel =
        Provider.of<NamedCollectionModel>(context);
    return Row(
      children: <Widget>[
        Expanded(
          child: TextField(
            controller: namedCollectionModel.nameEditingController,
            decoration: InputDecoration(hintText: "Name Your Collection"),
          ),
        ),
//        Column(
//          children: <Widget>[
//            Text("Multi"),
//            Checkbox(
//              value: namedCollectionModel.isMultiPart,
//              onChanged: (newValue) =>
//                  namedCollectionModel.changeMultiPartStatus(newValue),
//            )
//          ],
//        )
      ],
    );
  }

  Widget buildMultiPartCreator() {
    return Container();
  }

  Widget buildSinglePartCreator() {
    return Container();
  }

  //Will be the main body of buildSinglePartCreator()
  //Will also be used

  Widget buildPartCreator() {
    return Container();
  }
}
