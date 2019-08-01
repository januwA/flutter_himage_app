import 'package:flutter/material.dart';

Widget buildImageLoading(
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
