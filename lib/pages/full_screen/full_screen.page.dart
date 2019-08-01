import 'dart:io';

import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:himage/dto/images/images.dto.dart';
import 'package:himage/util/build_image_loading.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class FullScreenPage extends StatefulWidget {
  final BuiltList<DataDto> images;
  final int initialPage;

  const FullScreenPage({Key key, this.images, this.initialPage})
      : super(key: key);
  @override
  _FullScreenPageState createState() => _FullScreenPageState();
}

class _FullScreenPageState extends State<FullScreenPage> {
  PageController pageController;
  bool showAppbar = false;
  int currentPage;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: widget.initialPage);
    currentPage = widget.initialPage;

    FlutterDownloader.registerCallback((id, status, progress) async {
      FlutterDownloader.open(taskId: id);
    });
  }

  @override
  void dispose() {
    FlutterDownloader.registerCallback(null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  showAppbar = !showAppbar;
                });
              },
              child: PageView(
                controller: pageController,
                onPageChanged: (int page) {
                  setState(() {
                    currentPage = page;
                  });
                },
                children: <Widget>[
                  for (var item in widget.images)
                    Image.network(
                      item.canonicalUrl,
                      fit: BoxFit.contain,
                      loadingBuilder: buildImageLoading,
                    )
                ],
              ),
            ),
            if (showAppbar)
              Positioned(
                left: 0,
                top: 0,
                child: SizedBox(
                  width: width,
                  child: Row(
                    children: <Widget>[
                      BackButton(
                        color: Theme.of(context).accentColor,
                      ),
                      Expanded(
                        child: Text(
                          widget.images[currentPage].filename,
                          style: Theme.of(context).textTheme.body1.copyWith(
                                color: Colors.white,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        color: Theme.of(context).accentColor,
                        icon: Icon(Icons.file_download),
                        onPressed: () async {
                          Directory appDocDir =
                              await getExternalStorageDirectory();
                          String appDocPath = appDocDir.path;
                          final savedDir =
                              Directory(path.join(appDocPath, 'himage'));
                          if (!await savedDir.exists()) {
                            savedDir.create();
                          }
                          FlutterDownloader.enqueue(
                            url: widget.images[currentPage].canonicalUrl,
                            savedDir: savedDir.path,
                            showNotification:
                                true, // show download progress in status bar (for Android)
                            openFileFromNotification:
                                true, // click on notification to open downloaded file (for Android)
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
