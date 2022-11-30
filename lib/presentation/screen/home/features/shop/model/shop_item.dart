import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class ShopItem {
  int id;
  int positionId = 1;
  String price;
  String stockQuantity;
  String sKU;
  Description description;
  String priceInPoints;
  String visible;
  String createdAt;
  String updatedAt;
  Description name;
  String uUID;
  MainImage mainImage;

  String srcImage = "";
  String titleRu = "";
  String titleKz = "";
  List<dynamic> options;

  ShopItem(
      {this.id,
      this.price,
      this.stockQuantity,
      this.sKU,
      this.titleRu,
      this.titleKz,
      this.options = const [],
      this.srcImage,
      this.description,
      this.priceInPoints,
      this.visible,
      this.createdAt,
      this.updatedAt,
      this.name,
      this.uUID,
      this.mainImage});

  ShopItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    stockQuantity =
        json['stock_quantity'] == null ? "0" : json['stock_quantity'];
    sKU = json['SKU'];
    description = json['description'] != null
        ? new Description.fromJson(json['description'])
        : null;
    priceInPoints =
        json['price_in_points'] == null ? "0" : json["price_in_points"];
    visible = json['visible'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    name = json['name'] != null ? new Description.fromJson(json['name']) : null;
    uUID = json['UUID'];

    if (json['main_image'] != null) {
      mainImage = new MainImage.fromJson(json['main_image']);
    } else {
      if (json["id"].toString() == "127") {
        //temp code for cold brew
        mainImage = MainImage(
            catalogId: 1,
            src:
                "https://xo.kz/wp-content/uploads/2021/09/jameson_cod_brew.jpg",
            createdAt: "",
            updatedAt: "",
            id: 999);
      } else {
        mainImage = MainImage(
            catalogId: 1, src: "", createdAt: "", updatedAt: "", id: 999);
      }
    }
  }

  ShopItem.fromLocalJson(Map<String, dynamic> json) {
    id = json['fk_id'];
    positionId = json['id'];
    price = json['price'];
    priceInPoints =
        json['price_in_points'] == null ? "0" : json['price_in_points'];
    titleRu = json['name_ru'] != null ? json["name_ru"] : "";
    titleKz = json['name_kz'] != null ? json["name_kz"] : "";
    uUID = json['uuid'];
    srcImage = json["main_image"];
    options = json["options"] != null ? jsonDecode(json["options"]) : [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['price'] = this.price;
    data['stock_quantity'] = this.stockQuantity;
    data['SKU'] = this.sKU;
    if (this.description != null) {
      data['description'] = this.description.toJson();
    }
    data['price_in_points'] = this.priceInPoints;
    data['visible'] = this.visible;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.name != null) {
      //  ? data['name'] = this.name.toJson();
    }
    data['UUID'] = this.uUID;
    if (this.mainImage != null) {
      data['main_image'] = this.mainImage.toJson();
    } else {
      if (data["id"].toString() == "127") {
        //temp code for cold brew
        data['main_image'] = MainImage(
                catalogId: 1,
                src:
                    "https://xo.kz/wp-content/uploads/2021/09/jameson_cod_brew.jpg",
                createdAt: "",
                updatedAt: "",
                id: 999)
            .toJson();
      }
    }
    return data;
  }

  String priceFormatted() {
    try {
      return NumberFormat("##,###", "en_US")
          .format(int.parse(this.priceInPoints));
    } catch (e) {
      return NumberFormat("##,###", "en_US").format(0);
    }
  }

  Map<String, dynamic> toLocalJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['fk_id'] = this.id;
    data['name_ru'] = this.titleRu;
    data['name_kz'] = this.titleKz;
    data['uuid'] = this.uUID;
    data["main_image"] = this.srcImage;
    data["price_in_points"] = this.priceInPoints;

    data["options"] =
        this.options.isEmpty ? jsonEncode([]) : jsonEncode(this.options);

    return data;
  }
}

class Description {
  String ru;
  String kz;

  Description({this.ru, this.kz});

  Description.fromJson(Map<String, dynamic> json) {
    ru = json['ru'];
    kz = json['kz'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ru'] = this.ru;
    data['kz'] = this.kz;
    return data;
  }
}

class MainImage {
  int id;
  String src;
  int catalogId;
  String createdAt;
  String updatedAt;

  MainImage(
      {this.id, this.src, this.catalogId, this.createdAt, this.updatedAt});

  MainImage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    src = json['src'] == null ? "" : json["src"];
    catalogId = json['catalog_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['src'] = this.src.toString();
    data['catalog_id'] = this.catalogId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
