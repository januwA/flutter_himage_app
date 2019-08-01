import 'dart:io';

import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:himage/dto/images/images.dto.dart';
import 'package:mobx/mobx.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

part 'full_screen.store.g.dart';

class FullScreenStore = _FullScreenStore with _$FullScreenStore;

abstract class _FullScreenStore with Store {
  @action
  void initState({
    int initialPage,
    BuiltList<DataDto> images,
  }) {
    _images = images;
    pageController = PageController(initialPage: initialPage);
    currentPage = initialPage;

    FlutterDownloader.registerCallback((id, status, progress) async {
      FlutterDownloader.open(taskId: id);
    });
  }

  @observable
  BuiltList<DataDto> _images;

  @observable
  PageController pageController;

  @observable
  bool showAppbar = false;

  @observable
  int currentPage;

  @computed
  DataDto get image => _images[currentPage];

  @action
  void displayAppbar() {
    showAppbar = !showAppbar;
  }

  @action
  void setCurrentPage(int page) {
    currentPage = page;
  }

  Future<void> saveImage() async {
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

  Future<Directory> _getSaveDir() async {
    Directory appDocDir = await getExternalStorageDirectory();
    Directory savedDir = Directory(path.join(appDocDir.path, 'himage'));
    if (!await savedDir.exists()) {
      savedDir.create();
    }
    return savedDir;
  }

  @override
  void dispose() {
    pageController.dispose();
    FlutterDownloader.registerCallback(null);
    super.dispose();
  }
}
