import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:himage/dto/images/images.dto.dart';
import 'package:mobx/mobx.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';

part 'full_screen.store.g.dart';

class FullScreenStore = _FullScreenStore with _$FullScreenStore;

abstract class _FullScreenStore with Store {
  @action
  Future<void> initState({
    int initialPage,
    List<DataDto> images,
  }) async {
    this.images = images;
    pageController = PageController(initialPage: initialPage);
    currentPage = initialPage;

    await FlutterDownloader.initialize();
    FlutterDownloader.registerCallback(downloadCallback);
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) async {
    FlutterDownloader.open(taskId: id);
  }

  @observable
  List<DataDto> images;

  @observable
  PageController pageController;

  @observable
  bool showAppbar = false;

  @observable
  int currentPage;

  @computed
  DataDto get image => images[currentPage];

  @computed
  String get imageName => image.filename + '.' + image.extension;

  @action
  void displayAppbar() {
    showAppbar = !showAppbar;
  }

  @action
  void setCurrentPage(int page) {
    currentPage = page;
  }

  Future<void> saveImage(BuildContext context) async {
    if (await _checkPermission(context)) {
      final savedDir = await _getSaveDir();
      FlutterDownloader.enqueue(
        url: image.canonicalUrl,
        savedDir: savedDir.path,
        showNotification:
            true, // show download progress in status bar (for Android)
        openFileFromNotification:
            true, // click on notification to open downloaded file (for Android)
      );
    }
  }

  Future<Directory> _getSaveDir() async {
    Directory appDocDir = await getExternalStorageDirectory();
    Directory savedDir = Directory(path.join(appDocDir.path, 'himage'));
    if (!await savedDir.exists()) {
      savedDir.create();
    }
    return savedDir;
  }

  Future<bool> _checkPermission(BuildContext context) async {
    if (Theme.of(context).platform == TargetPlatform.android) {
      PermissionStatus permission = await PermissionHandler()
          .checkPermissionStatus(PermissionGroup.storage);
      if (permission != PermissionStatus.granted) {
        Map<PermissionGroup, PermissionStatus> permissions =
            await PermissionHandler()
                .requestPermissions([PermissionGroup.storage]);
        if (permissions[PermissionGroup.storage] == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  @override
  void dispose() {
    pageController.dispose();
    FlutterDownloader.registerCallback(null);
    super.dispose();
  }
}
