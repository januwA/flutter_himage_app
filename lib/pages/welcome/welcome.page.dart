import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:himage/pages/home/home.page.dart';
import 'package:gradient_text/gradient_text.dart';

class WelcomePage extends StatefulWidget {
  static const routeName = '/WelcomePage';
  @override
  WwelcomePageState createState() => WwelcomePageState();
}

class WwelcomePageState extends State<WelcomePage> {

  _toHomePage() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => HomePage()));
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Positioned(
            right: -20,
            child: Image.asset(
              'assets/images/bg.jpg',
              scale: 1.2,
              fit: BoxFit.fill,
            ),
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black38,
                  Colors.transparent,
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 88.0, left: 20, right: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  GradientText(
                    'HAnime Images',
                    gradient: LinearGradient(colors: [
                      Theme.of(context).accentColor,
                      Colors.deepOrange,
                      Colors.pink,
                    ]),
                    style: Theme.of(context).textTheme.display1.copyWith(
                          color: Colors.white,
                          wordSpacing: 10,
                          letterSpacing: 1.8,
                        ),
                  ),
                  SizedBox(height: 12),
                  GradientText(
                    'hentai pictures images for free!',
                    gradient: LinearGradient(colors: [
                      Theme.of(context).accentColor,
                      Theme.of(context).accentColor,
                      Colors.pink,
                    ]),
                    style: Theme.of(context).textTheme.title.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 20.0, bottom: 20.0),
              child: MaterialButton(
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 30.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                color: Theme.of(context).accentColor,
                onPressed: _toHomePage,
                child: Text('Get Start'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
