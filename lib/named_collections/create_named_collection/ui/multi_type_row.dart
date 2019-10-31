import 'package:d20_dice_roller/named_collections/create_named_collection/model/named_multi_type_collection_model.dart';
import 'package:flutter/material.dart';

class MultiTypeRow extends StatelessWidget {
  final NamedMultiTypeCollectionModel model;
  MultiTypeRow(this.model);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(),
      borderRadius: BorderRadius.circular(5)),
      child: Text(model.name),
    );
  }
}
