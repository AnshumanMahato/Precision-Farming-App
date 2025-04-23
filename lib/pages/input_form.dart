import 'package:flutter/material.dart';

class InputForm extends StatefulWidget {
  const InputForm({super.key});

  @override
  _InputFormState createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> {
  // Form key to access the form and validate
  final _formKey = GlobalKey<FormState>();

  // Controllers for the text fields
  final TextEditingController _nitrogenController = TextEditingController();
  final TextEditingController _phosphorusController = TextEditingController();
  final TextEditingController _potassiumController = TextEditingController();
  final TextEditingController _temperatureController = TextEditingController();
  final TextEditingController _humidityController = TextEditingController();
  final TextEditingController _phController = TextEditingController();
  final TextEditingController _rainfallController = TextEditingController();

  // Function to get the values from the form.
  Map<String, String> get formValues {
    return {
      'nitrogen': _nitrogenController.text,
      'phosphorus': _phosphorusController.text,
      'potassium': _potassiumController.text,
      'temperature': _temperatureController.text,
      'humidity': _humidityController.text,
      'ph': _phController.text,
      'rainfall': _rainfallController.text,
    };
  }

  // Function to clear all the text fields and reset dropdowns
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Input Form'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 2.0),
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
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Process the data (e.g., send to a server, display in a dialog)
                          Map<String, String> data = formValues;
                          print('Form Data: $data'); // Print to console
                          // Show a dialog with the data
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Form Data'),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: data.entries.map((entry) {
                                      return Text(
                                          '${entry.key}: ${entry.value}');
                                    }).toList(),
                                  ),
                                ),
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
                      },
                      child: const Text('Submit'),
                    ),
                    ElevatedButton(
                      onPressed: _clearForm,
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
      ),
    );
  }
}
