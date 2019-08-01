import 'package:flutter/material.dart';

class HImage extends StatelessWidget {
  final String src;

  const HImage(
    this.src, {
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Image.network(
      src,
      fit: BoxFit.contain,
      loadingBuilder: _buildImageLoading,
    );
  }

  Widget _buildImageLoading(
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
  }
}
