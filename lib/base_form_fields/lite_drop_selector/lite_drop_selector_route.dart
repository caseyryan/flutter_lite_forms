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
  required LiteDropSelectorViewType dropSelectorType,
  required LiteDropSelectorActionType dropSelectorActionType,
  required InputDecoration? decoration,
  required Size buttonSize,
  required LiteDropSelectorSettings settings,
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
    dropSelectorViewType: dropSelectorType,
    dropSelectorActionType: dropSelectorActionType,
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
    this.autofocusSearchField = false,
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

class LiteDropSelectorSettings {
  const LiteDropSelectorSettings({
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
    this.maxVeilOpacity = .04,
    this.withScrollBar = true,
    this.sheetPadding = const EdgeInsets.all(
      16.0,
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

  LiteDropSelectorSettings copyWith({
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
  }) {
    return LiteDropSelectorSettings(
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
    required this.dropSelectorViewType,
    required this.dropSelectorActionType,
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
  final LiteDropSelectorViewType dropSelectorViewType;
  final LiteDropSelectorActionType dropSelectorActionType;
  final LiteDropSelectorSettings dropSelectorSettings;
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

class DropSelectorView extends StatefulWidget {
  final Animation<double> animation;
  final LiteDropSelectorRouteArgs args;

  const DropSelectorView({
    Key? key,
    required this.animation,
    required this.args,
  }) : super(key: key);

  @override
  State<DropSelectorView> createState() => _DropSelectorViewState();
}

class _TempSelection {
  final String title;
  _TempSelection({
    required this.title,
  });
}

class _DropSelectorViewState extends State<DropSelectorView> with PostFrameMixin {
  final _sizeKey = GlobalKey();
  double _menuWidth = 0.0;
  Size? _size;
  final _draggableScrollableController = DraggableScrollableController();
  final ScrollController _scrollController = ScrollController();
  String? _searchValue;
  bool _isTopDirected = false;
  double _initialScreenHeight = 0.0;
  double _keyboardHeight = 0.0;
  final _searchFieldSizeKey = GlobalKey();
  double _searchFieldHeight = 0.0;

  /// for cancellation case
  List<_TempSelection> _initialSelection = [];

  @override
  void didFirstLayoutFinished(BuildContext context) {
    final size = MediaQuery.of(context).size;
    _initialScreenHeight = size.height;
    setState(() {
      _menuWidth = _sizeKey.currentContext!.size!.width.clamp(0.0, size.width);
      if (!_isSimple || _hasSearchField) {
        _menuWidth = max(
          _menuWidth,
          kMinDropSelectorWidth - _totalHorizontalPadding,
        );
      }
      for (var d in widget.args.items) {
        d._menuWidth = _menuWidth;
      }
    });
  }

  @override
  void initState() {
    _initialSelection = widget.args.items
        .where((e) => e.isSelected)
        .map((e) => _TempSelection(title: e.title))
        .toList();
    super.initState();
  }

  @override
  void dispose() {
    _draggableScrollableController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  LiteDropSelectorSettings get _settings {
    return widget.args.dropSelectorSettings;
  }

  bool get _isMultiselect {
    return widget.args.dropSelectorActionType == LiteDropSelectorActionType.multiselect;
  }

  bool get _isSingleSelect {
    return widget.args.dropSelectorActionType == LiteDropSelectorActionType.singleSelect;
  }

  bool get _isSimple {
    return widget.args.dropSelectorActionType == LiteDropSelectorActionType.simple;
  }

  void _onButtonPressed(
    LiteDropSelectorItem value,
  ) {
    FocusScope.of(context).unfocus();
    if (value.isSelected) {
      if (value.isSingleAction) {
        value.onPressed?.call([value]);
        return;
      }
    }

    if (value.type != null) {
      if (_isSimple) {
        Navigator.of(context).pop([value]);
        value.onPressed?.call([value]);
      }
    } else {
      if (_isMultiselect) {
        value.isSelected = !value.isSelected;
        final allSelected = widget.args.items.where((d) => d.isSelected).toList();
        value.onMultiSelection?.call(allSelected);
      } else if (_isSingleSelect) {
        for (var d in widget.args.items) {
          if (d.type != null) {
            continue;
          }
          d.isSelected = d == value;
        }
      }
      if (_isSimple) {
        Navigator.of(context).pop([value]);
      } else {
        setState(() {});
      }
      value.onPressed?.call([value]);
    }
  }

  double get _singleButtonHeight {
    return widget.args.buttonSize.height;
  }

  double get _totalButtonsHeight {
    return widget.args.items.length * _singleButtonHeight;
  }

  bool get _hasSearchField {
    if (_settings.menuSearchConfiguration.searchFieldVisibility ==
        SearchFieldVisibility.adaptive) {
      if (widget.args.items.length <= 8) {
        return false;
      }
    } else if (_settings.menuSearchConfiguration.searchFieldVisibility ==
        SearchFieldVisibility.none) {
      return false;
    }
    return true;
  }

  Widget _buildButtonRow() {
    if (_isSimple) {
      return const SizedBox.shrink();
    }
    return SizedBox(
      width: _menuWidth,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: _settings.sheetPadding.bottom,
        ),
        child: Row(
          children: [
            CupertinoButton(
              key: const Key('drop_selector_cancel_button'),
              onPressed: _onCancel,
              child: Text(
                widget.args.group.translationBuilder.call('Cancel')!,
              ),
            ),
            const Spacer(),
            CupertinoButton(
              key: const Key('drop_selector_done_button'),
              onPressed: () {
                final selectedItems = widget.args.items
                    .where(
                      (e) => e.isSelected,
                    )
                    .toList();
                Navigator.of(context).pop(
                  selectedItems,
                );
              },
              child: Text(
                widget.args.group.translationBuilder.call('Done')!,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _insertButtons(
    List<Widget> children,
  ) {
    if (_isTopDirected) {
      children.add(
        _buildButtonRow(),
      );
    } else {
      children.insert(
        0,
        _buildButtonRow(),
      );
    }
  }

  void _tryInsertSearchField(
    List<Widget> children,
  ) {
    if (!_hasSearchField) {
      return;
    }
    if (_searchFieldHeight == 0.0) {
      WidgetsBinding.instance.ensureVisualUpdate();
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        setState(() {
          _searchFieldHeight = _searchFieldSizeKey.currentContext?.size?.height ?? 0.0;
        });
      });
    }
    if (_isTopDirected) {
      children.add(
        SizedBox(
          width: _menuWidth,
          key: _searchFieldSizeKey,
          child: LiteSearchField(
            decoration: _settings.menuSearchConfiguration.searchFieldDecoration,
            settings: _settings.menuSearchConfiguration.innerFieldSettings,
            onSearch: _onSearch,
            autofocus: _settings.menuSearchConfiguration.autofocusSearchField,
            style: widget.args.style,
            paddingTop: _settings.menuSearchConfiguration.padding?.top ??
                _settings.sheetPadding.top,
            paddingBottom: _settings.menuSearchConfiguration.padding?.bottom ?? 0.0,
            paddingLeft: _settings.menuSearchConfiguration.padding?.left ??
                _settings.sheetPadding.left,
            paddingRight: _settings.menuSearchConfiguration.padding?.right ??
                _settings.sheetPadding.right,
          ),
        ),
      );
    } else {
      children.insert(
        0,
        SizedBox(
          width: _menuWidth,
          key: _searchFieldSizeKey,
          child: LiteSearchField(
            autofocus: _settings.menuSearchConfiguration.autofocusSearchField,
            onSearch: _onSearch,
            paddingTop: _settings.menuSearchConfiguration.padding?.top ?? 0.0,
            paddingBottom: _settings.menuSearchConfiguration.padding?.bottom ??
                _settings.sheetPadding.bottom,
            paddingLeft: _settings.menuSearchConfiguration.padding?.left ??
                _settings.sheetPadding.left,
            paddingRight: _settings.menuSearchConfiguration.padding?.right ??
                _settings.sheetPadding.right,
          ),
        ),
      );
    }
  }

  void _onSearch(String? value) {
    setState(() {
      _searchValue = value;
    });
  }

  bool get _requiresList {
    return _totalButtonsHeight > _viewportHeight;
  }

  Widget _buildButton(
    int index,
    LiteDropSelectorItem item,
    List items,
  ) {
    final isLast = index == items.length - 1;
    Widget button;
    if (widget.args.menuItemBuilder != null) {
      button = widget.args.menuItemBuilder!(
        index,
        item,
        isLast,
      );
    } else {
      button = Padding(
        padding: EdgeInsets.only(
          bottom: isLast ? 0.0 : _settings.sheetPadding.bottom,
        ),
        child: LiteDropSelectorButton(
          data: item,
          sheetSettings: _settings,
          decoration: widget.args.decoration,
          style: widget.args.style,
          paddingLeft: _settings.sheetPadding.left,
          paddingRight: _settings.sheetPadding.right,
          key: ValueKey(item),
          buttonHeight: _singleButtonHeight,
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        _onButtonPressed(item);
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          button,
        ],
      ),
    );
  }

  Widget _buildMenuContent() {
    final items = _filteredItems;
    final List<Widget> children = [
      Flexible(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: _isBottomSheet ? double.infinity : kMinDropSelectorWidth,
            maxHeight: _viewportHeight,
          ),
          child: Scrollbar(
            thickness: _settings.withScrollBar ? null : 0.0,
            controller: _scrollController,
            interactive: kIsWeb,
            child: _requiresList
                ? CustomScrollView(
                    controller: _scrollController,
                    shrinkWrap: true,
                    slivers: [
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final item = items[index];
                            return _buildButton(
                              index,
                              item,
                              items,
                            );
                          },
                          childCount: items.length,
                        ),
                      ),
                    ],
                  )
                : SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: items.mapIndexed(
                        (int index, item) {
                          return _buildButton(
                            index,
                            item,
                            items,
                          );
                        },
                      ).toList(),
                    ),
                  ),
          ),
        ),
      )
    ];
    if (_menuWidth > 0.0) {
      _tryInsertSearchField(children);
      _insertButtons(children);
    }
    return AnimatedSize(
      duration: kThemeAnimationDuration,
      curve: Curves.easeInOutExpo,
      alignment: _isTopDirected ? Alignment.bottomLeft : Alignment.topLeft,
      child: Padding(
        padding: EdgeInsets.only(
          top: _isBottomSheet ? _settings.sheetPadding.top : 0.0,
          bottom: _isBottomSheet ? _settings.sheetPadding.bottom : 0.0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: children,
        ),
      ),
    );
  }

  bool get isNarrowScreen {
    return _screenWidth < _screenHeight;
  }

  double get _screenWidth {
    return _size?.width ?? 0.0;
  }

  double get _screenHeight {
    return _size?.height ?? 0.0;
  }

  double get _safeScreenHeight {
    return _screenHeight - _bottomInset - _topInset;
  }

  double get _bottomInset {
    if (_keyboardHeight > 0.0) {
      return 0.0;
    }
    return MediaQuery.of(context).viewPadding.bottom;
  }

  double get _topInset {
    return MediaQuery.of(context).viewPadding.top;
  }

  List<LiteDropSelectorItem> get _filteredItems {
    if (_searchValue?.isNotEmpty == true) {
      return widget.args.items
          .where(
            (e) => e.isMatchingSearch(_searchValue!),
          )
          .toList();
    }
    return widget.args.items;
  }

  double get _minChildSize {
    double value =
        (_singleButtonHeight + _totalVerticalPadding + _bottomInset) / _safeScreenHeight;

    if (value > _initialChildSize) {
      return _initialChildSize;
    }
    return value;
  }

  double get _initialChildSize {
    return ((_totalButtonsHeight + _totalVerticalPadding + _bottomInset) /
            _viewportHeight)
        .clamp(0.0, 1.0);
  }

  double get _totalVerticalPadding {
    double padding =
        _settings.sheetPadding.top + _settings.sheetPadding.bottom + _searchFieldHeight;

    if (_isBottomSheet) {
      return padding + kDefaultPadding + _topInset;
    }
    return padding;
  }

  double get _totalHorizontalPadding {
    return _settings.sheetPadding.right + _settings.sheetPadding.left;
  }

  bool get _isBottomSheet {
    if (widget.args.dropSelectorViewType == LiteDropSelectorViewType.adaptive) {
      return isNarrowScreen;
    }
    if (widget.args.dropSelectorViewType == LiteDropSelectorViewType.menu) {
      return false;
    }
    return true;
  }

  double get _viewportHeight {
    return _screenHeight - max(_keyboardHeight, 0) - _topInset;
  }

  ShapeBorder? get _shape {
    return SmoothRectangleBorder(
      borderRadius: SmoothBorderRadius.only(
        topLeft: SmoothRadius(
          cornerRadius: _settings.topLeftRadius ?? kDefaultFormSmoothRadius,
          cornerSmoothing: 1.0,
        ),
        topRight: SmoothRadius(
          cornerRadius: _settings.topRightRadius ?? kDefaultFormSmoothRadius,
          cornerSmoothing: 1.0,
        ),
        bottomLeft: SmoothRadius(
          cornerRadius: _settings.bottomLeftRadius ?? kDefaultFormSmoothRadius,
          cornerSmoothing: 1.0,
        ),
        bottomRight: SmoothRadius(
          cornerRadius: _settings.bottomRightRadius ?? kDefaultFormSmoothRadius,
          cornerSmoothing: 1.0,
        ),
      ),
    );
  }

  Widget _buildMenu() {
    if (_isBottomSheet) {
      return SafeArea(
        bottom: false,
        child: SwipeDetector(
          velocityThreshhold: 270.0,
          acceptedSwipes: _isSimple ? AcceptedSwipes.vertical : AcceptedSwipes.none,
          onSwipe: (SwipeDirection value) {
            if (value == SwipeDirection.topToBottom) {
              if (_scrollController.position.pixels <= 0) {
                _onCancel();
              }
            }
          },
          child: DraggableScrollableSheet(
            snap: true,
            controller: _draggableScrollableController,
            minChildSize: _minChildSize,
            initialChildSize: _initialChildSize,
            builder: (
              BuildContext c,
              ScrollController scrollController,
            ) {
              return Transform.translate(
                offset: Offset(
                  0.0,
                  min(_viewportHeight, _totalButtonsHeight) *
                      (1.0 - widget.animation.value),
                ),
                child: Opacity(
                  opacity: widget.animation.value,
                  child: ConstrainedBox(
                    key: _sizeKey,
                    constraints: BoxConstraints(
                      maxHeight: _screenHeight - _bottomInset,
                      maxWidth: _screenWidth,
                    ),
                    child: Material(
                      shadowColor:
                          formConfig?.shadowColor ?? Colors.black.withOpacity(.3),
                      elevation: 10.0,
                      color: Theme.of(context).cardColor,
                      shape: _shape,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          bottom: kDefaultPadding,
                        ),
                        child: _buildMenuContent(),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
    }

    _isTopDirected = widget.args.buttonLeftTopCorner.dy > (_screenHeight * .5);

    double availableHeight = 0.0;
    if (_isTopDirected) {
      availableHeight = widget.args.buttonLeftTopCorner.dy;
    } else {
      availableHeight = _screenHeight - widget.args.buttonLeftTopCorner.dy - _bottomInset;
    }
    double? top = widget.args.buttonLeftTopCorner.dy;
    double? bottom;
    double left = widget.args.buttonLeftTopCorner.dx;
    bool isLeftAlignment = widget.args.buttonLeftTopCorner.dx > (_screenWidth * .5);
    if (isLeftAlignment) {
      left -= (_menuWidth - widget.args.buttonSize.width);
    }
    double initialOffset = -10.0;
    if (_isTopDirected) {
      bottom = _screenHeight - widget.args.buttonLeftTopCorner.dy;
      bottom -= widget.args.buttonSize.height;
      top = null;
      initialOffset = 10.0;
    }
    if (left < 0.0) {
      left = 0.0;
    }
    if (left + _menuWidth > _screenWidth) {
      left -= ((left + _menuWidth) - _screenWidth);
    }
    if (bottom != null) {
      bottom -= _keyboardHeight;
      bottom = max(0.0, bottom);
      availableHeight = min(
        availableHeight,
        // _viewportHeight - _topInset,
        _viewportHeight,
      );
    } else if (top != null) {
      final calculatedMenuBottom = availableHeight + top;
      var overlap = _keyboardHeight - (_initialScreenHeight - calculatedMenuBottom);
      if (overlap > 0.0) {
        top -= overlap + _settings.sheetPadding.top;
      }
      if (_keyboardHeight > 0.0) {
        bottom = 0.0;
        top = null;
      }

      if (top != null) {
        final topPadding = _topInset + _settings.sheetPadding.top;
        if (top < topPadding) {
          availableHeight += top - topPadding;
          top = topPadding;
        }
      }
    }
    availableHeight = min(_viewportHeight, availableHeight);

    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      child: Transform.translate(
        offset: Offset(
          0.0,
          initialOffset * (1.0 - widget.animation.value),
        ),
        child: Opacity(
          opacity: widget.animation.value,
          child: ConstrainedBox(
            key: _sizeKey,
            constraints: BoxConstraints(
              maxHeight: availableHeight,
              maxWidth: _screenWidth,
            ),
            child: Material(
              shadowColor: formConfig?.shadowColor ?? Colors.black.withOpacity(.3),
              elevation: 10.0,
              color: Theme.of(context).cardColor,
              shape: _shape,
              child: Padding(
                padding: EdgeInsets.only(
                  top: _settings.sheetPadding.top,
                  bottom: _settings.sheetPadding.bottom,
                ),
                child: _buildMenuContent(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getVeilColor(double animationValue) {
    if (_settings.veilColor != null) {
      return _settings.veilColor!.withOpacity(
        _settings.maxVeilOpacity * widget.animation.value,
      );
    }
    return Colors.black.withOpacity(
      _settings.maxVeilOpacity * widget.animation.value,
    );
  }

  void _reselectToInitial() {
    for (var item in widget.args.items) {
      item.isSelected = _initialSelection.any(
        (e) => e.title == item.title,
      );
    }
  }

  void _onCancel() {
    _reselectToInitial();
    Navigator.of(context).pop(
      widget.args.items.where((i) => i.isSelected).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    return AnimatedBuilder(
      animation: widget.animation,
      builder: (c, w) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.transparent,
          body: LayoutBuilder(
            builder: (c, BoxConstraints constraints) {
              _keyboardHeight = _initialScreenHeight - constraints.maxHeight;
              liteFormRebuildController.rebuild();
              return Stack(
                children: [
                  GestureDetector(
                    onTap: _onCancel,
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: _getVeilColor(
                        widget.animation.value,
                      ),
                    ),
                  ),
                  LiteState<LiteFormRebuildController>(
                    builder: (BuildContext c, LiteFormRebuildController controller) {
                      return _buildMenu();
                    },
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
