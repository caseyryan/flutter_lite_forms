part of 'lite_drop_selector.dart';

typedef DropSelectorItemIconBuilder = Widget Function(
  BuildContext context,
  LiteDropSelectorItem item,
  bool isSelected,
);

class LiteDropSelectorItem<T> with SearchQueryMixin {
  LiteDropSelectorItem({
    required this.title,
     this.subtitle,
    required this.payload,
    this.onPressed,
    this.iconBuilder,
    this.type,
    this.selectedBorderColor,
    this.selectedBorderWidth,
    bool isSelected = false,
    this.isSeparator = false,
    this.isSingleAction = false,
    this.isDestructive = false,
  }) : _isSelected = isSelected {
    final list = [title];
    if (payload is String) {
      list.add(payload as String);
    }
    if (payload is SearchQueryMixin) {
      prepareSearch([
        (payload as SearchQueryMixin).searchString ?? title,
      ]);
    } else {
      prepareSearch(list);
    }
  }
  final Color? selectedBorderColor;
  final double? selectedBorderWidth;
  final String title;
  final String? subtitle;
  final T payload;

  /// [isDestructive]
  final bool isDestructive;
  bool _isSelected;

  /// [iconBuilder] allows to provide a custom icon for each
  /// item in this drop selector separately
  DropSelectorItemIconBuilder? iconBuilder;

  // ignore: unnecessary_getters_setters
  bool get isSelected {
    return _isSelected;
  }

  set isSelected(bool value) {
    _isSelected = value;
  }

  ValueChanged<Object?>? onPressed;

  /// [type] the type of each button can be set independently of
  /// the whole menu
  DropSelectorType? type;
  ValueChanged<List<LiteDropSelectorItem>>? onMultiSelection;

  /// [isSeparator] means the button won't have a view.
  /// Instead, a white space
  /// will be added
  bool isSeparator;
  double? iconSize;
  bool isSingleAction;

  double? _menuWidth;
  double? get menuWidth => _menuWidth;

  @override
  bool operator ==(covariant LiteDropSelectorItem other) {
    return other.title == title;
  }

  @override
  int get hashCode {
    return title.hashCode;
  }
}
