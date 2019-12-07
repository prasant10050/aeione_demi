import 'package:aeione_demo/model/LoginModel.dart';
import 'package:aeione_demo/model/ResponseModel.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class RootState extends Equatable{
  RootState();
  @override
  List<Object> get props => [];
}

class InitialRootState extends RootState {}

class DialogHidden extends RootState {}

class DialogVisible extends RootState {}

class EmptyAccountState extends RootState{
  final dynamic failedReason;
  EmptyAccountState({this.failedReason});
  @override
  List<Object> get props => [failedReason];
}
class ErrorAccountState extends RootState{
  final dynamic failedReason;
  ErrorAccountState({this.failedReason});
  @override
  List<Object> get props => [failedReason];
}
class FailedAccountState extends RootState{
  final dynamic failedReason;
  FailedAccountState({this.failedReason});
  @override
  List<Object> get props => [failedReason];
}
class LoginState extends RootState{
  final dynamic userName;
  final ResponseModel responseModel;
  LoginState({this.userName,this.responseModel});
  @override
  List<Object> get props => [userName,responseModel];
}
class NavigateToAccountState extends RootState{
  final Map data;
  NavigateToAccountState({this.data});
  @override
  List<Object> get props => [data];
}
class SendDataToAccountState extends RootState{
  final Map data;
  SendDataToAccountState({this.data});
  @override
  List<Object> get props => [data];
}
class ChangeAutoValidateStatusState extends RootState{
  final bool status;
  ChangeAutoValidateStatusState({this.status});
  @override
  List<Object> get props => [status];
}
class PasswordVisibleStatusState extends RootState{
  final bool status;
  PasswordVisibleStatusState({this.status}):assert(status!=null);
  @override
  List<Object> get props => [status];
}