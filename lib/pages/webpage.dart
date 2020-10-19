import 'dart:async';
// import 'dart:io';

// import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:himage/pages/one_image_page.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:toast/toast.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:ajanuw_http/ajanuw_http.dart';
// import 'package:path/path.dart' as path;
import 'package:url_launcher/url_launcher.dart';

// import '../global.dart' show videoSavePath;

class WebPage extends StatefulWidget {
  static const routeName = '/WebPage';
  @override
  _WebPageState createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> {
  final _controller = Completer<WebViewController>();
  final api = AjanuwHttp();

  // void _download(String videoUrl) async {
  //   // 1. 获取权限
  //   var storageStatus = await Permission.storage.status;

  //   // 没有权限则申请
  //   if (storageStatus != PermissionStatus.granted) {
  //     storageStatus = await Permission.storage.request();
  //     if (storageStatus != PermissionStatus.granted) {
  //       return;
  //     }
  //   }

  //   // 2. 获取保存目录

  //   // 缓存目录路径，不免每次都选择目录
  //   String dpath = '';
  //   if (videoSavePath?.isNotEmpty ?? false) {
  //     dpath = videoSavePath;
  //   } else {
  //     dpath = await FilePicker.platform.getDirectoryPath();
  //     if (dpath != null) videoSavePath = dpath;
  //   }

  //   if (dpath != null) {
  //     var videoName = Uri.parse(videoUrl).pathSegments.last;
  //     var p = path.join(
  //         dpath, '${DateTime.now().millisecondsSinceEpoch}-$videoName');

  //     // 3. 从网络获取video保存到用户手机
  //     Toast.show("开始下载", context);
  //     api.getStream(videoUrl).then((r) {
  //       var f$ = File(p).openWrite();
  //       r.stream.listen(
  //         f$.add,
  //         onDone: () {
  //           Toast.show("下载完成", context);
  //           f$.close();
  //         },
  //         onError: () {
  //           Toast.show("下载失败", context, textColor: Colors.red);
  //           f$.close();
  //         },
  //       );
  //     }).catchError((_) {
  //       Toast.show("下载失败", context, textColor: Colors.red);
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("hanime.tv"),
        actions: <Widget>[NavigationControls(_controller.future)],
      ),
      body: WebView(
        /// web main
        initialUrl: 'https://hanime.tv/browse/images',

        /// 启用js
        javascriptMode: JavascriptMode.unrestricted,

        /// webview创建完毕
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },

        /// 页面加载完成，但是DOM可能未加载完毕
        onPageFinished: (String url) async {
          try {
            var c = await _controller.future;
            if (c == null) return;
            c.evaluateJavascript('''
              setInterval(() => {
                document.querySelector(".htvad")?.remove();
              }, 2000);
            ''');
          } catch (_) {}
        },

        /// webview导航时
        navigationDelegate: (NavigationRequest req) async {
          print(req.url);

          // 打开image
          if (req.url.indexOf('cdn.discordapp.com') >= 0) {
            // 防止导航

            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => OneImagePage(
                  imageUrl: req.url,
                ),
              ),
            );

            return NavigationDecision.prevent;
          }

          // 打开浏览器下载video
          if (req.url.indexOf('highwinds-cdn.com') >= 0) {
            // _download(req.url);
            launch(req.url);
            return NavigationDecision.prevent;
          }

          // 允许导航
          return NavigationDecision.navigate;
        },

        // gestureRecognizers: null,

        /// 允许video/audio自动播放
        initialMediaPlaybackPolicy:
            AutoMediaPlaybackPolicy.require_user_action_for_all_media_types,
      ),
    );
  }
}

class NavigationControls extends StatelessWidget {
  const NavigationControls(this._webViewControllerFuture)
      : assert(_webViewControllerFuture != null);

  final Future<WebViewController> _webViewControllerFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
      future: _webViewControllerFuture,
      builder: (context, snapshot) {
        final bool webViewReady =
            snapshot.connectionState == ConnectionState.done;
        if (!webViewReady) return SizedBox();
        final WebViewController controller = snapshot.data;
        return Row(
          children: <Widget>[
            ///  后退
            IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () async {
                if (await controller.canGoBack()) {
                  controller.goBack();
                }
              },
            ),

            /// 前进
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: () async {
                if (await controller.canGoForward()) {
                  controller.goForward();
                }
              },
            ),

            // options
            PopupMenuButton<int>(
              onSelected: (int value) async {
                switch (value) {
                  case 1:
                    controller.reload();
                    break;
                  case 2:
                    var url = await controller.currentUrl();
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      Toast.show('打开浏览器失败.', context);
                    }
                    break;
                  default:
                }
              },
              itemBuilder: (BuildContext context) => [
                PopupMenuItem<int>(
                  value: 1,
                  child: ListTile(
                    dense: true,
                    leading: Icon(Icons.replay),
                    title: const Text('Reload'),
                  ),
                ),
                PopupMenuItem<int>(
                  value: 2,
                  child: ListTile(
                    dense: true,
                    leading: Icon(Icons.open_in_browser),
                    title: const Text('浏览器打开'),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
