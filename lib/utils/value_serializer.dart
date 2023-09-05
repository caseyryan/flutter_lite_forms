/// used to write custom value serializers
typedef LiteFormValueSerializer = Object? Function(Object? value);

/// The default for all fields. This means that the values is 
/// supposed to be accepted as is. If you need to convert the 
/// value somehow, write your custom serializer for a particular field
Object? nonConvertingSerializer(Object? value) {
  return value;
}
