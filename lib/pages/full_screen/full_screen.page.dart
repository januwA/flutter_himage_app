import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:himage/dto/images/images.dto.dart';
import 'package:himage/pages/full_screen/full_screen.store.dart';
import 'package:himage/shared/widgets/himage.dart';

class FullScreenPage extends StatefulWidget {
  final BuiltList<DataDto> images;
  final int initialPage;

  const FullScreenPage({
    Key key,
    this.images,
    this.initialPage,
  }) : super(key: key);
  @override
  _FullScreenPageState createState() => _FullScreenPageState();
}

class _FullScreenPageState extends State<FullScreenPage> {
  final store = FullScreenStore();

  @override
  void initState() {
    super.initState();
    store.initState(
      initialPage: widget.initialPage,
      images: widget.images.toList(),
    );
  }

  @override
  void dispose() {
    store.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    Color accentColor = theme.accentColor;
    return Observer(
      builder: (context) => Scaffold(
        backgroundColor: theme.primaryColor,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: accentColor,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: Text(
            store.imageName,
            style: TextStyle(
              color: accentColor,
            ),
          ),
          actions: <Widget>[
            IconButton(
              color: accentColor,
              icon: Icon(Icons.file_download),
              onPressed: store.saveImage,
            ),
          ],
        ),

        // 打开速度快
        body: PageView(
          controller: store.pageController,
          onPageChanged: store.setCurrentPage,
          children: <Widget>[
            for (var item in widget.images) HImage(item.canonicalUrl)
          ],
        ),

        // 有点慢
        // body: PhotoViewGallery.builder(
        //   pageController: store.pageController,
        //   itemCount: store.images.length,
        //   builder: (BuildContext context, int index) {
        //     return PhotoViewGalleryPageOptions(
        //       key: ValueKey(store.image.filename + index.toString()),
        //       imageProvider: NetworkImage(store.image.canonicalUrl),
        //     );
        //   },
        //   onPageChanged: store.setCurrentPage,
        // ),
      ),
    );
  }
}
