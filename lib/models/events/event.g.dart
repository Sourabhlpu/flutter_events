// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Event> _$eventSerializer = new _$EventSerializer();

class _$EventSerializer implements StructuredSerializer<Event> {
  @override
  final Iterable<Type> types = const [Event, _$Event];
  @override
  final String wireName = 'Event';

  @override
  Iterable serialize(Serializers serializers, Event object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[];
    if (object.id != null) {
      result
        ..add('id')
        ..add(serializers.serialize(object.id,
            specifiedType: const FullType(String)));
    }
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
    if (object.isFavorite != null) {
      result
        ..add('isFavorite')
        ..add(serializers.serialize(object.isFavorite,
            specifiedType: const FullType(bool)));
    }
    if (object.eventType != null) {
      result
        ..add('eventType')
        ..add(serializers.serialize(object.eventType,
            specifiedType:
                const FullType(BuiltList, const [const FullType(String)])));
    }
    if (object.startDate != null) {
      result
        ..add('startDate')
        ..add(serializers.serialize(object.startDate,
            specifiedType: const FullType(String)));
    }
    if (object.startTime != null) {
      result
        ..add('startTime')
        ..add(serializers.serialize(object.startTime,
            specifiedType: const FullType(String)));
    }
    if (object.endDate != null) {
      result
        ..add('endDate')
        ..add(serializers.serialize(object.endDate,
            specifiedType: const FullType(String)));
    }
    if (object.endTime != null) {
      result
        ..add('endTime')
        ..add(serializers.serialize(object.endTime,
            specifiedType: const FullType(String)));
    }
    if (object.entryFees != null) {
      result
        ..add('entryFees')
        ..add(serializers.serialize(object.entryFees,
            specifiedType: const FullType(String)));
    }

    return result;
  }

  @override
  Event deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new EventBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
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
        case 'eventType':
          result.eventType.replace(serializers.deserialize(value,
                  specifiedType:
                      const FullType(BuiltList, const [const FullType(String)]))
              as BuiltList);
          break;
        case 'startDate':
          result.startDate = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'startTime':
          result.startTime = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'endDate':
          result.endDate = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'endTime':
          result.endTime = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'entryFees':
          result.entryFees = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$Event extends Event {
  @override
  final String id;
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
  @override
  final BuiltList<String> eventType;
  @override
  final String startDate;
  @override
  final String startTime;
  @override
  final String endDate;
  @override
  final String endTime;
  @override
  final String entryFees;

  factory _$Event([void updates(EventBuilder b)]) =>
      (new EventBuilder()..update(updates)).build();

  _$Event._(
      {this.id,
      this.title,
      this.image,
      this.location,
      this.date,
      this.price,
      this.by,
      this.about,
      this.category,
      this.isFavorite,
      this.eventType,
      this.startDate,
      this.startTime,
      this.endDate,
      this.endTime,
      this.entryFees})
      : super._();

  @override
  Event rebuild(void updates(EventBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  EventBuilder toBuilder() => new EventBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Event &&
        id == other.id &&
        title == other.title &&
        image == other.image &&
        location == other.location &&
        date == other.date &&
        price == other.price &&
        by == other.by &&
        about == other.about &&
        category == other.category &&
        isFavorite == other.isFavorite &&
        eventType == other.eventType &&
        startDate == other.startDate &&
        startTime == other.startTime &&
        endDate == other.endDate &&
        endTime == other.endTime &&
        entryFees == other.entryFees;
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
                                        $jc(
                                            $jc(
                                                $jc(
                                                    $jc(
                                                        $jc(
                                                            $jc(
                                                                $jc(0,
                                                                    id.hashCode),
                                                                title.hashCode),
                                                            image.hashCode),
                                                        location.hashCode),
                                                    date.hashCode),
                                                price.hashCode),
                                            by.hashCode),
                                        about.hashCode),
                                    category.hashCode),
                                isFavorite.hashCode),
                            eventType.hashCode),
                        startDate.hashCode),
                    startTime.hashCode),
                endDate.hashCode),
            endTime.hashCode),
        entryFees.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Event')
          ..add('id', id)
          ..add('title', title)
          ..add('image', image)
          ..add('location', location)
          ..add('date', date)
          ..add('price', price)
          ..add('by', by)
          ..add('about', about)
          ..add('category', category)
          ..add('isFavorite', isFavorite)
          ..add('eventType', eventType)
          ..add('startDate', startDate)
          ..add('startTime', startTime)
          ..add('endDate', endDate)
          ..add('endTime', endTime)
          ..add('entryFees', entryFees))
        .toString();
  }
}

class EventBuilder implements Builder<Event, EventBuilder> {
  _$Event _$v;

  String _id;
  String get id => _$this._id;
  set id(String id) => _$this._id = id;

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

  ListBuilder<String> _eventType;
  ListBuilder<String> get eventType =>
      _$this._eventType ??= new ListBuilder<String>();
  set eventType(ListBuilder<String> eventType) => _$this._eventType = eventType;

  String _startDate;
  String get startDate => _$this._startDate;
  set startDate(String startDate) => _$this._startDate = startDate;

  String _startTime;
  String get startTime => _$this._startTime;
  set startTime(String startTime) => _$this._startTime = startTime;

  String _endDate;
  String get endDate => _$this._endDate;
  set endDate(String endDate) => _$this._endDate = endDate;

  String _endTime;
  String get endTime => _$this._endTime;
  set endTime(String endTime) => _$this._endTime = endTime;

  String _entryFees;
  String get entryFees => _$this._entryFees;
  set entryFees(String entryFees) => _$this._entryFees = entryFees;

  EventBuilder();

  EventBuilder get _$this {
    if (_$v != null) {
      _id = _$v.id;
      _title = _$v.title;
      _image = _$v.image;
      _location = _$v.location;
      _date = _$v.date;
      _price = _$v.price;
      _by = _$v.by;
      _about = _$v.about;
      _category = _$v.category;
      _isFavorite = _$v.isFavorite;
      _eventType = _$v.eventType?.toBuilder();
      _startDate = _$v.startDate;
      _startTime = _$v.startTime;
      _endDate = _$v.endDate;
      _endTime = _$v.endTime;
      _entryFees = _$v.entryFees;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Event other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Event;
  }

  @override
  void update(void updates(EventBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$Event build() {
    _$Event _$result;
    try {
      _$result = _$v ??
          new _$Event._(
              id: id,
              title: title,
              image: image,
              location: location,
              date: date,
              price: price,
              by: by,
              about: about,
              category: category,
              isFavorite: isFavorite,
              eventType: _eventType?.build(),
              startDate: startDate,
              startTime: startTime,
              endDate: endDate,
              endTime: endTime,
              entryFees: entryFees);
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'eventType';
        _eventType?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'Event', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
