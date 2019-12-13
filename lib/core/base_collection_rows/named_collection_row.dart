import 'package:d20_dice_roller/core/base_collection_models/named_collection_model.dart';
import 'package:flutter/material.dart';

class NamedCollectionRow extends StatelessWidget {
  final NamedCollectionModel collectionModel;
  final Function onDismiss;
  final UniqueKey key = UniqueKey();

  NamedCollectionRow(
    this.collectionModel,
    this.onDismiss,
  );

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
                collectionModel.name + ":",
                style: TextStyle(fontSize: 18),
              ),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 8,
                  ),
                  Column(
                    children: collectionModel.singleTypeCollections
                        .map((singleTypeCollection) => Text(
                              singleTypeCollection
                                  .toString()
                                  .replaceAll(":", ", "),
                              style: TextStyle(fontSize: 16),
                            ))
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
    return collectionModel.name;
  }
}
