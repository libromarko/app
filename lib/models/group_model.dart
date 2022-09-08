import 'package:json_annotation/json_annotation.dart';

part 'group_model.g.dart';

@JsonSerializable()
class Group {
  @JsonKey(name: 'id')
  late String id;

  @JsonKey(name: 'name')
  late String name;

  @JsonKey(name: 'userId')
  late String userId;

  @JsonKey(name: 'public')
  late bool public;

  @JsonKey(name: 'createdAt')
  late DateTime createdAt;

  @JsonKey(name: 'updatedAt')
  late DateTime updatedAt;

  Group();

  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);
  Map<String, dynamic> toJson() => _$GroupToJson(this);
}