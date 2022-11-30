import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

// ignore: camel_case_types
class API_SETTINGS {
  // ignore: non_constant_identifier_names
  static final String APM_TEST_KEY = "65f767a8-fc75-4688-aaf7-7191b4768baa";
  // ignore: non_constant_identifier_names
  static final String APM_RELEASE_KEY = "65f767a8-fc75-4688-aaf7-7191b4768baa";

  static const String BASE_URL_TEST = "http://jameson.ibec.systems/api/v1/";
  static const String BASE_URL_PROD = "https://admin.jameson.kz/api/v1/";

  static const String APM_URL_TEST = "https://api-dev.apmcheck.ru/api/receipts";
  static const String APM_URL_PROD = "https://api.apmcheck.ru/api/receipts";

  static const String APM_URL = APM_URL_PROD;
  // ignore: non_constant_identifier_names
  static final String APM_KEY = APM_RELEASE_KEY;
  static const String BASE_URL = BASE_URL_PROD;

 
}

class AppSettings {
   Future<String> getTempTakedPhotoPath() async {
    Directory appDocDir = await getTemporaryDirectory();
    String appDocPath = appDocDir.path;
    var uuid = UniqueKey().toString();
    return "$appDocPath/temp_photo$uuid.png";
  }
}
