part of 'lite_drop_selector.dart';

typedef MenuItemBuilder = Widget? Function(
  int index,
  LiteDropSelectorItem item,
  bool isLast,
  double menuWidth,
);

Completer? _completer;
OverlayEntry? _overlayEntry;

void _closeDropSelector(Object? value) {
  _overlayEntry?.remove();
  _overlayEntry = null;
  _completer?.complete(value);
  _completer = null;
}

Future showDropSelector({
  required List<LiteDropSelectorItem> buttonDatas,
  required Offset tapPosition,
  required BuildContext context,
  required InputDecoration? decoration,
  required Size buttonSize,
  required DropSelectorSettings settings,
  required TextStyle? style,
  required LiteForm group,

  /// [title] if a non empty string passed here it will be used as a title
  String title = '',
  MenuItemBuilder? menuItemBuilder,
}) async {
  if (_completer != null) {
    return _completer!.future;
  }
  FocusScope.of(context).unfocus();
  final args = LiteDropSelectorRouteArgs(
    items: buttonDatas,
    title: title,
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
  _overlayEntry = OverlayEntry(
    builder: (context) {
      return DropSelectorView(
        args: args,
      );
    },
  );
  _completer = Completer();
  Overlay.of(context).insert(_overlayEntry!);
  return _completer!.future;
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
    this.searchSettings = const MenuSearchConfiguration(),
    this.veilColor,
    this.maxMenuWidth,
    this.maxVeilOpacity = .3,
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
  final MenuSearchConfiguration searchSettings;
  final double? chipSpacing;
  final double? topLeftRadius;
  final double? topRightRadius;
  final double? bottomLeftRadius;
  final double? bottomRightRadius;
  final double? maxMenuWidth;
  final DropSelectorType? dropSelectorType;
  final DropSelectorActionType? dropSelectorActionType;

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
    DropSelectorType? dropSelectorType,
    DropSelectorActionType? dropSelectorActionType,
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
      searchSettings: menuSearchConfiguration ?? this.searchSettings,
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
    this.title = '',
  });

  final LiteForm group;
  final InputDecoration? decoration;
  final List<LiteDropSelectorItem> items;
  final Offset buttonLeftTopCorner;
  final Size buttonSize;
  final DropSelectorSettings dropSelectorSettings;
  final TextStyle? style;

  /// [title] if a non empty string passed here it will be used as a title
  final String title;
  MenuItemBuilder? menuItemBuilder;
}

// class LiteDropSelectorRoute extends ModalRoute {
//   final LiteDropSelectorRouteArgs args;

//   LiteDropSelectorRoute(this.args);

//   @override
//   Color? get barrierColor => null;

//   @override
//   bool get barrierDismissible => false;

//   @override
//   String? get barrierLabel => null;

//   @override
//   Widget buildPage(
//     BuildContext context,
//     Animation<double> animation,
//     Animation<double> secondaryAnimation,
//   ) {
//     return DropSelectorView(
//       args: args,
//     );
//   }

//   @override
//   bool get maintainState => true;

//   @override
//   bool get opaque => false;

//   @override
//   Duration get transitionDuration => kThemeAnimationDuration;
// }
