// To parse this JSON data, do
//
//     final responseModel = responseModelFromJson(jsonString);

import 'dart:convert';

import 'package:equatable/equatable.dart';

ResponseModel responseModelFromJson(String str) => ResponseModel.fromJson(json.decode(str));

String responseModelToJson(ResponseModel data) => json.encode(data.toJson());

class ResponseModel extends Equatable{
    final String tokenType;
    final int expiresIn;
    final String accessToken;
    final String refreshToken;
    final String status;

    ResponseModel({
        this.tokenType,
        this.expiresIn,
        this.accessToken,
        this.refreshToken,
        this.status,
    });

    factory ResponseModel.fromJson(Map<String, dynamic> json) => ResponseModel(
        tokenType: json["token_type"] == null ? null : json["token_type"],
        expiresIn: json["expires_in"] == null ? null : json["expires_in"],
        accessToken: json["access_token"] == null ? null : json["access_token"],
        refreshToken: json["refresh_token"] == null ? null : json["refresh_token"],
        status: json["status"] == null ? null : json["status"],
    );

    Map<String, dynamic> toJson() => {
        "token_type": tokenType == null ? null : tokenType,
        "expires_in": expiresIn == null ? null : expiresIn,
        "access_token": accessToken == null ? null : accessToken,
        "refresh_token": refreshToken == null ? null : refreshToken,
        "status": status == null ? null : status,
    };

  @override
  // TODO: implement props
  List<Object> get props => [tokenType,expiresIn,accessToken,refreshToken,status];
}
