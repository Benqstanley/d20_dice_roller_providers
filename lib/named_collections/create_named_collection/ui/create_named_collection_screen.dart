import 'package:d20_dice_roller/app_wide_strings.dart';
import 'package:d20_dice_roller/main.dart';
import 'package:d20_dice_roller/named_collections/choose_named_collection/model/view_named_collections_bloc.dart';
import 'package:d20_dice_roller/named_collections/create_named_collection/model/create_named_collection_model.dart';
import 'package:d20_dice_roller/uikit/screen_divider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateNamedCollection extends StatelessWidget {
  final bool isPartOfBigger;

  CreateNamedCollection({this.isPartOfBigger = false});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (ctx) {
        return CreateNamedCollectionModel();
      },
      child: CreateNamedCollectionContents(
        isPartOfBigger: isPartOfBigger,
      ),
    );
  }
}

class CreateNamedCollectionContents extends StatelessWidget {
  final bool isPartOfBigger;

  CreateNamedCollectionContents({
    this.isPartOfBigger = true,
  });

  @override
  Widget build(BuildContext context) {
    CreateNamedCollectionModel namedCollectionModel =
        Provider.of<CreateNamedCollectionModel>(context);
    bool isMultiPart = !isPartOfBigger && namedCollectionModel.isMultiPart;
    return PageWrapper(
      appBar: AppBar(
        title: Text(AppWideStrings.createCollectionTitle),
      ),
      displayDrawer: !isPartOfBigger,
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
                        namedCollectionModel: namedCollectionModel,
                        context: context,
                      )),
          ],
        ),
      ),
    );
  }

  Widget buildNameAndTypeRow(
    BuildContext context,
    CreateNamedCollectionModel namedCollectionModel,
  ) {
    return Row(
      children: <Widget>[
        Expanded(
          child: TextField(
            controller: namedCollectionModel.nameController(isPartOfBigger),
            decoration: InputDecoration(
              hintText:
                  !isPartOfBigger ? "Name Your Collection" : "Name This Part",
            ),
          ),
        ),
        if (!isPartOfBigger)
          Column(
            children: <Widget>[
              Text("Multi"),
              Checkbox(
                value: namedCollectionModel.isMultiPart,
                onChanged: (newValue) =>
                    namedCollectionModel.changeMultirowstatus(newValue),
              )
            ],
          )
      ],
    );
  }

  Widget buildMultiPartCreator({
    CreateNamedCollectionModel namedCollectionModel,
    BuildContext context,
  }) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: namedCollectionModel.parts.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: namedCollectionModel.parts.length,
                      itemBuilder: (ctx, index) =>
                          namedCollectionModel.rows[index],
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
                    namedCollectionModel.resetRowsList();
                  },
                ),
                RaisedButton(
                  child: Text('Add Part'),
                  onPressed: () {
                    namedCollectionModel.partEditingController =
                        TextEditingController();
                    Navigator.of(context)
                        .push(MaterialPageRoute(
                            builder: (ctx) => ChangeNotifierProvider.value(
                                  value: namedCollectionModel,
                                  child: CreateNamedCollectionContents(
                                    isPartOfBigger: true,
                                  ),
                                )))
                        .then((result) {
                      if (result is bool && result) {
                        namedCollectionModel.moveCurrentToList();
                      }
                    });
                  },
                ),
                RaisedButton(
                  child: Text('Save'),
                  onPressed: () async {
                    namedCollectionModel.saveNamedCollection().then((value) async {
                      if(value){
                        ViewNamedCollectionsBloc bloc = Provider.of<ViewNamedCollectionsBloc>(context);
                        await bloc.getSavedFiles();
                        Navigator.of(context).pushReplacementNamed(AppWideStrings.viewNamedCollectionsPath);
                      }
                    });

                  },
                ),
              ],
            )
          ],
        ));
  }

  Widget buildSinglePartCreator({
    CreateNamedCollectionModel namedCollectionModel,
    BuildContext context,
  }) {
    return buildPartCreator(
      namedCollectionModel: namedCollectionModel,
      context: context,
    );
  }

  //Will be the main body of buildSinglePartCreator()
  //Will also be used
  Widget buildPartCreator({
    CreateNamedCollectionModel namedCollectionModel,
    BuildContext context,
  }) {
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
                onPressed: () {
                  if (isPartOfBigger) {
                    namedCollectionModel.currentPart.name = namedCollectionModel
                        .nameController(isPartOfBigger)
                        .text;
                    namedCollectionModel.currentPart.singleTypeCollections
                        .removeWhere((element) {
                      return !element.collectionModel.determineValidity();
                    });
                    Navigator.of(context).pop(namedCollectionModel
                        .currentPart.singleTypeCollections.isNotEmpty);
                  }else{
                    
                  }
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
