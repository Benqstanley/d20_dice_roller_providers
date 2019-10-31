import 'package:d20_dice_roller/app_wide_strings.dart';
import 'package:d20_dice_roller/main.dart';
import 'package:d20_dice_roller/named_collections/create_named_collection/model/create_named_collection_model.dart';
import 'package:d20_dice_roller/uikit/screen_divider.dart';
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
  final TextEditingController nameEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    NamedCollectionModel namedCollectionModel =
        Provider.of<NamedCollectionModel>(context);
    bool isMultiPart = namedCollectionModel.isMultiPart;
    return PageWrapper(
      appBar: AppBar(
        title: Text(AppWideStrings.createCollectionTitle),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            buildNameAndTypeRow(context),
            Expanded(
                child: isMultiPart
                    ? buildMultiPartCreator(
                        namedCollectionModel: namedCollectionModel)
                    : buildSinglePartCreator(
                        namedCollectionModel: namedCollectionModel)),
          ],
        ),
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
            controller: nameEditingController,
            decoration: InputDecoration(hintText: "Name Your Collection"),
          ),
        ),
        Column(
          children: <Widget>[
            Text("Multi"),
            Checkbox(
              value: namedCollectionModel.isMultiPart,
              onChanged: (newValue) =>
                  namedCollectionModel.changeMultiPartStatus(newValue),
            )
          ],
        )
      ],
    );
  }

  Widget buildMultiPartCreator({NamedCollectionModel namedCollectionModel}) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: namedCollectionModel.parts.isNotEmpty
                  ? ListView(
                      shrinkWrap: true,
                      children: namedCollectionModel.parts,
                    )
                  : Center(child: Text("There's Nothing Here Yet")),
            ),
            ScreenDivider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                RaisedButton(
                  child: Text('Clear'),
                  onPressed: () {
                    namedCollectionModel.resetCurrentList();
                  },
                ),
                RaisedButton(
                  child: Text('Add Part'),
                  onPressed: () {
                    namedCollectionModel
                        .addSingleTypeCollectionRowForCurrentPart();
                  },
                ),
                RaisedButton(
                  child: Text('Save'),
                  onPressed: () {},
                ),
              ],
            )
          ],
        ));
  }

  Widget buildSinglePartCreator({NamedCollectionModel namedCollectionModel}) {
    return buildPartCreator(namedCollectionModel: namedCollectionModel);
  }

  //Will be the main body of buildSinglePartCreator()
  //Will also be used
  Widget buildPartCreator({NamedCollectionModel namedCollectionModel}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (namedCollectionModel.isMultiPart)
            TextField(
              decoration: InputDecoration(hintText: "Name This Part"),
            ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount:
                  namedCollectionModel.currentPart.singleTypeCollections.length,
              itemBuilder: (ctx, int) {
                return namedCollectionModel
                    .currentPart.singleTypeCollections[int];
              },
            ),
          ),
          ScreenDivider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              RaisedButton(
                child: Text('Clear'),
                onPressed: () {
                  namedCollectionModel.resetCurrentList();
                },
              ),
              RaisedButton(
                child: Text('Add Row'),
                onPressed: () {
                  namedCollectionModel
                      .addSingleTypeCollectionRowForCurrentPart();
                },
              ),
              RaisedButton(
                child: Text('Save'),
                onPressed: () {},
              ),
            ],
          )
        ],
      ),
    );
  }
}
