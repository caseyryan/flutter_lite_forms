/// used to write custom value serializers / deserializers
typedef LiteFormValueConvertor = Object? Function(dynamic value);

/// The default for all fields. This means that the values is 
/// supposed to be accepted as is. If you need to convert the 
/// value somehow, write your custom serializer for a particular field
Object? nonConvertingValueConvertor(Object? value) {
  return value;
}
