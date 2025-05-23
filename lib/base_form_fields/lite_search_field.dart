import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lite_forms/controllers/lite_form_controller.dart';
import 'package:lite_forms/controllers/lite_form_rebuild_controller.dart';
import 'package:lite_forms/utils/merge_decorations.dart';
import 'package:lite_state/lite_state.dart';

enum SearchTriggerType {
  automatic,
  manual,
}

enum LiteSearchFieldIconPosition {
  left,
  right,
}

class LiteSearchFieldSettings {
  const LiteSearchFieldSettings({
    this.searchTriggerType = SearchTriggerType.automatic,
    this.minSearchPhraseLength = 2,
    this.searchDelay = const Duration(milliseconds: 800),
    this.searchIcon,
    this.iconPosition = LiteSearchFieldIconPosition.right,
  });

  /// [SearchTriggerType.automatic] by default
  /// this means that the search will be triggered automatically
  /// after a user stops entering values and a [searchDelay] is passed
  final SearchTriggerType searchTriggerType;
  final int minSearchPhraseLength;
  final Widget? searchIcon;
  final LiteSearchFieldIconPosition iconPosition;

  /// The delay after which a search will be triggered
  /// when user stops entering text. The recommended value is not less
  /// than 800 milliseconds
  final Duration searchDelay;
}

class LiteSearchField extends StatefulWidget {
  const LiteSearchField({
    super.key,
    required this.onSearch,
    this.textEditingController,
    this.paddingTop = 0.0,
    this.paddingBottom = 0.0,
    this.paddingLeft = 0.0,
    this.paddingRight = 0.0,
    this.decoration,
    this.focusNode,
    this.initialValue,
    this.hintText = 'Search...',
    this.autofocus = false,
    this.style,
    this.readOnly = false,
    this.settings = const LiteSearchFieldSettings(),
  });

  final LiteSearchFieldSettings settings;
  final double paddingTop;
  final double paddingBottom;
  final double paddingLeft;
  final double paddingRight;
  final bool autofocus;
  final FocusNode? focusNode;
  final InputDecoration? decoration;
  final String? initialValue;
  final String? hintText;
  final ValueChanged<String> onSearch;
  final TextStyle? style;
  final bool readOnly;
  final TextEditingController? textEditingController;

  @override
  State<LiteSearchField> createState() => _LiteSearchFieldState();
}

class _LiteSearchFieldState extends State<LiteSearchField> with LiteSearchMixin {
  String? _hintText;
  String _searchValue = '';
  TextEditingController? _myTextEditingController;
  FocusNode? _focusNode;

  @override
  void initState() {
    _hintText = widget.hintText;
    _focusNode = widget.focusNode ?? FocusNode();
    _updateSettings();
    _myTextEditingController = widget.textEditingController ?? textEditingController;
    super.initState();
    if (widget.initialValue?.isNotEmpty == true) {
      _myTextEditingController!.text = widget.initialValue!;
    }
    _searchValue = _myTextEditingController!.text;
    _tryFocus();
  }

  Future _tryFocus() async {
    if (widget.autofocus && _focusNode?.hasFocus == false) {
      await Future.delayed(kThemeAnimationDuration);
      if (mounted) {
        _focusNode?.requestFocus();
      }
    }
  }

  @override
  void didUpdateWidget(covariant LiteSearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.hintText != oldWidget.hintText) {
      setState(() {
        _hintText = widget.hintText;
      });
      _updateSettings();
    }
  }

  void _updateSettings() {
    onSearch = _onSearch;
    settings = widget.settings;
  }

  void _onSearch(String? value) {
    _searchValue = value ?? '';
    widget.onSearch(_searchValue);
  }

  bool get _isManualSearch {
    return widget.settings.searchTriggerType == SearchTriggerType.manual;
  }

  Widget _buildIcon() {
    return LiteState<LiteFormRebuildController>(
      builder: (BuildContext c, LiteFormRebuildController controller) {
        if (!_isManualSearch) {
          if (_myTextEditingController!.text.isNotEmpty) {
            return const Icon(
              Icons.clear_rounded,
            );
          }
        }
        return widget.settings.searchIcon ??
            const Icon(
              Icons.search,
            );
      },
    );
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode?.dispose();
    }
    super.dispose();
  }

  @override
  Future onChanged(
    String? value, {
    bool triggerImmediately = false,
  }) async {
    super.onChanged(
      value,
      triggerImmediately: triggerImmediately,
    );
    liteFormRebuildController.rebuild();
  }

  @override
  Widget build(BuildContext context) {
    // var decoration = widget.decoration ??
    //     liteFormController.config?.inputDecoration ??
    //     const InputDecoration();
    var decoration = mergeInputDecorations([
      const InputDecoration(),
      liteFormController.config?.inputDecoration,
      widget.decoration,
    ]);
    if (_hintText?.isNotEmpty == true && decoration.hintText?.isNotEmpty != true) {
      decoration = decoration.copyWith(
        hintText: _hintText,
      );
    }
    final icon = Align(
      widthFactor: 1.0,
      heightFactor: 1.0,
      child: GestureDetector(
        onTap: () {
          if (_isManualSearch) {
            onChanged(
              _myTextEditingController!.text,
              triggerImmediately: true,
            );
          } else {
            if (_myTextEditingController?.text.isNotEmpty == true) {
              _myTextEditingController!.clear();
              _onSearch('');
            }
          }
        },
        child: Container(
          color: Colors.transparent,
          child: _buildIcon(),
        ),
      ),
    );
    if (widget.settings.iconPosition == LiteSearchFieldIconPosition.right) {
      decoration = decoration.copyWith(
        suffixIcon: icon,
      );
    } else {
      decoration = decoration.copyWith(
        prefixIcon: icon,
      );
    }

    return Padding(
      padding: EdgeInsets.only(
        top: widget.paddingTop,
        bottom: widget.paddingBottom,
        left: widget.paddingLeft,
        right: widget.paddingRight,
      ),
      child: TextFormField(
        readOnly: widget.readOnly,
        style: widget.style ?? liteFormController.config?.defaultTextStyle,
        focusNode: _focusNode,
        autofocus: false,
        onFieldSubmitted: (value) {
          onChanged(
            value,
            triggerImmediately: true,
          );
        },
        textInputAction: TextInputAction.search,
        onChanged: onChanged,
        controller: _myTextEditingController,
        decoration: decoration,
      ),
    );
  }
}

mixin LiteSearchMixin<T extends StatefulWidget> on State<T> {
  late LiteSearchFieldSettings settings;

  Timer? _timer;
  String _pendingValue = '';
  ValueChanged<String>? onSearch;
  TextEditingController textEditingController = TextEditingController();
  FocusNode focusNode = FocusNode();

  void onChanged(
    String? value, {
    bool triggerImmediately = false,
  }) async {
    String searchValue = value ?? '';
    if (onSearch == null) {
      _pendingValue = '';
      return;
    }

    if (settings.searchTriggerType == SearchTriggerType.automatic) {
      if (_pendingValue != value) {
        _timer?.cancel();
        _pendingValue = searchValue;
        _timer = Timer(
          settings.searchDelay,
          _onTimer,
        );
      }
    } else {
      _timer?.cancel();
      _timer = null;
    }
    if (triggerImmediately) {
      _pendingValue = searchValue;
      onSearch!(_pendingValue);
    }
  }

  void _onTimer() {
    _timer?.cancel();
    if (onSearch != null) {
      if (_pendingValue.isNotEmpty == true) {
        if (_pendingValue.length < settings.minSearchPhraseLength) {
          /// it won't let the search to  be triggered if the value is too short
          return;
        }
      }
      onSearch!(_pendingValue);
    }
  }

  void cancelSearch() {
    _pendingValue = '';
  }

  @override
  void dispose() {
    _timer?.cancel();
    textEditingController.dispose();
    super.dispose();
  }
}
