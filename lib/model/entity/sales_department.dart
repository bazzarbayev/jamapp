import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class SalesDepartment {
  int id;
  String name;
  String type;
  String coordX;
  String coordY;
  int promotion;
  String contact;
  String logo;

  SalesDepartment(
      {this.id,
      this.name,
      this.type,
      this.coordX,
      this.coordY,
      this.promotion,
      this.contact,
      this.logo});

  SalesDepartment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'] == null ? "" : json['name'];
    type = json['type'] == null ? "" : json['type'];
    coordX = json['coordX'] == null ? "" : json['coordX'];
    coordY = json['coordY'] == null ? "" : json['coordY'];
    promotion = json['promotion'];
    contact = json['contact'] == null ? "" : json['contact'];
    logo = json['logo'] == null ? "" : json['logo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['type'] = this.type;
    data['coordX'] = this.coordX;
    data['coordY'] = this.coordY;
    data['promotion'] = this.promotion;
    data['contact'] = this.contact;
    data['logo'] = this.logo;
    return data;
  }
  static Map<String, dynamic> toMap(SalesDepartment salesDepartment) => {
        'id': salesDepartment.id,
        'name': salesDepartment.name,
        'type': salesDepartment.type,
        'coordX': salesDepartment.coordX,
        'coordY': salesDepartment.coordY,
        'promotion': salesDepartment.promotion,
        'contact': salesDepartment.contact,
        'logo': salesDepartment.logo,
      };

  static String encode(List<SalesDepartment> musics) => json.encode(
        musics
            .map<Map<String, dynamic>>((music) => SalesDepartment.toMap(music))
            .toList(),
      );

  static List<SalesDepartment> decode(String salesDeps) =>
      (json.decode(salesDeps) as List<dynamic>)
          .map<SalesDepartment>((item) => SalesDepartment.fromJson(item))
          .toList();
}
