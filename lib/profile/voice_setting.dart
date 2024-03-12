import 'package:crepas/profile/voice_setting_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:animated_toggle_switch/animated_toggle_switch.dart';

class VoiceSettingScreen extends ConsumerStatefulWidget {
  final String comeSource;
  const VoiceSettingScreen({super.key, required this.comeSource});

  @override
  VoiceSettingScreenState createState() => VoiceSettingScreenState();
}

class VoiceSettingScreenState extends ConsumerState<VoiceSettingScreen> {
  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {}
    });

    super.initState();
  }

  @override
  void dispose() {
    if (widget.comeSource == "tale") {
      isiOS
          ? SystemChrome.setPreferredOrientations(
              [DeviceOrientation.landscapeRight])
          : SystemChrome.setPreferredOrientations(
              [DeviceOrientation.landscapeLeft]);
    }

    super.dispose();
  }

  int value = 0;

  List<bool> isSelected = [true, false, false];
  bool get isiOS =>
      foundation.defaultTargetPlatform == foundation.TargetPlatform.iOS;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isiOS
          ? AppBar(
              title: Localizations.localeOf(context).toString() == "ko"
                  ? const Text(
                      "동화 재생 음성 설정",
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    )
                  : const Text("Voice Setting",
                      style: TextStyle(color: Colors.black, fontSize: 18)),
              backgroundColor: Colors.white,
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.black),
              toolbarHeight: 30,
            )
          : AppBar(
              toolbarHeight: 0,
              backgroundColor: Colors.white,
              elevation: 0,
            ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: ListView(
            children: [
              Row(
                children: [
                  Image.asset(
                    "assets/settingSpeed.png",
                    width: 19,
                    height: 20,
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  const Text(
                    "배속",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  const SizedBox(
                    width: 40,
                  ),
                  AnimatedToggleSwitch<int>.size(
                      height: 40,
                      selectedIconScale: 1,
                      textDirection: TextDirection.ltr,
                      current: ref.watch(voiceSettingProvider).speed,
                      values: const [0, 1, 2],
                      indicatorSize: const Size.fromWidth(65),
                      iconOpacity: 1,
                      borderWidth: 0,
                      iconBuilder: (value) => Text(
                            value == 0
                                ? "느리게"
                                : value == 1
                                    ? "보통"
                                    : "빠르게",
                            style: TextStyle(
                                color: Color(value ==
                                        ref.watch(voiceSettingProvider).speed
                                    ? 0xFF468aff
                                    : 0xff91A3BD),
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                          ),
                      iconAnimationType: AnimationType.onHover,
                      style: ToggleStyle(
                          backgroundColor: const Color(0xffF4F9FF),
                          borderColor: Colors.transparent,
                          borderRadius: BorderRadius.circular(50.0),
                          indicatorBoxShadow: [
                            BoxShadow(
                                color: const Color(0xff000000).withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4))
                          ]
                          // boxShadow: [
                          //   const BoxShadow(
                          //     color: Colors.black26,
                          //     spreadRadius: 1,
                          //     blurRadius: 2,
                          //     offset: Offset(0, 1.5),
                          //   ),
                          // ],
                          ),
                      styleBuilder: (i) =>
                          ToggleStyle(indicatorColor: colorBuilder(i)),
                      onChanged: (i) =>
                          ref.read(voiceSettingProvider.notifier).setSpeed(i)),
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              Row(
                children: [
                  Image.asset(
                    "assets/settingMood.png",
                    width: 19,
                    height: 20,
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  const Text(
                    "감정",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  const SizedBox(
                    width: 40,
                  ),
                  AnimatedToggleSwitch<int>.size(
                      height: 40,
                      selectedIconScale: 1,
                      textDirection: TextDirection.ltr,
                      current: ref.watch(voiceSettingProvider).emotion,
                      values: const [0, 1, 2],
                      indicatorSize: const Size.fromWidth(65),
                      iconOpacity: 1,
                      borderWidth: 0,
                      iconBuilder: (value) => Text(
                            value == 0
                                ? Localizations.localeOf(context).toString() ==
                                        "ko"
                                    ? "기쁨"
                                    : "Joy"
                                : value == 1
                                    ? Localizations.localeOf(context)
                                                .toString() ==
                                            "ko"
                                        ? "슬픔"
                                        : "Sad"
                                    : Localizations.localeOf(context)
                                                .toString() ==
                                            "ko"
                                        ? "분노"
                                        : "Angry",
                            style: TextStyle(
                                color: Color(value ==
                                        ref.watch(voiceSettingProvider).emotion
                                    ? 0xFF468aff
                                    : 0xff91A3BD),
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                          ),
                      iconAnimationType: AnimationType.onHover,
                      style: ToggleStyle(
                          backgroundColor: const Color(0xffF4F9FF),
                          borderColor: Colors.transparent,
                          borderRadius: BorderRadius.circular(50.0),
                          indicatorBoxShadow: [
                            BoxShadow(
                                color: const Color(0xff000000).withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4))
                          ]),
                      styleBuilder: (i) =>
                          ToggleStyle(indicatorColor: colorBuilder(i)),
                      onChanged: (i) => ref
                          .read(voiceSettingProvider.notifier)
                          .setEmotion(i)),
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              Row(
                children: [
                  Image.asset(
                    "assets/settingVoice.png",
                    width: 19,
                    height: 20,
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  const Text(
                    "목소리",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  const SizedBox(
                    width: 28,
                  ),
                  AnimatedToggleSwitch<int>.size(
                      height: 40,
                      selectedIconScale: 1,
                      textDirection: TextDirection.ltr,
                      current: ref.watch(voiceSettingProvider).gender,
                      values: const [0, 1, 2],
                      indicatorSize: const Size.fromWidth(65),
                      iconOpacity: 1,
                      borderWidth: 0,
                      iconBuilder: (value) => Text(
                            value == 0
                                ? "여자"
                                : value == 1
                                    ? "남자"
                                    : "아이",
                            style: TextStyle(
                                color: Color(value ==
                                        ref.watch(voiceSettingProvider).gender
                                    ? 0xFF468aff
                                    : 0xff91A3BD),
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                          ),
                      iconAnimationType: AnimationType.onHover,
                      style: ToggleStyle(
                          backgroundColor: const Color(0xffF4F9FF),
                          borderColor: Colors.transparent,
                          borderRadius: BorderRadius.circular(50.0),
                          indicatorBoxShadow: [
                            BoxShadow(
                                color: const Color(0xff000000).withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4))
                          ]),
                      styleBuilder: (i) =>
                          ToggleStyle(indicatorColor: colorBuilder(i)),
                      onChanged: (i) =>
                          ref.read(voiceSettingProvider.notifier).setGender(i)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Color colorBuilder(int value) => switch (value) {
        0 => Colors.white,
        1 => Colors.white,
        2 => Colors.white,
        _ => Colors.white,
      };
}
