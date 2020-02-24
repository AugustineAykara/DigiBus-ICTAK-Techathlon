import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class MapPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ShowMap(),
    );
  }
}

class ShowMap extends StatefulWidget {
  final String source;
  final String destination;
  ShowMap({Key key, this.source, this.destination}) : super(key: key);
  @override
  _ShowMapState createState() => _ShowMapState();
}

class _ShowMapState extends State<ShowMap> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        "/": (_) => new WebviewScaffold(
              url: "https://www.google.com/maps/dir/Kottayam,+Kerala/Kochi,+Kerala/",              
            ),
      },
    );
  }
}

// initialUrl: 'www.google.com/maps/dir/' + widget.source + '/' + widget.destination,
