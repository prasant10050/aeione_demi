import 'dart:async';
import 'package:aeione_demo/model/ErrorModel.dart';
import 'package:aeione_demo/model/LoginModel.dart';
import 'package:aeione_demo/model/ResponseModel.dart';
import 'package:aeione_demo/services/exception/app_exceptions.dart';
import 'package:aeione_demo/util/inheritedWidget/repoInherited.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import './bloc.dart';

class RootBloc extends Bloc<RootEvent, RootState> {
  final RepositoryWidget repositoryWidget;
  RootBloc({@required this.repositoryWidget})
      : assert(repositoryWidget != null);
  @override
  Stream<RootState> transformEvents(
      Stream<RootEvent> events,
      Stream<RootState> Function(RootEvent event) next,
      ) {
    return super.transformEvents(
      (events as Observable<RootEvent>).debounceTime(
        Duration(milliseconds: 100),
      ),
      next,
    );
  }

  @override
  void onTransition(
      Transition<RootEvent, RootState> transition) {
    super.onTransition(transition);
    print(transition);
  }

  @override
  RootState get initialState => InitialRootState();

  @override
  Stream<RootState> mapEventToState(
    RootEvent event,
  ) async* {
    try {
      if (event is ShowDialog) {
        yield DialogVisible();
      }
      if(event is HideDialog){
        yield DialogHidden();
      }
      if(event is LoginEvent){
        try{
          yield DialogVisible();
          LoginModel loginModel=LoginModel(
            clientId: "mobile",
            grantType: "password",
            username: event.userName,
            password: event.password,
          );
          var response=await repositoryWidget.repository.loginUser(bodyContent: loginModel.toJson());
          if(response is ResponseModel){
            yield DialogHidden();
            await Future.delayed(Duration(milliseconds: 100));
            if(response.status==null){
              yield FailedAccountState(failedReason: "Issues from server");
            }
            else {
              yield LoginState(responseModel: response);
            }
          }else if(response is ErrorModel){
            yield DialogHidden();
            await Future.delayed(Duration(milliseconds: 100));
            yield FailedAccountState(failedReason:response.message);
          }else{
            yield DialogHidden();
            await Future.delayed(Duration(milliseconds: 100));
            yield ErrorAccountState(failedReason: response);
          }
        }catch(e){
          print(e);
          yield DialogHidden();
          await Future.delayed(Duration(milliseconds: 100));
          yield ErrorAccountState(failedReason: e.toString());
        }
      }
      if(event is NavigateToAccountEvent){
        await Future.delayed(Duration(milliseconds: 100));
        yield NavigateToAccountState(data: event.data);
      }
      if(event is SendDataToAccountEvent){
        if(event.data!=null || event.data.isNotEmpty){
          await Future.delayed(Duration(milliseconds: 100));
          yield SendDataToAccountState(data: event.data);
        }
        else{
          yield FailedAccountState(failedReason: "No result found");
        }
      }
      if(event is ChangeAutoValidateStatusEvent){
        yield ChangeAutoValidateStatusState(status: event.status);
      }
      if(event is PasswordVisibleStatusEvent){
        yield PasswordVisibleStatusState(status: event.status);
      }
    }catch(e){
      print(e);
    }
  }
}
