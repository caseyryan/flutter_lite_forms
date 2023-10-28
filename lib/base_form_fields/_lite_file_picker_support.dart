part of 'lite_file_picker.dart';

typedef ViewBuilder = Widget Function(
  BuildContext context,
  List<LitePickerFile> files,
);

extension _ImageSourceExtension on FileSource {
  String toName() {
    if (this == FileSource.camera) {
      return 'Take a Picture';
    } else if (this == FileSource.gallery) {
      return 'Pick from Gallery';
    } else if (this == FileSource.fileExplorer) {
      return 'Pick as a File';
    }
    return '';
  }

  ImageSource? toImageSource() {
    if (isSupportedByImagePicker) {
      if (this == FileSource.camera) {
        return ImageSource.camera;
      } else if (this == FileSource.gallery) {
        return ImageSource.gallery;
      }
    }
    return null;
  }

  bool get isSupportedByImagePicker {
    return this == FileSource.camera || this == FileSource.gallery;
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

class LitePickerFile {
  static final Map<String, _ImageInfo> _infos = {};

  /// Can be used to mark images in a multiselector
  bool isSelected = false;

  LitePickerFile({
    this.xFile,
    this.platformFile,
  });
  final XFile? xFile;
  final PlatformFile? platformFile;

  @override
  bool operator ==(covariant LitePickerFile other) {
    return other.name == name;
  }

  ImageProvider? _imageProvider;

  bool get isImage {
    return _imageProvider != null;
  }

  @override
  int get hashCode {
    return name.hashCode;
  }

  String get name {
    return xFile?.name ?? platformFile?.name ?? '';
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
    return (width * height).clamp(1000000, 1600000);
  }

  Future _imageToImageInfo(Image? image) async {
    if (image == null) {
      return;
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

  Future _updateFileInfo() async {
    if (_infos.containsKey(name) && _imageProvider != null) {
      return;
    }
    if (platformFile != null) {
      if (await bytes != null) {
        bool isImage = false;
        await getMimeType(_bytes);
        if (_mimeType!.contains('xls') ||
            _mimeType!.contains('spreadsheet') ||
            _mimeType!.endsWith('sheet')) {
          /// xls
          _imageProvider = const AssetImage(
            'assets/icons/xlsx_icon.png',
            package: kPackageName,
          );
        } else if (_mimeType!.contains('word') ||
            _mimeType!.endsWith('doc') ||
            _mimeType!.endsWith('docx') ||
            _mimeType!.endsWith('document')) {
          /// word
          _imageProvider = const AssetImage(
            'assets/icons/doc_icon.png',
            package: kPackageName,
          );
        } else if (_mimeType!.contains('pdf')) {
          _imageProvider = const AssetImage(
            'assets/icons/pdf_icon.png',
            package: kPackageName,
          );
        } else if (_mimeType!.startsWith('image')) {
          final image = Image.memory(_bytes!);
          isImage = true;
          await _imageToImageInfo(image);
        } else {
          _imageProvider = const AssetImage(
            'assets/icons/unknown_icon.png',
            package: kPackageName,
          );
        }
        if (!isImage) {
          final info = _ImageInfo(
            name: name,
            width: 500,
            height: 409,
            byteSize: _bytes!.length,
          );
          _infos[name] = info;
        }
      }
    }
  }

  Future _updateImageInfo() async {
    if (_infos.containsKey(name) && _imageProvider != null) {
      return;
    }
    if (xFile == null) {
      return;
    }
    Image? image;
    if (kIsWeb) {
      Uint8List? bytes;
      if (xFile != null) {
        bytes = await xFile?.readAsBytes();
        _bytes = bytes;
      }
      if (bytes != null) {
        image = Image.memory(bytes);
        _imageProvider = MemoryImage(bytes);
      }
    } else {
      final file = File(xFile!.path);
      image = Image.file(file);
      _imageProvider = FileImage(file);
    }
    await _imageToImageInfo(image);
  }

  String? _mimeType;

  FutureOr<String> getMimeType([
    Uint8List? bytes,
  ]) async {
    _mimeType ??= lookupMimeType(
          name,
          headerBytes: bytes ?? await this.bytes,
        )?.toLowerCase() ??
        ''.toLowerCase();
    return _mimeType!;
  }

  Uint8List? _bytes;

  Future<Uint8List?> get bytes async {
    if (_bytes != null) {
      return _bytes!;
    }
    if (xFile != null) {
      _bytes = await xFile!.readAsBytes();
    } else if (platformFile != null) {
      if (platformFile?.bytes == null) {
        _bytes = await File(platformFile!.path!).readAsBytes();
      } else {
        _bytes = platformFile!.bytes!;
      }
    }
    return _bytes;
  }

  Future<Map> toMap() async {
    return {
      'name': name,
      'bytes': await bytes,
      'mimeType': await getMimeType(),
    };
  }
}

enum FileSource {
  camera,
  gallery,
  fileExplorer,
}
