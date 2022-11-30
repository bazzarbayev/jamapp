import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class ProductItem {
  int id;
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
  String shortDescription;
  List<Attribute> attribute;
  List<Images> images = List.of([]);

  List<String> imageSliders;

  ProductItem(
      {this.id,
      this.price,
      this.stockQuantity,
      this.sKU,
      this.description,
      this.priceInPoints,
      this.visible,
      this.createdAt,
      this.updatedAt,
      this.name,
      this.uUID,
      this.shortDescription,
      this.attribute,
      this.images});

  ProductItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    stockQuantity = json['stock_quantity'];
    sKU = json['SKU'];
    description = json['description'] != null
        ? new Description.fromJson(json['description'])
        : null;
    priceInPoints = json['price_in_points'];
    visible = json['visible'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    name = json['name'] != null ? new Description.fromJson(json['name']) : null;
    uUID = json['UUID'];
    shortDescription = json['short_description'];
    if (json['attribute'] != null) {
      attribute = [];
      json['attribute'].forEach((v) {
        attribute.add(new Attribute.fromJson(v));
      });
    }
    if (json['images'] != null) {
      if (json["id"].toString() == "127" && (json["images"] as List).isEmpty) {
        //temporary for cold brew, because it did not have a image, i add manually for fast release
        this.images.add(Images(
            catalogId: 1,
            src:
                "https://xo.kz/wp-content/uploads/2021/09/jameson_cod_brew.jpg",
            createdAt: "",
            updatedAt: "",
            id: 999));
      } else {
        json['images'].forEach((v) {
          this.images.add(new Images.fromJson(v));
        });
      }
    }
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
      data['name'] = this.name.toJson();
    }
    data['UUID'] = this.uUID;
    data['short_description'] = this.shortDescription;
    if (this.attribute != null) {
      data['attribute'] = this.attribute.map((v) => v.toJson()).toList();
    }
    if (this.images != null) {
      data['images'] = this.images.map((v) => v.toJson()).toList();
    }
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

class Attribute {
  int id;
  String name;
  int position;
  bool visible;
  bool variation;
  List<String> options;

  Attribute(
      {this.id,
      this.name,
      this.position,
      this.visible,
      this.variation,
      this.options});

  Attribute.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    position = json['position'];
    visible = json['visible'];
    variation = json['variation'];
    options = json['options'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['position'] = this.position;
    data['visible'] = this.visible;
    data['variation'] = this.variation;
    data['options'] = this.options;
    return data;
  }
}

class Images {
  int id;
  String src;
  int catalogId;
  String createdAt;
  String updatedAt;

  Images({this.id, this.src, this.catalogId, this.createdAt, this.updatedAt});

  Images.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    src = json['src'] == null ? "" : json["src"];
    catalogId = json['catalog_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['src'] = this.src;
    data['catalog_id'] = this.catalogId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
