import 'package:shared_preferences/shared_preferences.dart';

class PlaybackConfigRepository {
  static const String _muted = "muted";
  static const String _noti = "noti";

  final SharedPreferences _preferences;

  PlaybackConfigRepository(this._preferences);

  Future<void> setMuted(bool value) async {
    _preferences.setBool(_muted, value);
  }

  bool isMuted() {
    return _preferences.getBool(_muted) ?? false;
  }

  bool isNoti() {
    return _preferences.getBool(_noti) ?? false;
  }
}
