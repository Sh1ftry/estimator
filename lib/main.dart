import 'package:flutter/material.dart';
import 'package:estimator/screens/home.dart';
import 'package:estimator/routes.dart';
import 'package:get/get.dart';

void main() {
  runApp(GetMaterialApp(
    home: Home(),
    routes: routes,
  ));
}
