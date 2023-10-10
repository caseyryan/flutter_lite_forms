part of 'lite_drop_selector.dart';

Future showDropSelector({
  required List<LiteDropSelectorItem> buttonDatas,
  required Offset tapPosition,
  required BuildContext context,
  required LiteDropSelectorViewType dropSelectorType,
  required LiteDropSelectorActionType dropSelectorActionType,
  required InputDecoration? decoration,
  required Size buttonSize,
}) async {
  FocusScope.of(context).unfocus();
  return await Navigator.of(context).push(
    LiteDropSelectorRoute(
      LiteDropSelectorRouteArgs(
        items: buttonDatas,
        buttonLeftBottomCorner: Offset(
          tapPosition.dx,
          tapPosition.dy,
        ),
        decoration: decoration,
        buttonSize: buttonSize,
        dropSelectorViewType: dropSelectorType,
        dropSelectorActionType: dropSelectorActionType,
      ),
    ),
  );
}

class LiteDropSelectorSheetSettings {
  const LiteDropSelectorSheetSettings({
    this.topLeftRadius = 22.0,
    this.topRightRadius = 22.0,
    this.bottomLeftRadius = 22.0,
    this.bottomRightRadius = 22.0,
    this.headerStyle,
    this.header,
    this.paddingTop = 16.0,
    this.paddingLeft = 16.0,
    this.paddingRight = 16.0,
    this.paddingBottom = 16.0,
  });

  final double topLeftRadius;
  final double topRightRadius;
  final double bottomLeftRadius;
  final double bottomRightRadius;
  final TextStyle? headerStyle;
  final String? header;
  final double paddingTop;
  final double paddingLeft;
  final double paddingRight;
  final double paddingBottom;
}

class LiteDropSelectorRouteArgs {
  LiteDropSelectorRouteArgs({
    required this.items,
    required this.buttonLeftBottomCorner,
    required this.buttonSize,
    required this.dropSelectorViewType,
    required this.dropSelectorActionType,
    required this.decoration,
    this.dropSelectorSettings = const LiteDropSelectorSheetSettings(),
  });

  final InputDecoration? decoration;
  final List<LiteDropSelectorItem> items;
  final Offset buttonLeftBottomCorner;
  final Size buttonSize;
  final LiteDropSelectorViewType dropSelectorViewType;
  final LiteDropSelectorActionType dropSelectorActionType;
  final LiteDropSelectorSheetSettings dropSelectorSettings;
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
    return AdaptiveMenuView(
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

class AdaptiveMenuView extends StatefulWidget {
  final Animation<double> animation;
  final LiteDropSelectorRouteArgs args;

  const AdaptiveMenuView({
    Key? key,
    required this.animation,
    required this.args,
  }) : super(key: key);

  @override
  State<AdaptiveMenuView> createState() => _AdaptiveMenuViewState();
}

class _AdaptiveMenuViewState extends State<AdaptiveMenuView> with PostFrameMixin {
  final _sizeKey = GlobalKey();
  double _menuWidth = 0.0;
  double _menuHeight = 0.0;
  Size? _size;
  final _draggableScrollableController = DraggableScrollableController();

  @override
  void didFirstLayoutFinished(BuildContext context) {
    final size = MediaQuery.of(context).size;
    setState(() {
      _menuWidth = _sizeKey.currentContext!.size!.width.clamp(0.0, size.width);
      for (var d in widget.args.items) {
        d._menuWidth = _menuWidth;
      }
      _menuHeight = _sizeKey.currentContext!.size!.height.clamp(0.0, size.height);
    });
  }

  @override
  void dispose() {
    _draggableScrollableController.dispose();
    super.dispose();
  }

  LiteDropSelectorSheetSettings get _settings {
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
    if (value.isSelected) {
      if (value.isSingleAction) {
        value.onPressed?.call(value);
        return;
      }
    }

    if (value.type != null) {
      if (_isSimple) {
        Navigator.of(context).pop(value);
        value.onPressed?.call(value);
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
        Navigator.of(context).pop();
      } else {
        setState(() {});
      }
      value.onPressed?.call(value);
    }
  }

  double get _singleButtonHeight {
    return widget.args.buttonSize.height;
  }

  double get _totalButtonsHeight {
    return widget.args.items.length * _singleButtonHeight;
  }

  Widget _buildMenuContent() {
    final items = _filteredItems;
    return Padding(
      padding: EdgeInsets.only(
        top: _isBottomSheet ? _settings.paddingTop : 0.0,
        bottom: _isBottomSheet ? _settings.paddingBottom : 0.0,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: items.mapIndexed(
            (int index, e) {
              // final isLast = index == items.length - 1;
              return LiteDropSelectorButton(
                data: e,
                paddingLeft: _settings.paddingLeft,
                paddingRight: _settings.paddingRight,
                onPressed: _onButtonPressed,
                key: ValueKey(e),
                buttonHeight: _singleButtonHeight,
              );
            },
          ).toList(),
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
    return MediaQuery.of(context).viewPadding.bottom;
  }

  double get _topInset {
    return MediaQuery.of(context).viewPadding.top;
  }

  List<LiteDropSelectorItem> get _filteredItems {
    return widget.args.items;
  }

  double get _minChildSize {
    final value =
        (_singleButtonHeight + _totalVerticalPadding + _bottomInset) / _safeScreenHeight;
    if (value > _initialChildSize) {
      return _initialChildSize;
    }
    return value;
  }

  double get _initialChildSize {
    return ((_totalButtonsHeight + _totalVerticalPadding + _bottomInset) /
            _safeScreenHeight)
        .clamp(0.0, 1.0);
  }

  InputDecoration? get _decoration {
    return widget.args.decoration;
  }

  double get _totalVerticalPadding {
    return _settings.paddingTop + _settings.paddingBottom;
  }

  bool get _isBottomSheet {
    // return false;
    return isNarrowScreen;
  }

  Widget _buildMenu() {
    if (_isBottomSheet) {
      return SafeArea(
        bottom: false,
        child: DraggableScrollableSheet(
          snap: true,
          controller: _draggableScrollableController,
          minChildSize: _minChildSize,
          initialChildSize: _initialChildSize,
          builder: (
            BuildContext c,
            ScrollController scrollController,
          ) {
            return Padding(
              padding: const EdgeInsets.only(
                top: 20.0,
              ),
              child: Transform.translate(
                offset: Offset(
                  0.0,
                  20.0 * (1.0 - widget.animation.value),
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
                      shadowColor: Colors.black.withOpacity(.3),
                      elevation: 10.0,
                      shape: SmoothRectangleBorder(
                        borderRadius: SmoothBorderRadius.only(
                          topLeft: SmoothRadius(
                            cornerRadius: _settings.topLeftRadius,
                            cornerSmoothing: 1.0,
                          ),
                          topRight: SmoothRadius(
                            cornerRadius: _settings.topRightRadius,
                            cornerSmoothing: 1.0,
                          ),
                          bottomLeft: SmoothRadius(
                            cornerRadius: _settings.bottomLeftRadius,
                            cornerSmoothing: 1.0,
                          ),
                          bottomRight: SmoothRadius(
                            cornerRadius: _settings.bottomRightRadius,
                            cornerSmoothing: 1.0,
                          ),
                        ),
                      ),
                      child: _buildMenuContent(),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );
    }

    bool isTopDirected = widget.args.buttonLeftBottomCorner.dy > (_screenHeight * .5);

    double availableHeight = 0.0;
    if (isTopDirected) {
      availableHeight =
          widget.args.buttonLeftBottomCorner.dy - widget.args.buttonSize.height;
    } else {
      availableHeight = _screenHeight - widget.args.buttonLeftBottomCorner.dy;
    }
    double top = widget.args.buttonLeftBottomCorner.dy;
    double left = widget.args.buttonLeftBottomCorner.dx;
    bool isLeftAlignment = widget.args.buttonLeftBottomCorner.dx > (_screenWidth * .5);
    if (isLeftAlignment) {
      left -= (_menuWidth - widget.args.buttonSize.width);
    }
    double initialOffset = -10.0;
    if (isTopDirected) {
      top = widget.args.buttonLeftBottomCorner.dy;
      top -= _menuHeight + widget.args.buttonSize.height;
      initialOffset = 10.0;
    }
    if (left < 0.0) {
      left = 0.0;
    }
    if (left + _menuWidth > _screenWidth) {
      left -= ((left + _menuWidth) - _screenWidth);
    }

    return Positioned(
      top: top,
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
              shadowColor: Colors.black.withOpacity(.3),
              elevation: 10.0,
              shape: SmoothRectangleBorder(
                borderRadius: SmoothBorderRadius.only(
                  topLeft: SmoothRadius(
                    cornerRadius: _settings.topLeftRadius,
                    cornerSmoothing: 1.0,
                  ),
                  topRight: SmoothRadius(
                    cornerRadius: _settings.topRightRadius,
                    cornerSmoothing: 1.0,
                  ),
                  bottomLeft: SmoothRadius(
                    cornerRadius: _settings.bottomLeftRadius,
                    cornerSmoothing: 1.0,
                  ),
                  bottomRight: SmoothRadius(
                    cornerRadius: _settings.bottomRightRadius,
                    cornerSmoothing: 1.0,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20.0,
                ),
                child: _buildMenuContent(),
              ),
            ),
          ),
        ),
      ),
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
          // appBar: AppBar(),
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              GestureDetector(
                onTap: Navigator.of(context).pop,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.black.withOpacity(
                    .04 * widget.animation.value,
                  ),
                ),
              ),
              LiteState<LiteFormRebuildController>(
                builder: (BuildContext c, LiteFormRebuildController controller) {
                  return _buildMenu();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
