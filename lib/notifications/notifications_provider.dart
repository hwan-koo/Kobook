import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../tale/models/tale_view_model.dart';

class NotificationsProvider extends FamilyAsyncNotifier<void, BuildContext> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> updateToken(String token) async {
    final user = FirebaseAuth.instance.currentUser!;
    // print(await user.getIdToken());
    // print(token);
    await _db.collection("users").doc(user.uid).update({"token": token});

    print("update token $token");
  }

  Future<void> initListeners(BuildContext context) async {
    final permission = await _messaging.requestPermission();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (permission.authorizationStatus == AuthorizationStatus.denied) {
      await prefs.setBool("noti", false);
      return;
    } else {
      prefs.setBool("noti", true);
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage event) async {
      print("메시지는 도착함");
      // context.pushReplacement("/mybook");
      // MotionToast(
      //   icon: Icons.zoom_out,
      //   primaryColor: const Color(0xff468aff),
      //   title: const Text("동화가 완성되었어요!"),
      //   description: const Text("만들어진 동화를 감상해보세요!"),
      //   position: MotionToastPosition.top,
      //   animationType: AnimationType.fromTop,
      // ).show(context);
      await ref.watch(taleProviderModel.notifier).fetchTale();
      //앱이 열려있는 동안 알림을 받는 경우
    });
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      //앱이 백그라운드에 있을 때 알림을 실행한 경우
      context.push("/mybook");
    });
    //앱이 종료되었을 때 알림을 실행한 경우
    final notification = await _messaging.getInitialMessage();
    if (notification != null) {}
  }

  @override
  FutureOr build(BuildContext context) async {
    final token = await _messaging.getToken();
    if (token == null) return;
    await updateToken(token);
    await initListeners(context);
    _messaging.onTokenRefresh.listen((newToken) async {
      await updateToken(newToken);
    });
  }
}

final notificationsProvider = AsyncNotifierProvider.family(
  () => NotificationsProvider(),
);
