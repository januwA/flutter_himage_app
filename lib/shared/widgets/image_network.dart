import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// Example:
///
/// ```dart
/// ImageNetwork(
///   'https://htvassets.club/uploads/587000/587708.gif',
///   loadingWidget: ImageNetwork.defaultLoadingWidget,
///   loadingBuilder: ImageNetwork.defaultLoadingBuilder,
/// )
///```
///
class ImageNetwork extends StatefulWidget {
  final String src;
  final ImageLoadingBuilder loadingBuilder;
  final Widget loadingWidget;
  final BoxFit fit;
  final double width;
  final double height;
  final double scale;

  const ImageNetwork(
    this.src, {
    Key key,
    this.loadingBuilder,
    this.loadingWidget,
    this.fit,
    this.width,
    this.height,
    this.scale = 1.0,
  }) : super(key: key);
  @override
  _ImageNetworkState createState() => _ImageNetworkState();

  static final ImageLoadingBuilder defaultLoadingBuilder = (
    BuildContext context,
    Widget child,
    ImageChunkEvent loadingProgress,
  ) {
    if (loadingProgress == null) return child;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Theme.of(context).accentColor),
          value: loadingProgress.expectedTotalBytes != null
              ? loadingProgress.cumulativeBytesLoaded /
                  loadingProgress.expectedTotalBytes
              : null,
        ),
      ),
    );
  };

  static final Widget defaultLoadingWidget = Padding(
    padding: const EdgeInsets.all(8.0),
    child: Center(child: CircularProgressIndicator()),
  );
}

class _ImageNetworkState extends State<ImageNetwork> {
  Uint8List image;
  ImageChunkEvent loadingProgress;
  var _client = http.Client();
  Widget get child => image != null
      ? Image.memory(
          image,
          fit: widget.fit,
          width: widget.width,
          height: widget.height,
          scale: widget.scale,
        )
      : SizedBox();
  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    try {
      http.StreamedResponse r =
          await _client.send(http.Request('get', Uri.parse(widget.src)));
      List<int> ds = [];
      r.stream.listen((List<int> d) {
        ds.addAll(d);
        setState(() {
          loadingProgress = ImageChunkEvent(
            cumulativeBytesLoaded: ds.length,
            expectedTotalBytes: r.contentLength,
          );
        });
      }).onDone(() {
        setState(() {
          image = Uint8List.fromList(ds);
          loadingProgress = null;
        });
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    _client?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (loadingProgress == null &&
        image == null &&
        widget.loadingWidget != null) {
      return widget.loadingWidget;
    }
    if (widget.loadingBuilder != null) {
      return widget.loadingBuilder(
        context,
        child,
        loadingProgress,
      );
    } else {
      return child;
    }
  }
}
