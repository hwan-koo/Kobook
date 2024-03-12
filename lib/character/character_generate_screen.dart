import 'package:audioplayers/audioplayers.dart';
import 'package:crepas/character/character_gender_screen.dart';
import 'package:crepas/character/components/textbutton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../profile/setting_view_model.dart';

class CharacterGenerateScreen extends ConsumerStatefulWidget {
  static const String routeName = "characterGenerate";
  static const String routeURL = "generate";

  const CharacterGenerateScreen({super.key});

  @override
  CharacterGenerateScreenState createState() => CharacterGenerateScreenState();
}

class CharacterGenerateScreenState
    extends ConsumerState<CharacterGenerateScreen> {
  _onChoiceage3() {
    if (!ref.watch(playbackConfigProvider).muted) {
      AudioPlayer().play(AssetSource('button_click.wav'));
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const CharacterGenderScreen(
          age: 3,
        ),
      ),
    );
  }

  _onChoiceage9() {
    if (!ref.watch(playbackConfigProvider).muted) {
      AudioPlayer().play(AssetSource('button_click.wav'));
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const CharacterGenderScreen(
          age: 9,
        ),
      ),
    );
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
                            ? "아이의 나이는"
                            : "How old",
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
                            ? "몇 살인가요?"
                            : "is the child?",
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
                height: MediaQuery.of(context).size.width > 600 ? 230 : 163,
              ),
              GestureDetector(
                onTap: _onChoiceage3,
                child: CGTextButton(
                  buttonText: Localizations.localeOf(context).toString() == "ko"
                      ? "1살 ~ 6살"
                      : "1 ~ 6 years old ",
                  isCentered: false,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: _onChoiceage9,
                child: CGTextButton(
                  buttonText: Localizations.localeOf(context).toString() == "ko"
                      ? "7살 ~ 13살"
                      : "7 ~ 13 years old",
                  isCentered: false,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
