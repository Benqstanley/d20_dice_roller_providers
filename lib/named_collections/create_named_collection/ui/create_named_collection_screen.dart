import 'package:admob_flutter/admob_flutter.dart';
import 'package:d20_dice_roller/ads/bloc/ad_mob_bloc.dart';
import 'package:d20_dice_roller/app_wide_keys.dart';
import 'package:d20_dice_roller/app_wide_strings.dart';
import 'package:d20_dice_roller/core/base_collection_models/collection_model.dart';
import 'package:d20_dice_roller/core/base_collection_models/named_collection_model.dart';
import 'package:d20_dice_roller/core/base_collection_models/named_multi_collection_model.dart';
import 'package:d20_dice_roller/core/base_collection_rows/collection_row.dart';
import 'package:d20_dice_roller/core/base_collection_rows/single_type_collection_row.dart';
import 'package:d20_dice_roller/main.dart';
import 'package:d20_dice_roller/named_collections/create_named_collection/bloc/create_screen_bloc.dart';
import 'package:d20_dice_roller/named_collections/create_named_collection/model/named_collection_create_model.dart';
import 'package:d20_dice_roller/named_collections/create_named_collection/model/named_multi_collection_create_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateNamedCollectionScreen extends StatelessWidget {
  final CollectionModel modelToEdit;

  CreateNamedCollectionScreen({this.modelToEdit});

  factory CreateNamedCollectionScreen.forEdit(CollectionModel modelToEdit) {
    var screen = CreateNamedCollectionScreen(
      modelToEdit: modelToEdit,
    );

    return screen;
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => CreateScreenBloc(),
        ),
        ChangeNotifierProvider(create: (ctx) {
          return modelToEdit is NamedMultiCollectionModel
              ? NamedMultiCollectionCreateModel(model: modelToEdit)
              : NamedMultiCollectionCreateModel();
        }),
        ChangeNotifierProvider(create: (ctx) {
          return modelToEdit is NamedCollectionModel
              ? NamedCollectionCreateModel(model: modelToEdit)
              : NamedCollectionCreateModel();
        })
      ],
      child: CreateNamedCollectionContents(
        forEditing: modelToEdit != null,
      ),
    );
  }
}

class CreateNamedCollectionContents extends StatelessWidget {
  final bool inPart;
  final bool forEditing;

  CreateNamedCollectionContents({this.inPart = false, this.forEditing = false});

  @override
  Widget build(BuildContext context) {
    NamedMultiCollectionCreateModel namedMultiCollectionCreateModel =
        Provider.of<NamedMultiCollectionCreateModel>(context);
    NamedCollectionCreateModel namedCollectionCreateModel =
        Provider.of<NamedCollectionCreateModel>(context);
    CreateScreenBloc bloc = Provider.of<CreateScreenBloc>(context);
    bool isMulti =
        namedMultiCollectionCreateModel.namedModels.isNotEmpty && !inPart ||
            bloc.isMulti;
    return PageWrapper(
      appBar: AppBar(
        title: Text(AppWideStrings.createCollectionTitle),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.collections),
            onPressed: () => Navigator.of(context)
                .pushReplacementNamed(AppWideStrings.viewNamedCollectionsPath),
          )
        ],
      ),
      displayDrawer: !inPart && !forEditing,
      child: Column(
        key: AppWideKeys.createScreenKey,
        children: <Widget>[
          buildNameAndTypeRow(
            context,
            isMulti,
            createScreenBloc: bloc,
            namedMultiCollectionCreateModel: namedMultiCollectionCreateModel,
            namedCollectionCreateModel: namedCollectionCreateModel,
          ),
          Expanded(
            child: Padding(
                padding: EdgeInsets.all(4.0),
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
          ),
          AdmobBanner(
            adUnitId: AdInfo.adId,
            adSize: AdmobBannerSize.FULL_BANNER,
          )
        ],
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              enabled: !forEditing,
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
          if (!inPart && !forEditing)
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
      ),
    );
  }

  Widget buildMultiPartCreator({
    NamedMultiCollectionCreateModel namedMultiCollectionModel,
    NamedCollectionCreateModel namedCollectionCreateModel,
    BuildContext context,
  }) {
    return Column(
      children: <Widget>[
        Expanded(
          child: namedMultiCollectionModel.namedModels.isNotEmpty
              ? ListView.builder(
                  shrinkWrap: true,
                  itemCount: namedMultiCollectionModel.namedModels.length,
                  itemBuilder: (ctx, index) {
                    NamedCollectionModel model =
                        namedMultiCollectionModel.namedModels[index];
                    return CollectionRow<NamedCollectionModel>.forCreate(
                      model,
                      namedMultiCollectionModel.dismissMultiPartRow,
                      passParametersForEdit(context, namedMultiCollectionModel,
                          index: index),
                    );
                  })
              : Center(child: Text("There's Nothing Here Yet")),
        ),
        Container(
          height: 1,
          color: Theme.of(context).dividerColor,
        ),
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
                onPressed:
                    passParametersForEdit(context, namedMultiCollectionModel)),
            RaisedButton(
              child: Text('Save'),
              onPressed: () async {
                namedMultiCollectionModel
                    .saveCollection(forEditing: forEditing)
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
    );
  }

  Function passParametersForEdit(BuildContext context,
      NamedMultiCollectionCreateModel namedMultiCollectionCreateModel,
      {int index}) {
    var navigator = () {
      Navigator.of(context)
          .push(
        MaterialPageRoute(
          builder: (ctx) => MultiProvider(
            child: CreateNamedCollectionContents(
              inPart: true,
            ),
            providers: [
              ChangeNotifierProvider(
                create: (ctx) => CreateScreenBloc(),
              ),
              ChangeNotifierProvider.value(
                value: namedMultiCollectionCreateModel,
              ),
              ChangeNotifierProvider(
                create: (context) => NamedCollectionCreateModel(
                    model: index != null
                        ? namedMultiCollectionCreateModel.namedModels[index]
                        : null),
              ),
            ],
          ),
        ),
      )
          .then((result) {
        if (result == null) return;
        if (index != null) {
          namedMultiCollectionCreateModel.namedModels.removeAt(index);
          namedMultiCollectionCreateModel.namedModels.insert(index, result);
        } else {
          namedMultiCollectionCreateModel.absorbNamedCollection(result);
        }
      });
    };
    return navigator;
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
    NamedMultiCollectionCreateModel namedMultiCollectionCreateModel,
    NamedCollectionCreateModel namedCollectionCreateModel,
    BuildContext context,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: namedCollectionCreateModel.singleTypeCollections.length,
            itemBuilder: (ctx, index) {
              return SingleTypeCollectionRow.forCreate(
                namedCollectionCreateModel.singleTypeCollections[index],
                namedCollectionCreateModel.dismissRow,
              );
            },
          ),
        ),
        Container(
          height: 1,
          color: Theme.of(context).dividerColor,
        ),
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
                namedCollectionCreateModel.addSingleTypeCollectionModel();
              },
            ),
            RaisedButton(
              child: Text('Save'),
              onPressed: () {
                if (inPart) {
                  namedCollectionCreateModel.singleTypeCollections
                      .removeWhere((collectionModel) {
                    return !collectionModel.determineRollability();
                  });
                  NamedCollectionModel partModel;
                  if (namedCollectionCreateModel
                      .singleTypeCollections.isNotEmpty) {
                    partModel = namedCollectionCreateModel.returnModel();
                  }
                  Navigator.of(context).pop(partModel);
                } else {
                  namedCollectionCreateModel
                      .saveCollection(forEditing: forEditing)
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
    );
  }
}
