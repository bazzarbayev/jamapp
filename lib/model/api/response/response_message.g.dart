// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageResponse _$MessageResponseFromJson(Map<String, dynamic> json) {
  return MessageResponse(
    status: json['status'] as String,
    msg: json['msg'] as String,
  )..newUser = json['newUser'] as bool;
}

Map<String, dynamic> _$MessageResponseToJson(MessageResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'msg': instance.msg,
      'newUser': instance.newUser,
    };
