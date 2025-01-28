part of 'lite_drop_selector.dart';

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
  bool _sizeCalculated = false;

  @override
  void didFirstLayoutFinished(BuildContext context) {
    _tryCalculateSizes();
  }

  void _tryCalculateSizes() {
    if (_sizeCalculated) {
      return;
    }
    onPostframe(() {
      if (mounted && _sizeKey.currentContext != null) {
        final size = MediaQuery.of(context).size;
        _initialScreenHeight = size.height;
        setState(() {
          _sizeCalculated = true;
          if (_settings.dropSelectorType == DropSelectorType.bottomsheet) {
            _menuWidth = size.width;
          } else {
            _menuWidth = _sizeKey.currentContext!.size!.width.clamp(0.0, size.width);
          }
          if (!_isSimple || _hasSearchField) {
            _menuWidth = max(
              _menuWidth,
              _maxMenuWidth - _totalHorizontalPadding,
            );
          }
          for (var d in widget.args.items) {
            d._menuWidth = _menuWidth;
          }
        });
      }
    });
  }

  double get _maxMenuWidth {
    return _settings.maxMenuWidth ?? kMaxDropSelectorWidth;
  }

  @override
  void initState() {
    _initialSelection = widget.args.items
        .where(
          (e) => e.isSelected,
        )
        .map((e) => _TempSelection(title: e.title))
        .toList();
    _setInitialHeights();
    super.initState();
  }

  @override
  void dispose() {
    _draggableScrollableController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  DropSelectorSettings get _settings {
    return widget.args.dropSelectorSettings;
  }

  bool get _isMultiselect {
    return _settings.dropSelectorActionType == DropSelectorActionType.multiselect;
  }

  bool get _isSimpleWithNoSelection {
    return _settings.dropSelectorActionType == DropSelectorActionType.simpleWithNoSelection;
  }

  bool get _isSingleSelect {
    return _settings.dropSelectorActionType == DropSelectorActionType.singleSelect;
  }

  bool get _isSimple {
    if (_settings.dropSelectorActionType == null) {
      return true;
    }
    return _isSimpleWithNoSelection || _settings.dropSelectorActionType == DropSelectorActionType.simple;
  }

  void _onButtonPressed(
    LiteDropSelectorItem value,
    DropSelectorType? type,
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
    return _itemHeights.fold(0, (previousValue, element) => previousValue + element);
  }

  bool get _hasSearchField {
    if (_settings.searchSettings.searchFieldVisibility == SearchFieldVisibility.adaptive) {
      if (widget.args.items.length <= 8) {
        return false;
      }
    } else if (_settings.searchSettings.searchFieldVisibility == SearchFieldVisibility.none) {
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
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
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
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
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
    if (_settings.searchSettings.searchFieldVisibility == SearchFieldVisibility.none) {
      return;
    }
    if (_isTopDirected) {
      children.add(
        SizedBox(
          width: _menuWidth,
          key: _searchFieldSizeKey,
          child: LiteSearchField(
            decoration: _settings.searchSettings.searchFieldDecoration,
            settings: _settings.searchSettings.innerFieldSettings,
            onSearch: _onSearch,
            autofocus: _settings.searchSettings.autofocusSearchField,
            style: widget.args.style,
            paddingTop: _settings.searchSettings.padding?.top ?? _settings.sheetPadding.top,
            paddingBottom: _settings.searchSettings.padding?.bottom ?? 0.0,
            paddingLeft: _settings.searchSettings.padding?.left ?? _settings.sheetPadding.left,
            paddingRight: _settings.searchSettings.padding?.right ?? _settings.sheetPadding.right,
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
            style: widget.args.style,
            autofocus: _settings.searchSettings.autofocusSearchField,
            onSearch: _onSearch,
            paddingTop: _settings.searchSettings.padding?.top ?? 0.0,
            paddingBottom: _settings.searchSettings.padding?.bottom ?? _settings.sheetPadding.bottom,
            paddingLeft: _settings.searchSettings.padding?.left ?? _settings.sheetPadding.left,
            paddingRight: _settings.searchSettings.padding?.right ?? _settings.sheetPadding.right,
          ),
        ),
      );
    }
  }

  List<double> _itemHeights = <double>[];

  void _onSearch(String? value) {
    setState(() {
      _searchValue = value;
      _setInitialHeights();
    });
  }

  void _setInitialHeights() {
    _itemHeights = List.filled(_filteredItems.length, _singleButtonHeight);
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
    Widget? button;

    /// in case the builder returns null it will use a general view for an item
    if (widget.args.menuItemBuilder != null && !item.isSeparator) {
      final menuWidth = _isBottomSheet ? MediaQuery.of(context).size.width : _maxMenuWidth;
      final builtItem = widget.args.menuItemBuilder!(
        index,
        item,
        isLast,
        menuWidth,
      );
      if (builtItem != null) {
        button = ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: menuWidth,
            maxHeight: _viewportHeight,
          ),
          child: builtItem,
        );
      }
    }
    button ??= Padding(
      padding: EdgeInsets.only(
        bottom: isLast ? 0.0 : _settings.sheetPadding.bottom,
      ),
      child: LiteDropSelectorButton(
        data: item,
        showSelection: !_isSimpleWithNoSelection,
        sheetSettings: _settings,
        decoration: widget.args.decoration,
        style: widget.args.style,
        paddingLeft: _settings.sheetPadding.left,
        paddingRight: _settings.sheetPadding.right,
        key: ValueKey(item),
        buttonHeight: _singleButtonHeight,
      ),
    );

    return GestureDetector(
      onTap: () {
        _onButtonPressed(item, _settings.dropSelectorType);
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
            maxWidth: _isBottomSheet ? double.infinity : _maxMenuWidth,
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
                            return SizeDetector(
                              onSizeDetected: (Size value) {
                                _itemHeights[index] = value.height;
                              },
                              child: _buildButton(
                                index,
                                item,
                                items,
                              ),
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
                          return SizeDetector(
                            onSizeDetected: (Size value) {
                              _itemHeights[index] = value.height;
                            },
                            child: _buildButton(
                              index,
                              item,
                              items,
                            ),
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
    double value = (_singleButtonHeight + _totalVerticalPadding + _bottomInset) / _safeScreenHeight;

    if (value > _initialChildSize) {
      return _initialChildSize;
    }
    return value;
  }

  double get _initialChildSize {
    return ((_totalButtonsHeight + _bottomInset) / _viewportHeight).clamp(0.0, 1.0);
  }

  double get _totalVerticalPadding {
    double padding = _settings.sheetPadding.top + _settings.sheetPadding.bottom + _searchFieldHeight;

    if (_isBottomSheet) {
      return padding + kDefaultPadding + _topInset;
    }
    return padding;
  }

  double get _totalHorizontalPadding {
    return _settings.sheetPadding.right + _settings.sheetPadding.left;
  }

  bool get _isBottomSheet {
    if (_settings.dropSelectorType == DropSelectorType.adaptive) {
      return isNarrowScreen;
    }
    if (_settings.dropSelectorType == DropSelectorType.menu) {
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
                  min(_viewportHeight, _totalButtonsHeight) * (1.0 - widget.animation.value),
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
                      shadowColor: formConfig?.shadowColor ?? Colors.black.withOpacity(.3),
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
          opacity: widget.animation.value * (_sizeKey.currentContext != null ? 1.0 : 0.0),
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
    // if (_isSimpleWithNoSelection || _isSimple) {
      Navigator.of(context).pop(null);
    // } else {
    //   Navigator.of(context).pop(
    //     widget.args.items.where((i) => i.isSelected).toList(),
    //   );
    // }
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    return AnimatedBuilder(
      animation: widget.animation,
      builder: (c, w) {
        _tryCalculateSizes();
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
