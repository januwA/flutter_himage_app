import 'dart:io';

import 'package:flutter/material.dart';
import 'package:himage/dto/images/images.dto.dart';
import 'package:himage/pages/full_screen/full_screen.page.dart';
import 'package:himage/util/build_image_loading.dart';
import 'package:http/http.dart' as http;
import 'package:random_color/random_color.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController enterPageController = TextEditingController();
  String get goPage => enterPageController.text;

  /// tags
  final List<ChannelName> channelNames = [
    ChannelName(text: 'media', active: true),
    ChannelName(text: 'nsfw_general', active: true),
    ChannelName(text: 'furry'),
    ChannelName(text: 'futa'),
    ChannelName(text: 'yaoi'),
    ChannelName(text: 'yuri'),
    ChannelName(text: 'irl-3d'),
  ];

  /// active text in tags
  List<String> get channelNameIn =>
      channelNames.where((c) => c.active).map((c) => c.text).toList();

  /// 每页有24张图
  final int pageOffset = 24;

  /// 默认显示第一页
  int page = 1;

  /// api 地址
  Uri get apiUrl => Uri(
        scheme: 'https',
        host: 'hanime.tv',
        path: '/api/v3/community_uploads',
        queryParameters: {
          "channel_name__in[]": channelNameIn,
          '__offset': '${(page - 1) * pageOffset}',
          '__order': 'created_at,DESC'
        },
      );
  final headers = {
    HttpHeaders.userAgentHeader:
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36',
    'x-directive': 'api',
    'x-session-token': '',
    'x-signature': '',
    'x-time': '0',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: ListView(
        children: <Widget>[
          _buildTags(),
          if (channelNameIn.isEmpty)
            Padding(
              padding: EdgeInsets.all(14.0),
              child: Text(
                'There are no images for the current page / channel combination!',
                style: Theme.of(context)
                    .textTheme
                    .title
                    .copyWith(color: Colors.white),
              ),
            )
          else
            FutureBuilder(
              future: getImages(),
              builder: (context, AsyncSnapshot<ImagesDto> snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                        child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation(Theme.of(context).accentColor),
                    )),
                  );
                }

                if (snap.connectionState == ConnectionState.done) {
                  if (snap.hasError) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          '${snap.error}',
                          style: Theme.of(context).textTheme.body1.copyWith(
                                color: Theme.of(context).accentColor,
                              ),
                        ),
                      ),
                    );
                  } else {
                    ImagesDto body = snap.data;
                    int lastPage = (body.meta.total / pageOffset).ceil();

                    var pb = _buildPageButton(text: '...');
                    List<Widget> splitPageButtons = [
                      IconButton(
                        color: Colors.white,
                        icon: Icon(Icons.chevron_left),
                        onPressed: () => _setPage(page - 1),
                      ),
                      _buildPageButton(
                        text: '1',
                        color: page == 1 ? Theme.of(context).accentColor : null,
                        onTap: () => _setPage(1),
                      ),
                    ];

                    if (page <= 2 || page >= lastPage - 1) {
                      splitPageButtons.addAll([
                        _buildPageButton(
                          text: '2',
                          color:
                              page == 2 ? Theme.of(context).accentColor : null,
                          onTap: () => _setPage(2),
                        ),
                        pb,
                        _buildPageButton(
                          text: '${lastPage - 1}',
                          color: page == lastPage - 1
                              ? Theme.of(context).accentColor
                              : null,
                          onTap: () => _setPage(lastPage - 1),
                        ),
                      ]);
                    } else {
                      splitPageButtons.addAll([
                        pb,
                        _buildPageButton(
                          text: '$page',
                          color: Theme.of(context).accentColor,
                          onTap: () => _setPage(page),
                        ),
                        pb,
                      ]);
                    }

                    splitPageButtons.add(
                      _buildPageButton(
                        text: '$lastPage',
                        color: page == lastPage
                            ? Theme.of(context).accentColor
                            : null,
                        onTap: () => _setPage(lastPage),
                      ),
                    );

                    splitPageButtons.add(
                      IconButton(
                        color: Colors.white,
                        icon: Icon(Icons.chevron_right),
                        onPressed: () => _setPage(page + 1),
                      ),
                    );

                    return Column(
                      children: [
                        /// images list
                        ...body.data.map((DataDto item) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => FullScreenPage(
                                        images: body.data,
                                        initialPage: body.data.indexOf(item),
                                      )));
                            },
                            child: Image.network(
                              item.canonicalUrl,
                              fit: BoxFit.contain,
                              loadingBuilder: buildImageLoading,
                            ),
                          );
                        }).toList(),

                        /// split button list
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: splitPageButtons,
                          ),
                        ),

                        /// go to page
                        _buildInputPage(context, lastPage),
                      ],
                    );
                  }
                }

                return SizedBox();
              },
            )
        ],
      ),
    );
  }

  void _setPage(int newPage) {
    setState(() {
      page = newPage;
    });
  }

  /// 跳转到输入的page
  Padding _buildInputPage(BuildContext context, int lastPage) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            'NAV TO:',
            style: TextStyle(
              color: Colors.grey[300],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: SizedBox(
              width: 100,
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xff17181a),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: TextField(
                  controller: enterPageController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    hintText: 'PAGE #',
                    hintStyle: TextStyle(color: Colors.white60),
                    border: InputBorder.none,
                  ),
                  textAlign: TextAlign.center,
                  cursorColor: Theme.of(context).accentColor,
                  cursorWidth: 2,
                  cursorRadius: Radius.circular(4.0),
                ),
              ),
            ),
          ),
          RaisedButton(
            color: Theme.of(context).accentColor,
            textColor: Colors.white,
            child: Text('GO'),
            onPressed: () {
              try {
                int p = int.parse(goPage);
                if (p <= lastPage) {
                  setState(() {
                    page = p;
                  });
                }
              } catch (_) {} finally {
                enterPageController.clear();
              }
            },
          )
        ],
      ),
    );
  }

  Widget _buildPageButton({
    String text,
    Color color,
    final onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 34,
        margin: EdgeInsets.symmetric(horizontal: 4.0),
        decoration: BoxDecoration(
          color: color ?? Color(0xff424242),
          borderRadius: BorderRadius.circular(4.0),
        ),
        constraints: BoxConstraints(
          minWidth: 34,
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Future<ImagesDto> getImages() async {
    print(apiUrl);
    var r = await http.get(apiUrl, headers: headers);
    if (r.statusCode == HttpStatus.ok) {
      return ImagesDto.fromJson(r.body);
    } else {
      return Future.error(r.statusCode);
    }
  }

  Wrap _buildTags() {
    return Wrap(
      children: <Widget>[
        for (ChannelName channelName in channelNames)
          FlatButton(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 8.0),
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: channelName.active
                        ? channelName.color
                        : Colors.white.withOpacity(0),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: channelName.active
                          ? channelName.color
                          : Colors.white.withOpacity(0.5),
                    ),
                  ),
                ),
                Text(
                  '#${channelName.text}',
                  style: TextStyle(
                    color: Colors.white
                        .withOpacity(channelName.active ? 1.0 : 0.5),
                  ),
                ),
              ],
            ),
            splashColor: Colors.white30,
            onPressed: () {
              setState(() {
                channelName.active = !channelName.active;
                page = 1;
              });
            },
          )
      ],
    );
  }
}

class ChannelName {
  String text;
  bool active;
  Color color;
  ChannelName({
    this.text,
    this.active = false,
  }) : color = RandomColor().randomColor();
}
