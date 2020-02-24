import 'package:flutter/material.dart';
import 'listBus.dart';
import 'map.dart';
import 'payment.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bus Status User App',
      home: MyHomePage(),
      routes: <String, WidgetBuilder>{
        "/listBus": (BuildContext context) => ListBus(),
        "/map.dart": (BuildContext context) => ShowMap(),
        "/payment.dart": (BuildContext context) => QRScan(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final image = "assets/images/bus.png";
  String source = "";
  String destination = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xff0f4c65),
      appBar: appBar(),
      body: Container(
        child: Stack(
          children: <Widget>[
            backgroundImage(),
            Container(
              margin: EdgeInsets.all(18),
              child: Column(
                children: <Widget>[
                  sourceTextField(Icons.radio_button_checked, "Starting Point"),
                  destinationTextField(Icons.location_on, "Destination"),
                  Padding(
                    padding: EdgeInsets.only(bottom: 24),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      mapButton(),
                      searchBusButton(),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 18),
                  ),
                  instantPay(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

// instant pay button
  Widget instantPay() {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
          side: BorderSide(color: Colors.green),
        ),
        color: Colors.green[300],
        splashColor: Colors.green,
        padding: EdgeInsets.all(12.0),
        child: Text(
          "Instant Pay",
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  QRScan(),
            ),
          );
        },
      ),
    );
  }

// map button widget
  Widget mapButton() {
    return RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
        side: BorderSide(color: Colors.white),
      ),
      color: Colors.transparent,
      splashColor: Colors.blue,
      elevation: 0,
      padding: EdgeInsets.all(12.0),
      child: Text(
        "Show Map",
        style: TextStyle(
          fontSize: 18,
          color: Colors.white,
        ),
      ),
      onPressed: () {
        if (destination != "" && source != "") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ShowMap(source: source, destination: destination),
            ),
          );
        }
      },
    );
  }

// search bus button
  Widget searchBusButton() {
    return RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
        side: BorderSide(color: Colors.white),
      ),
      color: Colors.transparent,
      splashColor: Colors.blue,
      padding: EdgeInsets.all(12.0),
      child: Text(
        "Search Bus",
        style: TextStyle(
          fontSize: 18,
          color: Colors.white,
        ),
      ),
      onPressed: () {
        if (destination != "" && source != "") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ListBus(source: source, destination: destination),
            ),
          );
        }
      },
    );
  }

// source textField
  Widget sourceTextField(icon, label) {
    return TextFormField(
      decoration: InputDecoration(
        icon: Icon(
          icon,
          color: Colors.white,
          size: 28,
        ),
        labelText: label,
        labelStyle: TextStyle(
          color: Colors.white70,
          fontSize: 18,
        ),
      ),
      style: TextStyle(
        fontSize: 24,
        color: Colors.white,
      ),
      onChanged: (value) {
        source = value;
      },
    );
  }

// destinationTextField widget
  Widget destinationTextField(icon, label) {
    return TextFormField(
      decoration: InputDecoration(
        icon: Icon(
          icon,
          color: Colors.white,
          size: 28,
        ),
        labelText: label,
        labelStyle: TextStyle(
          color: Colors.white70,
          fontSize: 18,
        ),
      ),
      style: TextStyle(
        fontSize: 24,
        color: Colors.white,
      ),
      onChanged: (value) {
        destination = value;
      },
    );
  }

// background image
  Widget backgroundImage() {
    return Positioned.fill(
      child: Image.asset(
        image,
        fit: BoxFit.none,
        alignment: Alignment.bottomLeft,
      ),
    );
  }

// appbar widget
  Widget appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: Text(
        "DigiBus",
        style: TextStyle(
          fontSize: 36,
          fontFamily: 'serif',
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
