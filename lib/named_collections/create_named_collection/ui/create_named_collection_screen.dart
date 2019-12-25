import 'package:d20_dice_roller/app_wide_strings.dart';
import 'package:d20_dice_roller/core/base_collection_models/named_collection_model.dart';
import 'package:d20_dice_roller/main.dart';
import 'package:d20_dice_roller/named_collections/create_named_collection/bloc/create_screen_bloc.dart';
import 'package:d20_dice_roller/named_collections/create_named_collection/model/named_collection_create_model.dart';
import 'package:d20_dice_roller/named_collections/create_named_collection/model/named_multi_collection_create_model.dart';
import 'package:d20_dice_roller/uikit/screen_divider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateNamedCollectionScreen extends StatelessWidget {
  CreateNamedCollectionScreen();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => CreateScreenBloc(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => NamedMultiCollectionCreateModel(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => NamedCollectionCreateModel(),
        )
      ],
      child: CreateNamedCollectionContents(),
    );
  }
}

class CreateNamedCollectionContents extends StatelessWidget {
  final bool inPart;

  CreateNamedCollectionContents({this.inPart = false});

  @override
  Widget build(BuildContext context) {
    NamedMultiCollectionCreateModel namedMultiCollectionCreateModel =
        Provider.of<NamedMultiCollectionCreateModel>(context);
    NamedCollectionCreateModel namedCollectionCreateModel =
        Provider.of<NamedCollectionCreateModel>(context);
    CreateScreenBloc bloc = Provider.of<CreateScreenBloc>(context);
    bool isMulti = bloc.isMulti;
    print("rebuilding with isMulti: $isMulti");
    return PageWrapper(
      appBar: AppBar(
        title: Text(AppWideStrings.createCollectionTitle),
      ),
      displayDrawer: !inPart,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            buildNameAndTypeRow(
              context,
              isMulti,
              createScreenBloc: bloc,
              namedMultiCollectionCreateModel: namedMultiCollectionCreateModel,
              namedCollectionCreateModel: namedCollectionCreateModel,
            ),
            Expanded(
                child: isMulti
                    ? buildMultiPartCreator(
                        namedMultiCollectionModel:
                            namedMultiCollectionCreateModel,
                        namedCollectionCreateModel: namedCollectionCreateModel,
                        context: context,
                      )
                    : buildSinglePartCreator(
                        namedCollectionModel: namedCollectionCreateModel,
                        context: context,
                      )),
          ],
        ),
      ),
    );
  }

  Widget buildNameAndTypeRow(
    BuildContext context,
    bool isMulti, {
    CreateScreenBloc createScreenBloc,
    NamedMultiCollectionCreateModel namedMultiCollectionCreateModel,
    NamedCollectionCreateModel namedCollectionCreateModel,
  }) {
    return Row(
      children: <Widget>[
        Expanded(
          child: TextField(
            controller: !isMulti
                ? namedCollectionCreateModel.nameController
                : inPart
                    ? namedCollectionCreateModel.nameController
                    : namedMultiCollectionCreateModel.nameController,
            decoration: InputDecoration(
              hintText: !inPart ? "Name Your Collection" : "Name This Part",
            ),
          ),
        ),
        if (!inPart)
          Column(
            children: <Widget>[
              Text("Multi"),
              Checkbox(
                value: createScreenBloc.isMulti,
                onChanged: createScreenBloc.changeMultiStatus,
              )
            ],
          )
      ],
    );
  }

  Widget buildMultiPartCreator({
    NamedMultiCollectionCreateModel namedMultiCollectionModel,
    NamedCollectionCreateModel namedCollectionCreateModel,
    BuildContext context,
  }) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: namedMultiCollectionModel.rows.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: namedMultiCollectionModel.rows.length,
                      itemBuilder: (ctx, index) =>
                          namedMultiCollectionModel.rows[index],
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
                    namedMultiCollectionModel.resetRowsList();
                  },
                ),
                RaisedButton(
                  child: Text('Add Part'),
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(
                            builder: (ctx) => MultiProvider(
                                    child: CreateNamedCollectionContents(
                                      inPart: true,
                                    ),
                                    providers: [
                                      ChangeNotifierProvider(
                                        create: (ctx) => CreateScreenBloc(),
                                      ),
                                      ChangeNotifierProvider.value(
                                        value: namedMultiCollectionModel,
                                      ),
                                      ChangeNotifierProvider(
                                        create: (ctx) =>
                                            NamedCollectionCreateModel(),
                                      ),
                                    ])))
                        .then((result) {
                      print(result);
                      if (result != null) {
                        namedMultiCollectionModel.absorbNamedCollection(result);
                      }
                    });
                  },
                ),
                RaisedButton(
                  child: Text('Save'),
                  onPressed: () async {
                    namedMultiCollectionModel
                        .saveCollection()
                        .then((value) async {
                      if (value) {
                        //TODO: show snackbar to redirect to saved collections
                        //TODO: and refresh create screen
                        Navigator.of(context).pushReplacementNamed(
                            AppWideStrings.viewNamedCollectionsPath);
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
    NamedCollectionCreateModel namedCollectionModel,
    BuildContext context,
  }) {
    return buildPartCreator(
      namedCollectionCreateModel: namedCollectionModel,
      context: context,
    );
  }

  //Will be the main body of buildSinglePartCreator()
  Widget buildPartCreator({
    NamedCollectionCreateModel namedCollectionCreateModel,
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
              itemCount: namedCollectionCreateModel.singleTypeRows.length,
              itemBuilder: (ctx, int) {
                return namedCollectionCreateModel.singleTypeRows[int];
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
                  namedCollectionCreateModel.resetList();
                },
              ),
              RaisedButton(
                child: Text('Add Row'),
                onPressed: () {
                  namedCollectionCreateModel.addSingleTypeCollectionRow();
                },
              ),
              RaisedButton(
                child: Text('Save'),
                onPressed: () {
                  if (inPart) {
                    namedCollectionCreateModel.singleTypeRows
                        .removeWhere((element) {
                          print(element.collectionModel.determineRollability());
                      return !element.collectionModel.determineRollability();
                    });
                    NamedCollectionModel partModel;
                    if (namedCollectionCreateModel.singleTypeRows.isNotEmpty) {
                      partModel = namedCollectionCreateModel.returnModel();
                    }
                    Navigator.of(context).pop(partModel);
                  } else {
                    namedCollectionCreateModel
                        .saveCollection()
                        .then((value) async {
                      if (value) {
                        //TODO: show snackbar to redirect to saved collections
                        //TODO: and refresh create screen
                        Navigator.of(context).pushReplacementNamed(
                            AppWideStrings.viewNamedCollectionsPath);
                      }
                    });
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
