import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:lite_forms/base_form_fields/exports.dart';
import 'package:lite_forms/constants.dart';
import 'package:lite_forms/controllers/lite_form_controller.dart';

// class

class LiteDropSelectorMultipleSheet extends StatelessWidget {
  const LiteDropSelectorMultipleSheet({
    super.key,
    required this.items,
    required this.settings,
    required this.onRemove,
    this.paddingTop = 0.0,
    this.paddingBottom = 0.0,
    this.paddingLeft = 0.0,
    this.paddingRight = 0.0,
  });

  final double paddingTop;
  final double paddingBottom;
  final double paddingLeft;
  final double paddingRight;
  final DropSelectorSettings? settings;
  final ValueChanged<LiteDropSelectorItem> onRemove;

  final List<LiteDropSelectorItem> items;

  Widget _buildChild(
    List<Widget> chips,
  ) {
    if (settings?.multiselectorStyle == MultiSelectorStyle.row) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: chips.map((Widget e) {
            return Padding(
              padding: EdgeInsets.only(
                right: settings?.chipSpacing ?? kDefaultChipSpacing,
              ),
              child: e,
            );
          }).toList(),
        ),
      );
    } else if (settings?.multiselectorStyle == MultiSelectorStyle.column) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: chips.map((Widget e) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: settings?.chipSpacing ?? kDefaultChipSpacing,
            ),
            child: e,
          );
        }).toList(),
      );
    }
    return Wrap(
      spacing: settings?.chipSpacing ?? kDefaultChipSpacing,
      runSpacing: settings?.chipSpacing ?? kDefaultChipSpacing,
      children: chips,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (items.length < 2) {
      return const SizedBox.shrink();;
    }
    final chips = items.mapIndexed(
      (i, e) {
        if (settings?.chipBuilder != null) {
          return settings!.chipBuilder!(
            e,
            onRemove,
          );
        }

        return LiteDropSelectorChip(
          settings: settings,
          key: Key('chip_$i'),
          onRemove: onRemove,
          item: e,
        );
      },
    ).toList();
    return Padding(
      padding: EdgeInsets.only(
        top: paddingTop,
        bottom: paddingBottom,
        left: paddingLeft,
        right: paddingRight,
      ),
      child: _buildChild(chips),
    );
  }
}

class LiteDropSelectorChip extends StatelessWidget {
  const LiteDropSelectorChip({
    super.key,
    required this.settings,
    required this.item,
    required this.onRemove,
  });

  final LiteDropSelectorItem item;
  final DropSelectorSettings? settings;
  final ValueChanged<LiteDropSelectorItem> onRemove;

  Color _getBackgroundColor(ThemeData theme) {
    return formConfig?.dropSelectorChipColor ?? theme.primaryColor;
  }

  EdgeInsets get _contentPadding {
    return formConfig?.dropSelectorSettings.chipContentPadding ?? const EdgeInsets.all(6.0);
  }

  BorderRadius get _borderRadius {
    return BorderRadius.only(
      topLeft: Radius.circular(
        formConfig?.dropSelectorSettings.chipTopLeftRadius ?? kDefaultChipRadius,
      ),
      topRight: Radius.circular(
        formConfig?.dropSelectorSettings.chipTopRightRadius ?? kDefaultChipRadius,
      ),
      bottomLeft: Radius.circular(
        formConfig?.dropSelectorSettings.chipBottomLeftRadius ?? kDefaultChipRadius,
      ),
      bottomRight: Radius.circular(
        formConfig?.dropSelectorSettings.chipBottomRightRadius ?? kDefaultChipRadius,
      ),
    );
  }

  DropSelectorSettings? get _settings {
    return settings ?? formConfig?.dropSelectorSettings;
  }

  TextStyle? _getTextStyle(BuildContext context) {
    return _settings?.chipTextStyle ?? formConfig?.defaultTextStyle ?? Theme.of(context).textTheme.titleMedium;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _getBackgroundColor(Theme.of(context)),
      shape: RoundedRectangleBorder(
        borderRadius: _borderRadius,
      ),
      // shape: SmoothRectangleBorder(
      //   borderRadius: _borderRadius,
      // ),
      child: Padding(
        padding: _contentPadding,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () {
                onRemove(item);
              },
              child: Container(
                width: 20.0,
                height: 20.0,
                decoration: BoxDecoration(
                  color: _settings?.chipCloseButtonColor ?? Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Center(
                  child: Icon(
                    Icons.close,
                    size: 16.0,
                    color: _settings?.chipCloseIconButtonColor ?? Theme.of(context).iconTheme.color,
                  ),
                ),
                // color: Colors.white,
              ),
            ),
            SizedBox(
              width: _contentPadding.right,
            ),
            Text(
              item.title,
              style: _getTextStyle(context)?.copyWith(color: Theme.of(context).cardColor),
            ),
          ],
        ),
      ),
    );
  }
}
