import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:himage/dto/images/images.dto.dart';
import 'package:himage/pages/full_screen/full_screen.page.dart';
import 'package:himage/pages/home/home.store.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:himage/shared/widgets/himage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final store = HomeStore();

  @override
  void dispose() {
    store.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Stack(
        children: [
          Observer(
            builder: (_) => Positioned(
              right: 0,
              top: -store.offset,
              child: Opacity(
                opacity: 0.5,
                child: Image.asset(
                  'assets/images/bg.jpg',
                  height: MediaQuery.of(context).size.height / 2,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          ListView(
            controller: store.scrollController,
            children: <Widget>[
              _buildTags(),
              Observer(
                builder: (_) => store.channelNameIn.isEmpty
                    ? NotTags()
                    : FutureBuilder(
                        future: store.getImages(),
                        builder: (context, AsyncSnapshot<ImagesDto> snap) {
                          ConnectionState status = snap.connectionState;

                          if (status == ConnectionState.waiting) {
                            return _buildLoading(context);
                          }

                          if (status == ConnectionState.done) {
                            if (snap.hasError) {
                              return _buildError(snap, context);
                            }
                            ImagesDto body = snap.data;
                            int lastPage = store.getLstPage(body.meta.total);
                            return Column(
                              children: [
                                /// split button list
                                _buildSplitSection(context, lastPage),

                                /// go to page
                                _buildInputPage(context, lastPage),

                                /// images list
                                ..._buildListImages(body.data),

                                /// split button list
                                _buildSplitSection(context, lastPage),

                                /// go to page
                                _buildInputPage(context, lastPage),
                              ],
                            );
                          }

                          return SizedBox();
                        },
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSplitSection(BuildContext context, int lastPage) {
    return Observer(
      builder: (_) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _getSplitPageButtons(
            context: context,
            lastPage: lastPage,
          ),
        ),
      ),
    );
  }

  /// 返回分页按钮
  List<Widget> _getSplitPageButtons({
    BuildContext context,
    int lastPage,
  }) {
    var page = store.page;
    var setPage = store.setPage;

    var pb = _buildPageButton(text: '...');
    List<Widget> splitPageButtons = [
      /// prev
      _buildIconButtom(
        icon: Icons.chevron_left,
        onTap: () => setPage(page - 1),
      ),

      /// first
      _buildPageButton(
        text: '1',
        color: page == 1 ? Theme.of(context).accentColor : null,
        onTap: () => setPage(1),
      ),
    ];

    if (page <= 2 || page >= lastPage - 1) {
      splitPageButtons.addAll([
        _buildPageButton(
          text: '2',
          color: page == 2 ? Theme.of(context).accentColor : null,
          onTap: () => setPage(2),
        ),
        pb,
        _buildPageButton(
          text: '${lastPage - 1}',
          color: page == lastPage - 1 ? Theme.of(context).accentColor : null,
          onTap: () => setPage(lastPage - 1),
        ),
      ]);
    } else {
      splitPageButtons.addAll([
        pb,
        _buildPageButton(
          text: '$page',
          color: Theme.of(context).accentColor,
          onTap: () => setPage(page),
        ),
        pb,
      ]);
    }

    splitPageButtons.add(
      _buildPageButton(
        text: '$lastPage',
        color: page == lastPage ? Theme.of(context).accentColor : null,
        onTap: () => setPage(lastPage),
      ),
    );

    splitPageButtons.add(
      _buildIconButtom(
        icon: Icons.chevron_right,
        onTap: () => setPage(page + 1),
      ),
    );
    return splitPageButtons;
  }

  SizedBox _buildIconButtom({
    IconData icon,
    Function onTap,
  }) {
    return SizedBox(
      width: 34,
      height: 34,
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xff424242),
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: GestureDetector(
          child: Center(
            child: Icon(
              icon,
              color: Colors.white,
            ),
          ),
          onTap: onTap,
        ),
      ),
    );
  }

  /// 分页按钮 ui
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

  List<Widget> _buildListImages(BuiltList<DataDto> images) {
    return images.map((DataDto item) {
      return GestureDetector(
        onTap: () => toFullScreenPage(
          images: images,
          initialPage: images.indexOf(item),
        ),
        child: HImage(item.canonicalUrl),
      );
    }).toList();
  }

  /// 查看大图
  toFullScreenPage({
    BuiltList<DataDto> images,
    int initialPage,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FullScreenPage(
          images: images,
          initialPage: initialPage,
        ),
      ),
    );
  }

  Padding _buildLoading(BuildContext context) {
    Color color = Theme.of(context).accentColor;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
          child: Column(
        children: <Widget>[
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(color),
          ),
          SizedBox(height: 10),
          Text(
            'Loading...',
            style: TextStyle(color: color),
          ),
        ],
      )),
    );
  }

  Padding _buildError(AsyncSnapshot<ImagesDto> snap, BuildContext context) {
    Color accentColor = Theme.of(context).accentColor;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Center(
            child: Text(
              '${snap.error}',
              style: Theme.of(context)
                  .textTheme
                  .body1
                  .copyWith(color: accentColor),
            ),
          ),
          RaisedButton(
            color: accentColor,
            textColor: Colors.white,
            onPressed: () {
              setState(() {});
            },
            child: Text('Reload'),
          ),
        ],
      ),
    );
  }

  /// 跳转到输入的page
  Widget _buildInputPage(BuildContext context, int lastPage) {
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
          SizedBox(width: 10),
          SizedBox(
            width: 100,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xff17181a),
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: TextField(
                controller: store.enterPageController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                onChanged: store.inputChange,
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
          SizedBox(width: 10),
          Observer(builder: (_) {
            return AnimatedOpacity(
              duration: Duration(milliseconds: 200),
              opacity: store.showGoButton ? 1 : 0,
              child: FlatButton(
                color: Theme.of(context).accentColor,
                textColor: Colors.white,
                child: Text('GO'),
                onPressed: store.goToNewPage,
              ),
            );
          })
        ],
      ),
    );
  }

  /// 显示tags ui
  Widget _buildTags() {
    return Observer(
      builder: (_) => Wrap(
        children: <Widget>[
          for (var channelName in store.channelNames)
            Observer(
              builder: (_) => FlatButton(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    AnimatedContainer(
                      duration: store.tagDuration,
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
                    AnimatedDefaultTextStyle(
                      duration: store.tagDuration,
                      style: TextStyle(
                        color: Colors.white
                            .withOpacity(channelName.active ? 1.0 : 0.5),
                      ),
                      child: Text('#${channelName.text}'),
                    ),
                  ],
                ),
                splashColor: Colors.white30,
                onPressed: () => store.selectTag(channelName),
              ),
            ),
        ],
      ),
    );
  }
}

class NotTags extends StatelessWidget {
  const NotTags({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(14.0),
      child: Text(
        'There are no images for the current page / channel combination!',
        style: Theme.of(context).textTheme.body2.copyWith(color: Colors.white),
      ),
    );
  }
}
