import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_imagenetwork/flutter_imagenetwork.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:toast/toast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;

import '../global.dart';

class OneImagePage extends StatefulWidget {
  static const routeName = '/OneImagePage';
  final String imageUrl;

  const OneImagePage({Key key, this.imageUrl}) : super(key: key);
  @override
  _OneImagePageState createState() => _OneImagePageState();
}

class _OneImagePageState extends State<OneImagePage> {
  Offset _tapPosition;

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
    if (savePath?.isNotEmpty ?? false) {
      dpath = savePath;
    } else {
      dpath = await FilePicker.platform.getDirectoryPath();
      if (dpath != null) savePath = dpath;
    }

    if (dpath != null) {
      var name = path.basename(originalImage);
      var p = path.join(dpath, name);

      // 3. 从网络获取图片保存到用户手机
      Toast.show(
        "开始下载",
        context,
        duration: Toast.LENGTH_SHORT,
        gravity: Toast.CENTER,
      );
      http.get(originalImage).then((r) {
        Toast.show(
          "下载成功",
          context,
          duration: Toast.LENGTH_SHORT,
          gravity: Toast.CENTER,
        );
        File(p).writeAsBytes(r.bodyBytes).then((_) {
          Toast.show(
            "保存成功",
            context,
            duration: Toast.LENGTH_SHORT,
            gravity: Toast.CENTER,
          );
        }).catchError(_downloadError);
      }).catchError(_downloadError);
    }
  }

  _downloadError(_) {
    Toast.show(
      "下载失败",
      context,
      textColor: Colors.red,
      duration: Toast.LENGTH_SHORT,
      gravity: Toast.CENTER,
    );
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
