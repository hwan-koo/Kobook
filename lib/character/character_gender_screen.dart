import 'package:audioplayers/audioplayers.dart';
import 'package:crepas/character/character_photo_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../profile/setting_view_model.dart';

class CharacterGenderScreen extends ConsumerStatefulWidget {
  final int age;
  const CharacterGenderScreen({super.key, required this.age});

  @override
  CharacterGenderScreenState createState() => CharacterGenderScreenState();
}

class CharacterGenderScreenState extends ConsumerState<CharacterGenderScreen> {
  void _genderSelectBoy() {
    if (!ref.watch(playbackConfigProvider).muted) {
      AudioPlayer().play(AssetSource('button_click.wav'));
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PhotoSelectionScreen(
          age: widget.age,
          gender: "boy",
        ),
      ),
    );
  }

  void _genderSelectGirl() {
    if (!ref.watch(playbackConfigProvider).muted) {
      AudioPlayer().play(AssetSource('button_click.wav'));
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PhotoSelectionScreen(
          age: widget.age,
          gender: "girl",
        ),
      ),
    );
    // Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (context) => CharacterStyleScreen(
    //       age: widget.age,
    //       gender: "girl",
    //       cloth: '',
    //     ),
    //   ),
    // );
  }

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    super.initState();
  }

  bool get isiOS =>
      foundation.defaultTargetPlatform == foundation.TargetPlatform.iOS;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isiOS
          ? AppBar(
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
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Localizations.localeOf(context).toString() == "ko"
                            ? "아이의 성별을"
                            : "Tell us the gender ",
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width > 600
                                ? 32
                                : 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.02,
                            fontFamily: "TmoneyRoundWind"),
                      ),
                      Text(
                        Localizations.localeOf(context).toString() == "ko"
                            ? "알려 주세요"
                            : "of your child",
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width > 600
                                ? 32
                                : 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.02,
                            fontFamily: "TmoneyRoundWind"),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width > 600 ? 120 : 81,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: _genderSelectBoy,
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/genderboy.png",
                          width: MediaQuery.of(context).size.width > 600
                              ? 140
                              : 110,
                          height: MediaQuery.of(context).size.width > 600
                              ? 280
                              : 220,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Container(
                            alignment: Alignment.center,
                            width:
                                MediaQuery.of(context).size.width * 140 / 360,
                            height: MediaQuery.of(context).size.width > 600
                                ? 60
                                : 48,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              shadows: const [
                                BoxShadow(
                                  color: Color(0x19000000),
                                  blurRadius: 20,
                                  offset: Offset(0, 4),
                                  spreadRadius: 0,
                                )
                              ],
                            ),
                            child: Text(
                              Localizations.localeOf(context).toString() == "ko"
                                  ? "남자"
                                  : "Boy",
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width > 600
                                          ? 22
                                          : 16,
                                  fontWeight: FontWeight.bold),
                            ))
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 32,
                  ),
                  GestureDetector(
                    onTap: _genderSelectGirl,
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/gendergirl.png",
                          width: MediaQuery.of(context).size.width > 600
                              ? 140
                              : 110,
                          height: MediaQuery.of(context).size.width > 600
                              ? 280
                              : 220,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Container(
                            alignment: Alignment.center,
                            width:
                                MediaQuery.of(context).size.width * 140 / 360,
                            height: MediaQuery.of(context).size.width > 600
                                ? 60
                                : 48,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              shadows: const [
                                BoxShadow(
                                  color: Color(0x19000000),
                                  blurRadius: 20,
                                  offset: Offset(0, 4),
                                  spreadRadius: 0,
                                )
                              ],
                            ),
                            child: Text(
                              Localizations.localeOf(context).toString() == "ko"
                                  ? "여자"
                                  : "Girl",
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width > 600
                                          ? 22
                                          : 16,
                                  fontWeight: FontWeight.bold),
                            ))
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
