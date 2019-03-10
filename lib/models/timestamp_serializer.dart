import 'package:built_value/serializer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DateTimeToTimestampSerializerPlugin implements SerializerPlugin {
  @override
  Object beforeSerialize(Object object, FullType specifiedType) {
    return object;
  }

  @override
  Object afterSerialize(Object object, FullType specifiedType) {
    if (object is int && specifiedType.root == DateTime)
      return Timestamp.fromMicrosecondsSinceEpoch(object);

    return object;
  }

  @override
  Object beforeDeserialize(Object object, FullType specifiedType) {
    if (object is Timestamp && specifiedType.root == DateTime)
      return object.microsecondsSinceEpoch;

    return object;
  }

  @override
  Object afterDeserialize(Object object, FullType specifiedType) {
    return object;
  }
}