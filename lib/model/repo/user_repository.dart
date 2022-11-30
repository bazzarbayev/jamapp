import 'package:flutter/material.dart';
import 'package:jam_app/model/api/dio_provider.dart';
import 'package:jam_app/model/api/response/city_response.dart';
import 'package:jam_app/model/api/response/mark_response.dart';
import 'package:jam_app/model/api/response/response_message.dart';
import 'package:jam_app/model/api/rest_client.dart';
import 'package:jam_app/model/entity/history.dart';
import 'package:jam_app/model/entity/history_order.dart';
import 'package:jam_app/model/entity/sales_department.dart';
import 'package:jam_app/model/entity/user.dart';
import 'package:jam_app/model/local/pref.dart';
import 'package:jam_app/utils/const.dart';

class UserRepository {
  var dio = DioProvider.instance();

  LocalPref pref;

  UserRepository({@required this.pref});

  Future<List<Mark>> getUserOrdersMark() async {
    try {
      var token = await this.phone;
      var url = API_SETTINGS.BASE_URL + "getgrades?phone=$token";
      var response = await dio.get(url);
      final List<dynamic> body = response.data;
      List<Mark> list = [];
      for (var data in body) {
        list.add(Mark.fromJson(data));
      }
      return list;
    } catch (e) {
      return [];
    }
  }

  Future<bool> sendUserOrderMark({int id, int grade, String comment}) async {
    try {
      var url = API_SETTINGS.BASE_URL + "savegrade";
      var response = await dio.post(url, data: {
        "id": id,
        "grade": grade,
        "grade_comment": comment,
      });
      print(response.data);

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> skipUserOrderMark({int id}) async {
    try {
      var url = API_SETTINGS.BASE_URL + "skipgrade?id=$id";
      var response = await dio.get(url);
      print(response.data);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<void> signOut() async {}

  Future<bool> isOlder21() async {
    final old = await this.pref.getString("older_21");
    return old != null;
  }

  Future<bool> setOlder21() async {
    return await this.pref.saveString("older_21", "yes");
  }

  Future<bool> isRegistered() async {
    final old = await this.pref.getString("isRegistered");
    return old != null;
  }

  Future<bool> setRegistered(String phone) async {
    return await this.pref.saveString("isRegistered", phone);
  }

  Future<bool> isLoyalty() async {
    final old = await this.pref.getString("isLoyal");
    return old != null;
  }

  Future<bool> setLoyalty(String loyal) async {
    return await this.pref.saveString("isLoyal", loyal);
  }

  Future<User> getUser() async {
    final client = RestClient(dio);
    var token = await this.phone;
    return await client.getProfile(token);
  }

  Future<List<SalesDepartment>> getSalesDepartments() async {
    final client = RestClient(dio);
    return await client.getSalesDepartments();
  }

  Future<MessageResponse> checkForBonus() async {
    final client = RestClient(dio);
    var token = await this.phone;
    return await client.checkForBonus(token);
  }

  Future<User> getUserWithPhone(String phone) async {
    this.pref.saveString("isRegistered", phone);
    final client = RestClient(dio);
    var token = phone;
    return await client.getProfile(token);
  }

  Future<String> get phone async {
    return await this.pref.getString("isRegistered");
  }

  Future<MessageResponse> registerPhone(String phone) async {
    final client = RestClient(dio);
    return await client.postRegisterPhone(phone);
  }

  Future<MessageResponse> checkCode(String phone, String code) async {
    final client = RestClient(dio);
    return await client.postCheckCode(phone, code);
  }

  Future<List<CityResponse>> getCities() async {
    final client = RestClient(dio);
    return await client.getCities();
  }

  Future<MessageResponse> updateUser(
      String phone, String name, String instagram, String facebook, String city, 
      {String loyalty = ""}) async {
    final client = RestClient(dio);
    return await client.userUpdate(
        phone: phone,
        name: name,
        instagram: instagram,
        facebook: facebook,
        city: city,
        loyalty: loyalty);
  }

  Future<List<HistoryOrder>> getMyOrders() async {
    final client = RestClient(dio);
    var token = await this.phone;
    return await client.getMyOrders(token);
  }

  Future<HistoryOrder> getMyOrder(int id) async {
    final client = RestClient(dio);
    var token = await this.phone;
    return await client.getMyOrder(id, token);
  }

  Future<List<History>> getHistory(String lang) async {
    final client = RestClient(dio);
    var token = await this.phone;

    return await client.getAllHistory(token, lang: lang);
  }

  Future<User> updateFullUser(User user) async {
    final client = RestClient(dio);
    return await client.userUpdateFull(user);
  }

  Future<MessageResponse> saveDeviceToken({String token, String phone}) async {
    final client = RestClient(dio);
    return await client.postSaveToken(token: token, phone: phone);
  }
}
