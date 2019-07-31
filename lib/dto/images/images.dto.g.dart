// GENERATED CODE - DO NOT MODIFY BY HAND

part of images_dto;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<ImagesDto> _$imagesDtoSerializer = new _$ImagesDtoSerializer();
Serializer<MetaDto> _$metaDtoSerializer = new _$MetaDtoSerializer();
Serializer<DataDto> _$dataDtoSerializer = new _$DataDtoSerializer();

class _$ImagesDtoSerializer implements StructuredSerializer<ImagesDto> {
  @override
  final Iterable<Type> types = const [ImagesDto, _$ImagesDto];
  @override
  final String wireName = 'ImagesDto';

  @override
  Iterable<Object> serialize(Serializers serializers, ImagesDto object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'meta',
      serializers.serialize(object.meta,
          specifiedType: const FullType(MetaDto)),
      'data',
      serializers.serialize(object.data,
          specifiedType:
              const FullType(BuiltList, const [const FullType(DataDto)])),
    ];

    return result;
  }

  @override
  ImagesDto deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ImagesDtoBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'meta':
          result.meta.replace(serializers.deserialize(value,
              specifiedType: const FullType(MetaDto)) as MetaDto);
          break;
        case 'data':
          result.data.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(DataDto)]))
              as BuiltList<dynamic>);
          break;
      }
    }

    return result.build();
  }
}

class _$MetaDtoSerializer implements StructuredSerializer<MetaDto> {
  @override
  final Iterable<Type> types = const [MetaDto, _$MetaDto];
  @override
  final String wireName = 'MetaDto';

  @override
  Iterable<Object> serialize(Serializers serializers, MetaDto object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'total',
      serializers.serialize(object.total, specifiedType: const FullType(int)),
      'offset',
      serializers.serialize(object.offset, specifiedType: const FullType(int)),
      'count',
      serializers.serialize(object.count, specifiedType: const FullType(int)),
    ];
    if (object.error != null) {
      result
        ..add('error')
        ..add(serializers.serialize(object.error,
            specifiedType: const FullType(Null)));
    }
    return result;
  }

  @override
  MetaDto deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new MetaDtoBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'total':
          result.total = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'offset':
          result.offset = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'count':
          result.count = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'error':
          result.error = serializers.deserialize(value,
              specifiedType: const FullType(Null)) as Null;
          break;
      }
    }

    return result.build();
  }
}

class _$DataDtoSerializer implements StructuredSerializer<DataDto> {
  @override
  final Iterable<Type> types = const [DataDto, _$DataDto];
  @override
  final String wireName = 'DataDto';

  @override
  Iterable<Object> serialize(Serializers serializers, DataDto object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'channel_name',
      serializers.serialize(object.channelName,
          specifiedType: const FullType(String)),
      'user_avatar_url',
      serializers.serialize(object.userAvatarUrl,
          specifiedType: const FullType(String)),
      'username',
      serializers.serialize(object.username,
          specifiedType: const FullType(String)),
      'extension',
      serializers.serialize(object.extension,
          specifiedType: const FullType(String)),
      'width',
      serializers.serialize(object.width, specifiedType: const FullType(int)),
      'height',
      serializers.serialize(object.height, specifiedType: const FullType(int)),
      'filesize',
      serializers.serialize(object.filesize,
          specifiedType: const FullType(int)),
      'filename',
      serializers.serialize(object.filename,
          specifiedType: const FullType(String)),
      'created_at_unix',
      serializers.serialize(object.createdAtUnix,
          specifiedType: const FullType(int)),
      'user_id',
      serializers.serialize(object.userId,
          specifiedType: const FullType(String)),
      'canonical_url',
      serializers.serialize(object.canonicalUrl,
          specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  DataDto deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new DataDtoBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'channel_name':
          result.channelName = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'user_avatar_url':
          result.userAvatarUrl = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'username':
          result.username = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'extension':
          result.extension = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'width':
          result.width = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'height':
          result.height = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'filesize':
          result.filesize = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'filename':
          result.filename = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'created_at_unix':
          result.createdAtUnix = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'user_id':
          result.userId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'canonical_url':
          result.canonicalUrl = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$ImagesDto extends ImagesDto {
  @override
  final MetaDto meta;
  @override
  final BuiltList<DataDto> data;

  factory _$ImagesDto([void Function(ImagesDtoBuilder) updates]) =>
      (new ImagesDtoBuilder()..update(updates)).build();

  _$ImagesDto._({this.meta, this.data}) : super._() {
    if (meta == null) {
      throw new BuiltValueNullFieldError('ImagesDto', 'meta');
    }
    if (data == null) {
      throw new BuiltValueNullFieldError('ImagesDto', 'data');
    }
  }

  @override
  ImagesDto rebuild(void Function(ImagesDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ImagesDtoBuilder toBuilder() => new ImagesDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ImagesDto && meta == other.meta && data == other.data;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, meta.hashCode), data.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('ImagesDto')
          ..add('meta', meta)
          ..add('data', data))
        .toString();
  }
}

class ImagesDtoBuilder implements Builder<ImagesDto, ImagesDtoBuilder> {
  _$ImagesDto _$v;

  MetaDtoBuilder _meta;
  MetaDtoBuilder get meta => _$this._meta ??= new MetaDtoBuilder();
  set meta(MetaDtoBuilder meta) => _$this._meta = meta;

  ListBuilder<DataDto> _data;
  ListBuilder<DataDto> get data => _$this._data ??= new ListBuilder<DataDto>();
  set data(ListBuilder<DataDto> data) => _$this._data = data;

  ImagesDtoBuilder();

  ImagesDtoBuilder get _$this {
    if (_$v != null) {
      _meta = _$v.meta?.toBuilder();
      _data = _$v.data?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ImagesDto other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$ImagesDto;
  }

  @override
  void update(void Function(ImagesDtoBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$ImagesDto build() {
    _$ImagesDto _$result;
    try {
      _$result =
          _$v ?? new _$ImagesDto._(meta: meta.build(), data: data.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'meta';
        meta.build();
        _$failedField = 'data';
        data.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'ImagesDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$MetaDto extends MetaDto {
  @override
  final int total;
  @override
  final int offset;
  @override
  final int count;
  @override
  final Null error;

  factory _$MetaDto([void Function(MetaDtoBuilder) updates]) =>
      (new MetaDtoBuilder()..update(updates)).build();

  _$MetaDto._({this.total, this.offset, this.count, this.error}) : super._() {
    if (total == null) {
      throw new BuiltValueNullFieldError('MetaDto', 'total');
    }
    if (offset == null) {
      throw new BuiltValueNullFieldError('MetaDto', 'offset');
    }
    if (count == null) {
      throw new BuiltValueNullFieldError('MetaDto', 'count');
    }
  }

  @override
  MetaDto rebuild(void Function(MetaDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MetaDtoBuilder toBuilder() => new MetaDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MetaDto &&
        total == other.total &&
        offset == other.offset &&
        count == other.count &&
        error == other.error;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc(0, total.hashCode), offset.hashCode), count.hashCode),
        error.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('MetaDto')
          ..add('total', total)
          ..add('offset', offset)
          ..add('count', count)
          ..add('error', error))
        .toString();
  }
}

class MetaDtoBuilder implements Builder<MetaDto, MetaDtoBuilder> {
  _$MetaDto _$v;

  int _total;
  int get total => _$this._total;
  set total(int total) => _$this._total = total;

  int _offset;
  int get offset => _$this._offset;
  set offset(int offset) => _$this._offset = offset;

  int _count;
  int get count => _$this._count;
  set count(int count) => _$this._count = count;

  Null _error;
  Null get error => _$this._error;
  set error(Null error) => _$this._error = error;

  MetaDtoBuilder();

  MetaDtoBuilder get _$this {
    if (_$v != null) {
      _total = _$v.total;
      _offset = _$v.offset;
      _count = _$v.count;
      _error = _$v.error;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MetaDto other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$MetaDto;
  }

  @override
  void update(void Function(MetaDtoBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$MetaDto build() {
    final _$result = _$v ??
        new _$MetaDto._(
            total: total, offset: offset, count: count, error: error);
    replace(_$result);
    return _$result;
  }
}

class _$DataDto extends DataDto {
  @override
  final String channelName;
  @override
  final String userAvatarUrl;
  @override
  final String username;
  @override
  final String extension;
  @override
  final int width;
  @override
  final int height;
  @override
  final int filesize;
  @override
  final String filename;
  @override
  final int createdAtUnix;
  @override
  final String userId;
  @override
  final String canonicalUrl;

  factory _$DataDto([void Function(DataDtoBuilder) updates]) =>
      (new DataDtoBuilder()..update(updates)).build();

  _$DataDto._(
      {this.channelName,
      this.userAvatarUrl,
      this.username,
      this.extension,
      this.width,
      this.height,
      this.filesize,
      this.filename,
      this.createdAtUnix,
      this.userId,
      this.canonicalUrl})
      : super._() {
    if (channelName == null) {
      throw new BuiltValueNullFieldError('DataDto', 'channelName');
    }
    if (userAvatarUrl == null) {
      throw new BuiltValueNullFieldError('DataDto', 'userAvatarUrl');
    }
    if (username == null) {
      throw new BuiltValueNullFieldError('DataDto', 'username');
    }
    if (extension == null) {
      throw new BuiltValueNullFieldError('DataDto', 'extension');
    }
    if (width == null) {
      throw new BuiltValueNullFieldError('DataDto', 'width');
    }
    if (height == null) {
      throw new BuiltValueNullFieldError('DataDto', 'height');
    }
    if (filesize == null) {
      throw new BuiltValueNullFieldError('DataDto', 'filesize');
    }
    if (filename == null) {
      throw new BuiltValueNullFieldError('DataDto', 'filename');
    }
    if (createdAtUnix == null) {
      throw new BuiltValueNullFieldError('DataDto', 'createdAtUnix');
    }
    if (userId == null) {
      throw new BuiltValueNullFieldError('DataDto', 'userId');
    }
    if (canonicalUrl == null) {
      throw new BuiltValueNullFieldError('DataDto', 'canonicalUrl');
    }
  }

  @override
  DataDto rebuild(void Function(DataDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DataDtoBuilder toBuilder() => new DataDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DataDto &&
        channelName == other.channelName &&
        userAvatarUrl == other.userAvatarUrl &&
        username == other.username &&
        extension == other.extension &&
        width == other.width &&
        height == other.height &&
        filesize == other.filesize &&
        filename == other.filename &&
        createdAtUnix == other.createdAtUnix &&
        userId == other.userId &&
        canonicalUrl == other.canonicalUrl;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc(
                        $jc(
                            $jc(
                                $jc(
                                    $jc(
                                        $jc($jc(0, channelName.hashCode),
                                            userAvatarUrl.hashCode),
                                        username.hashCode),
                                    extension.hashCode),
                                width.hashCode),
                            height.hashCode),
                        filesize.hashCode),
                    filename.hashCode),
                createdAtUnix.hashCode),
            userId.hashCode),
        canonicalUrl.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('DataDto')
          ..add('channelName', channelName)
          ..add('userAvatarUrl', userAvatarUrl)
          ..add('username', username)
          ..add('extension', extension)
          ..add('width', width)
          ..add('height', height)
          ..add('filesize', filesize)
          ..add('filename', filename)
          ..add('createdAtUnix', createdAtUnix)
          ..add('userId', userId)
          ..add('canonicalUrl', canonicalUrl))
        .toString();
  }
}

class DataDtoBuilder implements Builder<DataDto, DataDtoBuilder> {
  _$DataDto _$v;

  String _channelName;
  String get channelName => _$this._channelName;
  set channelName(String channelName) => _$this._channelName = channelName;

  String _userAvatarUrl;
  String get userAvatarUrl => _$this._userAvatarUrl;
  set userAvatarUrl(String userAvatarUrl) =>
      _$this._userAvatarUrl = userAvatarUrl;

  String _username;
  String get username => _$this._username;
  set username(String username) => _$this._username = username;

  String _extension;
  String get extension => _$this._extension;
  set extension(String extension) => _$this._extension = extension;

  int _width;
  int get width => _$this._width;
  set width(int width) => _$this._width = width;

  int _height;
  int get height => _$this._height;
  set height(int height) => _$this._height = height;

  int _filesize;
  int get filesize => _$this._filesize;
  set filesize(int filesize) => _$this._filesize = filesize;

  String _filename;
  String get filename => _$this._filename;
  set filename(String filename) => _$this._filename = filename;

  int _createdAtUnix;
  int get createdAtUnix => _$this._createdAtUnix;
  set createdAtUnix(int createdAtUnix) => _$this._createdAtUnix = createdAtUnix;

  String _userId;
  String get userId => _$this._userId;
  set userId(String userId) => _$this._userId = userId;

  String _canonicalUrl;
  String get canonicalUrl => _$this._canonicalUrl;
  set canonicalUrl(String canonicalUrl) => _$this._canonicalUrl = canonicalUrl;

  DataDtoBuilder();

  DataDtoBuilder get _$this {
    if (_$v != null) {
      _channelName = _$v.channelName;
      _userAvatarUrl = _$v.userAvatarUrl;
      _username = _$v.username;
      _extension = _$v.extension;
      _width = _$v.width;
      _height = _$v.height;
      _filesize = _$v.filesize;
      _filename = _$v.filename;
      _createdAtUnix = _$v.createdAtUnix;
      _userId = _$v.userId;
      _canonicalUrl = _$v.canonicalUrl;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DataDto other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$DataDto;
  }

  @override
  void update(void Function(DataDtoBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$DataDto build() {
    final _$result = _$v ??
        new _$DataDto._(
            channelName: channelName,
            userAvatarUrl: userAvatarUrl,
            username: username,
            extension: extension,
            width: width,
            height: height,
            filesize: filesize,
            filename: filename,
            createdAtUnix: createdAtUnix,
            userId: userId,
            canonicalUrl: canonicalUrl);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
