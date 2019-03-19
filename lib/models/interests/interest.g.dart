// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'interest.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Interest> _$interestSerializer = new _$InterestSerializer();

class _$InterestSerializer implements StructuredSerializer<Interest> {
  @override
  final Iterable<Type> types = const [Interest, _$Interest];
  @override
  final String wireName = 'Interest';

  @override
  Iterable serialize(Serializers serializers, Interest object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[];
    if (object.interestName != null) {
      result
        ..add('interestName')
        ..add(serializers.serialize(object.interestName,
            specifiedType: const FullType(String)));
    }
    if (object.interestImage != null) {
      result
        ..add('interestImage')
        ..add(serializers.serialize(object.interestImage,
            specifiedType: const FullType(String)));
    }
    if (object.isSelected != null) {
      result
        ..add('isSelected')
        ..add(serializers.serialize(object.isSelected,
            specifiedType: const FullType(bool)));
    }
    if (object.id != null) {
      result
        ..add('id')
        ..add(serializers.serialize(object.id,
            specifiedType: const FullType(String)));
    }

    return result;
  }

  @override
  Interest deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new InterestBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'interestName':
          result.interestName = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'interestImage':
          result.interestImage = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'isSelected':
          result.isSelected = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$Interest extends Interest {
  @override
  final String interestName;
  @override
  final String interestImage;
  @override
  final bool isSelected;
  @override
  final String id;

  factory _$Interest([void updates(InterestBuilder b)]) =>
      (new InterestBuilder()..update(updates)).build();

  _$Interest._(
      {this.interestName, this.interestImage, this.isSelected, this.id})
      : super._();

  @override
  Interest rebuild(void updates(InterestBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  InterestBuilder toBuilder() => new InterestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Interest &&
        interestName == other.interestName &&
        interestImage == other.interestImage &&
        isSelected == other.isSelected &&
        id == other.id;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc(0, interestName.hashCode), interestImage.hashCode),
            isSelected.hashCode),
        id.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Interest')
          ..add('interestName', interestName)
          ..add('interestImage', interestImage)
          ..add('isSelected', isSelected)
          ..add('id', id))
        .toString();
  }
}

class InterestBuilder implements Builder<Interest, InterestBuilder> {
  _$Interest _$v;

  String _interestName;
  String get interestName => _$this._interestName;
  set interestName(String interestName) => _$this._interestName = interestName;

  String _interestImage;
  String get interestImage => _$this._interestImage;
  set interestImage(String interestImage) =>
      _$this._interestImage = interestImage;

  bool _isSelected;
  bool get isSelected => _$this._isSelected;
  set isSelected(bool isSelected) => _$this._isSelected = isSelected;

  String _id;
  String get id => _$this._id;
  set id(String id) => _$this._id = id;

  InterestBuilder();

  InterestBuilder get _$this {
    if (_$v != null) {
      _interestName = _$v.interestName;
      _interestImage = _$v.interestImage;
      _isSelected = _$v.isSelected;
      _id = _$v.id;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Interest other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Interest;
  }

  @override
  void update(void updates(InterestBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$Interest build() {
    final _$result = _$v ??
        new _$Interest._(
            interestName: interestName,
            interestImage: interestImage,
            isSelected: isSelected,
            id: id);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
