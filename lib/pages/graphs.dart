import 'package:flutter/material.dart';
import 'dart:convert'; // For JSON decoding
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../components/analysis_card.dart'; // Assuming this file contains the AnalysisCard class
import '../providers/farm_provider.dart'; // Assuming this file contains the FarmProvider class

class Graphs extends StatefulWidget {
  const Graphs({super.key});

  @override
  State<Graphs> createState() => _GraphsState();
}

class _GraphsState extends State<Graphs> {
  late List<Map<String, dynamic>> farmData = [];
  String timeRange = "1d";
  bool isLoading = false;

  // Function to fetch data based on time range
  Future<void> fetchData(String farmId, String timeRange) async {
    setState(() {
      isLoading = true;
    });

    final url = Uri.parse(
        'http://192.168.1.35:5000/api/farm/$farmId/analyse?timeslot=$timeRange');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        setState(() {
          farmData = List<Map<String, dynamic>>.from(jsonResponse['farmData']);
        });
        setState(() {
          this.timeRange = timeRange;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print("Error fetching data: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final farmId = Provider.of<FarmProvider>(context, listen: false).farmID;
      if (farmId.isNotEmpty) {
        fetchData(farmId, "1d"); // Default load for "1 day"
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FarmProvider>(builder: (context, farmProvider, child) {
      final farmID = farmProvider.farmID;

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
        appBar: AppBar(
          title: const Text("Farm Analytics"),
        ),
        body: Column(
          children: [
            // Button Row
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => fetchData(farmID, "1d"),
                    style: timeRange == "1d"
                        ? ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[300])
                        : null,
                    child: const Text("1 Day"),
                  ),
                  ElevatedButton(
                    onPressed: () => fetchData(farmID, "7d"),
                    style: timeRange == "7d"
                        ? ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[300])
                        : null,
                    child: const Text("7 Days"),
                  ),
                  ElevatedButton(
                    onPressed: () => fetchData(farmID, "14d"),
                    style: timeRange == "14d"
                        ? ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[300])
                        : null,
                    child: const Text("14 Days"),
                  ),
                  ElevatedButton(
                    onPressed: () => fetchData(farmID, "30d"),
                    style: timeRange == "30"
                        ? ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[300])
                        : null,
                    child: const Text("30 Days"),
                  ),
                ],
              ),
            ),

            // Loading Indicator
            if (isLoading)
              const Center(
                child: CircularProgressIndicator(),
              ),

            // Graph Data
            if (!isLoading)
              Expanded(
                child: GridView.count(
                  padding: const EdgeInsets.all(10),
                  crossAxisCount: 1, // Takes both columns
                  children: [
                    AnalysisCard(
                      farmData: farmData,
                      title: "Temperature",
                      field: "temperature",
                      timeRange: timeRange,
                    ),
                    AnalysisCard(
                      farmData: farmData,
                      title: "Moisture",
                      field: "moisture",
                      timeRange: timeRange,
                    ),
                    AnalysisCard(
                      farmData: farmData,
                      title: "Humidity",
                      field: "humidity",
                      timeRange: timeRange,
                    ),
                  ],
                ),
              ),
          ],
        ),
      );
    });
  }
}
