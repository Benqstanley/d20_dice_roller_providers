import 'package:admob_flutter/admob_flutter.dart';
import 'package:d20_dice_roller/ads/bloc/ad_mob_bloc.dart';
import 'package:d20_dice_roller/core/base_collection_models/collection_model.dart';
import 'package:d20_dice_roller/core/base_collection_models/named_collection_model.dart';
import 'package:d20_dice_roller/core/base_collection_models/named_multi_collection_model.dart';
import 'package:d20_dice_roller/core/base_collection_models/single_type_collection_model.dart';
import 'package:d20_dice_roller/core/base_collection_rows/collection_row.dart';
import 'package:d20_dice_roller/core/base_collection_rows/single_type_collection_row.dart';
import 'package:d20_dice_roller/roller/bloc/roller_screen_bloc.dart';
import 'package:d20_dice_roller/session_history/model/session_history_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RollerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    RollerScreenBloc rollerScreenBloc = Provider.of<RollerScreenBloc>(context);
    SessionHistoryModel sessionHistoryModel =
        Provider.of<SessionHistoryModel>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(4.0),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: rollerScreenBloc.collectionModels.length +
                  rollerScreenBloc.singleTypeModels.length,
              itemBuilder: (ctx, index) {
                if (index < rollerScreenBloc.collectionModels.length) {
                  CollectionModel collectionModel =
                      rollerScreenBloc.collectionModels[index];
                  if (collectionModel is NamedMultiCollectionModel) {
                    return CollectionRow<NamedMultiCollectionModel>.forRoller(
                        collectionModel,
                        rollerScreenBloc.dismissCollectionModel);
                  } else if (rollerScreenBloc.collectionModels[index]
                      is NamedCollectionModel) {
                    return CollectionRow<NamedCollectionModel>.forRoller(
                        collectionModel,
                        rollerScreenBloc.dismissCollectionModel);
                  } else {
                    return Container();
                  }
                }
                SingleTypeCollectionModel collectionModel =
                    rollerScreenBloc.singleTypeModels[
                        index - rollerScreenBloc.collectionModels.length];
                return SingleTypeCollectionRow.forRoller(
                  collectionModel,
                  rollerScreenBloc.dismissSingleTypeCollectionModel,
                );
              },
            ),
          ),
        ),
        Container(
          height: 1,
          color: Theme.of(context).dividerColor,
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              RaisedButton(
                child: Text('Clear'),
                onPressed: () {
                  rollerScreenBloc.resetScreen();
                },
              ),
              RaisedButton(
                child: Text('Add Row'),
                onPressed: () {
                  rollerScreenBloc.addSingleTypeCollectionModel();
                },
              ),
              RaisedButton(
                child: Text('Roll'),
                onPressed: () {
                  rollerScreenBloc.rollCollections(
                    context,
                    sessionHistoryModel,
                  );
                },
              )
            ],
          ),
        ),
        AdmobBanner(
          adUnitId: AdInfo.adId,
          adSize: AdmobBannerSize.FULL_BANNER,
        ),
      ],
    );
  }
}
