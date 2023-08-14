import 'dart:io';

import 'package:app_group_directory/app_group_directory.dart';
import 'package:flutter/services.dart';

import 'model/live_activity_image.dart';

/// Name of the folder in App Group defaults to 'LiveActivityImage'
const String folderName = 'LiveActivityImage';

class LiveActivityImageService {
  factory LiveActivityImageService() => _;
  static final LiveActivityImageService _ = LiveActivityImageService.__();

  LiveActivityImageService.__();

  String? _appGroupId;
  late String _appGroupDirectoryPath;
  late String _imageDirectoryPath;
  final List<String> _addedImages = [];

  /// Initialize [LiveActivityImageService] with [appGroupId].
  ///
  /// Calls [_removeAll] before creating new App Group directory.
  init(String appGroupId) async {
    _appGroupId = appGroupId;
    Directory? appGroupDirectory =
        await AppGroupDirectory.getAppGroupDirectory(_appGroupId!);
    _appGroupDirectoryPath = appGroupDirectory!.path;
    await _removeAll();
    appGroupDirectory.createSync();
  }

  /// Adds [LiveActivityImage] objects in [data] to App Group.
  Future addImageToAppGroup(Map<String, dynamic> data) async {
    if (_appGroupId == null) {
      throw Exception('init required');
    }

    Directory imageDirectory = Directory('$_appGroupDirectoryPath/$folderName');
    imageDirectory.createSync();
    _imageDirectoryPath = imageDirectory.path;

    for (String key in data.keys) {
      if (data[key] is LiveActivityImage) {
        if (data[key] is LiveActivityImageFromAsset) {
          data[key] = await _addImageAsset(data[key].path);
        }
        if (data[key] is LiveActivityImageFromNetwork) {
          data[key] = await _addImageNetwork(data[key].url);
        }
      }
    }
  }

  /// Adds an Image from assets at [path] to App Group.
  ///
  /// Returns [filePath] of the added file.
  Future<String> _addImageAsset(String path) async {
    File file;
    String fileName = (path.split('/').last);
    String filePath = '$_imageDirectoryPath/$fileName';
    file = File(filePath);

    final byteData = await rootBundle.load(path);

    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    _addedImages.add(filePath);
    return filePath;
  }

  /// Adds an Image from network at [url] to App Group.
  ///
  /// Returns [filePath] of the added file.
  Future<String> _addImageNetwork(String url) async {
    File file;
    String fileName = (url.split('/').last);
    String filePath = '$_imageDirectoryPath/$fileName';
    final ByteData imageData =
        await NetworkAssetBundle(Uri.parse(url)).load("");
    final Uint8List bytes = imageData.buffer.asUint8List();
    file = await File(filePath).create();

    file.writeAsBytesSync(bytes);
    _addedImages.add(filePath);
    return filePath;
  }

  /// Removes images in App Group folder.
  Future<void> removeImages() async {
    for (String filePath in _addedImages) {
      final file = File(filePath);
      await file.delete();
    }
    _addedImages.clear();
  }

  /// Removes App Group folder and images inside.
  Future<void> _removeAll() async {
    final imageFolderDirectory = Directory(
      '$_appGroupDirectoryPath/$folderName',
    );
    if (await imageFolderDirectory.exists()) {
      imageFolderDirectory.deleteSync(recursive: true);
    }
  }
}
