// ignore_for_file: library_private_types_in_public_api

import 'dart:collection';

import 'package:flutter/material.dart';

class CountryFlag extends StatefulWidget {
  static final HashSet<String> _hasFlagStates = HashSet();

  static bool hasFlagIcon(String? countryId) {
    if (countryId == null) {
      return false;
    }
    countryId = countryId.toLowerCase();
    return !_hasFlagStates.contains(countryId);
  }

  final String? countryId;
  final double width;
  final double height;
  final bool isCircle;
  final VoidCallback onFlagError;

  const CountryFlag({
    Key? key,
    this.width = 50.0,
    this.height = 50.0,
    this.isCircle = true,
    required this.countryId,
    required this.onFlagError,
  }) : super(key: key);

  @override
  _CountryFlagState createState() => _CountryFlagState();
}

class _CountryFlagState extends State<CountryFlag> {
  @override
  Widget build(BuildContext context) {
    final countryId = widget.countryId?.toLowerCase();
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          widget.isCircle ? widget.height * widget.width : 3.0,
        ),
        image: DecorationImage(
          image: AssetImage(
            'icons/flags/png/$countryId.png',
            package: 'country_icons',
          ),
          onError: (e, s) {
            if (countryId != null && mounted) {
              setState(() {
                CountryFlag._hasFlagStates.add(countryId);
                widget.onFlagError();
              });
            }
          },
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
