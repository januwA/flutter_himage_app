import 'dart:io';

import 'package:flutter/material.dart';
import 'package:himage/dto/images/images.dto.dart';
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
      backgroundColor: Color(0xff303030),
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
                      valueColor: AlwaysStoppedAnimation(
                          Theme.of(context).primaryColor),
                    )),
                  );
                }

                if (snap.connectionState == ConnectionState.done) {
                  if (snap.hasError) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          snap.error,
                          style: Theme.of(context).textTheme.body1.copyWith(
                                color: Theme.of(context).primaryColor,
                              ),
                        ),
                      ),
                    );
                  } else {
                    ImagesDto body = snap.data;
                    int lastPage = (body.meta.total / pageOffset).ceil();
                    return Column(
                      children: [
                        ...body.data.map((DataDto item) {
                          return Image.network(
                            item.canonicalUrl,
                            fit: BoxFit.contain,
                            loadingBuilder: (
                              BuildContext context,
                              Widget child,
                              ImageChunkEvent loadingProgress,
                            ) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation(
                                      Theme.of(context).primaryColor),
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes
                                      : null,
                                ),
                              );
                            },
                          );
                        }).toList(),

                        /// list
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              IconButton(
                                color: Colors.white,
                                icon: Icon(Icons.chevron_left),
                                onPressed: () {
                                  setState(() {
                                    page -= 1;
                                  });
                                },
                              ),
                              _buildPageButton(
                                  text: '$page',
                                  color: Theme.of(context).primaryColor),
                              _buildPageButton(
                                  text: '${page + 1}',
                                  onTap: () {
                                    setState(() {
                                      page = page + 1;
                                    });
                                  }),
                              _buildPageButton(text: '...'),
                              _buildPageButton(
                                  text: '${lastPage - 1}',
                                  onTap: () {
                                    setState(() {
                                      page = lastPage - 1;
                                    });
                                  }),
                              _buildPageButton(
                                  text: '$lastPage',
                                  onTap: () {
                                    setState(() {
                                      page = lastPage;
                                    });
                                  }),
                              IconButton(
                                color: Colors.white,
                                icon: Icon(Icons.chevron_right),
                                onPressed: () {
                                  setState(() {
                                    page += 1;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),

                        /// go to page
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'NAV TO:',
                                style: TextStyle(
                                  color: Colors.grey[200],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: SizedBox(
                                  width: Theme.of(context).buttonTheme.minWidth,
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
                                        hintStyle:
                                            TextStyle(color: Colors.white60),
                                        border: InputBorder.none,
                                      ),
                                      textAlign: TextAlign.center,
                                      cursorColor:
                                          Theme.of(context).primaryColor,
                                      cursorWidth: 4,
                                      cursorRadius: Radius.circular(4.0),
                                    ),
                                  ),
                                ),
                              ),
                              RaisedButton(
                                color: Theme.of(context).primaryColor,
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
                        ),
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
