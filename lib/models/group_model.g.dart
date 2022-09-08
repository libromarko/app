// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Group _$GroupFromJson(Map<String, dynamic> json) => Group()
  ..id = json['id'] as String
  ..name = json['name'] as String
  ..userId = json['userId'] as String
  ..public = json['public'] as bool
  ..createdAt = DateTime.parse(json['createdAt'] as String)
  ..updatedAt = DateTime.parse(json['updatedAt'] as String);

Map<String, dynamic> _$GroupToJson(Group instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'userId': instance.userId,
      'public': instance.public,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
