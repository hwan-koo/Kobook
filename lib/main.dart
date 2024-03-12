import 'package:crepas/firebase_options.dart';
import 'package:crepas/profile/playingStatus.dart';
import 'package:crepas/profile/setting_repo.dart';
import 'package:crepas/profile/setting_view_model.dart';
import 'package:crepas/profile/voice_repo.dart';
import 'package:crepas/profile/voice_setting_view_model.dart';
import 'package:crepas/router.dart';
import 'package:crepas/tale/makingTime_repo.dart';
import 'package:crepas/tale/makingTime_view_model.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk_share/kakao_flutter_sdk_share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import 'generated/l10n.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  KakaoSdk.init(
    nativeAppKey: "24d553ca4c271d8dc78c00d7e7e63a16",
    javaScriptAppKey: 'be825d6263e2825de7f04e98a5d3ffa5',
  );
  final preferences = await SharedPreferences.getInstance();
  final repository = PlaybackConfigRepository(preferences);
  final timeRepository = MakingTimeRepository(preferences);
  final voiceRepository = VoiceSettingRepository(preferences);
  final playingStatusRepository = PlayingStatusRepository(preferences);

  runApp(ProviderScope(overrides: [
    playbackConfigProvider
        .overrideWith(() => PlaybackConfigViewModel(repository)),
    makingTimeProvider.overrideWith(() => MakingTimeViewModel(timeRepository)),
    playingStatusProvider
        .overrideWith(() => PlayingStatusViewModel(playingStatusRepository)),
    voiceSettingProvider
        .overrideWith(() => VoiceSettingViewModel(voiceRepository))
  ], child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      routerConfig: ref.watch(router),
      localizationsDelegates: const [
        S.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate
      ],
      supportedLocales: const [Locale("en"), Locale("ko")],
      title: "꼬북",
      theme: ThemeData(fontFamily: "Pretentard"),
      debugShowCheckedModeBanner: false,
    );
  }
}
