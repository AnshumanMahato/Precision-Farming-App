import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Documentation: https://docs.flutter.dev/data-and-backend/networking
//Temporary sample below

/* Commented

Future<FarmData> fetchFarmData() async {
 final response = await http
      .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));
      //Replace the above link ^^^

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return FarmData.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load farm data');
  }
}

class FarmData {
  final double temp;
  final double soilmoisture;
  final String daylight;
  final double humidity;

  const FarmData({
    required this.temp,
    required this.soilmoisture,
    required this.daylight,
    required this.humidity
  });

  factory FarmData.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'temp': double temp,
        'soilmoisture': double soilmoisture,
        'daylight': String daylight,
        'humidity': double humidity
      } =>
        FarmData(
          temp: temp,
          soilmoisture: soilmoisture,
          daylight: daylight,
          humidity: humidity
        ),
      _ => throw const FormatException('Failed to load farm data.'),
    };
  }
}

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<FarmData> futureFarmData;

  @override
  void initState() {
    super.initState();
    futureFarmData = fetchFarmData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Fetch Data Example'),
        ),
        body: Center(
          child: FutureBuilder<FarmData>(
            future: futureFarmData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data!.temp.toStringAsFixed(4));
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}

*/