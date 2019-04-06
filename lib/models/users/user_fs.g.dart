// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_fs.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<UserFireStore> _$userFireStoreSerializer =
    new _$UserFireStoreSerializer();

class _$UserFireStoreSerializer implements StructuredSerializer<UserFireStore> {
  @override
  final Iterable<Type> types = const [UserFireStore, _$UserFireStore];
  @override
  final String wireName = 'UserFireStore';

  @override
  Iterable serialize(Serializers serializers, UserFireStore object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[];
    if (object.name != null) {
      result
        ..add('name')
        ..add(serializers.serialize(object.name,
            specifiedType: const FullType(String)));
    }
    if (object.email != null) {
      result
        ..add('email')
        ..add(serializers.serialize(object.email,
            specifiedType: const FullType(String)));
    }
    if (object.phone != null) {
      result
        ..add('phone')
        ..add(serializers.serialize(object.phone,
            specifiedType: const FullType(String)));
    }
    if (object.interests != null) {
      result
        ..add('interests')
        ..add(serializers.serialize(object.interests,
            specifiedType:
                const FullType(BuiltList, const [const FullType(String)])));
    }
    if (object.favorites != null) {
      result
        ..add('favorites')
        ..add(serializers.serialize(object.favorites,
            specifiedType:
                const FullType(BuiltList, const [const FullType(String)])));
    }

    return result;
  }

  @override
  UserFireStore deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new UserFireStoreBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'email':
          result.email = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'phone':
          result.phone = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'interests':
          result.interests.replace(serializers.deserialize(value,
                  specifiedType:
                      const FullType(BuiltList, const [const FullType(String)]))
              as BuiltList);
          break;
        case 'favorites':
          result.favorites.replace(serializers.deserialize(value,
                  specifiedType:
                      const FullType(BuiltList, const [const FullType(String)]))
              as BuiltList);
          break;
      }
    }

    return result.build();
  }
}

class _$UserFireStore extends UserFireStore {
  @override
  final String name;
  @override
  final String email;
  @override
  final String phone;
  @override
  final BuiltList<String> interests;
  @override
  final BuiltList<String> favorites;

  factory _$UserFireStore([void updates(UserFireStoreBuilder b)]) =>
      (new UserFireStoreBuilder()..update(updates)).build();

  _$UserFireStore._(
      {this.name, this.email, this.phone, this.interests, this.favorites})
      : super._();

  @override
  UserFireStore rebuild(void updates(UserFireStoreBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  UserFireStoreBuilder toBuilder() => new UserFireStoreBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserFireStore &&
        name == other.name &&
        email == other.email &&
        phone == other.phone &&
        interests == other.interests &&
        favorites == other.favorites;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc($jc(0, name.hashCode), email.hashCode), phone.hashCode),
            interests.hashCode),
        favorites.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('UserFireStore')
          ..add('name', name)
          ..add('email', email)
          ..add('phone', phone)
          ..add('interests', interests)
          ..add('favorites', favorites))
        .toString();
  }
}

class UserFireStoreBuilder
    implements Builder<UserFireStore, UserFireStoreBuilder> {
  _$UserFireStore _$v;

  String _name;
  String get name => _$this._name;
  set name(String name) => _$this._name = name;

  String _email;
  String get email => _$this._email;
  set email(String email) => _$this._email = email;

  String _phone;
  String get phone => _$this._phone;
  set phone(String phone) => _$this._phone = phone;

  ListBuilder<String> _interests;
  ListBuilder<String> get interests =>
      _$this._interests ??= new ListBuilder<String>();
  set interests(ListBuilder<String> interests) => _$this._interests = interests;

  ListBuilder<String> _favorites;
  ListBuilder<String> get favorites =>
      _$this._favorites ??= new ListBuilder<String>();
  set favorites(ListBuilder<String> favorites) => _$this._favorites = favorites;

  UserFireStoreBuilder();

  UserFireStoreBuilder get _$this {
    if (_$v != null) {
      _name = _$v.name;
      _email = _$v.email;
      _phone = _$v.phone;
      _interests = _$v.interests?.toBuilder();
      _favorites = _$v.favorites?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UserFireStore other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$UserFireStore;
  }

  @override
  void update(void updates(UserFireStoreBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$UserFireStore build() {
    _$UserFireStore _$result;
    try {
      _$result = _$v ??
          new _$UserFireStore._(
              name: name,
              email: email,
              phone: phone,
              interests: _interests?.build(),
              favorites: _favorites?.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'interests';
        _interests?.build();
        _$failedField = 'favorites';
        _favorites?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'UserFireStore', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
