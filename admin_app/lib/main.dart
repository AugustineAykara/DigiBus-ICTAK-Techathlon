import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'location.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter ICT Admin App',
      theme: ThemeData(
          // primarySwatch: Colors.blue,
          ),
      home: MyHomePage(),
      routes: <String, WidgetBuilder>{
        "/location.dart": (BuildContext context) => LiveLocation(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List destination = [
    'Kottayam',
    'Ettumanoor',
    'Kaduthuruthy',
    'Vaikkom',
    'Thrippunithura',
    'Vytilla Hub',
    'Ernakulam'
  ];
  String selectedLocation;
  int counter = 1;
  int totalSeats = 50;
  int availableSeats = 50;

  var busStatus = Firestore.instance.collection('busStatus');

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        floatingActionButton: floatingActionButton(),
        body: Container(
          margin: new EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              passengerDestination(),
              Column(
                children: <Widget>[
                  textTitle("Total Seats", 18.0),
                  editableTotalSeat(),
                ],
              ),
              Column(
                children: <Widget>[
                  textTitle("Number of Tickets", 22.0),
                  numberOfTickets(),
                ],
              ),
              getTicket(),
            ],
          ),
        ),
      ),
    );
  }

// FLoating action button widget
  Widget floatingActionButton() {
    return FloatingActionButton(
      backgroundColor: Colors.black,
      mini: true,
      child: Icon(
        Icons.location_searching,
      ),
      onPressed: () {
        Navigator.push(
          context,
          new MaterialPageRoute(
            builder: (context) => LiveLocation(
              destinationLocation: destination,
            ),
          ),
        );
      },
    );
  }

// Dropdown menu for destination selection
  Widget passengerDestination() {
    return ListTile(
      leading: Icon(
        Icons.location_on,
        color: Colors.black,
        size: 48,
      ),
      title: DropdownButton(
        isExpanded: true,
        hint: Text("Select Destination"),
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        value: selectedLocation,
        underline: SizedBox(),
        iconEnabledColor: Colors.black,
        iconSize: 42,
        focusColor: Colors.green,
        onChanged: (value) {
          setState(() {
            selectedLocation = value;
          });
        },
        items: destination.map((value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

// Number of tickets count
  Widget numberOfTickets() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        FloatingActionButton(
          heroTag: null,
          backgroundColor: Colors.red,
          splashColor: Colors.redAccent,
          onPressed: () {
            setState(() {
              if (counter == 0)
                counter = 0;
              else
                counter--;
            });
          },
          child: Icon(
            Icons.exposure_neg_1,
            color: Colors.black,
          ),
        ),
        Text(
          counter.toString(),
          style: TextStyle(
            fontSize: 52,
            fontWeight: FontWeight.bold,
          ),
        ),
        FloatingActionButton(
          heroTag: null,
          backgroundColor: Colors.green,
          splashColor: Colors.greenAccent,
          onPressed: () {
            setState(() {
              counter++;
            });
          },
          child: Icon(
            Icons.exposure_plus_1,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

// Text title style
  Widget textTitle(text, size) {
    return Text(
      text,
      style: TextStyle(
        fontSize: size,
        fontWeight: FontWeight.bold,
      ),
    );
  }

// Total seats textfield
  Widget editableTotalSeat() {
    return Container(
      decoration: new BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.grey,
        border: new Border.all(
          color: Colors.black,
          width: 1.5,
        ),
      ),
      width: 60,
      child: TextFormField(
        keyboardType: TextInputType.number,
        initialValue: totalSeats.toString(),
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        onChanged: (value) {
          setState(() {
            totalSeats = int.parse(value);
            availableSeats = totalSeats;
          });
          busStatus.document('totalSeats').setData({
            'totalSeats': totalSeats,
          });
          busStatus.document('availableSeats').updateData({
            'availableSeats': availableSeats,
          });
        },
      ),
    );
  }

// Get ticket button
  Widget getTicket() {
    return FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(18.0),
          side: BorderSide(
            color: Colors.green,
          ),
        ),
        child: Text(
          "GENERATE TICKET",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        splashColor: Colors.lightGreen,
        highlightColor: Colors.green,
        padding: EdgeInsets.all(16),
        onPressed: () async {
          var snapshot = await busStatus.document(selectedLocation).get();
          if (snapshot == null || !snapshot.exists) {
            busStatus.document(selectedLocation).setData({
              'ticketCount': FieldValue.increment(counter),
            });
          } else {
            busStatus.document(selectedLocation).updateData({
              'ticketCount': FieldValue.increment(counter),
            });
          }

          busStatus.document('availableSeats').updateData({
            'availableSeats': FieldValue.increment(-counter),
          });

          setState(() {
            counter = 1;
          });

          showDialog(
            context: context,
            child: AlertDialog(
              title: QrImage(
                data: 'your payment has been transferred successfully',
                version: QrVersions.auto,
                gapless: true,
              ),
              content: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Icon(
                    Icons.check_circle,
                    size: 56,
                    color: Colors.green,
                  ),
                  RaisedButton(
                    color: Colors.green,
                    splashColor: Colors.greenAccent,
                    highlightColor: Colors.green,
                    padding: EdgeInsets.all(12),
                    child: Text(
                      "Done",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            ),
          );
        });
  }
}
