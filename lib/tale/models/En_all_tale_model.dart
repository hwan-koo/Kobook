import 'dart:async';
import 'dart:convert';
import 'package:crepas/apiPaths.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllTaleProviderEn extends AsyncNotifier<Map<String, dynamic>> {
  Map<String, dynamic> tales = {};
  @override
  // build 안에서 API 호출, 데이터를 반환하면 그 데이터를 Provider가 expose
  FutureOr<Map<String, dynamic>> build() async {
    return await fetchAllTaleEn();
  }

  Future<Map<String, dynamic>> fetchAllTaleEn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      try {
        final String? value = prefs.getString('jwt');
        var headersList = {
          'Authorization': "Bearer $value",
        };
        var url = Uri.parse(fetchAllTaleURL);

        var body = {"ver": "global"};

        var req = http.Request('GET', url);
        req.body = json.encode(body);

        req.headers.addAll(headersList);

        var res = await req.send();
        final resBody = await res.stream.bytesToString();
        tales = jsonDecode(resBody);
        print("모든 동화 불러오기");
        print(tales);

        if (res.statusCode >= 200 && res.statusCode < 300) {
        } else {}
      } catch (e) {
        final value = await FirebaseAuth.instance.currentUser!.getIdToken();
        await prefs.setString('jwt', value!);

        var headersList = {
          'Authorization': "Bearer $value",
        };
        var url = Uri.parse(fetchAllTaleURL);
        var body = {"ver": "global"};

        var req = http.Request('GET', url);
        req.headers.addAll(headersList);
        req.body = json.encode(body);

        var res = await req.send();
        final resBody = await res.stream.bytesToString();
        print("모든 동화 불러오기");
        tales = jsonDecode(resBody);
        print(tales);

        if (res.statusCode >= 200 && res.statusCode < 300) {
        } else {}
      }

      return tales;
    });
    return tales;
  }
}

final allTaleProviderModelEn =
    AsyncNotifierProvider<AllTaleProviderEn, Map<String, dynamic>>(
  () => AllTaleProviderEn(),
);
