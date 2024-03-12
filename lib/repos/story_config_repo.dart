//데이터 유지와 데이터 읽는 것만 책임지는 파일

import 'package:shared_preferences/shared_preferences.dart';

class StoryConfigRepository {
  static const String _story = "test";
  static const String _thema = "test1";
  static const List<String> _imaginePlus = ["test2"];
  static const String _age = "3";
  static const String _name = "test4";
  static const String _faceUrl = "test5";
  static const String _paintingStyle = "test6";
  static const String _cloth = "test7";

  final SharedPreferences _preferences;

  StoryConfigRepository(this._preferences);

  Future<void> setStory(String story) async {
    _preferences.setString(_story, story);
  }

  Future<void> setThema(String thema) async {
    _preferences.setString(_thema, thema);
  }

  Future<void> setImaginePlus(List<String> imaginePlus) async {
    _preferences.setStringList(_imaginePlus as String, imaginePlus);
  }

  Future<void> setage(String age) async {
    _preferences.setString(_age, age);
  }

  Future<void> setName(String name) async {
    _preferences.setString(_name, name);
  }

  Future<void> setFaceUrl(String faceUrl) async {
    _preferences.setString(_faceUrl, faceUrl);
  }

  Future<void> setPaintingStyle(String paintingStyle) async {
    _preferences.setString(_paintingStyle, paintingStyle);
  }

  Future<void> setCloth(String cloth) async {
    _preferences.setString(_cloth, cloth);
  }

  String isStory() => _preferences.getString(_story) ?? "";
  String isThema() => _preferences.getString(_thema) ?? "";
  String isAge() => _preferences.getString(_age) ?? "";
  String isName() => _preferences.getString(_name) ?? "";
  String isFaceUrl() => _preferences.getString(_faceUrl) ?? "";
  String isPaintingStyle() => _preferences.getString(_paintingStyle) ?? "";
  String isCloth() => _preferences.getString(_cloth) ?? "";
  List<String> isImaginePlus() =>
      _preferences.getStringList(_imaginePlus as String) ?? [""];
}
