import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FarmProvider extends ChangeNotifier {
  static const String _farmIDKey = 'farm_id';
  static const String _moistureMinKey = 'moisture_min';
  static const String _moistureMaxKey = 'moisture_max';

  String _farmID = "";
  int _moistureMin = 30;
  int _moistureMax = 70;

  SharedPreferences? _prefs;

  FarmProvider() {
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    _farmID = _prefs?.getString(_farmIDKey) ?? "";
    _moistureMin = _prefs?.getInt(_moistureMinKey) ?? 30;
    _moistureMax = _prefs?.getInt(_moistureMaxKey) ?? 70;
    notifyListeners();
  }

  Future<void> _saveToPrefs() async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
    await _prefs?.setString(_farmIDKey, _farmID);
    await _prefs?.setInt(_moistureMinKey, _moistureMin);
    await _prefs?.setInt(_moistureMaxKey, _moistureMax);
  }

  String get farmID => _farmID;
  int get moistureMin => _moistureMin;
  int get moistureMax => _moistureMax;

  Future<void> setFarmID(String farmID) async {
    _farmID = farmID;
    await _saveToPrefs();
    notifyListeners();
  }

  void setMoistureThresholds(int min, int max) {
    if (min > max) {
      throw Exception("Minimum moisture cannot be greater than maximum.");
    }
    _moistureMin = min;
    _moistureMax = max;
    _saveToPrefs();
    notifyListeners();
  }
}
