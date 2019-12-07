import 'package:aeione_demo/app/bloc/bloc.dart';
import 'package:aeione_demo/model/ResponseModel.dart';
import 'package:aeione_demo/util/row_data/row_collection.dart';
import 'package:aeione_demo/util/row_data/src/separator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountScreen extends StatefulWidget {
  final Map<String,dynamic> loginResponse;

  AccountScreen({this.loginResponse});

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  RootBloc rootBloc;
  ScrollController parentScrollController = new ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Map data = {};
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initScreen();
  }
  initScreen(){
    rootBloc = BlocProvider.of<RootBloc>(context);
    rootBloc.add(SendDataToAccountEvent(data:widget.loginResponse));
  }
  @override
  Widget build(BuildContext context) {

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    Widget topAppBar = AppBar(
      title: Text("Account"),
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          _hardwareBack(context);
        },
      ),
    );
    return BlocListener<RootBloc,RootState>(
      bloc: rootBloc,
      listener: (context,state){

      },
      child: WillPopScope(
        onWillPop: ()=>_hardwareBack(context),
        child: Scaffold(
          appBar: topAppBar,
          body: _buildBody(context),
        ),
      ),
    );
  }

  _hardwareBack(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
    Navigator.of(context).maybePop();
  }

  _buildBody(BuildContext context) {
    return BlocBuilder<RootBloc,RootState>(
      bloc: rootBloc,
      builder:(context,state){
        if (state is FailedAccountState) {
          return Center(
            child: Column(
              children: <Widget>[
                Container(
                  child: Image.asset(
                    "assets/no_result.png",
                    height: MediaQuery.of(context).size.height / 3,
                  ),
                ),
                Text("No results found."),
              ],
            ),
          );
        }
        if (state is EmptyAccountState) {
          return Center(
            child: Column(
              children: <Widget>[
                Container(
                  child: Image.asset(
                    "assets/no_result.png",
                    height: MediaQuery.of(context).size.height / 3,
                  ),
                ),
                Text("No results found."),
              ],
            ),
          );
        }
        if (state is ErrorAccountState) {
          return Center(
            child: Column(
              children: <Widget>[
                Container(
                  child: Image.asset(
                    "assets/internet.png",
                    height: MediaQuery.of(context).size.height / 3,
                  ),
                ),
                Text(
                  "Slow or no internet connection\nPlease check your internet settings and try again",
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }
        if (state is SendDataToAccountState) {
          print("State ${state.data}");
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RowItem.text('Status',
                    '${(state.data.containsKey('status') != null && state.data.containsKey('status')) ? state.data['status'] : ""}'),
                Separator.divider(),
                RowItem.text('Token type',
                    '${(state.data.containsKey('token_type') != null && state.data.containsKey('token_type')) ? state.data['token_type'] : ""}'),
                Separator.divider(),
                RowItem.text('Expires-in',
                    '${(state.data.containsKey('expires_in') != null && state.data.containsKey('expires_in')) ? state.data['expires_in'] : ""}'),
                Separator.divider(),
                RowItem.text("Access-token", ""),
                Text(
                    "${(state.data.containsKey('access_token') != null && state.data.containsKey('access_token')) ? state.data['access_token'] : ""}")
              ],
            ),
          );
        }
        return Container();
      },
    );
  }
}
