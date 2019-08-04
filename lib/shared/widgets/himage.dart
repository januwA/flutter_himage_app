import 'package:flutter/material.dart';
import 'package:himage/shared/widgets/image_network.dart';

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
    return ImageNetwork(
      widget.src,
      loadingWidget: ImageNetwork.defaultLoadingWidget,
      loadingBuilder: ImageNetwork.defaultLoadingBuilder,
    );
  }
}
