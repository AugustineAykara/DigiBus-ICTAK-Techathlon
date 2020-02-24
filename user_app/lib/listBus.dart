import 'package:flutter/material.dart';
import 'status.dart';

class ListBusPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ListBus(),
      routes: <String, WidgetBuilder>{
        "/status.dart": (BuildContext context) => BusStatus(),
      },
    );
  }
}

class ListBus extends StatefulWidget {
  final String source;
  final String destination;
  ListBus({Key key, this.source, this.destination}) : super(key:key);
  @override
  _ListBusState createState() => _ListBusState();
}

class _ListBusState extends State<ListBus> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0f4c65),
      appBar: appBar(),
      body: Column(
        children: <Widget>[
          busListCard(" AlphaBus", Colors.blueGrey),
          Card(
            color: Color(0xf00f475),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            elevation: 6,
            child: ListTile(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              leading: Icon(Icons.directions_bus,
                  color: Colors.greenAccent, size: 36),
              title: Row(
                children: <Widget>[
                  Icon(Icons.linear_scale, color: Colors.greenAccent),
                  Text(
                    " DigiBus",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.greenAccent),
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BusStatus(),
                  ),
                );
              },
            ),
          ),
          busListCard(" BetaBus", Colors.blueGrey),
          busListCard(" GammaBus", Colors.white),
        ],
      ),
    );
  }

// bus list card
  Widget busListCard(name, color) {
    return Card(
      color: Color(0xf00f475),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 6,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        leading: Icon(Icons.directions_bus, color: color, size: 36),
        title: Row(
          children: <Widget>[
            Icon(Icons.linear_scale, color: color),
            Text(
              name,
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: color),
            ),
          ],
        ),
      ),
    );
  }

// appbar widget
  Widget appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: Text(
        widget.source + " -> " + widget.destination,
        style: TextStyle(
          fontSize: 20,
          fontFamily: 'serif',
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
