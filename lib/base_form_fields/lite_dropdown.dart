import 'package:flutter/material.dart';
import 'package:lite_forms/utils/value_serializer.dart';
import 'package:lite_forms/utils/value_validator.dart';

class LiteDropdown extends StatefulWidget {
  const LiteDropdown({
    required this.name,
    super.key,
    this.initialValueDeserializer,
    this.validator,
    this.serializer = nonConvertingValueConvertor,
  });

  final String name;

  /// Allows you to convert initial value to a proper data type or
  /// format before using it. E.g. you have a iso8601 format but you need
  /// to have a DateTime object to work with in a date picker.
  /// Use [initialValueDeserializer] to convert iso8601 value to a DateTime
  /// like so: initialValueDeserializer: (value) => DateTime.parse(value);
  /// and you will get a DateTime as an initial value. You can use any custom
  /// conversions you want
  final LiteFormValueConvertor? initialValueDeserializer;
  final LiteFormFieldValidator<Object?>? validator;

  /// Allows you to prepare the data for some general usage like sending it
  /// to an api endpoint. E.g. you have a Date Picker which returns a DateTime object
  /// but you need to send it to a backend in a iso8601 string format.
  /// Just pass the serializer like this: serializer: (value) => value.toIso8601String()
  /// And it will always store this date as a string in a form map which you can easily send
  /// wherever you need
  final LiteFormValueConvertor serializer;

  @override
  State<LiteDropdown> createState() => _LiteDropdownState();
}

class _LiteDropdownState extends State<LiteDropdown> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
