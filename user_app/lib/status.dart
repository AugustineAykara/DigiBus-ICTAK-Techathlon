import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:async/async.dart';

class StatusScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BusStatus(),
    );
  }
}

class BusStatus extends StatefulWidget {
  @override
  _BusStatusState createState() => _BusStatusState();
}

class _BusStatusState extends State<BusStatus> {
  int availableSeats;
  int totalSeats;
  String currentLocation;
  var busStatus = Firestore.instance.collection('busStatus');

  @override
  Widget build(BuildContext context) {
    Stream<DocumentSnapshot> stream1 =
        busStatus.document('availableSeats').snapshots();
    Stream<DocumentSnapshot> stream2 =
        busStatus.document('totalSeats').snapshots();
    Stream<DocumentSnapshot> stream3 =
        busStatus.document('currentLocation').snapshots();
    StreamZip bothStreams = StreamZip([stream1, stream2, stream3]);

    return Scaffold(
      appBar: appBar(),
      backgroundColor: Color(0xff1b262c),
      body: StreamBuilder(
        stream: bothStreams,
        builder: (context, snapshot) {
          availableSeats = snapshot.data[0].data['availableSeats'];
          totalSeats = snapshot.data[1].data['totalSeats'];
          currentLocation = snapshot.data[2].data['currentLocation'];

          if (!snapshot.hasData)
            return new Center(child: Text("Loading..."));
          else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                status(Icons.directions_bus, 'Bus Name', 'DigiBus'),
                status(Icons.place, 'Current Location', currentLocation),
                status(Icons.event_seat, 'Available Number of Seats',
                    availableSeats),
                status(Icons.airline_seat_recline_normal,
                    'Total Number of Seats', totalSeats),
                status(
                    Icons.access_time, 'Time to reach your location', "10 min"),
              ],
            );
          }
        },
      ),
    );
  }

// status card
  Widget status(icon, statusQ, statusAns) {
    return Card(
      color: Color(0xff0f4c75),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 6,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        leading: Icon(icon, color: Colors.white, size: 36),
        title: Row(
          children: <Widget>[
            Icon(Icons.play_arrow, color: Colors.yellowAccent),
            Text(
              statusAns.toString(),
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ],
        ),
        subtitle: Text(
          statusQ,
          style: TextStyle(color: Colors.white),
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
        "DigiBus Status",
        style: TextStyle(
          fontSize: 24,
          fontFamily: 'serif',
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.refresh,size: 32,),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => BusStatus(),
              ),
            );
          },
        ),
      ],
    );
  }
}
