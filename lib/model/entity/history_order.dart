import 'package:easy_localization/easy_localization.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class HistoryOrder {
  int id;
  String orderNumber;
  String clientId;
  String price;
  Info info;
  String shipping;
  String status;
  String createdAt;
  String updatedAt;
  List<CatalogsCatalog> catalogsCatalog;

  HistoryOrder(
      {this.id,
      this.orderNumber,
      this.clientId,
      this.price,
      this.info,
      this.shipping,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.catalogsCatalog});

  HistoryOrder.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderNumber = json['order_number'];
    clientId = json['client_id'];
    price = json['price'];
    info = json['info'] != null ? new Info.fromJson(json['info']) : null;
    shipping = json['shipping'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['catalogs_catalog'] != null) {
      catalogsCatalog = [];
      json['catalogs_catalog'].forEach((v) {
        catalogsCatalog.add(new CatalogsCatalog.fromJson(v));
      });
    }
  }

  String get date {
    try {
      var dateTime = DateTime.parse(this.createdAt);
      return DateFormat("dd.MM.yyyy").format(dateTime);
    } catch (e) {
      return "";
    }
  }

  String get dateOrder {
    try {
      var dateTime = DateTime.parse(this.createdAt);
      return DateFormat("dd.MM.yyyy - hh:mm").format(dateTime);
    } catch (e) {
      return "";
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_number'] = this.orderNumber;
    data['client_id'] = this.clientId;
    data['price'] = this.price;
    if (this.info != null) {
      data['info'] = this.info.toJson();
    }
    data['shipping'] = this.shipping;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.catalogsCatalog != null) {
      data['catalogs_catalog'] =
          this.catalogsCatalog.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Info {
  String name;
  String surname;
  String city;
  String street;
  String home;
  String apartment;
  String block;
  String entrance;
  String other;
  String phone;
  String email;

  Info(
      {this.name,
      this.surname,
      this.city,
      this.street,
      this.home,
      this.apartment,
      this.block,
      this.entrance,
      this.other,
      this.phone,
      this.email});

  Info.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    surname = json['surname'];
    city = json['city'];
    street = json['street'];
    home = json['home'];
    apartment = json['apartment'];
    block = json['block'];
    entrance = json['entrance'];
    other = json['other'];
    phone = json['phone'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['surname'] = this.surname;
    data['city'] = this.city;
    data['street'] = this.street;
    data['home'] = this.home;
    data['apartment'] = this.apartment;
    data['block'] = this.block;
    data['entrance'] = this.entrance;
    data['other'] = this.other;
    data['phone'] = this.phone;
    data['email'] = this.email;
    return data;
  }
}

class CatalogsCatalog {
  int id;
  String orderId;
  String catalogId;
  String quantity;

  CatalogWithMainImage catalogWithMainImage;

  CatalogsCatalog(
      {this.id,
      this.orderId,
      this.catalogId,
      this.quantity,
      this.catalogWithMainImage});

  CatalogsCatalog.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    catalogId = json['catalog_id'];
    quantity = json['quantity'];

    catalogWithMainImage = json['catalog_with_main_image'] != null
        ? new CatalogWithMainImage.fromJson(json['catalog_with_main_image'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_id'] = this.orderId;
    data['catalog_id'] = this.catalogId;
    data['quantity'] = this.quantity;

    if (this.catalogWithMainImage != null) {
      data['catalog_with_main_image'] = this.catalogWithMainImage.toJson();
    }
    return data;
  }
}

class CatalogWithMainImage {
  int id;
  String price;
  String stockQuantity;
  String sKU;
  Description description;
  String priceInPoints;
  int visible;
  String createdAt;
  String updatedAt;
  Description name;
  int uUID;
  String shortDescription;
  String attribute;
  MainImage mainImage;

  CatalogWithMainImage(
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
      this.mainImage});

  CatalogWithMainImage.fromJson(Map<String, dynamic> json) {
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
    attribute = json['attribute'];
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
    data['attribute'] = this.attribute;
    if (this.mainImage != null) {
      data['main_image'] = this.mainImage.toJson();
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
    src = json['src'];
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
