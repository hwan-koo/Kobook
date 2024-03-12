import 'dart:async';
import 'dart:convert';
import 'package:crepas/apiPaths.dart';
import 'package:crepas/tale/makingTime_view_model.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaleProvider extends AsyncNotifier<Map<String, dynamic>> {
  Map<String, dynamic> tales = {};
  @override
  // build 안에서 API 호출, 데이터를 반환하면 그 데이터를 Provider가 expose
  FutureOr<Map<String, dynamic>> build() async {
    return await fetchTale();
  }

  Future<Map<String, dynamic>> fetchTale() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      try {
        final String? value = prefs.getString('jwt');
        var headersList = {
          'Authorization': "Bearer $value",
        };
        var url = Uri.parse(fetchTaleURL);

        var req = http.Request('GET', url);
        req.headers.addAll(headersList);

        var res = await req.send();
        final resBody = await res.stream.bytesToString();
        print("내 동화 불러오기");
        tales = jsonDecode(resBody);

        if (res.statusCode >= 200 && res.statusCode < 300) {
        } else {}
      } catch (e) {
        final value = await FirebaseAuth.instance.currentUser!.getIdToken();
        await prefs.setString('jwt', value!);
        var headersList = {
          'Authorization': "Bearer $value",
        };
        var url = Uri.parse(fetchTaleURL);

        var req = http.Request('GET', url);
        req.headers.addAll(headersList);

        var res = await req.send();
        final resBody = await res.stream.bytesToString();
        print("내 동화 불러오기");
        tales = jsonDecode(resBody);

        if (res.statusCode >= 200 && res.statusCode < 300) {
        } else {}
      }

      return tales;
    });
    return tales;
  }

  Future<void> removeTale(String timestamp) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      try {
        final String? value = prefs.getString('jwt');
        var headersList = {
          'Authorization': "Bearer $value",
          'Content-Type': 'application/json'
        };
        var url = Uri.parse(removeTaleURL);

// datetime type: str!!!
        var body = {"datetime": timestamp};

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
      } catch (e) {
        final value = await FirebaseAuth.instance.currentUser!.getIdToken();
        await prefs.setString('jwt', value!);

        var headersList = {
          'Authorization': "Bearer $value",
          'Content-Type': 'application/json'
        };
        var url = Uri.parse(removeTaleURL);

// datetime type: str!!!
        var body = {"datetime": timestamp};

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
      }

      return fetchTale();
    });
  }

  Future generateTale(data) async {
    FirebaseAnalytics.instance.logEvent(name: "TaleGeneration");
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      try {
        final String? value = prefs.getString('jwt');

        var headersList = {
          'Authorization': "Bearer $value",
          'Content-Type': 'application/json'
        };
        var url = Uri.parse(makeTaleURL);

        var body = data;

        var req = http.Request('POST', url);
        req.headers.addAll(headersList);
        req.body = json.encode(body);

        var res = await req.send();
        final resBody = await res.stream.bytesToString();
        final waiting = jsonDecode(resBody);
        if (res.statusCode >= 200 && res.statusCode < 300) {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('book_waiting', waiting['waiting_num']);
          DateTime dt = DateTime.now();
          DateTime dateTime =
              dt.add(Duration(minutes: 5 * int.parse(waiting['waiting_num'])));
          String formatDate = DateFormat('HH : mm').format(dateTime);
          ref.read(makingTimeProvider.notifier).setMakingTime(formatDate);
        } else {}
      } catch (e) {
        final value = await FirebaseAuth.instance.currentUser!.getIdToken();
        await prefs.setString('jwt', value!);

        var headersList = {
          'Authorization': "Bearer $value",
          'Content-Type': 'application/json'
        };
        var url = Uri.parse(makeTaleURL);

        var body = data;

        var req = http.Request('POST', url);
        req.headers.addAll(headersList);
        req.body = json.encode(body);

        var res = await req.send();
        final resBody = await res.stream.bytesToString();
        final waiting = jsonDecode(resBody);
        if (res.statusCode >= 200 && res.statusCode < 300) {
          DateTime dt = DateTime.now();
          DateTime dateTime =
              dt.add(Duration(minutes: 5 * int.parse(waiting['waiting_num'])));
          String formatDate = DateFormat('HH:mm').format(dateTime);
          ref.read(makingTimeProvider.notifier).setMakingTime(formatDate);
        } else {}
      }
      return await fetchTale();
    });
    return await fetchTale();
  }
}

final taleProviderModel =
    AsyncNotifierProvider<TaleProvider, Map<String, dynamic>>(
  () => TaleProvider(),
);
