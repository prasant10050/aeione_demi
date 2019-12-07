import 'package:aeione_demo/model/LoginModel.dart';
import 'package:aeione_demo/model/ResponseModel.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class RootEvent extends Equatable{
  RootEvent();
  @override
  List<Object> get props => [];
}
class ShowDialog extends RootEvent {}

class HideDialog extends RootEvent {}
class LoginEvent extends RootEvent{
  final dynamic userName;
  final dynamic password;
  LoginEvent({this.userName,this.password}):assert(userName!=null && password!=null);
  @override
  List<Object> get props => [userName,password,];
}
class NavigateToAccountEvent extends RootEvent{
  final Map data;
  NavigateToAccountEvent({this.data});
  @override
  List<Object> get props => [data];
}
class SendDataToAccountEvent extends RootEvent{
  final Map data;
  SendDataToAccountEvent({this.data});
  @override
  List<Object> get props => [data];
}
class ChangeAutoValidateStatusEvent extends RootEvent{
  final bool status;
  ChangeAutoValidateStatusEvent({this.status});
  @override
  List<Object> get props => [status];
}
class PasswordVisibleStatusEvent extends RootEvent{
  final bool status;
  PasswordVisibleStatusEvent({this.status});
  @override
  List<Object> get props => [status];
}
