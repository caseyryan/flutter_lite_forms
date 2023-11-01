import 'package:lite_forms/lite_forms.dart';

DynamicFormController get dynamicFormController {
  return findController<DynamicFormController>();
}

class DynamicFormController extends LiteStateController<DynamicFormController> {
  bool _isWithPhone = false;
  bool get isWithPhone => _isWithPhone;
  void onPhoneUseChange(bool value) {
    _isWithPhone = value;
    rebuild();
  }

  @override
  void reset() {}
  @override
  void onLocalStorageInitialized() {}
}
