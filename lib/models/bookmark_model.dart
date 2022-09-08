import 'package:json_annotation/json_annotation.dart';

part 'bookmark_model.g.dart';

@JsonSerializable()
class Bookmark {
  @JsonKey(name: 'id')
  late String id;

  @JsonKey(name: 'description')
  late String description;

  @JsonKey(name: 'url')
  late String url;

  @JsonKey(name: 'userId')
  late String userId;

  @JsonKey(name: 'groupId')
  late String groupId;

  @JsonKey(name: 'createdAt')
  late DateTime createdAt;

  @JsonKey(name: 'updatedAt')
  late DateTime updatedAt;

  Bookmark();

  factory Bookmark.fromJson(Map<String, dynamic> json) => _$BookmarkFromJson(json);
  Map<String, dynamic> toJson() => _$BookmarkToJson(this);
}