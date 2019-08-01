import 'dart:io';

import 'package:flutter/material.dart';
import 'package:himage/dto/images/images.dto.dart';
import 'package:mobx/mobx.dart';
import 'package:random_color/random_color.dart';
import 'package:http/http.dart' as http;

part 'home.store.g.dart';

class HomeStore = _HomeStore with _$HomeStore;

abstract class _HomeStore with Store {
  static const INITPAGE = 1;

  /// 每页有24张图
  final int pageOffset = 24;

  @observable
  int _lastPage;

  @observable
  bool showGoButton = false;

  /// 默认显示第一页
  @observable
  int page = INITPAGE;
  TextEditingController enterPageController = TextEditingController();
  String get goPage => enterPageController.text;

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
          '__offset': '${(page - 1) * pageOffset}',
          '__order': 'created_at,DESC'
        },
      );

  /// 发出请求务必带上header
  final headers = {
    HttpHeaders.userAgentHeader:
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36',
    'x-directive': 'api',
    'x-session-token': '',
    'x-signature': '',
    'x-time': '0',
  };

  /// 获取最大page
  @action
  int getLstPage(int total) {
    _lastPage = (total / pageOffset).ceil();
    return _lastPage;
  }

  @action
  void setPage(int np) {
    page = np;
  }

  /// 前往指定page
  @action
  void goToNewPage() {
    try {
      int p = int.parse(goPage);
      if (p <= _lastPage) {
        page = p;
      }
    } catch (_) {} finally {
      enterPageController.clear();
    }
  }

  /// 获取api数据
  Future<ImagesDto> getImages() async {
    try {
      var r = await http.get(apiUrl, headers: headers);
      if (r.statusCode == HttpStatus.ok) {
        return ImagesDto.fromJson(r.body);
      } else {
        return Future.error(r.statusCode);
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  @action
  void inputChange(String text) {
    try {
      int p = int.parse(text);
      if (p <= _lastPage) {
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
