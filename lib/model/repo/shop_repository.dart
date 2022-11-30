import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:jam_app/model/api/dio_provider.dart';
import 'package:jam_app/model/api/response/response_message.dart';
import 'package:jam_app/model/api/rest_client.dart';
import 'package:jam_app/model/entity/user.dart';
import 'package:jam_app/model/local/pref.dart';
import 'package:jam_app/presentation/screen/home/features/shop/model/product_item.dart';
import 'package:jam_app/presentation/screen/home/features/shop/model/shop_item.dart';
import 'package:jam_app/utils/const.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class ShopRepository {
  var dio = DioProvider.instance();

  LocalPref pref;

  ShopRepository({@required this.pref});

  Future<User> getUser() async {

    final client = RestClient(dio);
    var token = await this.phone;
    return await client.getProfile(token);
  }

  Future<String> get phone async {
    return await this.pref.getString("isRegistered");
  }

  Future<List<ShopItem>> getCatalogs() async {
    final client = RestClient(dio);
    return await client.getCatalogList();
  }

  Future<List<ShopItem>> getCatalogFiltered({String order, String type}) async {
    final client = RestClient(dio);
    return await client.getCatalogListFilter(order: order, type: type);
  }

  Future<List<ProductItem>> getCatalogsID(int id) async {
    final client = RestClient(dio);
    return await client.getCatalogWithID(id);
  }

  Future<MessageResponse> doOrder(Map map) async {
    final client = RestClient(dio);
    return await client.doOrder(map);
  }

  Future<File> compressAndGetFile(File file) async {
    final dir = await getTemporaryDirectory();
    var random = Uuid().v1();
    final targetPath = dir.absolute.path + "/$random.jpg";

    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 50,
    );

    print(file.lengthSync());
    print(targetPath);
    print(result.lengthSync());

    return result;
  }

  Future<bool> sendChecksUpdated(
      {@required List<File> files, @required String id}) async {
    List<File> compressedImages = [];

    for (File file in files) {
      var compressed = await compressAndGetFile(file);
      compressedImages.add(compressed);
    }

    var formData = FormData.fromMap({
      "id": id,
      "platform": Platform.isAndroid ? "android" : "ios",
    });

    for (File file in compressedImages) {
      formData.files.addAll([
        MapEntry("images[]", await MultipartFile.fromFile(file.path)),
      ]);
    }
    // ignore: unused_local_variable
    Response response;
    try {
      response = await dio.post(API_SETTINGS.BASE_URL + "storeChecknew",
          data: formData,
          options: Options(
            headers: {"Accept": "application/json"},
          ));
    } on DioError catch (e) {
      throw (e.response.data);
    }

    return true;
  }

  Future<bool> sendPhotos(List<File> files, String id) async {
    // diop.options.headers["api-key"] = "7468ab7f-96a4-4685-a222-f5bdf5c60e52";
    final client = RestClient(dio);

    var photos = [];
    files.forEach((element) async {
      photos.add(await MultipartFile.fromFile(element.path));
    });

    var formData = FormData.fromMap({
      "userUuid": id,
    });

    print("ZZZZ $id");

    for (File item in files) {
      formData.files.add(
        MapEntry("photos", await MultipartFile.fromFile(item.path)),
      );
    }

    Response apiRespon = await dio
        .post(API_SETTINGS.APM_URL,
            data: formData,
            options: Options(headers: {"api-key": API_SETTINGS.APM_KEY}))
        .catchError((e) => throw (e.toString()));

    if (apiRespon.statusCode == 200) {
      var platform = "";

      if (Platform.isAndroid) {
        platform = "android";
      } else {
        platform = "ios";
      }

      var dd = await client.saveCheck(id, apiRespon.data["uuid"],
          platform: platform);
      if (dd.status == "vse ok") {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }

//     return await client.sendPhotos();
//  "files": [
//       await MultipartFile.fromFile("./text1.txt", filename: "text1.txt"),
//       await MultipartFile.fromFile("./text2.txt", filename: "text2.txt"),
//     ]
  }
}
