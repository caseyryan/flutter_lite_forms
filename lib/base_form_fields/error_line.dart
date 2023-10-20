import 'package:flutter/material.dart';
import 'package:lite_forms/base_form_fields/lite_form_group.dart';
import 'package:lite_forms/controllers/lite_form_controller.dart';
import 'package:lite_state/lite_state.dart';

class LiteFormErrorLine extends StatefulWidget {
  const LiteFormErrorLine({
    Key? key,
    required this.fieldName,
    required this.formName,
    this.paddingTop,
    this.paddingBottom,
    this.paddingRight,
    this.paddingLeft,
    this.isExpanded = true,
    this.errorStyle,
    this.textAlign = TextAlign.left,
  }) : super(key: key);

  final String fieldName;
  final String formName;
  final double? paddingTop;
  final double? paddingBottom;
  final double? paddingLeft;
  final double? paddingRight;
  final TextAlign textAlign;
  final bool isExpanded;
  final TextStyle? errorStyle;

  @override
  State<LiteFormErrorLine> createState() => _LiteFormErrorLineState();
}

class _LiteFormErrorLineState extends State<LiteFormErrorLine> {
  @override
  Widget build(BuildContext context) {
    return LiteState<LiteFormController>(
      builder: (BuildContext c, LiteFormController controller) {
        final field = controller.tryGetField(
          fieldName: widget.fieldName,
          formName: widget.formName,
        );
        final group = LiteFormGroup.of(context)!;
        final errorText = group.translationBuilder(field?.error);
        final hasText = errorText?.isNotEmpty == true;

        return AnimatedOpacity(
          opacity: hasText ? 1.0 : 0.0,
          duration: kThemeAnimationDuration,
          child: AnimatedSize(
            alignment: Alignment.topLeft,
            duration: kThemeAnimationDuration,
            child: Padding(
              padding: EdgeInsets.only(
                bottom: !hasText ? 0.0 : widget.paddingBottom ?? 0.0,
                top: !hasText ? 0.0 : widget.paddingTop ?? 0.0,
                right: !hasText ? 0.0 : widget.paddingRight ?? 0.0,
                left: !hasText ? 0.0 : widget.paddingLeft ?? 0.0,
              ),
              child: SizedBox(
                width: widget.isExpanded ? double.infinity : null,
                height: !hasText ? 0.0 : null,
                child: Text(
                  errorText ?? '',
                  style: widget.errorStyle,
                  textAlign: widget.textAlign,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
