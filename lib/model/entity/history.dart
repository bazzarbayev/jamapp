
import 'package:easy_localization/easy_localization.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class History {
  String name;
  String nameKz;
  String info;
  String infoKz;
  String status;
  String bonusInfo;
  String createdAt;
  String updatedAt;

  DateTime get date {
    DateFormat format = new DateFormat("yyyy-MM-dd");
    try {
      return format.parse(this.createdAt);
    } catch (e) {
      return DateTime(2020);
    }
  }

  String get time {
    DateFormat format = new DateFormat("yyyy-MM-dd HH:mm");
    try {
      var dd = format.parse(createdAt);
      return DateFormat.Hm().format(dd);
    } catch (e) {
      return "";
    }
  }

  History(
      {this.name,
      this.info,
      this.status,
      this.bonusInfo,
      this.createdAt,
      this.updatedAt});

  History.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    nameKz = json['name_kz'] == null ? json['name'] : json['name_kz'];
    info = json['info'];
    infoKz = json['info_kz'] == null ? json['info'] : json['info_kz'];
    status = json['status'];
    bonusInfo = json['bonus_info'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['info'] = this.info;
    data['status'] = this.status;
    data['bonus_info'] = this.bonusInfo;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
