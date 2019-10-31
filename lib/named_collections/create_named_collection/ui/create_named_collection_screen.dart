import 'package:d20_dice_roller/app_wide_strings.dart';
import 'package:d20_dice_roller/main.dart';
import 'package:d20_dice_roller/named_collections/create_named_collection/model/create_named_collection_model.dart';
import 'package:d20_dice_roller/uikit/screen_divider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateNamedCollection extends StatelessWidget {
  final bool canBeMulti;

  CreateNamedCollection({this.canBeMulti = true});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (ctx) {
        return NamedCollectionModel();
      },
      child: CreateNamedCollectionContents(
        canBeMulti: canBeMulti,
      ),
    );
  }
}

class CreateNamedCollectionContents extends StatelessWidget {
  final TextEditingController nameEditingController = TextEditingController();
  final bool canBeMulti;

  CreateNamedCollectionContents({
    this.canBeMulti = true,
  });

  @override
  Widget build(BuildContext context) {
    NamedCollectionModel namedCollectionModel =
        Provider.of<NamedCollectionModel>(context);
    bool isMultiPart = canBeMulti && namedCollectionModel.isMultiPart;
    return PageWrapper(
      appBar: AppBar(
        title: Text(AppWideStrings.createCollectionTitle),
      ),
      displayDrawer: canBeMulti,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            buildNameAndTypeRow(
              context,
              namedCollectionModel,
            ),
            Expanded(
                child: isMultiPart
                    ? buildMultiPartCreator(
                        namedCollectionModel: namedCollectionModel,
                        context: context,
                      )
                    : buildSinglePartCreator(
                        namedCollectionModel: namedCollectionModel)),
          ],
        ),
      ),
    );
  }

  Widget buildNameAndTypeRow(
    BuildContext context,
    NamedCollectionModel namedCollectionModel,
  ) {
    return Row(
      children: <Widget>[
        Expanded(
          child: TextField(
            controller: nameEditingController,
            decoration: InputDecoration(
              hintText: canBeMulti ? "Name Your Collection" : "Name This Part",
            ),
          ),
        ),
        if (canBeMulti)
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

  Widget buildMultiPartCreator({
    NamedCollectionModel namedCollectionModel,
    BuildContext context,
  }) {
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
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (ctx) => ChangeNotifierProvider.value(
                              value: namedCollectionModel,
                              child: CreateNamedCollectionContents(
                                canBeMulti: false,
                              ),
                            )));
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
