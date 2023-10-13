import 'package:lite_state/lite_state.dart';

LiteFormRebuildController get liteFormRebuildController {
  return findController<LiteFormRebuildController>();
}

class LiteFormRebuildController extends LiteStateController<LiteFormRebuildController> {
  
  @override
  void reset() {
    
  }

  Future rebuildAfterMillis(int millis) async {
    await delay(millis);
    rebuild();
  }
  @override
  void onLocalStorageInitialized() {
    
  }
}