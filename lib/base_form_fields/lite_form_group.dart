// ignore_for_file: must_be_immutable

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lite_forms/base_form_fields/mixins/post_frame_mixin.dart';
import 'package:lite_forms/controllers/lite_form_controller.dart';
import 'package:lite_forms/lite_forms.dart';

/// all of the forms' errors, hints and labels call this
/// function before displaying. The value passed as a parameter.
/// If you need to translate the value of even change it completely
/// return your value.
///
/// The way you implement your localization mechanism is up to you
typedef TranslationBuilder = String? Function(String? value);

String? defaultTranslationBuilder(String? value) {
  // if (kDebugMode) {
  //   if (value != null) {
  //     print('LiteFormGroup.defaultTranslationBuilder("$value")');
  //   }
  // }
  return value;
}

typedef LiteFormBuilder = Widget Function(
  BuildContext context,
  ScrollController scrollController,
);

class LiteFormGroup extends InheritedWidget {
  ScrollController? _scrollController;
  ScrollController get scrollController {
    _scrollController ??= ScrollController();
    return _scrollController!;
  }

  /// Wrap your form with this group. Inside you can use any
  /// LiteForm fields. Here's the list of basic LiteFormFields ->
  ///
  /// [LiteTextFormField] : used to create a text input, including a multiline one and
  /// an input with a separate route to enter text.
  ///
  /// [LiteDatePicker] : a flexible and powerful date picker which
  /// can use a cupertino or a material style, or use an adaptive view.
  /// It can be used to pick date, date and time, or time only
  LiteFormGroup({
    Key? key,
    required this.name,
    this.autoDispose = true,
    this.autoRemoveUnregisteredFields = true,
    this.allowUnfocusOnTapOutside,
    this.translationBuilder = defaultTranslationBuilder,
    ScrollController? scrollController,
    required LiteFormBuilder builder,
  }) : super(
          child: _LiteGroupWrapper(
            name: name,
            autoRemoveUnregisteredFields: autoRemoveUnregisteredFields,
            allowUnfocusOnTapOutside: allowUnfocusOnTapOutside,
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
                  autoRemoveUnregisteredFields: autoRemoveUnregisteredFields,
                );
                // if (LiteFormGroup.of(c)!.scrollController == null) {
                //   LiteFormGroup.of(c)!.scrollController = ScrollController();
                // }
                return builder(
                  c,
                  LiteFormGroup.of(c)!.scrollController,
                );
              },
            ),
          ),
          key: key,
        ) {
    _scrollController = scrollController;
  }

  /// Form name.
  final String name;

  /// All of the forms' errors, hints and labels call this
  /// function before displaying. The value passed as a parameter.
  /// If you need to translate the value of even change it completely
  /// return your value.
  ///
  /// The way you implement your localization mechanism is up to you
  final TranslationBuilder translationBuilder;

  /// if [autoDispose] is true, the form will be automatically
  /// disposed when a containing widget is disposed.
  /// True by default.
  /// If you change it to false, the form will be stored during the
  /// whole app lifecycle or unless you call
  /// clearLiteForm method
  final bool autoDispose;

  /// [autoRemoveUnregisteredFields] If some condition removes a form field
  /// from your form
  final bool autoRemoveUnregisteredFields;

  /// if true it will automatically unfocus any active focus node
  /// on tap outside. null by default, which equivalent to true
  /// You can also set this globally via a config
  /// value passed into a [initializeLiteForms] function,
  /// [true] by default
  final bool? allowUnfocusOnTapOutside;

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
    required this.allowUnfocusOnTapOutside,
    required this.autoRemoveUnregisteredFields,
  });

  final String name;
  final Widget child;
  final VoidCallback onDispose;
  final bool? allowUnfocusOnTapOutside;
  final bool autoRemoveUnregisteredFields;

  @override
  State<_LiteGroupWrapper> createState() => __LiteGroupWrapperState();
}

class __LiteGroupWrapperState extends State<_LiteGroupWrapper>
    with PostFrameMixin {
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    widget.onDispose();
    super.dispose();
  }

  /// Called after a frame has been built
  /// to make sure all dependencies are set
  Future _tryUnregisterFields(BuildContext _) async {
    final allFields = liteFormController.getAllFieldsOfForm(
      formName: widget.name,
    );
    for (var field in allFields) {
      liteFormController.changeRemoveState(
        fieldName: field.name,
        formName: widget.name,
        isRemoved: !field.isMounted,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Theme.of(context).brightness;
    liteFormController.updateBrightness(
      Theme.of(context).brightness,
    );
    if (widget.autoRemoveUnregisteredFields) {
      callAfterFrame(_tryUnregisterFields);
    }

    liteFormController.checkAlwaysValidatingFields(
      formName: widget.name,
    );
    bool isUnfocuserEnabled = false;
    if (!kIsWeb) {
      isUnfocuserEnabled = widget.allowUnfocusOnTapOutside ??
          liteFormController.config?.allowUnfocusOnTapOutside ??
          true;
    }
    return Unfocuser(
      isEnabled: isUnfocuserEnabled,
      child: Container(
        color: Colors.transparent,
        child: Form(
          key: _formKey,
          child: widget.child,
        ),
      ),
    );
  }

  @override
  void didFirstLayoutFinished(BuildContext context) {}
}
