import 'package:d20_dice_roller/named_collections/create_named_collection/model/create_named_multi_type_collection_model.dart';
import 'package:flutter/material.dart';

class MultiTypeRowForCreateScreen extends StatelessWidget {
  final CreateNamedMultiTypeCollectionModel model;
  final Function onDismiss;
  final UniqueKey key = UniqueKey();

  MultiTypeRowForCreateScreen(this.model, this.onDismiss);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: key,
      onDismissed: (_) => onDismiss(this),
      background: Container(
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(
              child: ListTile(
            leading: Icon(Icons.delete),
            trailing: Icon(Icons.delete),
          ))),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
              border: Border.all(), borderRadius: BorderRadius.circular(5)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                model.name + ":",
                style: TextStyle(fontSize: 18),
              ),
              Row(
                children: <Widget>[SizedBox(width: 8,),
                  Column(
                    children: model.singleTypeCollections
                        .map((singleTypeCollection) =>
                            Text(singleTypeCollection.collectionModel.toString().replaceAll(":", ", "),
                                style: TextStyle(fontSize: 16),))
                        .toList(),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  String toStringShort() {
    return model.name;
  }
}