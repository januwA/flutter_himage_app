library images_dto;

import 'dart:convert';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:himage/dto/images/serializers.dart';

part 'images.dto.g.dart';

/// ImagesDto
abstract class ImagesDto implements Built<ImagesDto, ImagesDtoBuilder> {
  ImagesDto._();

  factory ImagesDto([updates(ImagesDtoBuilder b)]) = _$ImagesDto;

  @BuiltValueField(wireName: 'meta')
  MetaDto get meta;

  @BuiltValueField(wireName: 'data')
  BuiltList<DataDto> get data;

  String toJson() {
    return jsonEncode(serializers.serializeWith(ImagesDto.serializer, this));
  }

  static ImagesDto fromJson(String jsonString) {
    return serializers.deserializeWith(
        ImagesDto.serializer, jsonDecode(jsonString));
  }

  static Serializer<ImagesDto> get serializer => _$imagesDtoSerializer;
}

/// MetaDto
abstract class MetaDto implements Built<MetaDto, MetaDtoBuilder> {
  MetaDto._();

  factory MetaDto([updates(MetaDtoBuilder b)]) = _$MetaDto;

  @BuiltValueField(wireName: 'total')
  int get total;

  @BuiltValueField(wireName: 'offset')
  int get offset;

  @BuiltValueField(wireName: 'count')
  int get count;

  @nullable
  @BuiltValueField(wireName: 'error')
  Null get error;

  String toJson() {
    return jsonEncode(serializers.serializeWith(MetaDto.serializer, this));
  }

  static MetaDto fromJson(String jsonString) {
    return serializers.deserializeWith(
        MetaDto.serializer, jsonDecode(jsonString));
  }

  static Serializer<MetaDto> get serializer => _$metaDtoSerializer;
}

/// DataDto
abstract class DataDto implements Built<DataDto, DataDtoBuilder> {
  DataDto._();

  factory DataDto([updates(DataDtoBuilder b)]) = _$DataDto;

  @BuiltValueField(wireName: 'channel_name')
  String get channelName;

  @BuiltValueField(wireName: 'user_avatar_url')
  String get userAvatarUrl;

  @BuiltValueField(wireName: 'username')
  String get username;

  @BuiltValueField(wireName: 'extension')
  String get extension;

  @BuiltValueField(wireName: 'width')
  int get width;

  @BuiltValueField(wireName: 'height')
  int get height;

  @BuiltValueField(wireName: 'filesize')
  int get filesize;

  @BuiltValueField(wireName: 'filename')
  String get filename;

  @BuiltValueField(wireName: 'created_at_unix')
  int get createdAtUnix;

  @BuiltValueField(wireName: 'user_id')
  String get userId;

  @BuiltValueField(wireName: 'canonical_url')
  String get canonicalUrl;

  String toJson() {
    return jsonEncode(serializers.serializeWith(DataDto.serializer, this));
  }

  static DataDto fromJson(String jsonString) {
    return serializers.deserializeWith(
        DataDto.serializer, jsonDecode(jsonString));
  }

  static Serializer<DataDto> get serializer => _$dataDtoSerializer;
}
