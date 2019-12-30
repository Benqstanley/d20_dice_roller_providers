import 'package:d20_dice_roller/app_wide_strings.dart';
import 'package:d20_dice_roller/core/base_collection_models/collection_model.dart';
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

class ChooseNamedCollectionsScreen extends StatefulWidget {
  @override
  _ChooseNamedCollectionsScreenState createState() =>
      _ChooseNamedCollectionsScreenState();
}

class _ChooseNamedCollectionsScreenState
    extends State<ChooseNamedCollectionsScreen> {
  ViewNamedCollectionsBloc bloc;
  RollerScreenBloc rollerScreenBloc;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    rollerScreenBloc = Provider.of<RollerScreenBloc>(context);
    bloc = Provider.of<ViewNamedCollectionsBloc>(context);
    bloc.requestCollectionsPipe.launch();
    bloc.setContext(context);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ChangeNotifier>>(
        stream: bloc.collectionsPipe.receive,
        builder: (context, snapshot) {
          print("Stream receiving");
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState != ConnectionState.waiting &&
              !snapshot.hasData) {
            return Center(
              child: Text("There is nothing here!"),
            );
          }
          if (snapshot.hasData) {
            List<dynamic> itemsToDisplay = prepareChooseScreenRows(bloc);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    itemCount: itemsToDisplay.length + bloc.collections.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (index <= 1) {
                        return itemsToDisplay[index];
                      } else {
                        return mapCollectionToRow(
                            bloc.collections[index - 2], bloc);
                      }
                    },
                  ),
                ),
                Divider(),
                RaisedButton(
                  child: Text("Add Selection To Roller"),
                  onPressed: () {
                    rollerScreenBloc.collectionModels
                        .addAll(prepareRowsToAdd());
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
    return itemsToDisplay;
  }

  CollectionRow mapCollectionToRow(
      CollectionModel collection, ViewNamedCollectionsBloc bloc) {
    if (collection is NamedMultiCollectionModel) {
      return CollectionRow<NamedMultiCollectionModel>.forChoose(
          collection, bloc.pendingDelete);
    } else {
      return CollectionRow<NamedCollectionModel>.forChoose(
          collection, bloc.pendingDelete);
    }
  }

  List<CollectionModel> prepareRowsToAdd() {
    List<CollectionModel> toAdd = [];
    bloc.collections.forEach((collectionModel) {
      if (collectionModel is NamedMultiCollectionModel &&
          collectionModel.checkBox) {
        for (int i = 0; i < collectionModel.counterState; i++) {
          toAdd.add(collectionModel.copy());
        }
      } else if (collectionModel is NamedCollectionModel &&
          collectionModel.checkBox) {
        for (int i = 0; i < collectionModel.counterState; i++) {
          toAdd.add(collectionModel.copy());
        }
      }
    });
    print(toAdd.length);
    return toAdd;
  }
}
