import 'dart:async';
import 'dart:convert';
import 'package:crepas/apiPaths.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CoinProvider extends AsyncNotifier<int> {
  int coin = 0;
  @override
  // build 안에서 API 호출, 데이터를 반환하면 그 데이터를 Provider가 expose
  FutureOr<int> build() async {
    return await fetchCoin();
  }

  Future<int> fetchCoin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      try {
        final String? value = prefs.getString('jwt');
        var headersList = {
          'Authorization': "Bearer $value",
        };
        var url = Uri.parse(getCoinURL);

        var req = http.Request('GET', url);
        req.headers.addAll(headersList);

        var res = await req.send();
        final resBody = await res.stream.bytesToString();

        if (res.statusCode >= 200 && res.statusCode < 300) {
          final coin = jsonDecode(resBody)["coin_num"];
          print(coin);
          return coin;
        } else {}
      } catch (e) {
        final value = await FirebaseAuth.instance.currentUser!.getIdToken();
        await prefs.setString('jwt', value!);
        var headersList = {
          'Authorization': "Bearer $value",
        };
        var url = Uri.parse(getCoinURL);

        var req = http.Request('GET', url);
        req.headers.addAll(headersList);

        var res = await req.send();
        final resBody = await res.stream.bytesToString();

        if (res.statusCode >= 200 && res.statusCode < 300) {
          final coin = jsonDecode(resBody)["coin_num"];
          print(coin);
          return coin;
        } else {}
      }

      return coin;
    });
    return coin;
  }
}

final coinProviderModel = AsyncNotifierProvider<CoinProvider, int>(
  () => CoinProvider(),
);
