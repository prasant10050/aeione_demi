// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

import 'package:equatable/equatable.dart';

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel extends Equatable{
    final String grantType;
    final String clientId;
    final String username;
    final String password;

    LoginModel({
        this.grantType,
        this.clientId,
        this.username,
        this.password,
    });

    factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        grantType: json["grant_type"] == null ? null : json["grant_type"],
        clientId: json["client_id"] == null ? null : json["client_id"],
        username: json["username"] == null ? null : json["username"],
        password: json["password"] == null ? null : json["password"],
    );

    Map<String, dynamic> toJson() => {
        "grant_type": grantType == null ? null : grantType,
        "client_id": clientId == null ? null : clientId,
        "username": username == null ? null : username,
        "password": password == null ? null : password,
    };

  @override
  // TODO: implement props
  List<Object> get props => [grantType,clientId,username,password];
}
