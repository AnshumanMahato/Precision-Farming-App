import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class InputForm extends StatefulWidget {
  const InputForm({super.key});

  @override
  _InputFormState createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> {
  // Form key to access the form and validate
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _showResults = false;
  List<dynamic> _cropPredictions = [];

  // Controllers for the text fields
  final TextEditingController _nitrogenController = TextEditingController();
  final TextEditingController _phosphorusController = TextEditingController();
  final TextEditingController _potassiumController = TextEditingController();
  final TextEditingController _temperatureController = TextEditingController();
  final TextEditingController _humidityController = TextEditingController();
  final TextEditingController _phController = TextEditingController();
  final TextEditingController _rainfallController = TextEditingController();

  // Function to get the values from the form.
  Map<String, dynamic> get formValues {
    return {
      'N': double.parse(_nitrogenController.text),
      'P': double.parse(_phosphorusController.text),
      'K': double.parse(_potassiumController.text),
      'temperature': double.parse(_temperatureController.text),
      'humidity': double.parse(_humidityController.text),
      'ph': double.parse(_phController.text),
      'rainfall': double.parse(_rainfallController.text),
    };
  }

  // Function to submit data to API
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Replace with your actual API endpoint
        final response = await http.post(
          Uri.parse('http://192.168.1.35:5000/api/farm/crop-prediction'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(formValues),
        );

        setState(() {
          _isLoading = false;
        });

        if (response.statusCode == 200 || response.statusCode == 201) {
          // Successfully processed the request
          final responseData = jsonDecode(response.body);
          //logging the response for debugging
          print('Response data: $responseData');
          if (responseData.containsKey('predictions')) {
            setState(() {
              _cropPredictions = responseData['predictions'];
              _showResults = true;
            });
          } else {
            _showErrorDialog('Invalid response format from server');
          }
        } else {
          // Server returned an error
          _showErrorDialog('Server error: ${response.statusCode}');
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        _showErrorDialog('Connection error: $e');
      }
    }
  }

  // Function to show error dialog
  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Function to clear all the text fields and reset form
  void _clearForm() {
    _nitrogenController.clear();
    _phosphorusController.clear();
    _potassiumController.clear();
    _temperatureController.clear();
    _humidityController.clear();
    _phController.clear();
    _rainfallController.clear();
    // Reset the form state to clear any validation errors
    _formKey.currentState?.reset();
    setState(() {}); // Trigger a rebuild to update the UI
  }

  // Function to reset to form view
  void _resetToForm() {
    setState(() {
      _showResults = false;
      _cropPredictions = [];
      _clearForm();
    });
  }

  @override
  void dispose() {
    // Dispose the controllers when they are no longer needed.
    _nitrogenController.dispose();
    _phosphorusController.dispose();
    _potassiumController.dispose();
    _temperatureController.dispose();
    _humidityController.dispose();
    _phController.dispose();
    _rainfallController.dispose();
    super.dispose();
  }

  // Get a color based on the probability value
  Color _getProbabilityColor(double probability) {
    if (probability > 0.8) return Colors.green[700]!;
    if (probability > 0.6) return Colors.green[400]!;
    if (probability > 0.4) return Colors.orange[400]!;
    if (probability > 0.2) return Colors.orange[700]!;
    return Colors.red[400]!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            _showResults ? 'Crop Recommendations' : 'Get Crop Recommendation'),
        centerTitle: true,
      ),
      body: _showResults ? _buildResultsView() : _buildFormView(),
    );
  }

  // Build the form input view
  Widget _buildFormView() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 20.0),

              // Nitrogen input field
              TextFormField(
                controller: _nitrogenController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Nitrogen (N)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.agriculture),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter nitrogen value';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Invalid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12.0),

              // Phosphorus input field
              TextFormField(
                controller: _phosphorusController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Phosphorus (P)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.agriculture),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter phosphorus value';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Invalid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12.0),

              // Potassium input field
              TextFormField(
                controller: _potassiumController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Potassium (K)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.agriculture),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter potassium value';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Invalid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12.0),

              // Temperature input field
              TextFormField(
                controller: _temperatureController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Temperature (°C)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.thermostat),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter temperature';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Invalid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12.0),

              // Humidity input field
              TextFormField(
                controller: _humidityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Humidity (%)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.water_drop),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter humidity';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Invalid number';
                  }
                  if (double.parse(value) < 0 || double.parse(value) > 100) {
                    return 'Humidity must be between 0 and 100';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12.0),

              // pH input field
              TextFormField(
                controller: _phController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'pH',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.science),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter pH value';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Invalid number';
                  }
                  if (double.parse(value) < 0 || double.parse(value) > 14) {
                    return 'pH must be between 0 and 14';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12.0),

              // Rainfall input field
              TextFormField(
                controller: _rainfallController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Rainfall (mm)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.umbrella),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter rainfall value';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Invalid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),

              // Submit and Clear buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: _isLoading ? null : _submitForm,
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : const Text('Submit'),
                  ),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _clearForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey, // Set background color
                    ),
                    child: const Text('Clear'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Build the results view with cards
  Widget _buildResultsView() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Crop predictions
          Expanded(
            child: ListView.builder(
              itemCount: _cropPredictions.length,
              itemBuilder: (context, index) {
                final crop = _cropPredictions[index]['crop'];
                final probability = double.parse(
                    _cropPredictions[index]['probability'].toString());

                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: _getProbabilityColor(probability),
                      width: 2,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.grass, size: 28),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                crop.toString(),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: LinearProgressIndicator(
                                  value: probability,
                                  minHeight: 16,
                                  backgroundColor: Colors.grey[200],
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    _getProbabilityColor(probability),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${(probability * 100).toStringAsFixed(1)}%',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: _getProbabilityColor(probability),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // New prediction button
          ElevatedButton.icon(
            onPressed: _resetToForm,
            icon: const Icon(Icons.refresh),
            label: const Text('Get New Prediction'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build soil parameter chips
  Widget _buildSoilParameter(String label, String value) {
    return Chip(
      label: Text(
        '$label: $value',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.green[50],
    );
  }
}
