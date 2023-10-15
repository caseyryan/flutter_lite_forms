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
}
