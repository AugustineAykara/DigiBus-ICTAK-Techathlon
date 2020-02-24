import 'package:flutter/material.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class QRScan extends StatefulWidget {
  @override
  _QRScanState createState() => _QRScanState();
}

class _QRScanState extends State<QRScan> {
  String barcode = 'Scan the QR Code for instant payment';

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0f4c65),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            AlertDialog(
              backgroundColor: Colors.teal[700],
              title: Text(
                "$barcode",
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w400),
              ),
            ),
            scanButton(),
          ],
        ),
      ),
    );
  }

  Future _scan() async {
    String barcode = await scanner.scan();
    setState(() {
      this.barcode = barcode;
    });
  }

  Widget scanButton() {
    return RaisedButton(
      onPressed: _scan,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
        side: BorderSide(color: Colors.white),
      ),
      color: Colors.green[300],
      splashColor: Colors.green,
      padding: EdgeInsets.all(14.0),
      child: Text(
        "     Scan     ",
        style: TextStyle(
            fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
      ),
    );
  }
}
