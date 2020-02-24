import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LiveLocation(),
    );
  }
}

class LiveLocation extends StatefulWidget {
  final List destinationLocation;
  LiveLocation({Key key, this.destinationLocation}) : super(key: key);
  @override
  _LiveLocationState createState() => _LiveLocationState();
}

class _LiveLocationState extends State<LiveLocation> {
  String currentStatus = "";
  int ticketCount = 0;
  var busStatus = Firestore.instance.collection('busStatus');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
            child: StreamBuilder(
          stream:
              Firestore.instance.collection('busStatus').document().snapshots(),
          builder: (context, snapshot) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    currentLocationQ("Current Location :"),
                    currentLocationA(currentStatus),
                  ],
                ),
                for (var location in widget.destinationLocation)
                  locationButton(location, snapshot)
              ],
            );
          },
        )),
      ),
    );
  }

// Text Style
  Widget currentLocationQ(text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget currentLocationA(
    text,
  ) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.green,
      ),
    );
  }

// location button
  Widget locationButton(location, snapshot) {
    return FlatButton(
      splashColor: Colors.lightGreen,
      highlightColor: Colors.green,
      padding: EdgeInsets.all(12),
      shape: RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(18.0),
        side: BorderSide(
          color: Colors.black,
        ),
      ),
      child: Text(
        location,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      onPressed: () {
// get ticketCount value and add it with available seats then delete that document
        busStatus.document(location).get().then((DocumentSnapshot ds) {
          busStatus.document('availableSeats').updateData({
            'availableSeats': FieldValue.increment(ds.data['ticketCount']),
          });
          busStatus.document(location).delete();
        });

// get current location
        busStatus.document('currentLocation').setData({
          'currentLocation': location,
        });

        setState(() {
          currentStatus = location;
        });
      },
    );
  }
}
