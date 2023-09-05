import 'package:lite_forms/controllers/lite_form_controller.dart';
import 'package:lite_state/lite_state.dart';

/// Call it somewhere in the beginning of your app code
void initializeLiteForms() {
  initControllersLazy({
    LiteFormController: () => LiteFormController(),
  });
}