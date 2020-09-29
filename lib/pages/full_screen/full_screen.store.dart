import 'package:flutter/material.dart';
import 'package:himage/dto/images/images.dto.dart';
import 'package:mobx/mobx.dart';

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
      // final savedDir = await _getSaveDir();
    }
  }

  Future<bool> _checkPermission(BuildContext context) async {
    return false;
  }

  void dispose() {
    pageController.dispose();
  }
}
