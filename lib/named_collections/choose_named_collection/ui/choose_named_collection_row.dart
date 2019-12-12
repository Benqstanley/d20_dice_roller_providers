import 'package:d20_dice_roller/core/named_multi_collection_model.dart';
import 'package:d20_dice_roller/named_collections/choose_named_collection/model/view_named_collections_row_cn.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChooseNamedCollectionRow extends StatelessWidget {
  final ViewNamedCollectionsRowCN changeNotifier;
  ChooseNamedCollectionRow(this.changeNotifier);

  factory ChooseNamedCollectionRow.factory(NamedMultiCollectionModel model, Function onDismiss){
    return ChooseNamedCollectionRow(ViewNamedCollectionsRowCN(model, onDismiss));
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (context) => changeNotifier,
      child: ChooseNamedCollectionRowContents(),
    );
  }

  @override
  String toStringShort() {
    return changeNotifier.model.name;
  }
}

class ChooseNamedCollectionRowContents extends StatelessWidget {
  final UniqueKey key = UniqueKey();

  ChooseNamedCollectionRowContents();

  @override
  Widget build(BuildContext context) {
    ViewNamedCollectionsRowCN rowCN =
        Provider.of<ViewNamedCollectionsRowCN>(context);
    NamedMultiCollectionModel model = rowCN.model;
    Function onDismiss = rowCN.onDismiss;
    return Dismissible(
      key: key,
      onDismissed: (_) => onDismiss(rowCN),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: model.parts
                          .map((singleTypeCollection) => Text(
                                singleTypeCollection.toString(),
                                style: TextStyle(fontSize: 16),
                              ))
                          .toList(),
                    ),
                  ),
                  rowCN.add
                      ? Flexible(
                          flex: 1,
                          child: Row(
                            children: <Widget>[
                              Flexible(
                                flex: 2,
                                child: FlatButton(
                                  child: Text('-'),
                                  onPressed: rowCN.decrement,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: InkWell(
                                  child: Container(
                                    alignment: AlignmentDirectional.centerEnd,
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                        border: Border.all(),
                                        color: Colors.white),
                                    child: Text(rowCN.numberToAdd.toString()),
                                  ),
                                  onTap: rowCN.resetNum,
                                ),
                              ),
                              Flexible(
                                flex: 2,
                                child: FlatButton(
                                  child: Text('+'),
                                  onPressed: rowCN.increment,
                                ),
                              )
                            ],
                          ),
                        )
                      : Checkbox(
                          value: rowCN.add,
                          onChanged: rowCN.changeAdd,
                        ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
