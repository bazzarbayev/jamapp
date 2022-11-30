import 'package:json_annotation/json_annotation.dart';

part 'response_message.g.dart';

@JsonSerializable()
class MessageResponse {
  @JsonKey(name: "status")
  String status = "";
  String msg;

  @JsonKey(name: "newUser")
  bool newUser = true;

  MessageResponse({this.status, this.msg});

  factory MessageResponse.fromJson(Map<String, dynamic> json) =>
      _$MessageResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MessageResponseToJson(this);
}
