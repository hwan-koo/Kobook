import 'package:shared_preferences/shared_preferences.dart';

class VoiceSettingRepository {
  static const String speed = "voiceSpeed";
  static const String emotion = "voiceEmotion";
  static const String gender = "voiceGender";

  final SharedPreferences _preferences;

  VoiceSettingRepository(this._preferences);

  Future<void> setSpeed(int value) async {
    _preferences.setInt(speed, value);
  }

  Future<void> setEmotion(int value) async {
    _preferences.setInt(emotion, value);
  }

  Future<void> setGender(int value) async {
    _preferences.setInt(gender, value);
  }

  int getSpeed() {
    return _preferences.getInt(speed) ?? 0;
  }

  int getEmotion() {
    return _preferences.getInt(emotion) ?? 0;
  }

  int getGender() {
    return _preferences.getInt(gender) ?? 0;
  }
}
