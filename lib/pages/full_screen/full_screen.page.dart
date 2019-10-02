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
      images: widget.images,
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
    double width = MediaQuery.of(context).size.width;
    Color accentColor = theme.accentColor;
    return SafeArea(
      child: Scaffold(
        backgroundColor: theme.primaryColor,
        body: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            GestureDetector(
              onTap: store.displayAppbar,
              child: PageView(
                controller: store.pageController,
                onPageChanged: store.setCurrentPage,
                children: <Widget>[
                  for (var item in widget.images) HImage(item.canonicalUrl)
                ],
              ),
            ),
            Observer(
              builder: (_) => store.showAppbar
                  ? Positioned(
                      left: 0,
                      top: 0,
                      child: SizedBox(
                        width: width,
                        child: Container(
                          color: Theme.of(context).primaryColor.withAlpha(100),
                          child: Row(
                            children: <Widget>[
                              BackButton(color: accentColor),
                              Expanded(
                                child: Text(
                                  store.image.filename,
                                  style: Theme.of(context)
                                      .textTheme
                                      .body1
                                      .copyWith(
                                        color: Colors.white,
                                      ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              IconButton(
                                color: accentColor,
                                icon: Icon(Icons.file_download),
                                onPressed: store.saveImage,
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}
