import 'package:flutter/material.dart';
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
    this.style,
    this.isExpanded = true,
    this.textAlign = TextAlign.left,
  }) : super(key: key);

  final String fieldName;
  final String formName;
  final double? paddingTop;
  final double? paddingBottom;
  final double? paddingLeft;
  final double? paddingRight;
  final TextAlign textAlign;
  final TextStyle? style;
  final bool isExpanded;

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
        final hasText = field?.error?.isNotEmpty == true;
        return AnimatedPadding(
          padding: EdgeInsets.only(
            bottom: !hasText ? 0.0 : widget.paddingBottom ?? 0.0,
            top: !hasText ? 0.0 : widget.paddingTop ?? 0.0,
            right: !hasText ? 0.0 : widget.paddingRight ?? 0.0,
            left: !hasText ? 0.0 : widget.paddingLeft ?? 0.0,
          ),
          duration: kThemeAnimationDuration,
          child: AnimatedOpacity(
            opacity: hasText ? 1.0 : 0.0,
            duration: kThemeAnimationDuration,
            child: AnimatedSize(
              duration: kThemeAnimationDuration,
              child: SizedBox(
                width: (widget.isExpanded && hasText) ? double.infinity : null,
                height: !hasText ? 0.0 : null,
                child: Text(
                  field?.error ?? '',
                  style: widget.style,
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
