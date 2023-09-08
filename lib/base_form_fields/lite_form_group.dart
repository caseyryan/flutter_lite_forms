import 'package:flutter/material.dart';
import 'package:lite_forms/controllers/lite_form_controller.dart';
import 'package:lite_state/lite_state.dart';

/// Wrap your form with this group
class LiteFormGroup extends InheritedWidget {
  LiteFormGroup({
    Key? key,
    required this.name,
    this.autoDispose = true,
    required Widget child,
  }) : super(
          child: _LiteGroupWrapper(
            name: name,
            onDispose: () {
              liteFormController.onFormDisposed(
                formName: name,
                autoDispose: autoDispose,
              );
            },
            child: LiteState<LiteFormController>(
              builder: (BuildContext c, LiteFormController controller) {
                final formState = Form.of(c);
                controller.createFormIfNull(
                  formName: name,
                  formState: formState,
                );

                return child;
              },
            ),
          ),
          key: key,
        );

  /// Form name.
  final String name;

  /// if [autoDispose] is true, the form will be automatically
  /// disposed when a containing widget is disposed.
  /// True by default.
  /// If you change it to false, the worm will be stored during the
  /// whole app lifecycle or unless you call
  /// clearLiteForm method
  final bool autoDispose;

  @override
  bool updateShouldNotify(LiteFormGroup oldWidget) => false;
  static LiteFormGroup? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<LiteFormGroup>();
}

class _LiteGroupWrapper extends StatefulWidget {
  const _LiteGroupWrapper({
    required this.child,
    required this.onDispose,
    required this.name,
  });

  final String name;
  final Widget child;
  final VoidCallback onDispose;

  @override
  State<_LiteGroupWrapper> createState() => __LiteGroupWrapperState();
}

class __LiteGroupWrapperState extends State<_LiteGroupWrapper> {
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    widget.onDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    liteFormController.checkAlwaysValidatingFields(
      formName: widget.name,
    );
    return Form(
      key: _formKey,
      child: widget.child,
    );
  }
}
