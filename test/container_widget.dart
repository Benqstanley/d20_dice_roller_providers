import 'package:d20_dice_roller/main.dart';
import 'package:d20_dice_roller/named_collections/create_named_collection/bloc/create_screen_bloc.dart';
import 'package:d20_dice_roller/roller/bloc/roller_screen_bloc.dart';
import 'package:d20_dice_roller/session_history/model/session_history_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContainerWidget extends StatelessWidget {
  final List<ChangeNotifier> changeNotifiers;
  final Widget child;

  ContainerWidget(this.changeNotifiers, this.child)
      : assert(changeNotifiers.length > 0);

  @override
  Widget build(BuildContext context) {

    List<SingleChildCloneableWidget> providers = [];
    providers.addAll(changeNotifiers.map((changeNotifier) {
      switch (changeNotifier.runtimeType) {
        case RollerScreenBloc:
          return ChangeNotifierProvider<RollerScreenBloc>(
            create: (context) => changeNotifier,
          );
        case SessionHistoryModel:
          return ChangeNotifierProvider<SessionHistoryModel>(
            create: (context) => changeNotifier,
          );
        case CreateScreenBloc:
          return ChangeNotifierProvider<CreateScreenBloc>(
            create: (context) => changeNotifier,
          );
        default:
          print(changeNotifier.runtimeType);
          return null;
      }
    }).toList());
    return MaterialApp(
      home: PageWrapper(
        title: child.runtimeType.toString(),
        child: MultiProvider(
          providers: providers,
          child: child,
        ),
      ),
    );
  }
}
