import 'package:flutter/material.dart';
import 'package:flutter_github_releases_service/flutter_github_releases_service.dart';

class VersionService {
  GithubReleasesService grs = GithubReleasesService(
    owner: 'januwA',
    repo: 'flutter_himage_app',
  );

  /// 只检查一次
  int _checkCount = 0;

  updateApp(BuildContext context) async {
    if (_checkCount > 0) {
      return null;
    }
    _checkCount += 1;
    try {
      if (await grs.isNeedUpdate && await _showDialog(context)) {
        try {
          grs.downloadApk(
            downloadUrl: grs.latestSync.assets.first.browserDownloadUrl,
            apkName: grs.latestSync.assets.first.name,
          );
        } catch (e) {
          print('安装失败: $e');
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Future<bool> _showDialog(BuildContext context) {
    final shape = RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(8.0), topLeft: Radius.circular(8.0)));
    String title = '有新版本可更新 v${grs.latestSync.tagName}';
    Image image = Image.asset(
      'assets/images/bg.jpg',
      fit: BoxFit.cover,
    );
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).primaryColor,
          titlePadding: EdgeInsets.zero,
          shape: shape,
          title: Column(
            children: <Widget>[
              Card(
                elevation: 0.0,
                margin: EdgeInsets.zero,
                shape: shape,
                child: image,
              ),
              Transform.translate(
                offset: const Offset(0.0, -1.0),
                child: Container(
                  width: double.infinity,
                  color: Theme.of(context).primaryColor,
                  child: Center(
                    child: Text(
                      title,
                      style: Theme.of(context)
                          .textTheme
                          .title
                          .copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('取消'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            FlatButton(
              child: Text('确定'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }
}
