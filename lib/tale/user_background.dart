import 'package:audioplayers/audioplayers.dart';
import 'package:crepas/tale/user_story.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'background_choice.dart';

class UserBackground extends StatefulWidget {
  final String character_datetime;
  final String character_name;
  final String character_type;
  const UserBackground({
    super.key,
    required this.character_datetime,
    required this.character_name,
    required this.character_type,
  });

  @override
  State<UserBackground> createState() => _UserBackgroundState();
}

class _UserBackgroundState extends State<UserBackground> {
  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    super.initState();
  }

  final _textController = TextEditingController();
  String background = "";
  bool get isiOS =>
      foundation.defaultTargetPlatform == foundation.TargetPlatform.iOS;
  bool isRecomendation = false;
  bool isFree = false;
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
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
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
                            width: MediaQuery.of(context).size.width > 600
                                ? 200
                                : 120,
                            height: MediaQuery.of(context).size.width > 600
                                ? 64
                                : 32,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  Localizations.localeOf(context).toString() ==
                                          "ko"
                                      ? "동화 만들기"
                                      : "Make Tale",
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width >
                                                  600
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
                          Navigator.of(context)
                              .popUntil((route) => route.isFirst);
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.white),
                            width: MediaQuery.of(context).size.width > 600
                                ? 200
                                : 120,
                            height: MediaQuery.of(context).size.width > 600
                                ? 64
                                : 32,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  Localizations.localeOf(context).toString() ==
                                          "ko"
                                      ? "동화 읽기"
                                      : "Read Books",
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width >
                                                  600
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
                                ? "배경이 될 장소는"
                                : "Where will",
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width > 600
                                        ? 32
                                        : 24,
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.02),
                          ),
                          Text(
                            Localizations.localeOf(context).toString() == "ko"
                                ? "어디인가요"
                                : "the background be?",
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width > 600
                                        ? 32
                                        : 24,
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.02),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ],
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    height: isFree
                        ? 30
                        : MediaQuery.of(context).size.width > 600
                            ? 230
                            : 100,
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
                      height:
                          MediaQuery.of(context).size.width > 600 ? 100 : 84,
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
                                  ? "장소를 추천해주세요"
                                  : "Recommend a place to go",
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width > 600
                                          ? 22
                                          : 14),
                            ),
                            isRecomendation
                                ? Container(
                                    alignment: Alignment.center,
                                    width:
                                        MediaQuery.of(context).size.width > 600
                                            ? 30
                                            : 20,
                                    height:
                                        MediaQuery.of(context).size.width > 600
                                            ? 30
                                            : 20,
                                    decoration: BoxDecoration(
                                        color: const Color(0xff468AFF),
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    child: FaIcon(
                                      FontAwesomeIcons.check,
                                      color: Colors.white,
                                      size: MediaQuery.of(context).size.width >
                                              600
                                          ? 18
                                          : 12,
                                    ),
                                  )
                                : Container(
                                    width:
                                        MediaQuery.of(context).size.width > 600
                                            ? 30
                                            : 20,
                                    height:
                                        MediaQuery.of(context).size.width > 600
                                            ? 30
                                            : 20,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 1,
                                            color: const Color(0xffD9DFE4)),
                                        borderRadius:
                                            BorderRadius.circular(50)),
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
                      height: isFree
                          ? MediaQuery.of(context).size.height * 3 / 8
                          : MediaQuery.of(context).size.width > 600
                              ? 100
                              : 84,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              width: 1,
                              color: isFree
                                  ? const Color(0xff468AFF)
                                  : const Color(0xffECEDED)),
                          color:
                              isFree ? const Color(0xffF9FBFF) : Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      Localizations.localeOf(context)
                                                  .toString() ==
                                              "ko"
                                          ? "직접 적을게요"
                                          : "Write it down myself",
                                      style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width >
                                                  600
                                              ? 22
                                              : 14)),
                                  isFree
                                      ? Container(
                                          alignment: Alignment.center,
                                          width: MediaQuery.of(context)
                                                      .size
                                                      .width >
                                                  600
                                              ? 30
                                              : 20,
                                          height: MediaQuery.of(context)
                                                      .size
                                                      .width >
                                                  600
                                              ? 30
                                              : 20,
                                          decoration: BoxDecoration(
                                              color: const Color(0xff468AFF),
                                              borderRadius:
                                                  BorderRadius.circular(50)),
                                          child: FaIcon(
                                            FontAwesomeIcons.check,
                                            color: Colors.white,
                                            size: MediaQuery.of(context)
                                                        .size
                                                        .width >
                                                    600
                                                ? 18
                                                : 12,
                                          ),
                                        )
                                      : Container(
                                          width: MediaQuery.of(context)
                                                      .size
                                                      .width >
                                                  600
                                              ? 30
                                              : 20,
                                          height: MediaQuery.of(context)
                                                      .size
                                                      .width >
                                                  600
                                              ? 30
                                              : 20,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 1,
                                                  color:
                                                      const Color(0xffD9DFE4)),
                                              borderRadius:
                                                  BorderRadius.circular(50)),
                                        )
                                ],
                              ),
                            ),
                            isFree
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              2 /
                                              8,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                              width: 1,
                                              color: const Color(0xffECEDED)),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: TextField(
                                          style: TextStyle(
                                              color: const Color(0xff468AFF),
                                              fontSize: MediaQuery.of(context)
                                                          .size
                                                          .width >
                                                      600
                                                  ? 24
                                                  : 16),
                                          cursorHeight: 15,
                                          maxLength: 15,
                                          controller: _textController,
                                          onChanged: (text) {
                                            setState(() {
                                              background = text;
                                            });
                                          },
                                          decoration: InputDecoration(
                                            hintText: Localizations.localeOf(
                                                            context)
                                                        .toString() ==
                                                    "ko"
                                                ? "예) 우주 정거장"
                                                : "ex) a Mysterious Magic Garden",
                                            hintStyle: MediaQuery.of(context)
                                                        .size
                                                        .width >
                                                    600
                                                ? const TextStyle(fontSize: 24)
                                                : const TextStyle(),
                                            counterText: "",
                                            constraints: const BoxConstraints(
                                                maxHeight: 80, maxWidth: 160),
                                            suffixIcon: IconButton(
                                                iconSize: 16,
                                                onPressed: () {
                                                  _textController.clear();
                                                  setState(() {
                                                    background = "";
                                                  });
                                                },
                                                icon: _textController
                                                        .text.isNotEmpty
                                                    ? FaIcon(
                                                        FontAwesomeIcons
                                                            .solidCircleXmark,
                                                        size: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width >
                                                                600
                                                            ? 18
                                                            : 12)
                                                    : FaIcon(
                                                        FontAwesomeIcons.pen,
                                                        size: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width >
                                                                600
                                                            ? 18
                                                            : 12)),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.width > 600 ? 40 : 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      if (isRecomendation) {
                        // Airbridge.trackEvent("taleBackgroundRecomendation");
                        FirebaseAnalytics.instance
                            .logEvent(name: "TaleBackgroundRecommendation");
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => BackgroundChoice(
                                    character_datetime:
                                        widget.character_datetime,
                                    character_name: widget.character_name,
                                    character_type: widget.character_type,
                                  )),
                        );
                      }
                      if (isFree) {
                        // Airbridge.trackEvent("taleBackgroundUserInput");
                        FirebaseAnalytics.instance
                            .logEvent(name: "TaleBackgroundUserInput");
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => UserStory(
                                  character_datetime: widget.character_datetime,
                                  character_name: widget.character_name,
                                  character_type: widget.character_type,
                                  background: background)),
                        );
                      }
                    },
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        height:
                            MediaQuery.of(context).size.width > 600 ? 90 : 66,
                        decoration: ShapeDecoration(
                          color:
                              isRecomendation || _textController.text.isNotEmpty
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
                                Localizations.localeOf(context).toString() ==
                                        "ko"
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
        ),
      ),
    );
  }
}
