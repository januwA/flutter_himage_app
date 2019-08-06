import 'package:flutter/material.dart';
import 'package:flutter_imagenetwork/flutter_imagenetwork.dart';

class HImage extends StatefulWidget {
  final String src;

  const HImage(
    this.src, {
    Key key,
  }) : super(key: key);

  @override
  _HImageState createState() => _HImageState();
}

class _HImageState extends State<HImage> {
  @override
  Widget build(BuildContext context) {
    return AjanuwImage(
      image: AjanuwNetworkImage(widget.src),
      fit: BoxFit.contain,
      loadingWidget: AjanuwImage.defaultLoadingWidget,
      loadingBuilder: AjanuwImage.defaultLoadingBuilder,
      errorBuilder: AjanuwImage.defaultErrorBuilder,
    );
  }
}
