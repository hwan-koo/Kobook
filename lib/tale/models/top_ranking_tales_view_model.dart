import 'dart:async';
import 'dart:convert';
import 'package:crepas/apiPaths.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RankingTaleProvider extends AsyncNotifier<Map<String, dynamic>> {
  Map<String, dynamic> tales = {};
  @override
  // build 안에서 API 호출, 데이터를 반환하면 그 데이터를 Provider가 expose
  FutureOr<Map<String, dynamic>> build() async {
    return await fetchrankingTale();
  }

  Future<Map<String, dynamic>> fetchrankingTale() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      try {
        final String? value = prefs.getString('jwt');
        var headersList = {
          'Authorization': "Bearer $value",
        };
        var url = Uri.parse(rankingBooks);

        var req = http.Request('GET', url);

        req.headers.addAll(headersList);

        var res = await req.send();
        final resBody = await res.stream.bytesToString();
        tales = jsonDecode(resBody);
        print("랭킹 동화 불러오기");

        if (res.statusCode >= 200 && res.statusCode < 300) {
        } else {}
      } catch (e) {
        final value = await FirebaseAuth.instance.currentUser!.getIdToken();
        await prefs.setString('jwt', value!);

        var headersList = {
          'Authorization': "Bearer $value",
        };
        var url = Uri.parse(rankingBooks);

        var req = http.Request('GET', url);
        req.headers.addAll(headersList);

        var res = await req.send();
        final resBody = await res.stream.bytesToString();
        print("랭킹 동화 불러오기");
        tales = jsonDecode(resBody);

        if (res.statusCode >= 200 && res.statusCode < 300) {
        } else {}
      }

      return tales;
    });
    return tales;
  }
}

final rankingTaleProviderModel =
    AsyncNotifierProvider<RankingTaleProvider, Map<String, dynamic>>(
  () => RankingTaleProvider(),
);
