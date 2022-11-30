// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeResponse _$HomeResponseFromJson(Map<String, dynamic> json) {
  return HomeResponse(
    recommended: (json['recommended_seats'] as List<dynamic>)
        .map((e) => e as String)
        .toList(),
    categories:
        (json['categories'] as List<dynamic>).map((e) => e as String).toList(),
  );
}

Map<String, dynamic> _$HomeResponseToJson(HomeResponse instance) =>
    <String, dynamic>{
      'categories': instance.categories,
      'recommended_seats': instance.recommended,
    };
