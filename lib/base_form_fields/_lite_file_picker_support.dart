part of 'lite_file_picker.dart';

typedef ViewBuilder = Widget Function(
  BuildContext context,
  List<LiteFile> files,
);

extension _ImageSourceExtension on FileSource {
  String toName() {
    if (this == FileSource.camera) {
      return 'Capture on Camera';
    } else if (this == FileSource.gallery) {
      return 'Pick from Gallery';
    } else if (this == FileSource.fileExplorer) {
      return 'Pick from File Explorer';
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

class LiteFile {
  static final Map<String, _ImageInfo> _infos = {};

  /// Can be used to mark images in a multiselector
  bool isSelected = false;

  LiteFile({
    this.xFile,
    this.platformFile,
    this.userSetName,
  }) {
    _updateFileInfo().then((value) {
      liteFormRebuildController.rebuild();
    });
  }
  final XFile? xFile;
  final PlatformFile? platformFile;

  /// when we rebuild LiteFile from xFile, xFile
  /// does not set name (seems like a bug in xFile)
  /// so this is used instead
  final String? userSetName;

  @override
  bool operator ==(covariant LiteFile other) {
    return other.name == name;
  }

  ImageProvider? _imageProvider;

  bool get hasImageProvider {
    return _imageProvider != null;
  }

  @override
  int get hashCode {
    return name.hashCode;
  }

  String get name {
    final n = xFile?.name ?? platformFile?.name ?? '';
    if (n.isEmpty) {
      if (userSetName?.isNotEmpty == true) {
        return userSetName!;
      }
    }
    return n;
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
    return (width / height * 1000).toInt();
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

  bool get isImage {
    return _mimeType?.startsWith('image') == true;
  }

  bool get isVideo {
    return _mimeType?.startsWith('video') == true;
  }

  bool get isAudio {
    return _mimeType?.startsWith('audio') == true;
  }

  Future _updateFileInfo() async {
    if (_infos.containsKey(name) && _imageProvider != null) {
      return;
    }
    if (platformFile != null || xFile != null) {
      if (await getBytesAsync() != null) {
        bool isImage = false;
        await getMimeType(_bytes);
        if (_mimeType!.contains('xls') || _mimeType!.contains('spreadsheet') || _mimeType!.endsWith('sheet')) {
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
          _imageProvider = MemoryImage(_bytes!);
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

  Future _updateMediaInfo() async {
    if (_infos.containsKey(name) && _imageProvider != null) {
      return;
    }
    if (xFile == null) {
      return;
    }
    await getMimeType();

    Image? image;

    if (kIsWeb) {
      // if (bytes != null) {
      if (isImage) {
        image = Image.memory(_bytes!);
        _imageProvider = MemoryImage(_bytes!);
      } else if (isVideo) {
        final imageByteData = await rootBundle.load(
          'packages/$kPackageName/assets/icons/video_icon.png',
        );
        final imageBytes = imageByteData.buffer.asUint8List();
        image = Image.memory(imageBytes);
        _imageProvider = MemoryImage(
          imageBytes,
        );
      }
      // }
    } else {
      // final file = File(xFile!.path);
      if (isImage) {
        image = Image.memory(_bytes!);
        _imageProvider = MemoryImage(
          _bytes!,
        );
      } else if (isVideo) {
        final thumbBytes = await VideoCompress.getByteThumbnail(
          xFile!.path,
          quality: 50,
          position: -1,
        );
        image = Image.memory(thumbBytes!);
        _imageProvider = MemoryImage(
          thumbBytes,
        );
      }
    }
    await _imageToImageInfo(image);
  }

  String? _mimeType;

  FutureOr<String> getMimeType([
    Uint8List? bytes,
  ]) async {
    _mimeType ??= lookupMimeType(
          name,
          headerBytes: bytes ?? await getBytesAsync(),
        )?.toLowerCase() ??
        ''.toLowerCase();
    return _mimeType!;
  }

  Uint8List? _bytes;
  Uint8List? get bytes => _bytes;

  FutureOr<int> get kiloBytes async {
    final numBytes = (await getBytesAsync())?.length ?? 0;
    return numBytes ~/ 1024;
  }

  Future<Uint8List?> getBytesAsync() async {
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

  static LiteFile fromBytesData({
    required List<int> bytes,
    required String name,
    String? mimeType,
  }) {
    mimeType ??= lookupMimeType(
      name,
      headerBytes: bytes,
    );
    final file = LiteFile(
      xFile: XFile.fromData(
        Uint8List.fromList(bytes),
        name: name,
        mimeType: mimeType,
      ),
      userSetName: name,
    );

    file._updateFileInfo().then((value) {
      liteFormRebuildController.rebuild();
    });
    return file;
  }

  static Future<LiteFile> fromMapAsync(Map json) async {
    final intList = (json['bytes'] as List).cast<int>();
    final Uint8List bytes = Uint8List.fromList(intList);
    // XFile();
    final file = LiteFile(
      xFile: XFile.fromData(
        bytes,
        mimeType: json['mimeType'],
        name: json['name'],
      ),
      userSetName: json['name'],
    );

    await file._updateFileInfo();
    return file;
  }

  Future<Map> toMapAsync() async {
    return {
      'name': name,
      'mimeType': await getMimeType(),
      'bytes': await getBytesAsync(),
    };
  }
}

enum FileSource {
  camera,
  gallery,
  fileExplorer,
}
