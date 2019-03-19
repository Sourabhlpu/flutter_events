library serializers;


import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter_events/models/interests/interest.dart';
import 'package:flutter_events/models/events/event.dart';
import 'timestamp_serializer.dart';
import 'users/user_fs.dart';


part 'serializers.g.dart';

/// Example of how to use built_value serialization.
///
/// Declare a top level [Serializers] field called serializers. Annotate it
/// with [SerializersFor] and provide a `const` `List` of types you want to
/// be serializable.
///
/// The built_value code generator will provide the implementation. It will
/// contain serializers for all the types asked for explicitly plus all the
/// types needed transitively via fields.
///
/// You usually only need to do this once per project.
@SerializersFor(const [
  Event,
  Interest,
  UserFireStore,
])
Serializers serializers = _$serializers;

Serializers standardSerializers =
(serializers.toBuilder()..addPlugin(StandardJsonPlugin())..addPlugin(DateTimeToTimestampSerializerPlugin())).build();