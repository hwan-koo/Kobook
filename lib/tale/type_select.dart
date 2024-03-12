import 'package:audioplayers/audioplayers.dart';
import 'package:crepas/tale/big_theme_choice.dart';
import 'package:crepas/tale/user_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BookTypeSelect extends StatefulWidget {
  final String character_type;
  final String character_datetime;
  final String character_name;
  const BookTypeSelect(
      {super.key,
      required this.character_type,
      required this.character_datetime,
      required this.character_name});

  @override
  State<BookTypeSelect> createState() => _BookTypeSelectState();
}

class _BookTypeSelectState extends State<BookTypeSelect> {
  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    super.initState();
  }

  bool isRecomendation = false;
  bool isFree = false;

  bool get isiOS =>
      foundation.defaultTargetPlatform == foundation.TargetPlatform.iOS;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: isiOS
      //     ? AppBar(
      //         backgroundColor: Colors.white,
      //         elevation: 0,
      //         iconTheme: const IconThemeData(color: Colors.black),
      //         toolbarHeight: 30,
      //       )
      //     : AppBar(
      //         toolbarHeight: 0,
      //         backgroundColor: Colors.white,
      //         elevation: 0,
      //       ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: const Color(0xff468AFF)),
                        width:
                            MediaQuery.of(context).size.width > 600 ? 200 : 120,
                        height:
                            MediaQuery.of(context).size.width > 600 ? 64 : 32,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              Localizations.localeOf(context).toString() == "ko"
                                  ? "동화 만들기"
                                  : "Make Tale",
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width > 600
                                          ? 24
                                          : Localizations.localeOf(context)
                                                      .toString() ==
                                                  "ko"
                                              ? 14
                                              : 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            )
                          ],
                        )),
                  ),
                  GestureDetector(
                    onTap: () {
                      AudioPlayer().play(AssetSource('button_click.wav'));
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.white),
                        width:
                            MediaQuery.of(context).size.width > 600 ? 200 : 120,
                        height:
                            MediaQuery.of(context).size.width > 600 ? 64 : 32,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              Localizations.localeOf(context).toString() == "ko"
                                  ? "동화 읽기"
                                  : "Read Books",
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width > 600
                                          ? 24
                                          : Localizations.localeOf(context)
                                                      .toString() ==
                                                  "ko"
                                              ? 14
                                              : 16,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xffC1C1C1)),
                            )
                          ],
                        )),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Localizations.localeOf(context).toString() == "ko"
                            ? "어떤 이야기를"
                            : "What story",
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width > 600
                                ? 32
                                : 24,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.02),
                      ),
                      Text(
                        Localizations.localeOf(context).toString() == "ko"
                            ? "만들어 볼까요?"
                            : "do you want to tell?",
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width > 600
                                ? 32
                                : 24,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.02),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width > 600 ? 230 : 100,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isRecomendation = !isRecomendation;
                    isFree = false;
                  });
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width > 600 ? 90 : 66,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          width: 1,
                          color: isRecomendation
                              ? const Color(0xff468AFF)
                              : const Color(0xffECEDED)),
                      color: isRecomendation
                          ? const Color(0xffF9FBFF)
                          : Colors.white),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          Localizations.localeOf(context).toString() == "ko"
                              ? "주제를 추천해주세요"
                              : "Recommend topics",
                          style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width > 600
                                  ? 22
                                  : Localizations.localeOf(context)
                                              .toString() ==
                                          "ko"
                                      ? 14
                                      : 16),
                        ),
                        isRecomendation
                            ? Container(
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width > 600
                                    ? 30
                                    : 20,
                                height: MediaQuery.of(context).size.width > 600
                                    ? 30
                                    : 20,
                                decoration: BoxDecoration(
                                    color: const Color(0xff468AFF),
                                    borderRadius: BorderRadius.circular(50)),
                                child: FaIcon(
                                  FontAwesomeIcons.check,
                                  color: Colors.white,
                                  size: MediaQuery.of(context).size.width > 600
                                      ? 18
                                      : 12,
                                ),
                              )
                            : Container(
                                width: MediaQuery.of(context).size.width > 600
                                    ? 30
                                    : 20,
                                height: MediaQuery.of(context).size.width > 600
                                    ? 30
                                    : 20,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1,
                                        color: const Color(0xffD9DFE4)),
                                    borderRadius: BorderRadius.circular(50)),
                              )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isFree = !isFree;
                    isRecomendation = false;
                  });
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width > 600 ? 90 : 66,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          width: 1,
                          color: isFree
                              ? const Color(0xff468AFF)
                              : const Color(0xffECEDED)),
                      color: isFree ? const Color(0xffF9FBFF) : Colors.white),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          Localizations.localeOf(context).toString() == "ko"
                              ? "직접 만들게요"
                              : "My ideas",
                          style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width > 600
                                  ? 22
                                  : Localizations.localeOf(context)
                                              .toString() ==
                                          "ko"
                                      ? 14
                                      : 16),
                        ),
                        isFree
                            ? Container(
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width > 600
                                    ? 30
                                    : 20,
                                height: MediaQuery.of(context).size.width > 600
                                    ? 30
                                    : 20,
                                decoration: BoxDecoration(
                                    color: const Color(0xff468AFF),
                                    borderRadius: BorderRadius.circular(50)),
                                child: FaIcon(
                                  FontAwesomeIcons.check,
                                  color: Colors.white,
                                  size: MediaQuery.of(context).size.width > 600
                                      ? 18
                                      : 12,
                                ),
                              )
                            : Container(
                                width: MediaQuery.of(context).size.width > 600
                                    ? 30
                                    : 20,
                                height: MediaQuery.of(context).size.width > 600
                                    ? 30
                                    : 20,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1,
                                        color: const Color(0xffD9DFE4)),
                                    borderRadius: BorderRadius.circular(50)),
                              )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 2 / 10,
              ),
              GestureDetector(
                onTap: () {
                  if (isRecomendation) {
                    // Airbridge.trackEvent("taleRecomendation");

                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => BigThemeChoice(
                                character_datetime: widget.character_datetime,
                                character_name: widget.character_name,
                                character_type: widget.character_type,
                              )),
                    );
                  }
                  if (isFree) {
                    // Airbridge.trackEvent("taleUserInput");
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => UserBackground(
                                character_datetime: widget.character_datetime,
                                character_name: widget.character_name,
                                character_type: widget.character_type,
                              )),
                    );
                  }
                },
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width > 600 ? 90 : 66,
                    decoration: ShapeDecoration(
                      color: isRecomendation || isFree
                          ? const Color(0xff468AFF)
                          : const Color(0xffDFDFDF),
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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 21),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            Localizations.localeOf(context).toString() == "ko"
                                ? "다음"
                                : "Next",
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width > 600
                                        ? 22
                                        : 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
