import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FarmProvider extends ChangeNotifier {
  String _farmId = "";
  bool _isConnected = false;

  String get farmId => _farmId;
  bool get isConnected => _isConnected;

  // Initialize FarmProvider and load saved farm ID if available
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _farmId = prefs.getString('farmId') ?? "";
    _isConnected = _farmId.isNotEmpty;
    notifyListeners();
  }

  // Set farm ID and save to SharedPreferences for persistence
  Future<void> setFarmId(String farmId) async {
    _farmId = farmId;
    _isConnected = farmId.isNotEmpty;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('farmId', farmId);

    notifyListeners();
  }

  // Disconnect and clear farm ID
  Future<void> disconnect() async {
    _farmId = "";
    _isConnected = false;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('farmId');

    notifyListeners();
  }
}
