import 'dart:io';

import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:himage/dto/images/images.dto.dart';
import 'package:mobx/mobx.dart';
import 'package:random_color/random_color.dart';
import 'package:http/http.dart' as http;
import 'package:video_box/video.controller.dart';

part 'home.store.g.dart';

const INITPAGE = 1;
const PAGEOFFSET = 24;
const TIMEOUT = Duration(seconds: 10);
const double INITSCALE = 1.0;

class HomeStore = _HomeStore with _$HomeStore;

abstract class _HomeStore with Store {
  _HomeStore() {
    _init();
  }

  @action
  Future<void> _init() async {
    _getImages();
  }

  /// 获取api数据
  @action
  Future<void> _getImages() async {
    loading = true;
    try {
      var r = await http.get(apiUrl, headers: headers).timeout(TIMEOUT);
      if (r.statusCode == HttpStatus.ok) {
        body = ImagesDto.fromJson(r.body);
        error = null;
      } else {
        error = r.statusCode;
      }
      loading = false;
    } catch (e) {
      error = e;
      loading = false;
    }

    /// 每次获取数据代表数据的重载
    /// 无论新的请求成功还是失败
    /// 清理掉视频
    for (var v in videos) {
      v.dispose();
    }
  }

  final ScrollController scrollController = ScrollController();
  final tagDuration = const Duration(milliseconds: 400);
  final TextEditingController enterPageController = TextEditingController();

  final Map<String, String> headers = {
    HttpHeaders.userAgentHeader:
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36',
    'x-directive': 'api',
    'x-session-token': '',
    'x-signature': '',
    'x-time': '0',
  };

  @observable
  double scale = INITSCALE;
  final double scaleMin = 0.2;
  final double scaleOffset = 300;

  @observable
  bool isDisplayUpButton = false;

  String get goPage => enterPageController.text;

  List<VideoController> videos = [];

  @observable
  bool loading = true;

  @observable
  ImagesDto body;

  @computed
  BuiltList<DataDto> get images => body.data;

  @computed
  int get lastPage => (body.meta.total / PAGEOFFSET).ceil();

  @observable
  Object error;

  @observable
  double dy = 0.0;

  @observable
  bool showGoButton = false;

  /// 默认显示第一页
  @observable
  int page = INITPAGE;

  /// tags
  @observable
  ObservableList<ChannelName> channelNames = ObservableList<ChannelName>()
    ..addAll([
      ChannelName(text: 'media', active: true),
      ChannelName(text: 'nsfw_general', active: true),
      ChannelName(text: 'furry'),
      ChannelName(text: 'futa'),
      ChannelName(text: 'yaoi'),
      ChannelName(text: 'yuri'),
      ChannelName(text: 'irl-3d'),
    ]);

  /// active text in tags
  List<String> get channelNameIn =>
      channelNames.where((c) => c.active).map((c) => c.text).toList();

  /// api 地址
  Uri get apiUrl => Uri(
        scheme: 'https',
        host: 'hanime.tv',
        path: '/api/v3/community_uploads',
        queryParameters: {
          "channel_name__in[]": channelNameIn,
          '__offset': ((page - 1) * PAGEOFFSET).toString(),
          '__order': 'created_at,DESC'
        },
      );

  @action
  void setPage(int np) {
    page = np;
    _getImages();
  }

  /// 前往指定page
  @action
  void goToNewPage() {
    if (!showGoButton) return null;
    try {
      int p = int.parse(goPage);
      if (p <= lastPage) {
        setPage(p);
      }
    } catch (_) {} finally {
      enterPageController.clear();
      showGoButton = false;
    }
  }

  @action
  void inputChange(String text) {
    try {
      int p = int.parse(text);
      if (p <= lastPage) {
        showGoButton = true;
      } else {
        showGoButton = false;
      }
    } catch (_) {
      showGoButton = false;
    }
  }

  /// 选择 tag
  @action
  selectTag(ChannelName channelName) {
    channelName.active = !channelName.active;
    page = INITPAGE;
    _getImages();
  }

  @action
  void _setDy(double y) {
    dy = y;
  }

  void reload() {
    _getImages();
  }

  void scrollUp() {
    if (!isDisplayUpButton) return;
    scrollController.animateTo(
      scrollController.initialScrollOffset,
      duration: const Duration(seconds: 1),
      curve: Curves.easeIn,
    );
  }

  @action
  bool onNotification(Notification notification) {
    if (notification is ScrollUpdateNotification && notification.depth == 0) {
      // dy
      dy = scrollController.offset;

      // scale
      double newScale = INITSCALE - scrollController.offset / scaleOffset;
      if (newScale != scaleMin) {
        scale = newScale;
      }

      // display floatingActionButton
      if (scrollController.position.extentBefore > 400) {
        isDisplayUpButton = true;
      } else {
        isDisplayUpButton = false;
      }
      return true;
    }
    return false;
  }

  @override
  void dispose() {
    enterPageController.dispose();
    super.dispose();
  }
}

/// tag
class ChannelName = _ChannelName with _$ChannelName;

abstract class _ChannelName with Store {
  _ChannelName({
    this.text,
    this.active = false,
  });
  @observable
  bool active;
  String text;
  Color color = RandomColor().randomColor();
}
