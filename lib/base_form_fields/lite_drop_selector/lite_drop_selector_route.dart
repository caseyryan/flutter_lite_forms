part of 'lite_drop_selector.dart';

typedef MenuItemBuilder = Widget Function(
  int index,
  LiteDropSelectorItem item,
  bool isLast,
);

Future showDropSelector({
  required List<LiteDropSelectorItem> buttonDatas,
  required Offset tapPosition,
  required BuildContext context,
  required InputDecoration? decoration,
  required Size buttonSize,
  required DropSelectorSettings settings,
  required TextStyle? style,
  required LiteFormGroup group,
  MenuItemBuilder? menuItemBuilder,
}) async {
  FocusScope.of(context).unfocus();
  final args = LiteDropSelectorRouteArgs(
    items: buttonDatas,
    style: style,
    group: group,
    dropSelectorSettings: settings,
    buttonLeftTopCorner: Offset(
      tapPosition.dx,
      tapPosition.dy,
    ),
    decoration: decoration,
    buttonSize: buttonSize,
    menuItemBuilder: menuItemBuilder,
  );

  return await Navigator.of(context).push(
    LiteDropSelectorRoute(args),
  );
}

class MenuSearchConfiguration {
  const MenuSearchConfiguration({
    this.searchFieldVisibility = SearchFieldVisibility.adaptive,
    this.innerFieldSettings = const LiteSearchFieldSettings(),
    this.searchFieldDecoration,
    this.padding,
    this.autofocusSearchField = true,
  });

  final SearchFieldVisibility searchFieldVisibility;
  final LiteSearchFieldSettings innerFieldSettings;
  final InputDecoration? searchFieldDecoration;
  final EdgeInsets? padding;
  final bool autofocusSearchField;
}

typedef MultiselectChipBuilder = Widget Function(
  LiteDropSelectorItem item,
  ValueChanged<LiteDropSelectorItem> removeItem,
);

enum MultiSelectorStyle {
  wrap,
  row,
  column,
}

class DropSelectorSettings {
  const DropSelectorSettings({
    this.chipTextStyle,
    this.multiselectorStyle = MultiSelectorStyle.wrap,
    this.chipBuilder,
    this.chipSpacing = 8.0,
    this.chipCloseIconButtonColor,
    this.chipCloseButtonColor,
    this.topLeftRadius,
    this.topRightRadius,
    this.bottomLeftRadius,
    this.bottomRightRadius,
    this.chipTopLeftRadius = kDefaultChipRadius,
    this.chipTopRightRadius = kDefaultChipRadius,
    this.chipBottomLeftRadius = kDefaultChipRadius,
    this.chipBottomRightRadius = kDefaultChipRadius,
    this.buttonHeight,
    this.menuSearchConfiguration = const MenuSearchConfiguration(),
    this.veilColor,
    this.maxMenuWidth,
    this.maxVeilOpacity = .04,
    this.withScrollBar = true,
    this.dropSelectorType,
    this.dropSelectorActionType,
    this.sheetPadding = const EdgeInsets.all(
      8.0,
    ),
    this.chipContentPadding = const EdgeInsets.all(
      6.0,
    ),
  });

  /// [chipBuilder] use this callback if you need a completely custom
  /// chip for multi selector
  final MultiselectChipBuilder? chipBuilder;
  final MultiSelectorStyle multiselectorStyle;
  final MenuSearchConfiguration menuSearchConfiguration;
  final double? chipSpacing;
  final double? topLeftRadius;
  final double? topRightRadius;
  final double? bottomLeftRadius;
  final double? bottomRightRadius;
  final double? maxMenuWidth;
  final LiteDropSelectorViewType? dropSelectorType;
  final LiteDropSelectorActionType? dropSelectorActionType;

  final double chipTopLeftRadius;
  final double chipTopRightRadius;
  final double chipBottomLeftRadius;
  final double chipBottomRightRadius;

  final Color? veilColor;
  final double maxVeilOpacity;

  /// [buttonHeight] a height for a button i na list.
  /// Defaults to the current height of the drop selector
  final double? buttonHeight;
  final bool withScrollBar;
  final EdgeInsets sheetPadding;

  /// [chipContentPadding] is the padding around content inside
  /// a multiselect chips
  final EdgeInsets chipContentPadding;
  final TextStyle? chipTextStyle;
  final Color? chipCloseButtonColor;
  final Color? chipCloseIconButtonColor;

  DropSelectorSettings copyWith({
    MenuSearchConfiguration? menuSearchConfiguration,
    double? topLeftRadius,
    double? topRightRadius,
    double? bottomLeftRadius,
    double? bottomRightRadius,
    Color? veilColor,
    double? maxVeilOpacity,
    double? buttonHeight,
    bool? withScrollBar,
    EdgeInsets? sheetPadding,
    EdgeInsets? chipContentPadding,
    LiteDropSelectorViewType? dropSelectorType,
    LiteDropSelectorActionType? dropSelectorActionType,
  }) {
    return DropSelectorSettings(
      bottomLeftRadius: bottomLeftRadius ?? this.bottomLeftRadius,
      chipContentPadding: chipContentPadding ?? this.chipContentPadding,
      bottomRightRadius: bottomRightRadius ?? this.bottomRightRadius,
      topLeftRadius: topLeftRadius ?? this.topLeftRadius,
      topRightRadius: topRightRadius ?? this.topRightRadius,
      veilColor: veilColor ?? this.veilColor,
      maxVeilOpacity: maxVeilOpacity ?? this.maxVeilOpacity,
      buttonHeight: buttonHeight ?? this.buttonHeight,
      withScrollBar: withScrollBar ?? this.withScrollBar,
      sheetPadding: sheetPadding ?? this.sheetPadding,
      dropSelectorActionType: dropSelectorActionType ?? this.dropSelectorActionType,
      dropSelectorType: dropSelectorType ?? this.dropSelectorType,
    );
  }
}

enum SearchFieldVisibility {
  none,
  adaptive,
  always,
}

class LiteDropSelectorRouteArgs {
  LiteDropSelectorRouteArgs({
    required this.items,
    required this.buttonLeftTopCorner,
    required this.buttonSize,
    required this.decoration,
    required this.dropSelectorSettings,
    required this.style,
    required this.group,
    this.menuItemBuilder,
  });

  final LiteFormGroup group;
  final InputDecoration? decoration;
  final List<LiteDropSelectorItem> items;
  final Offset buttonLeftTopCorner;
  final Size buttonSize;
  final DropSelectorSettings dropSelectorSettings;
  final TextStyle? style;
  MenuItemBuilder? menuItemBuilder;
}

class LiteDropSelectorRoute extends ModalRoute {
  final LiteDropSelectorRouteArgs args;

  LiteDropSelectorRoute(this.args);

  @override
  Color? get barrierColor => null;

  @override
  bool get barrierDismissible => false;

  @override
  String? get barrierLabel => null;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return DropSelectorView(
      animation: animation,
      args: args,
    );
  }

  @override
  bool get maintainState => true;

  @override
  bool get opaque => false;

  @override
  Duration get transitionDuration => kThemeAnimationDuration;
}
