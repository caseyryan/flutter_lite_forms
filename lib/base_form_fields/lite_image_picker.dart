import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lite_forms/base_form_fields/treemap/src/treenode.dart';
import 'package:lite_forms/controllers/lite_form_controller.dart';
import 'package:lite_forms/controllers/lite_form_rebuild_controller.dart';
import 'package:lite_forms/lite_forms.dart';
import 'package:lite_state/lite_state.dart';

import 'mixins/form_field_mixin.dart';
import 'treemap/src/tiles/binary.dart';
import 'treemap/src/treemap_layout.dart';

typedef ViewBuilder = Widget Function(
  BuildContext context,
  List<XFileWrapper> files,
);

extension _ImageSourceExtension on ImageSource {
  String toName() {
    if (this == ImageSource.camera) {
      return 'Take a Picture';
    } else if (this == ImageSource.gallery) {
      return 'Pick from Gallery';
    }
    return '';
  }
}

class _ImageInfo {
  final String name;
  final int width;
  final int height;
  final int byteSize;
  _ImageInfo({
    required this.name,
    required this.width,
    required this.height,
    required this.byteSize,
  });
}

class XFileWrapper {
  static Map<String, _ImageInfo> _infos = {};

  XFileWrapper({
    required this.xFile,
  });
  final XFile xFile;

  String get name {
    return xFile.name;
  }

  int get width {
    return _infos[name]?.width ?? 0;
  }

  int get height {
    return _infos[name]?.height ?? 0;
  }

  int get _leafWeight {
    if (height == 0 || width == 0) {
      return 1;
    }
    return width * height;
  }

  Future _calculateSize() async {
    if (_infos.containsKey(name)) {
      return;
    }
    Image? image;
    if (kIsWeb) {
      final bytes = await xFile.readAsBytes();
      image = Image.memory(bytes);
    } else {
      image = Image.file(File(xFile.path));
    }
    final asUiImage = await image.toUiImage();
    final info = _ImageInfo(
      name: name,
      width: asUiImage.image.width,
      height: asUiImage.image.height,
      byteSize: asUiImage.sizeBytes,
    );
    _infos[name] = info;
  }
}

class LiteImagePicker extends StatefulWidget {
  const LiteImagePicker({
    required this.name,
    super.key,
    this.autovalidateMode,
    this.maxImages = 1,
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
      ImageSource.camera,
      ImageSource.gallery,
    ],
  }) : assert(sources.length > 0);

  final String name;
  final double menuButtonHeight;

  /// [preferredCameraDevice] makes sense if you pass
  /// [ImageSource.camera] in the list
  /// of [sources] and the camera is supported by your device
  final CameraDevice preferredCameraDevice;
  final List<ImageSource> sources;
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

  /// [imageSpacing] the space between images in a multiselector
  final double imageSpacing;

  /// [maxImages] the maximum number of image a user can attach
  final int maxImages;

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
  State<LiteImagePicker> createState() => _LiteImagePickerState();
}

class _LiteImagePickerState extends State<LiteImagePicker> with FormFieldMixin {
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

  List<ImageSource>? _supportedSources;
  List<ImageSource> _getSources() {
    if (_supportedSources != null) {
      return _supportedSources!;
    }
    _supportedSources = <ImageSource>[];
    for (var s in widget.sources) {
      if (_picker.supportsImageSource(s)) {
        _supportedSources!.add(s);
      }
    }
    return _supportedSources!;
  }

  List<LiteDropSelectorItem<ImageSource>> _getSourceItems() {
    return _getSources()
        .map(
          (e) => LiteDropSelectorItem(
            title: group.translationBuilder(e.toName()) ?? e.toName(),
            payload: e,
          ),
        )
        .toList();
  }

  List<XFileWrapper> get _selectedFiles {
    final value = getFormFieldValue<List<XFileWrapper>>(
      formName: formName,
      fieldName: widget.name,
    );
    return value ?? <XFileWrapper>[];
  }

  Future _onImageTap(XFileWrapper value) async {
    print('Open Gallery ${value.name}');
  }

  void _clear() {

  }

  Widget _buildView() {
    return LiteState<LiteFormRebuildController>(
      builder: (BuildContext c, LiteFormRebuildController controller) {
        final files = _selectedFiles;
        if (files.isNotEmpty) {
          return Padding(
            padding: EdgeInsets.all(
              files.length == 1 ? 0.0 : widget.imageSpacing * .5,
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
                        onLongPress: () {
                          _onImageTap(e);
                        },
                        child: Padding(
                          padding: EdgeInsets.all(
                            files.length == 1
                                ? widget.imageSpacing
                                : widget.imageSpacing * .5,
                          ),
                          child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: FileImage(
                                  File(e.xFile.path),
                                ),
                              ),
                            ),
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
          child: Icon(
            Icons.camera_alt,
          ),
        );
      },
    );
  }

  BoxDecoration _buildDecoration() {
    return widget.decoration ?? const BoxDecoration();
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
          child: LiteDropSelector(
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
                child: _buildView(),
              );
            },
            onChanged: (value) async {
              if (value is List && value.isNotEmpty) {
                final source = value.first.payload;
                if (source == ImageSource.camera) {
                } else if (source == ImageSource.gallery) {
                  if (widget.maxImages > 1) {
                    final xFiles = await _picker.pickMultiImage(
                      imageQuality: widget.imageQuality,
                      maxHeight: widget.maxHeight,
                      maxWidth: widget.maxHeight,
                      requestFullMetadata: widget.requestFullMetadata,
                    );
                    final wrappers = xFiles
                        .take(widget.maxImages)
                        .map(
                          (e) => XFileWrapper(xFile: e),
                        )
                        .toList();
                    if (wrappers.isNotEmpty) {
                      for (var w in wrappers) {
                        await w._calculateSize();
                      }
                      liteFormController.onValueChanged(
                        formName: formName,
                        fieldName: widget.name,
                        value: wrappers,
                        view: null,
                      );
                    }
                    liteFormRebuildController.rebuild();
                  } else {
                    final xFile = await _picker.pickImage(
                      source: source,
                      imageQuality: widget.imageQuality,
                      maxHeight: widget.maxHeight,
                      maxWidth: widget.maxHeight,
                      requestFullMetadata: widget.requestFullMetadata,
                    );
                    if (xFile != null) {
                      final wrapper = XFileWrapper(xFile: xFile);
                      await wrapper._calculateSize();
                      liteFormController.onValueChanged(
                        formName: formName,
                        fieldName: widget.name,
                        value: [wrapper],
                        view: null,
                      );
                      liteFormRebuildController.rebuild();
                    }
                  }
                }
              }
            },
            name: widget.name.toFormIgnoreName(),
            items: _getSourceItems(),
          ),
        ),
      ),
    );
  }
}
