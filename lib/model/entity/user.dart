import 'package:easy_localization/easy_localization.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class User {
  int id;
  String phone = "";
  String code;
  String name;
  String city;
  String createdAt;
  String updatedAt;
  String bonus;
  String surname;
  String sex;
  String street;
  String house;
  String email = "";
  String apartment;
  String block;
  String entrance;
  String comment;
  String instagram;
  String facebook;

  // ignore: non_constant_identifier_names
  String date_of_birth;

  bool initialBonus = false;

   String bonusFormatted() {
    try {
      return NumberFormat("##,###", "en_US")
          .format(int.parse(this.bonus));
    } catch (e) {
      return NumberFormat("##,###", "en_US").format(0);
    }
  }

  User(
      {this.id,
      this.phone,
      this.code,
      this.name,
      this.city,
      this.email,
      this.createdAt,
      this.updatedAt,
      this.bonus,
      this.surname,
      this.sex,
      // ignore: non_constant_identifier_names
      this.date_of_birth,
      this.street,
      this.house,
      this.apartment,
      this.block,
      this.entrance,
      this.comment,
      this.instagram,
      this.facebook
      });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    phone = json['phone'] == null ? "" : json['phone'];
    code = json['code'];
    name = json['name'] == null ? "" : json['name'];
    city = json['city'] == null ? "" : json['city'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    bonus = json['bonus'] == null ? "" : json["bonus"];
    surname = json['surname'] == null ? "" : json['surname'];
    sex = json['sex'] == null ? "" : json['sex'];
    street = json['street'] == null ? "" : json['street'];
    house = json['house'];
    apartment = json['apartment'];
    block = json['block'];
    date_of_birth = json["date_of_birth"] == null ? "" : json["date_of_birth"];
    email = json['email'] == null ? "" : json['email'];
    entrance = json['entrance'];
    comment = json['comment'];
    instagram = json['instagram'] == null ? "" : json['instagram'];
    facebook = json['facebook'] == null ? "" : json['facebook'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['phone'] = this.phone;
    data['code'] = this.code;
    data['name'] = this.name;
    data['city'] = this.city;
    data['email'] = this.email;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['bonus'] = this.bonus;
    data['surname'] = this.surname;
    data['sex'] = this.sex;
    data['street'] = this.street;
    data['house'] = this.house;
    data['apartment'] = this.apartment;
    data['block'] = this.block;
    data['entrance'] = this.entrance;
    data['comment'] = this.comment;
    data['instagram'] = this.instagram;
    data['facebook'] = this.facebook;
    data["date_of_birth"] = this.date_of_birth;
    return data;
  }
}
