import 'package:aeione_demo/app/bloc/aeionBlocDelegate.dart';
import 'package:aeione_demo/app/bloc/bloc.dart';
import 'package:aeione_demo/app/repository/repository.dart';
import 'package:aeione_demo/app/route/router.dart';
import 'package:aeione_demo/constants/routeConstants.dart';
import 'package:aeione_demo/pages/loginScreen.dart';
import 'package:aeione_demo/util/inheritedWidget/repoInherited.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';

void main() {
  BlocSupervisor.delegate = AeionBlocDelegate();
  WidgetsFlutterBinding.ensureInitialized();
  RepositoryWidget repositoryWidget=new RepositoryWidget(
    repository: new AppRepo(),
  );

  runApp(MyApp(repositoryWidget: repositoryWidget,));
}

class MyApp extends StatefulWidget {
  final RepositoryWidget repositoryWidget;
  MyApp({Key key, this.repositoryWidget}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RootBloc>(
          create: (context) => RootBloc(
            repositoryWidget: widget.repositoryWidget,
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: LoginScreen(),
        onGenerateRoute: Router.generateRoute,
      ),
    );
  }
}

