

import 'package:flutter/material.dart';
import 'package:lite_forms/base_form_fields/exports.dart';

class LiteDropSelectorMultipleSheet extends StatelessWidget {
  const LiteDropSelectorMultipleSheet({
    super.key,
    required this.items,
  });

  final List<LiteDropSelectorItem> items;

  @override
  Widget build(BuildContext context) {
    if (items.length < 2) {
      return const SizedBox.shrink();
    }
    return const Placeholder();
  }
}
