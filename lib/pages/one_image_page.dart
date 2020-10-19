import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_imagenetwork/flutter_imagenetwork.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:toast/toast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;
import 'package:ajanuw_http/ajanuw_http.dart';

import '../global.dart' show imageSavePath;

class OneImagePage extends StatefulWidget {
  static const routeName = '/OneImagePage';
  final String imageUrl;

  const OneImagePage({Key key, this.imageUrl}) : super(key: key);
  @override
  _OneImagePageState createState() => _OneImagePageState();
}

class _OneImagePageState extends State<OneImagePage> {
  Offset _tapPosition;
  final api = AjanuwHttp();

  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }

  void _showCustomMenu() {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();

    showMenu(
      context: context,
      items: <PopupMenuEntry<int>>[
        const PopupMenuItem<int>(
          value: 1,
          child: Text('Download'),
        ),
      ],
      position: RelativeRect.fromRect(
          _tapPosition & Size.zero, // smaller rect, the touch area
          Offset.zero & overlay.size // Bigger rect, the entire screen
          ),
    ).then<void>((int r) {
      if (r == null) {
        print('cancel');
        return;
      }

      if (r == 1) _download(widget.imageUrl);
    });
  }

  void _download(String originalImage) async {
    // 1. 获取权限
    var storageStatus = await Permission.storage.status;

    // 没有权限则申请
    if (storageStatus != PermissionStatus.granted) {
      storageStatus = await Permission.storage.request();
      if (storageStatus != PermissionStatus.granted) {
        return;
      }
    }

    // 2. 获取保存目录

    // 缓存目录路径，不免每次都选择目录
    String dpath = '';
    if (imageSavePath?.isNotEmpty ?? false) {
      dpath = imageSavePath;
    } else {
      dpath = await FilePicker.platform.getDirectoryPath();
      if (dpath != null) imageSavePath = dpath;
    }

    if (dpath != null) {
      var name = path.basename(originalImage);
      var p =
          path.join(dpath, '${DateTime.now().millisecondsSinceEpoch}-$name');

      // 3. 从网络获取图片保存到用户手机
      Toast.show("开始下载", context);
      api.getStream(originalImage).then((r) {
        var f$ = File(p).openWrite();
        r.stream.listen(
          f$.add,
          onDone: () {
            Toast.show("下载完成", context);
            f$.close();
          },
          onError: (e) {
            Toast.show("保存失败", context, textColor: Colors.red);
            f$.close();
          },
        );
      }).catchError((e) {
        Toast.show("下载失败", context, textColor: Colors.red);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onLongPress: () => _showCustomMenu(), // 长按打开Menu菜单
          onTapDown: _storePosition, // 按下去的时候记住位置
          child: AjanuwImage(
            image: AjanuwNetworkImage(widget.imageUrl),
            fit: BoxFit.contain,
            loadingWidget: AjanuwImage.defaultLoadingWidget,
            loadingBuilder: AjanuwImage.defaultLoadingBuilder,
            errorBuilder: AjanuwImage.defaultErrorBuilder,
          ),
        ),
      ),
    );
  }
}
