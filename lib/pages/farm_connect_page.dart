// farm_connect_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_agri_app/pages/main_view.dart';
import 'package:provider/provider.dart';
import 'package:flutter_agri_app/providers/farm_provider.dart';

class FarmConnectPage extends StatefulWidget {
  const FarmConnectPage({Key? key}) : super(key: key);

  @override
  _FarmConnectPageState createState() => _FarmConnectPageState();
}

class _FarmConnectPageState extends State<FarmConnectPage> {
  final _formKey = GlobalKey<FormState>();
  final _farmIdController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _farmIdController.dispose();
    super.dispose();
  }

  // Validate and connect to farm
  Future<void> _connectToFarm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // You can add API call here to validate farm ID if needed
      // For this example, we'll just set the farm ID directly
      await Provider.of<FarmProvider>(context, listen: false)
          .setFarmId(_farmIdController.text.trim());

      // Navigate to home page after successful connection
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MainPageNavBottom()),
        );
      }
    } catch (e) {
      // Show error if connection fails
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error connecting: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // App logo or farm image
                  Image.asset(
                    'assets/images/farm_logo.png', // Add your logo image here
                    height: 150,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 32),

                  // App title
                  const Text(
                    'Farm Assistant',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Subtitle
                  const Text(
                    'Connect to your farm to continue',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 48),

                  // Farm ID input form
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          controller: _farmIdController,
                          decoration: InputDecoration(
                            labelText: 'Farm ID',
                            hintText: 'Enter your farm identifier',
                            prefixIcon: const Icon(Icons.agriculture),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.grey[100],
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter a farm ID';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),

                        // Connect button
                        ElevatedButton(
                          onPressed: _isLoading ? null : _connectToFarm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'Connect',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
