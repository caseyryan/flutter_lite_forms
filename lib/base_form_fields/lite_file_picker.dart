import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lite_forms/base_form_fields/treemap/src/treenode.dart';
import 'package:lite_forms/constants.dart';
import 'package:lite_forms/controllers/lite_form_controller.dart';
import 'package:lite_forms/controllers/lite_form_rebuild_controller.dart';
import 'package:lite_forms/lite_forms.dart';
import 'package:lite_state/lite_state.dart';
import 'package:mime/mime.dart';

import 'mixins/form_field_mixin.dart';
import 'treemap/src/tiles/binary.dart';
import 'treemap/src/treemap_layout.dart';

part '_lite_file_picker_support.dart';

class LiteFilePicker extends StatefulWidget {
  const LiteFilePicker({
    required this.name,
    super.key,
    this.autovalidateMode,
    this.maxFiles = 1,
    this.viewBuilder,
    this.initialValueDeserializer,
    this.initialValue,
    this.serializer = nonConvertingValueConvertor,
    this.validators,
    this.hintText,
    this.dropSelectorType = LiteDropSelectorViewType.adaptive,
    this.errorStyle,
    this.paddingTop = 0.0,
    this.paddingBottom = 0.0,
    this.paddingLeft = 0.0,
    this.paddingRight = 0.0,
    this.aspectRatio,
    this.constraints,
    this.width = 110.0,
    this.height = 70.0,
    this.preferredCameraDevice = CameraDevice.rear,
    this.maxHeight,
    this.maxWidth,
    this.margin,
    this.imageQuality,
    this.decoration,
    this.imageSpacing = 1.0,
    this.menuButtonHeight = 54.0,
    this.requestFullMetadata = false,
    this.sources = const [
      FileSource.camera,
      FileSource.gallery,
      FileSource.fileExplorer,
    ],
    this.allowedExtensions,
    // this.allowedExtensions = const [
    //   'jpg',
    //   'jpeg',
    //   'pdf',
    //   'doc',
    //   'bmp',
    //   'png',
    //   'gif',
    //   'mp4',
    //   'mov',
    //   'avi',
    //   'webp',
    //   'tif',
    // ],
  }) : assert(sources.length > 0);

  final String name;
  final double menuButtonHeight;

  /// [allowedExtensions] files extensions accepted by file picker
  /// this will make sense only if you add
  /// [FileSource.fileExplorer] to [sources]
  final List<String>? allowedExtensions;

  /// [preferredCameraDevice] makes sense if you pass
  /// [ImageSource.camera] in the list
  /// of [sources] and the camera is supported by your device
  final CameraDevice preferredCameraDevice;
  final List<FileSource> sources;
  final LiteDropSelectorViewType dropSelectorType;
  final double paddingTop;
  final BoxConstraints? constraints;
  final double paddingBottom;
  final double paddingLeft;
  final double paddingRight;
  final Object? initialValue;
  final String? hintText;
  final AutovalidateMode? autovalidateMode;
  final TextStyle? errorStyle;
  final double? aspectRatio;
  final double width;
  final double height;
  final EdgeInsets? margin;

  /// [imageSpacing] the gap size between images in a multiselector
  final double imageSpacing;

  /// [maxFiles] the maximum number of image a user can attach
  final int maxFiles;

  /// [viewBuilder] builds a completely custom view for the image picker
  final ViewBuilder? viewBuilder;

  final double? maxWidth;
  final double? maxHeight;
  final int? imageQuality;
  final bool requestFullMetadata;
  final BoxDecoration? decoration;

  /// Allows you to prepare the data for some general usage like sending it
  /// to an api endpoint. E.g. you have a Date Picker which returns a DateTime object
  /// but you need to send it to a backend in a iso8601 string format.
  /// Just pass the serializer like this: serializer: (value) => value.toIso8601String()
  /// And it will always store this date as a string in a form map which you can easily send
  /// wherever you need
  final LiteFormValueSerializer serializer;

  /// Allows you to convert initial value to a proper data type or
  /// format before using it. E.g. you have a iso8601 format but you need
  /// to have a DateTime object to work with in a date picker.
  /// Use [initialValueDeserializer] to convert iso8601 value to a DateTime
  /// like so: initialValueDeserializer: (value) => DateTime.parse(value);
  /// and you will get a DateTime as an initial value. You can use any custom
  /// conversions you want
  final LiteFormValueSerializer? initialValueDeserializer;
  final List<LiteFormFieldValidator<Object?>>? validators;

  @override
  State<LiteFilePicker> createState() => _LiteFilePickerState();
}

class _LiteFilePickerState extends State<LiteFilePicker> with FormFieldMixin {
  final ImagePicker _picker = ImagePicker();

  Widget _tryWrapWithAspectRatio({
    required Widget child,
  }) {
    if (widget.aspectRatio != null) {
      return AspectRatio(
        aspectRatio: widget.aspectRatio!,
        child: child,
      );
    }
    return child;
  }

  Widget _tryWrapWithConstraints({
    required Widget child,
  }) {
    if (widget.constraints != null) {
      return Flex(
        direction: Axis.horizontal,
        children: [
          Container(
            constraints: widget.constraints,
            child: child,
          ),
        ],
      );
    }

    return child;
  }

  List<FileSource>? _supportedSources;
  List<FileSource> _getSources() {
    if (_supportedSources != null) {
      return _supportedSources!;
    }
    _supportedSources = <FileSource>[];
    for (var s in widget.sources) {
      if (s == FileSource.camera) {
        if (_picker.supportsImageSource(ImageSource.camera)) {
          _supportedSources!.add(s);
        }
      } else {
        _supportedSources!.add(s);
      }
    }
    return _supportedSources!;
  }

  List<LiteDropSelectorItem<Object>> _getItems() {
    final List<LiteDropSelectorItem<Object>> items = _getSources().map(
      (e) {
        return LiteDropSelectorItem<Object>(
          title: group.translationBuilder(e.toName()) ?? e.toName(),
          payload: e,
        );
      },
    ).toList();
    if (_selectedFiles.isNotEmpty) {
      String itemName = 'Clear';
      if (_hasSelection) {
        itemName = 'Clear Selected';
      }
      items.add(
        LiteDropSelectorItem<Object>(
          title: group.translationBuilder(itemName) ?? itemName,
          payload: 'clear',
          isDestructive: true,
        ),
      );
    }
    return items;
  }

  List<LitePickerFile> get _selectedFiles {
    final value = getFormFieldValue<List<LitePickerFile>>(
      formName: formName,
      fieldName: widget.name,
    );
    return value ?? <LitePickerFile>[];
  }

  Future _onImageTap(LitePickerFile value) async {
    if (_selectedFiles.length < 2) {
      return;
    }
    value.isSelected = !value.isSelected;
    liteFormRebuildController.rebuild();
  }

  void _clear() {
    if (_hasSelection) {
      final unselected = _selectedFiles.where((e) => !e.isSelected).toList();
      liteFormController.onValueChanged(
        formName: formName,
        fieldName: widget.name,
        value: unselected,
        view: null,
      );
    } else {
      liteFormController.onValueChanged(
        formName: formName,
        fieldName: widget.name,
        value: <LitePickerFile>[],
        view: null,
      );
    }
  }

  bool get _hasSelection {
    return _selectedFiles.any((s) => s.isSelected);
  }

  Widget _buildCheckBox(bool isSelected) {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: AnimatedOpacity(
          duration: const Duration(
            milliseconds: 200,
          ),
          curve: Curves.easeOutExpo,
          opacity: _hasSelection ? 1.0 : 0.0,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(
              !isSelected ? Icons.circle_outlined : Icons.check_circle,
              color: Theme.of(context).indicatorColor,
              size: 20.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildView() {
    final files = _selectedFiles;
    if (widget.viewBuilder != null) {
      return widget.viewBuilder!.call(
        context,
        files,
      );
    }

    if (files.isNotEmpty) {
      return Padding(
        padding: EdgeInsets.all(
          files.length == 1 ? widget.imageSpacing : widget.imageSpacing * .5,
        ),
        child: TreeMapLayout(
          tile: Binary(),
          round: true,
          duration: const Duration(milliseconds: 80),
          children: _selectedFiles.map(
            (e) {
              return TreeNode.leaf(
                value: e._leafWeight,
                builder: (context) {
                  return GestureDetector(
                    onTap: _hasSelection
                        ? () {
                            _onImageTap(e);
                          }
                        : null,
                    onLongPress: _hasSelection
                        ? null
                        : () {
                            _onImageTap(e);
                          },
                    child: Padding(
                      padding: EdgeInsets.all(
                        files.length == 1
                            ? widget.imageSpacing
                            : widget.imageSpacing * .5,
                      ),
                      child: Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            height: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                3.0,
                              ),
                              image: e._imageProvider != null
                                  ? DecorationImage(
                                      fit: BoxFit.cover,
                                      image: e._imageProvider!,
                                    )
                                  : null,
                            ),
                          ),
                          _buildCheckBox(e.isSelected),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ).toList(),
        ),
      );
    }
    return Center(
      child: _isAttaching
          ? null
          : Icon(
              Icons.camera_alt,
              color: Theme.of(context).iconTheme.color,
            ),
    );
  }

  BoxDecoration _buildDecoration() {
    return widget.decoration ??
        liteFormController.config?.filePickerDecoration ??
        const BoxDecoration();
  }

  bool get _isAttaching {
    return liteFormRebuildController.getIsLoading(
      _loaderKey,
    );
  }

  Widget _buildLoader({
    required Widget child,
  }) {
    return Stack(
      alignment: Alignment.center,
      children: [
        AnimatedOpacity(
          duration: kThemeAnimationDuration,
          opacity: _isAttaching ? .5 : 1.0,
          child: child,
        ),
        if (_isAttaching)
          const CupertinoActivityIndicator(
            animating: true,
          ),
      ],
    );
  }

  List<LitePickerFile> _mergeWrappers({
    required List<LitePickerFile> firstList,
    required List<LitePickerFile> secondList,
  }) {
    _deselectAll();
    final tempList = <LitePickerFile>[...firstList];
    for (var file in secondList) {
      if (!tempList.contains(file)) {
        tempList.add(file);
      }
    }

    return tempList.take(widget.maxFiles).toList();
  }

  void _deselectAll() {
    for (var file in _selectedFiles) {
      file.isSelected = false;
    }
  }

  String get _loaderKey {
    return 'loadingFile${widget.name}${group.name}';
  }

  Future _processFilePickResult(
    FilePickerResult? result,
    bool isMultiple,
  ) async {
    final temp = <LitePickerFile>[];
    if (result == null) {
      return;
    }
    liteFormRebuildController.setIsLoading(
      _loaderKey,
      true,
    );
    final files = result.files;
    List<LitePickerFile> tempValue = [];
    for (PlatformFile file in files) {
      final wrapper = LitePickerFile(
        platformFile: file,
      );
      await wrapper._updateFileInfo();
      tempValue.add(wrapper);
    }
    List<LitePickerFile> newValue = _mergeWrappers(
      firstList: tempValue,
      secondList: _selectedFiles,
    );
    if (newValue.isNotEmpty) {
      liteFormController.onValueChanged(
        formName: formName,
        fieldName: widget.name,
        value: newValue,
        view: null,
      );
    }
    liteFormRebuildController.setIsLoading(
      _loaderKey,
      false,
    );
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    initializeFormField(
      fieldName: widget.name,
      autovalidateMode: widget.autovalidateMode,
      serializer: widget.serializer,
      initialValueDeserializer: widget.initialValueDeserializer,
      validators: widget.validators,
      hintText: widget.hintText,
      decoration: null,
      errorStyle: widget.errorStyle,
    );

    tryDeserializeInitialValueIfNecessary(
      rawInitialValue: widget.initialValue,
      initialValueDeserializer: widget.initialValueDeserializer,
    );

    setInitialValue(
      fieldName: widget.name,
      formName: group.name,
      setter: () {
        liteFormController.onValueChanged(
          fieldName: widget.name,
          formName: group.name,
          value: initialValue,
          isInitialValue: true,
          view: null,
        );
      },
    );
    return Padding(
      padding: EdgeInsets.only(
        top: widget.paddingTop,
        bottom: widget.paddingBottom,
        left: widget.paddingLeft,
        right: widget.paddingRight,
      ),
      child: _tryWrapWithConstraints(
        child: _tryWrapWithAspectRatio(
          child: LiteState<LiteFormRebuildController>(
            builder: (BuildContext c, LiteFormRebuildController controller) {
              return LiteDropSelector(
                dropSelectorType: widget.dropSelectorType,
                dropSelectorActionType: LiteDropSelectorActionType.simpleWithNoSelection,
                settings: LiteDropSelectorSettings(
                  buttonHeight: widget.menuButtonHeight,
                ),
                selectorViewBuilder: (context, selectedItems) {
                  return Container(
                    width: widget.width,
                    height: widget.height,
                    margin: widget.margin,
                    decoration: _buildDecoration(),
                    child: _buildLoader(
                      child: _buildView(),
                    ),
                  );
                },
                onChanged: (value) async {
                  if (value is List && value.isNotEmpty) {
                    final payload = value.first.payload;
                    if (payload is FileSource) {
                      if (widget.maxFiles > 1) {
                        if (payload.isSupportedByImagePicker) {
                          final xFiles = await _picker.pickMultiImage(
                            imageQuality: widget.imageQuality,
                            maxHeight: widget.maxHeight,
                            maxWidth: widget.maxHeight,
                            requestFullMetadata: widget.requestFullMetadata,
                          );
                          liteFormRebuildController.setIsLoading(
                            _loaderKey,
                            true,
                          );
                          final wrappers = xFiles.take(widget.maxFiles).map(
                            (e) {
                              return LitePickerFile(xFile: e);
                            },
                          ).toList();
                          if (wrappers.isNotEmpty) {
                            for (var w in wrappers) {
                              await w._updateImageInfo();
                            }
                            final result = _mergeWrappers(
                              firstList: wrappers,
                              secondList: _selectedFiles,
                            );

                            liteFormController.onValueChanged(
                              formName: formName,
                              fieldName: widget.name,
                              value: result,
                              view: null,
                            );
                          }
                          liteFormRebuildController.setIsLoading(
                            _loaderKey,
                            false,
                          );
                        } else {
                          final result = await FilePicker.platform.pickFiles(
                            allowMultiple: true,
                            allowedExtensions: widget.allowedExtensions,
                          );
                          _processFilePickResult(
                            result,
                            true,
                          );
                        }
                      } else {
                        if (payload.isSupportedByImagePicker) {
                          final xFile = await _picker.pickImage(
                            source: payload.toImageSource()!,
                            imageQuality: widget.imageQuality,
                            maxHeight: widget.maxHeight,
                            maxWidth: widget.maxHeight,
                            requestFullMetadata: widget.requestFullMetadata,
                          );
                          if (xFile != null) {
                            liteFormRebuildController.setIsLoading(
                              _loaderKey,
                              true,
                            );
                            final wrapper = LitePickerFile(xFile: xFile);
                            await wrapper._updateImageInfo();
                            List<LitePickerFile>? newValue;

                            /// this condition may meet only for a camera
                            if (widget.maxFiles > 1) {
                              newValue = _selectedFiles
                                  .take(
                                    widget.maxFiles - 1,
                                  )
                                  .toList();
                              newValue.add(wrapper);
                            } else {
                              newValue = [wrapper];
                            }
                            liteFormController.onValueChanged(
                              formName: formName,
                              fieldName: widget.name,
                              value: newValue.take(widget.maxFiles).toList(),
                              view: null,
                            );
                            liteFormRebuildController.setIsLoading(
                              _loaderKey,
                              false,
                            );
                          }
                        } else {
                          // print('Pick Single File');
                          final result = await FilePicker.platform.pickFiles(
                            allowMultiple: false,
                            allowedExtensions: widget.allowedExtensions,
                          );
                          _processFilePickResult(
                            result,
                            false,
                          );
                        }
                      }
                    } else if (payload is String) {
                      if (payload == 'clear') {
                        _clear();
                      }
                    }
                  }
                },
                name: widget.name.toFormIgnoreName(),
                items: _getItems(),
              );
            },
          ),
        ),
      ),
    );
  }
}
