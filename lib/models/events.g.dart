// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'events.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Events> _$eventsSerializer = new _$EventsSerializer();

class _$EventsSerializer implements StructuredSerializer<Events> {
  @override
  final Iterable<Type> types = const [Events, _$Events];
  @override
  final String wireName = 'Events';

  @override
  Iterable serialize(Serializers serializers, Events object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'isFavorite',
      serializers.serialize(object.isFavorite,
          specifiedType: const FullType(bool)),
    ];
    if (object.title != null) {
      result
        ..add('title')
        ..add(serializers.serialize(object.title,
            specifiedType: const FullType(String)));
    }
    if (object.image != null) {
      result
        ..add('image')
        ..add(serializers.serialize(object.image,
            specifiedType: const FullType(String)));
    }
    if (object.location != null) {
      result
        ..add('location')
        ..add(serializers.serialize(object.location,
            specifiedType: const FullType(String)));
    }
    if (object.date != null) {
      result
        ..add('date')
        ..add(serializers.serialize(object.date,
            specifiedType: const FullType(String)));
    }
    if (object.price != null) {
      result
        ..add('price')
        ..add(serializers.serialize(object.price,
            specifiedType: const FullType(String)));
    }
    if (object.by != null) {
      result
        ..add('by')
        ..add(serializers.serialize(object.by,
            specifiedType: const FullType(String)));
    }
    if (object.about != null) {
      result
        ..add('about')
        ..add(serializers.serialize(object.about,
            specifiedType: const FullType(String)));
    }
    if (object.category != null) {
      result
        ..add('category')
        ..add(serializers.serialize(object.category,
            specifiedType: const FullType(String)));
    }

    return result;
  }

  @override
  Events deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new EventsBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'title':
          result.title = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'image':
          result.image = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'location':
          result.location = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'date':
          result.date = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'price':
          result.price = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'by':
          result.by = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'about':
          result.about = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'category':
          result.category = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'isFavorite':
          result.isFavorite = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
      }
    }

    return result.build();
  }
}

class _$Events extends Events {
  @override
  final String title;
  @override
  final String image;
  @override
  final String location;
  @override
  final String date;
  @override
  final String price;
  @override
  final String by;
  @override
  final String about;
  @override
  final String category;
  @override
  final bool isFavorite;

  factory _$Events([void updates(EventsBuilder b)]) =>
      (new EventsBuilder()..update(updates)).build();

  _$Events._(
      {this.title,
      this.image,
      this.location,
      this.date,
      this.price,
      this.by,
      this.about,
      this.category,
      this.isFavorite})
      : super._() {
    if (isFavorite == null) {
      throw new BuiltValueNullFieldError('Events', 'isFavorite');
    }
  }

  @override
  Events rebuild(void updates(EventsBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  EventsBuilder toBuilder() => new EventsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Events &&
        title == other.title &&
        image == other.image &&
        location == other.location &&
        date == other.date &&
        price == other.price &&
        by == other.by &&
        about == other.about &&
        category == other.category &&
        isFavorite == other.isFavorite;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc(
                        $jc(
                            $jc($jc($jc(0, title.hashCode), image.hashCode),
                                location.hashCode),
                            date.hashCode),
                        price.hashCode),
                    by.hashCode),
                about.hashCode),
            category.hashCode),
        isFavorite.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Events')
          ..add('title', title)
          ..add('image', image)
          ..add('location', location)
          ..add('date', date)
          ..add('price', price)
          ..add('by', by)
          ..add('about', about)
          ..add('category', category)
          ..add('isFavorite', isFavorite))
        .toString();
  }
}

class EventsBuilder implements Builder<Events, EventsBuilder> {
  _$Events _$v;

  String _title;
  String get title => _$this._title;
  set title(String title) => _$this._title = title;

  String _image;
  String get image => _$this._image;
  set image(String image) => _$this._image = image;

  String _location;
  String get location => _$this._location;
  set location(String location) => _$this._location = location;

  String _date;
  String get date => _$this._date;
  set date(String date) => _$this._date = date;

  String _price;
  String get price => _$this._price;
  set price(String price) => _$this._price = price;

  String _by;
  String get by => _$this._by;
  set by(String by) => _$this._by = by;

  String _about;
  String get about => _$this._about;
  set about(String about) => _$this._about = about;

  String _category;
  String get category => _$this._category;
  set category(String category) => _$this._category = category;

  bool _isFavorite;
  bool get isFavorite => _$this._isFavorite;
  set isFavorite(bool isFavorite) => _$this._isFavorite = isFavorite;

  EventsBuilder();

  EventsBuilder get _$this {
    if (_$v != null) {
      _title = _$v.title;
      _image = _$v.image;
      _location = _$v.location;
      _date = _$v.date;
      _price = _$v.price;
      _by = _$v.by;
      _about = _$v.about;
      _category = _$v.category;
      _isFavorite = _$v.isFavorite;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Events other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Events;
  }

  @override
  void update(void updates(EventsBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$Events build() {
    final _$result = _$v ??
        new _$Events._(
            title: title,
            image: image,
            location: location,
            date: date,
            price: price,
            by: by,
            about: about,
            category: category,
            isFavorite: isFavorite);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
