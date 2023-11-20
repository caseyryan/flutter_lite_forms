part of 'lite_drop_selector.dart';

enum LiteDropSelectorViewType {
  /// [bottomsheet] means the the selector will appear from the
  /// bottom of the screen
  bottomsheet,

  /// [menu] the selector will appear right from the tap area
  menu,

  /// [adaptive] means it will become a floating menu on wide screens
  /// and [bottomsheet] on narrow ones
  adaptive,
}

enum LiteDropSelectorActionType {
  singleSelect,
  multiselect,
  simple,

  /// The same as simple but it will not highlight the
  /// selected button. Might be useful for action sheets
  simpleWithNoSelection,
}
