
import 'package:aeione_demo/app/bloc/bloc.dart';
import 'package:aeione_demo/constants/routeConstants.dart';
import 'package:aeione_demo/pages/accountScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  ScrollController parentScrollController = new ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  TextEditingController loginTextEditingController =
      new TextEditingController();
  TextEditingController passwordTextEditingController =
      new TextEditingController();
  bool _obscureText = true;
  bool _validate = false;
  RootBloc rootBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initPlatform();
  }

  initPlatform() {
    rootBloc = BlocProvider.of<RootBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    Widget topAppBar = AppBar(
      title: Text("Login"),
    );
    return BlocListener<RootBloc, RootState>(
      bloc: rootBloc,
      listener: (context, state) {
        if (state is DialogVisible) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                });
          });
        }
        if (state is DialogHidden) {
          WidgetsBinding.instance.addPostFrameCallback((_){
            Navigator.of(context).pop();
          });
        }
        if (state is NavigateToAccountState) {
          WidgetsBinding.instance.addPostFrameCallback((_){
            Navigator.of(context).pushNamed(accountRoute,arguments: state.data);
          });
        }
        if (state is FailedAccountState) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Title(
                  color: Colors.red, child: Text("${state.failedReason}")),
              duration: Duration(seconds: 2),
            ),
          );
        }
        if (state is EmptyAccountState) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Title(
                  color: Colors.red, child: Text("${state.failedReason}")),
              duration: Duration(seconds: 2),
            ),
          );
        }
        if (state is ErrorAccountState) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Title(
                  color: Colors.red, child: Text("${state.failedReason}")),
              duration: Duration(seconds: 2),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: topAppBar,
        resizeToAvoidBottomPadding: false,
        backgroundColor:Color(0xffEEF0EB),
        body: _buildBody(context),
      ),
    );
  }

  _buildBody(BuildContext context) {
    return BlocBuilder<RootBloc, RootState>(
      bloc: rootBloc,
      builder: (context, state) {
        if (state is PasswordVisibleStatusState) {
          _obscureText = !state.status;
        }
        if (state is ChangeAutoValidateStatusState) {
          _validate = state.status;
        }
        if (state is LoginState) {
          BlocProvider.of<RootBloc>(context).add(
            NavigateToAccountEvent(
              data: state.responseModel.toJson(),
            ),
          );
        }
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              child: Container(
                child: Form(
                  key: formKey,
                  autovalidate: _validate,
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    padding: EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          alignment: Alignment.center,
                          child: Text("Login",style: Theme.of(context).textTheme.title.copyWith(color: Colors.black54,fontWeight: FontWeight.w800),),
                        ),
                        TextFormField(
                          controller: loginTextEditingController,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          obscureText: true,
                          maxLines: 1,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.account_circle),
                            labelText: "Username",
                          ),
                          validator: (input) => isValidPassword(input)
                              ? null
                              : "Username must not be empty.",
                        ),
                        TextFormField(
                          controller: passwordTextEditingController,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          obscureText: _obscureText,
                          maxLines: 1,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock),
                            labelText: "Password",
                            suffixIcon: _obscureText
                                ? IconButton(
                                    icon: Icon(
                                      Icons.visibility,
                                      color: Colors.black45,
                                    ),
                                    onPressed: () {
                                      rootBloc.add(
                                        PasswordVisibleStatusEvent(
                                          status: _obscureText,
                                        ),
                                      );
                                    },
                                  )
                                : IconButton(
                                    icon: Icon(
                                      Icons.visibility_off,
                                      color: Colors.black45,
                                    ),
                                    onPressed: () {
                                      rootBloc.add(
                                        PasswordVisibleStatusEvent(
                                          status: _obscureText,
                                        ),
                                      );
                                    },
                                  ),
                          ),
                          validator: (input) => isValidPassword(input)
                              ? null
                              : "Password length must not be empty.",
                        ),
                        RaisedButton(
                          child: Text("Login"),
                          onPressed: () {
                            FocusScopeNode currentFocus =
                                FocusScope.of(context);
                            if (!currentFocus.hasPrimaryFocus) {
                              currentFocus.unfocus();
                            }
                            if (formKey.currentState.validate()) {
                              formKey.currentState.save();
                              var userName = loginTextEditingController
                                  .value.text
                                  .toString()
                                  .trim();
                              var password = passwordTextEditingController
                                  .value.text
                                  .toString()
                                  .trim();
                              rootBloc.add(LoginEvent(
                                  userName: userName, password: password));
                            } else {
                              rootBloc.add(
                                ChangeAutoValidateStatusEvent(
                                  status: true,
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  bool isValidPassword(String input) {
    if (input.trim().isEmpty) return false;
    return true;
  }

  bool isValidUsername(String input) {
    if (input.trim().isEmpty) return false;
    return true;
  }
}
