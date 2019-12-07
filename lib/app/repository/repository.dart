import 'package:aeione_demo/constants/service_constants.dart';
import 'package:aeione_demo/model/ErrorModel.dart';
import 'package:aeione_demo/model/ResponseModel.dart';
import 'package:aeione_demo/services/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:aeione_demo/constants/url_constants.dart';
import 'dart:convert';
import 'package:aeione_demo/services/exception/app_exceptions.dart';
import 'dart:async';

abstract class Repository{
  Future<dynamic> loginUser({String endPoint = LOGIN, Map<String, dynamic> bodyContent});
}
class AppRepo extends Repository{
  @override
  Future loginUser({String endPoint = LOGIN, Map<String, dynamic> bodyContent}) async {
    // TODO: implement registerUser
    var result = await DataConnectionChecker().hasConnection;
    if(result){
      var status=await DataConnectionChecker().connectionStatus;
      if(status==DataConnectionStatus.connected){
        Map<String,String> params={"cb":"${DateTime.now().millisecondsSinceEpoch ~/ 1000}"};
        var uri = Uri.https(Uri.encodeFull(BASE_URL), Uri.encodeFull(endPoint),params);
        print(uri);
        var bodyEncoded = jsonEncode(bodyContent);
        print(bodyEncoded);
        Response response;
        Dio dio = new Dio();
        dio.interceptors.add(
            LogInterceptor(requestBody: true, request: true, responseBody: true));
        response = await dio.postUri(uri, data: bodyEncoded,);
        var responseJson=_returnResponse(response);
        print("responseJson ${responseJson.toString()}");
        if(responseJson is AppException){
          return responseJson;
        }else{
          if(responseJson['status']=="error"){
            return ErrorModel.fromJson(responseJson);
          }
          else {
            return ResponseModel.fromJson(responseJson);
          }
        }
      }
      if(status==DataConnectionStatus.disconnected){
        throw FetchDataException('Error occured while Communication with Server with StatusCode : ${SERVICE_UNAVAILABLE}');
      }
    }else{
      throw FetchDataException('Error occured while Communication with Server with StatusCode : ${SERVICE_UNAVAILABLE}');
    }
  }
}
dynamic _returnResponse(Response response) {
  switch (response.statusCode) {
    case SUCCESS:
      return response.data;
    case BAD_REQUEST:
      throw BadRequestException(response.data.toString());
    case UNAUTHORIZED:
    case FORBIDDEN:
      throw UnauthorisedException(response.data.toString());
    case INTERNAL_SERVER_ERROR:
    default:
      throw FetchDataException(
          'Error occured while Communication with Server with StatusCode : ${response
              .statusCode}');
  }
}
