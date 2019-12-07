import 'package:aeione_demo/app/repository/repository.dart';
import 'package:flutter/material.dart';

enum MODEL_NAME {
  REPOSITORY,
}

class RepositoryWidget extends InheritedModel<MODEL_NAME> {
  final Repository repository;

  RepositoryWidget(
      {Key key,
      this.repository,
      Widget child})
      : super(key: key, child: child);

  static RepositoryWidget of(BuildContext context, {MODEL_NAME aspect}) {
    return InheritedModel.inheritFrom<RepositoryWidget>(context,
        aspect: aspect);
  }

  @override
  bool updateShouldNotify(RepositoryWidget old) {
    return repository != old.repository;
  }

  @override
  bool updateShouldNotifyDependent(
      RepositoryWidget oldWidget, Set<MODEL_NAME> aspects) {
    // TODO: implement updateShouldNotifyDependent
    return (aspects.contains(MODEL_NAME.REPOSITORY) &&
            oldWidget.repository != repository);
  }
}
