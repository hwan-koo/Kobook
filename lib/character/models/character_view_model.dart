import 'dart:async';
import 'dart:convert';
import 'package:crepas/apiPaths.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CharacterProvider extends AsyncNotifier<Map<String, dynamic>> {
  Map<String, dynamic> character = {};
  @override
  // build 안에서 API 호출, 데이터를 반환하면 그 데이터를 Provider가 expose
  FutureOr<Map<String, dynamic>> build() async {
    return await fetchCharacter();
  }

  Future<Map<String, dynamic>> fetchCharacter() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      try {
        final String? value = prefs.getString('jwt');
        var headersList = {'Authorization': "Bearer $value"};
        var url = Uri.parse(fetchCharacterURL);

        var req = http.Request('GET', url);
        req.headers.addAll(headersList);

        var res = await req.send();
        final resBody = await res.stream.bytesToString();
        character = jsonDecode(resBody);

        if (res.statusCode >= 200 && res.statusCode < 300) {
          print("내 캐릭터 불러오기");
        } else {
          print(res.reasonPhrase);
        }
      } catch (e) {
        final value = await FirebaseAuth.instance.currentUser!.getIdToken();
        await prefs.setString('jwt', value!);
        var headersList = {'Authorization': "Bearer $value"};
        var url = Uri.parse(fetchCharacterURL);

        var req = http.Request('GET', url);
        req.headers.addAll(headersList);

        var res = await req.send();
        final resBody = await res.stream.bytesToString();
        character = jsonDecode(resBody);

        if (res.statusCode >= 200 && res.statusCode < 300) {
          print("내 캐릭터 불러오기");
        } else {
          print(res.reasonPhrase);
        }
      }

      return character;
    });
    return character;
  }

  Future<void> removeCharacter(String timestamp) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final value = await FirebaseAuth.instance.currentUser!.getIdToken();

      var headersList = {
        'Authorization': "Bearer $value",
        'Content-Type': 'application/json'
      };
      var url = Uri.parse(removeCharacterURL);

// datetime type: str!!!
      var body = {"time_stamp": timestamp};

      var req = http.Request('POST', url);
      req.headers.addAll(headersList);
      req.body = json.encode(body);

      var res = await req.send();
      final resBody = await res.stream.bytesToString();
      if (res.statusCode >= 200 && res.statusCode < 300) {
        print(resBody);
      } else {
        print(res.reasonPhrase);
      }

      return await fetchCharacter();
    });
  }

  Future generateCharacter(int selectedImage, String name) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final value = await FirebaseAuth.instance.currentUser!.getIdToken();

      var headersList = {
        'Authorization': "Bearer $value",
        'Content-Type': 'application/json'
      };
      var url = Uri.parse(characterImageUpscaleURL);

      var body = {"index": selectedImage + 1, "name": name};

      var req = http.Request('POST', url);
      req.headers.addAll(headersList);
      req.body = json.encode(body);

      var res = await req.send();
      final resBody = await res.stream.bytesToString();

      if (res.statusCode >= 200 && res.statusCode < 300) {
        print(resBody);
      } else {
        print(res.reasonPhrase);
      }
      return await fetchCharacter();
    });
  }
}

final characterProviderModel =
    AsyncNotifierProvider<CharacterProvider, Map<String, dynamic>>(
  () => CharacterProvider(),
);
