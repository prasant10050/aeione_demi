import 'package:aeione_demo/constants/routeConstants.dart';
import 'package:aeione_demo/main.dart';
import 'package:aeione_demo/pages/accountScreen.dart';
import 'package:aeione_demo/pages/loginScreen.dart';
import 'package:flutter/material.dart';
class Router{
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homeRoute:
        return MaterialPageRoute(builder: (_) => MyApp());
      case loginRoute:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case accountRoute:
        Map<String,dynamic> data = settings.arguments as Map;
        return MaterialPageRoute(
          builder: (_) {
            return AccountScreen(
              loginResponse: data,
            );
          },
        );
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
              body: Center(
                  child: Text('No route defined for ${settings.name}')),
            ));
    }
  }
}