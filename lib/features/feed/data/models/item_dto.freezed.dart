// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'item_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ItemDto _$ItemDtoFromJson(Map<String, dynamic> json) {
  return _ItemDto.fromJson(json);
}

/// @nodoc
mixin _$ItemDto {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  int? get userId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get body => throw _privateConstructorUsedError;

  /// Serializes this ItemDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ItemDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ItemDtoCopyWith<ItemDto> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ItemDtoCopyWith<$Res> {
  factory $ItemDtoCopyWith(ItemDto value, $Res Function(ItemDto) then) =
      _$ItemDtoCopyWithImpl<$Res, ItemDto>;
  @useResult
  $Res call({
    int id,
    @JsonKey(name: 'user_id') int? userId,
    String title,
    String body,
  });
}

/// @nodoc
class _$ItemDtoCopyWithImpl<$Res, $Val extends ItemDto>
    implements $ItemDtoCopyWith<$Res> {
  _$ItemDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ItemDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = freezed,
    Object? title = null,
    Object? body = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            userId: freezed == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as int?,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            body: null == body
                ? _value.body
                : body // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ItemDtoImplCopyWith<$Res> implements $ItemDtoCopyWith<$Res> {
  factory _$$ItemDtoImplCopyWith(
    _$ItemDtoImpl value,
    $Res Function(_$ItemDtoImpl) then,
  ) = __$$ItemDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    @JsonKey(name: 'user_id') int? userId,
    String title,
    String body,
  });
}

/// @nodoc
class __$$ItemDtoImplCopyWithImpl<$Res>
    extends _$ItemDtoCopyWithImpl<$Res, _$ItemDtoImpl>
    implements _$$ItemDtoImplCopyWith<$Res> {
  __$$ItemDtoImplCopyWithImpl(
    _$ItemDtoImpl _value,
    $Res Function(_$ItemDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ItemDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = freezed,
    Object? title = null,
    Object? body = null,
  }) {
    return _then(
      _$ItemDtoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        userId: freezed == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as int?,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        body: null == body
            ? _value.body
            : body // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ItemDtoImpl implements _ItemDto {
  const _$ItemDtoImpl({
    required this.id,
    @JsonKey(name: 'user_id') this.userId,
    required this.title,
    required this.body,
  });

  factory _$ItemDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ItemDtoImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'user_id')
  final int? userId;
  @override
  final String title;
  @override
  final String body;

  @override
  String toString() {
    return 'ItemDto(id: $id, userId: $userId, title: $title, body: $body)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ItemDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.body, body) || other.body == body));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, userId, title, body);

  /// Create a copy of ItemDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ItemDtoImplCopyWith<_$ItemDtoImpl> get copyWith =>
      __$$ItemDtoImplCopyWithImpl<_$ItemDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ItemDtoImplToJson(this);
  }
}

abstract class _ItemDto implements ItemDto {
  const factory _ItemDto({
    required final int id,
    @JsonKey(name: 'user_id') final int? userId,
    required final String title,
    required final String body,
  }) = _$ItemDtoImpl;

  factory _ItemDto.fromJson(Map<String, dynamic> json) = _$ItemDtoImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'user_id')
  int? get userId;
  @override
  String get title;
  @override
  String get body;

  /// Create a copy of ItemDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ItemDtoImplCopyWith<_$ItemDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
