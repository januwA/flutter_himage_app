import 'dart:async';

import 'package:flutter/material.dart';
import 'package:himage/pages/one_image_page.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebPage extends StatefulWidget {
  static const routeName = '/WebPage';
  @override
  _WebPageState createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[NavigationControls(_controller.future)],
      ),
      body: WebView(
        initialUrl: 'https://hanime.tv/browse/images',
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
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
        navigationDelegate: (NavigationRequest request) {
          if (request.url.indexOf('cdn.discordapp.com') >= 0) {
            // 防止导航

            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => OneImagePage(
                  imageUrl: request.url,
                ),
              ),
            );

            return NavigationDecision.prevent;
          }
          // 允许导航
          return NavigationDecision.navigate;
        },
        gestureRecognizers: null,
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

            /// reload
            IconButton(
              icon: const Icon(Icons.replay),
              onPressed: () => controller.reload(),
            ),
          ],
        );
      },
    );
  }
}
