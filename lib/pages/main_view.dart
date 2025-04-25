import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_agri_app/pages/graphs.dart';
import 'package:flutter_agri_app/pages/home_page.dart';
import 'package:flutter_agri_app/pages/input_form.dart';
import 'package:flutter_agri_app/providers/farm_provider.dart';

class MainPageNavBottom extends StatefulWidget {
  const MainPageNavBottom({super.key});

  @override
  State<MainPageNavBottom> createState() => _MainPageNavBottomState();
}

class _MainPageNavBottomState extends State<MainPageNavBottom> {
  int _selectedIndex = 0;
  final pages = [MyHomePage(), Graphs(), InputForm()];
  final ScrollController _homeController = ScrollController();

  // Text controller for the farm ID input
  final TextEditingController _farmIDController = TextEditingController();

  // Function to show the settings dialog with farm ID form
  void _showSettingsDialog() {
    final farmProvider = Provider.of<FarmProvider>(context, listen: false);

    // Set initial values
    _farmIDController.text = farmProvider.farmID;
    final TextEditingController _moistureMinController =
        TextEditingController(text: farmProvider.moistureMin.toString());
    final TextEditingController _moistureMaxController =
        TextEditingController(text: farmProvider.moistureMax.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Settings'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Enter Farm ID:'),
                const SizedBox(height: 8),
                TextField(
                  controller: _farmIDController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Farm ID',
                  ),
                ),
                const SizedBox(height: 20),
                const Text('Set Moisture Thresholds:'),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _moistureMinController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Min',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _moistureMaxController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Max',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final loadingDialog = _showLoadingDialog(context);

                try {
                  // Save farm ID
                  await farmProvider.setFarmID(_farmIDController.text);

                  // Parse moisture thresholds
                  final int min =
                      int.tryParse(_moistureMinController.text) ?? 0;
                  final int max =
                      int.tryParse(_moistureMaxController.text) ?? 100;

                  // This will throw if invalid
                  farmProvider.setMoistureThresholds(min, max);

                  Navigator.of(context).pop(); // Close loading
                  Navigator.of(context).pop(); // Close settings

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Settings saved!')),
                  );
                } catch (e) {
                  Navigator.of(context).pop(); // Close loading

                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text("Invalid Thresholds"),
                      content: Text(e.toString()),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text("OK"),
                        ),
                      ],
                    ),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // Simple loading dialog
  AlertDialog _showLoadingDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          CircularProgressIndicator(),
          Container(
            margin: EdgeInsets.only(left: 15),
            child: Text("Saving..."),
          ),
        ],
      ),
    );

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );

    return alert;
  }

  @override
  void dispose() {
    _farmIDController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FarmProvider>(builder: (context, farmProvider, child) {
      return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: AppBar(
            title: Text(
              'Krishi Asist',
              style: TextStyle(
                  fontSize: 30,
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 3.4
                    ..color = const Color.fromARGB(255, 73, 67, 67)),
              textAlign: TextAlign.center,
            ),
            elevation: 4,
            backgroundColor: const Color.fromARGB(255, 10, 194, 169),
            actions: [
              // Farm ID indicator
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    farmProvider.farmID.isEmpty
                        ? "No Farm ID"
                        : "Farm: ${farmProvider.farmID}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              // Settings button
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: _showSettingsDialog,
                tooltip: 'Settings',
              ),
            ],
          ),
        ),
        body: pages[_selectedIndex],
        bottomNavigationBar: SizedBox(
          height: 70,
          child: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.graph_circle),
                label: 'Analytics',
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.chart_bar_circle),
                label: 'Prediction',
              )
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.amber[800],
            onTap: (int index) {
              switch (index) {
                case 0:
                  // only scroll to top when current index is selected.
                  if (_selectedIndex == index) {
                    _homeController.animateTo(
                      0.0,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeOut,
                    );
                  }
                  break;
                case 1:
                  //showModal(context);
                  break;
              }
              setState(
                () {
                  _selectedIndex = index;
                },
              );
            },
          ),
        ),
      );
    });
  }
}
