import 'package:shared_preferences/shared_preferences.dart';

class MakingTimeRepository {
  static const String _makingTime = "makingTime";

  final SharedPreferences _preferences;

  MakingTimeRepository(this._preferences);

  Future<void> setMakingTime(String dateTime) async {
    _preferences.setString(_makingTime, dateTime);
  }

  String isMakingTime() {
    return _preferences.getString(_makingTime) ?? "";
  }
}
