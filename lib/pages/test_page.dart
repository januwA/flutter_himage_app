import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:himage/pages/home/home.store.dart';
import 'package:himage/shared/widgets/ajanuw_image.dart';

class TestPage extends StatefulWidget {
  static const routeName = '/TestPage';
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  var store = HomeStore();

  @override
  void dispose() {
    store.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Observer(
        builder: (_) {
          if (store.loading) return SizedBox();
          return ListView.builder(
            itemCount: store.images.length + 1,
            itemBuilder: (context, int index) {
              if (index == 0) {
                return AjanuwImage(
                  image: AjanuwNetworkImage('http://example.com/logo.png'),
                  loadingBuilder: AjanuwImage.defaultLoadingBuilder,
                  loadingWidget: AjanuwImage.defaultLoadingWidget,
                  errorBuilder: AjanuwImage.defaultErrorBuilder,
                );
              }
              var image = store.images[index - 1];
              // return Image(
              //   image: NetworkImage(image.canonicalUrl),
              //   loadingBuilder: AjanuwImage.defaultLoadingBuilder,
              // );
              return AjanuwImage(
                image: AjanuwNetworkImage(image.canonicalUrl),
                loadingBuilder: AjanuwImage.defaultLoadingBuilder,
                loadingWidget: AjanuwImage.defaultLoadingWidget,
                errorBuilder: AjanuwImage.defaultErrorBuilder,
              );
              // return Image.network(
              //   image.canonicalUrl,
              //   loadingBuilder: AjanuwImage.defaultLoadingBuilder,
              // );
            },
          );
          // return ListView(
          //   children: <Widget>[
          //     ...store.images.map((DataDto image) {
          //       // return Image(
          //       //   image: NetworkImage(image.canonicalUrl),
          //       //   loadingBuilder: AjanuwImage.defaultLoadingBuilder,
          //       // );

          //       return AjanuwImage(
          //         image: AjanuwNetworkImage(image.canonicalUrl),
          //         loadingBuilder: AjanuwImage.defaultLoadingBuilder,
          //         loadingWidget: AjanuwImage.defaultLoadingWidget,
          //         errorBuilder: AjanuwImage.defaultErrorBuilder,
          //       );
          //     }).toList()
          //   ],
          // );
        },
      ),
    );
  }
}
