import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../services/socket_service.dart';
import '../components/pump_control_card.dart';
import '../components/item_dashboard.dart';
import '../components/graph_card.dart';
import '../providers/farm_provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  PumpService pumpSocket = PumpService();
  List<Map<String, dynamic>> farmData = [];
  String pumpStatus = 'OFF';
  Timer? timer;
  DateTime? _lastNotificationTime;

  String? selectedCrop;
  String? selectedStage;
  List<String> cropOptions = ['Wheat', 'Rice', 'Corn', 'Barley', 'Soybean'];
  List<String> stageOptions = ['Seedling', 'Vegetative', 'Flowering'];

  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();

    // Initialize with the current Farm ID
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final farmID = Provider.of<FarmProvider>(context, listen: false).farmID;
      if (farmID.isNotEmpty) {
        initializeWithFarmID(farmID);
      }
    });
  }

  void _initializeNotifications() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void _showNotification(String title, String body) async {
    final now = DateTime.now();

    if (_lastNotificationTime != null &&
        now.difference(_lastNotificationTime!).inSeconds < 60) {
      // Skip notification if last one was shown less than 60 seconds ago
      return;
    }

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'soil_moisture_channel',
      'Soil Moisture Notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      0, // notification id
      title,
      body,
      platformDetails,
    );

    _lastNotificationTime = now; // Update the timestamp
  }

  void initializeWithFarmID(String farmID,
      [int moistureMin = 30, int moistureMax = 70]) {
    if (mounted)
      fetchData(farmID, moistureMin, moistureMax); // Fetch initial data
    pumpSocket.initializeConnection(farmID);
    pumpSocket.startPump = () {
      if (mounted) {
        setState(() {
          pumpStatus = 'ON';
        });
      }
    };
    pumpSocket.stopPump = () {
      if (mounted) {
        setState(() {
          pumpStatus = 'OFF';
        });
      }
    };

    // Cancel existing timer if any
    timer?.cancel();
    // Set up new timer with the Farm ID
    timer = Timer.periodic(const Duration(seconds: 10),
        (timer) => fetchData(farmID, moistureMin, moistureMax));
  }

  @override
  void dispose() {
    timer?.cancel(); // Cancel the timer to avoid memory leaks
    super.dispose();
  }

  Future<void> fetchData(
      String farmID, int moistureMin, int moistureMax) async {
    if (farmID.isEmpty) {
      // Show a message or handle empty Farm ID case
      print('No Farm ID set');
      return;
    }

    final url = Uri.parse('http://192.168.1.35:5000/api/farm/$farmID/data');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        if (mounted) {
          setState(() {
            farmData =
                List<Map<String, dynamic>>.from(decodedResponse['farmData']);
          });

          // Check if the soil moisture is outside the set threshold
          final lastData = farmData.isNotEmpty ? farmData.last : null;
          if (lastData != null) {
            double soilMoisture = double.parse(lastData["moisture"].toString());
            double minThreshold =
                double.parse(moistureMin.toString()); // Example min threshold
            double maxThreshold =
                double.parse(moistureMax.toString()); // Example max threshold

            // Show notification if moisture is outside the threshold
            if (soilMoisture < minThreshold && pumpStatus == 'OFF') {
              _showNotification(
                'Soil Moisture Low',
                'The soil moisture level is below the minimum threshold. You may want to irrigate.',
              );
            } else if (soilMoisture > maxThreshold && pumpStatus == 'ON') {
              _showNotification(
                'Soil Moisture High',
                'The soil moisture level is above the maximum threshold. You may want to stop irrigation.',
              );
            }
          }
        }
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FarmProvider>(builder: (context, farmProvider, child) {
      final farmID = farmProvider.farmID;
      final moistureMin = farmProvider.moistureMin;
      final moistureMax = farmProvider.moistureMax;

      // If Farm ID changes, reinitialize with the new ID
      if (farmID.isNotEmpty) {
        // Add this farmID property to your PumpService class
        WidgetsBinding.instance.addPostFrameCallback((_) {
          initializeWithFarmID(farmID, moistureMin, moistureMax);
        });
      }

      final lastData = farmData.isNotEmpty ? farmData.last : null;

      // If no Farm ID is set, show a message
      if (farmID.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'No Farm ID set',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Implement navigation to settings
                  // or show settings dialog here
                },
                child: const Text('Go to Settings'),
              ),
            ],
          ),
        );
      }

      return Scaffold(
        body: ListView(
          padding: const EdgeInsets.only(top: 0),
          children: [
            Container(
              padding: const EdgeInsets.only(top: 35),
              color: const Color.fromARGB(255, 145, 164, 248),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 157, 239, 241),
                  borderRadius:
                      BorderRadius.only(topLeft: Radius.circular(900)),
                ),
                child: GridView.count(
                  padding: const EdgeInsets.only(bottom: 80),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 40,
                  mainAxisSpacing: 30,
                  children: [
                    itemDashboard(
                      'Temperature',
                      lastData != null ? '${lastData["temperature"]}°C' : '...',
                      CupertinoIcons.thermometer,
                      Colors.deepOrange,
                    ),
                    itemDashboard(
                      'Soil Moisture',
                      lastData != null ? '${lastData["moisture"]}%' : '...',
                      CupertinoIcons.drop,
                      Colors.blue,
                    ),
                    itemDashboard(
                      'Humidity',
                      lastData != null ? '${lastData["humidity"]}%' : '...',
                      CupertinoIcons.wind,
                      Colors.deepPurple,
                    ),
                    pumpControlCard(
                      pumpStatus,
                      () {
                        String event =
                            pumpStatus == 'ON' ? 'stopPump' : 'startPump';
                        pumpSocket.sendData(event, {"farmId": farmID});
                      },
                    ),
                  ],
                ),
              ),
            ),
            GraphCard(
              farmData: farmData,
              title: "Temperature",
              field: "temperature",
              color: Colors.deepOrange,
            ),
            GraphCard(
              farmData: farmData,
              title: "Soil Moisture",
              field: "moisture",
              color: Colors.blue,
            ),
            GraphCard(
              farmData: farmData,
              title: "Humidity",
              field: "humidity",
              color: Colors.deepPurple,
            ),
          ],
        ),
      );
    });
  }
}
