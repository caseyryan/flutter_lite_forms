import 'package:lite_forms/controllers/lite_form_controller.dart';
import 'package:lite_forms/controllers/lite_form_rebuild_controller.dart';
import 'package:lite_state/lite_state.dart';

import 'lite_forms_configuration.dart';

/// Call it somewhere in the beginning of your app code
/// [config] allows you to configure the look and feel
/// for all of your form fields by default.
/// Doing this you won't have to set decorations, paddings
/// and other common stuff for your forms everywhere
void initializeLiteForms({
  LiteFormsConfiguration? config,
}) {
  initControllersLazy({
    LiteFormController: () => LiteFormController(),

    /// this controller is used as a helper to rebuild some parts of the UI
    /// related to the inners parts of the form fields
    LiteFormRebuildController: () => LiteFormRebuildController(),
  });
  if (config != null) {
    liteFormController.configureLiteFormUI(
      config: config,
    );
  }
}
