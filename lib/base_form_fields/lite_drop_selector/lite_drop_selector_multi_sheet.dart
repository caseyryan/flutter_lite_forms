import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:lite_forms/base_form_fields/exports.dart';



class LiteDropSelectorMultipleSheet extends StatelessWidget {
  const LiteDropSelectorMultipleSheet({
    super.key,
    required this.items,
    this.paddingTop = 0.0,
    this.paddingBottom = 0.0,
    this.paddingLeft = 0.0,
    this.paddingRight = 0.0,
  });

  final double paddingTop;
  final double paddingBottom;
  final double paddingLeft;
  final double paddingRight;

  final List<LiteDropSelectorItem> items;

  @override
  Widget build(BuildContext context) {
    if (items.length < 2) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: EdgeInsets.only(
        top: paddingTop,
        bottom: paddingBottom,
        left: paddingLeft,
        right: paddingRight,
      ),
      child: Wrap(
        spacing: 10.0,
        runSpacing: 10.0,
        children: items.mapIndexed(
          (i, e) {
            return  LiteDropSelectorChip(
              key: Key('chip_$i'),
              item: e,
            );
          },
        ).toList(),
      ),
    );
  }
}

class LiteDropSelectorChip extends StatelessWidget {
  const LiteDropSelectorChip({
    super.key,
    required this.item,
  });

  final LiteDropSelectorItem item;

  @override
  Widget build(BuildContext context) {
    final group = LiteFormGroup.of(context);
    return Container(
      color: Colors.red,
      height: 30.0,
      constraints: const BoxConstraints(
        minWidth: 40.0,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            item.title,
          ),
        ],
      ),
    );
  }
}
