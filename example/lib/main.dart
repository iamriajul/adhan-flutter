import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';

import 'package:adhan_flutter/adhan_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Address: Jagati, Kushtia, Bangladesh
  final latitude = 22.631100;
  final longitude = 88.102110;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Container(
          padding: EdgeInsets.all(16),
          child: Center(
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 16),
                  child: Text("Today's Fajr Prayer Time", style: TextStyle(
                    fontSize: 22
                  ),),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FutureBuilder(
                    future: getTodayFajrTime(),
                    builder: (context, AsyncSnapshot<DateTime> snapshot) {
                      if (snapshot.hasData) {
                        final dateTime = snapshot.data.toLocal();
                        return Text(DateFormat.jm().format(dateTime), style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold
                        ),);
                      } else if (snapshot.hasError) {
                        return Text(snapshot.error.toString());
                      } else {
                        return Text('Waiting...');
                      }
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 16),
                  child: Text("Current Prayer", style: TextStyle(
                      fontSize: 22
                  ),),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FutureBuilder(
                    future: getCurrentPrayer(),
                    builder: (context, AsyncSnapshot<Prayer> snapshot) {
                      if (snapshot.hasData) {
                        final prayer = snapshot.data;
                        return Text(prayer.toString(), style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold
                        ),);
                      } else if (snapshot.hasError) {
                        return Text(snapshot.error.toString());
                      } else {
                        return Text('Waiting...');
                      }
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 16),
                  child: Text("Next Prayer", style: TextStyle(
                      fontSize: 22
                  ),),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FutureBuilder(
                    future: getNextPrayer(),
                    builder: (context, AsyncSnapshot<Prayer> snapshot) {
                      if (snapshot.hasData) {
                        final prayer = snapshot.data;
                        return Text(prayer.toString(), style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold
                        ),);
                      } else if (snapshot.hasError) {
                        return Text(snapshot.error.toString());
                      } else {
                        return Text('Waiting...');
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<DateTime> getTodayFajrTime() async {
    final adhan = AdhanFlutter.create(Coordinates(latitude, longitude), DateTime.now(), CalculationMethod.KARACHI);
    return await adhan.fajr;
  }

  Future<Prayer> getCurrentPrayer() async {
    final adhan = AdhanFlutter.create(Coordinates(latitude, longitude), DateTime.now(), CalculationMethod.KARACHI);
    return await adhan.currentPrayer();
  }

  Future<Prayer> getNextPrayer() async {
    final adhan = AdhanFlutter.create(Coordinates(latitude, longitude), DateTime.now(), CalculationMethod.KARACHI);
    return await adhan.nextPrayer();
  }
}
