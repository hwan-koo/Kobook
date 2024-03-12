import 'package:crepas/quizs/quiz_main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../testview.dart';

// ignore: must_be_immutable
class QuizResult extends ConsumerStatefulWidget {
  final String title;
  final Map<String, dynamic> taleData;
  final String userId;
  final String timeStamp;
  final Map<String, dynamic> quizData;
  final List<String> quizTitle;
  final List<String> quizAnswer;
  final int answerNum;
  final String userType;
  const QuizResult(
      {super.key,
      required this.title,
      required this.taleData,
      required this.userId,
      required this.timeStamp,
      required this.quizAnswer,
      required this.quizTitle,
      required this.answerNum,
      required this.quizData,
      required this.userType});

  @override
  QuizResultState createState() => QuizResultState();
}

class QuizResultState extends ConsumerState<QuizResult> {
  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.initState();
  }

  bool isLoading = false;
  bool isResult = false;
  Future<bool> _onBackKey() async {
    return await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            backgroundColor: Colors.white,
            title: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FaIcon(
                  FontAwesomeIcons.circleExclamation,
                  color: Color(0xff468AFF),
                  size: 50,
                )
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  Localizations.localeOf(context).toString() == "ko"
                      ? "퀴즈를 다 풀었어요!"
                      : "You're done with the quiz!",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context, false);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: 124,
                        height: 48,
                        child: Text(
                            Localizations.localeOf(context).toString() == "ko"
                                ? "결과 다시 보기"
                                : "Cancel",
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context, true);
                        context.pushReplacement("/home");
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: 134,
                        height: 48,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color(0xff468AFF)),
                        child: Text(
                            Localizations.localeOf(context).toString() == "ko"
                                ? "다른 동화 보기"
                                : "View other tales",
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ),
                    )
                  ],
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return _onBackKey();
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          actions: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => TestViewer(
                        images: [
                          widget.taleData["1"][0],
                          widget.taleData["2"][0],
                          widget.taleData["3"][0],
                          widget.taleData["4"][0],
                          widget.taleData["5"][0],
                          widget.taleData["6"][0],
                          widget.taleData["7"][0],
                          widget.taleData["8"][0],
                        ],
                        texts: [
                          [
                            widget.taleData["1"][1],
                            widget.taleData["2"][1],
                            widget.taleData["3"][1],
                            widget.taleData["4"][1],
                            widget.taleData["5"][1],
                            widget.taleData["6"][1],
                            widget.taleData["7"][1],
                            widget.taleData["8"][1]
                          ],
                          [
                            widget.taleData["1"][2],
                            widget.taleData["2"][2],
                            widget.taleData["3"][2],
                            widget.taleData["4"][2],
                            widget.taleData["5"][2],
                            widget.taleData["6"][2],
                            widget.taleData["7"][2],
                            widget.taleData["8"][2]
                          ]
                        ],
                        userID: widget.userId,
                        timeStamp: widget.timeStamp,
                        taleData: widget.taleData,
                        title: widget.title,
                        userType: widget.userType,
                      ),
                    ));
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width > 600 ? 200 : 120,
                    height: MediaQuery.of(context).size.width > 600 ? 50 : 40,
                    decoration: BoxDecoration(
                        color: const Color(0xff468aff),
                        borderRadius: BorderRadius.circular(40)),
                    child: Text(
                      Localizations.localeOf(context).toString() == "ko"
                          ? "동화 다시보기"
                          : "Retell tale",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.width > 600
                              ? 22
                              : 14),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
              ],
            ),
          ],
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
          toolbarHeight: MediaQuery.of(context).size.width > 600 ? 50 : 30,
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: Image.asset("assets/talebackground.png").image,
                        fit: BoxFit.cover)),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: isResult
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Text(
                                      widget.title,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: "TmoneyRoundWind",
                                        fontSize:
                                            MediaQuery.of(context).size.width >
                                                    600
                                                ? 36
                                                : 24,
                                        letterSpacing: 5,
                                        fontWeight: FontWeight.bold,
                                        foreground: Paint()
                                          ..style = PaintingStyle.stroke
                                          ..strokeWidth = 10
                                          ..color = Colors.white,
                                      ),
                                    ),
                                    Text(
                                      widget.title,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: "TmoneyRoundWind",
                                        fontSize:
                                            MediaQuery.of(context).size.width >
                                                    600
                                                ? 36
                                                : 24,
                                        letterSpacing: 5,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xff468aff),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 5 / 6,
                              child: Text(
                                "Q1. ${widget.quizTitle[0]}",
                                maxLines: 4,
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width > 600
                                            ? 24
                                            : 16,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: -0.02),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 5 / 6,
                              child: Text(
                                " ${widget.quizAnswer[0]}",
                                maxLines: 4,
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width > 600
                                            ? 24
                                            : 16,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xff468aff),
                                    letterSpacing: -0.02),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 5 / 6,
                              child: Text(
                                "Q2. ${widget.quizTitle[1]}",
                                maxLines: 4,
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width > 600
                                            ? 24
                                            : 16,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: -0.02),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 5 / 6,
                              child: Text(
                                " ${widget.quizAnswer[1]}",
                                maxLines: 4,
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width > 600
                                            ? 24
                                            : 16,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xff468aff),
                                    letterSpacing: -0.02),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 5 / 6,
                              child: Text(
                                "Q3. ${widget.quizTitle[2]}",
                                maxLines: 4,
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width > 600
                                            ? 24
                                            : 16,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: -0.02),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 5 / 6,
                              child: Text(
                                " ${widget.quizAnswer[2]}",
                                maxLines: 4,
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width > 600
                                            ? 24
                                            : 16,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xff468aff),
                                    letterSpacing: -0.02),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 5 / 6,
                              child: Text(
                                "Q4. ${widget.quizTitle[3]}",
                                maxLines: 4,
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width > 600
                                            ? 24
                                            : 16,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: -0.02),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 5 / 6,
                              child: Text(
                                " ${widget.quizAnswer[3]}",
                                maxLines: 4,
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width > 600
                                            ? 24
                                            : 16,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xff468aff),
                                    letterSpacing: -0.02),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Text(
                                      widget.title,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: "TmoneyRoundWind",
                                        fontSize:
                                            MediaQuery.of(context).size.width >
                                                    600
                                                ? 42
                                                : 32,
                                        letterSpacing: 5,
                                        fontWeight: FontWeight.bold,
                                        foreground: Paint()
                                          ..style = PaintingStyle.stroke
                                          ..strokeWidth = 15
                                          ..color = Colors.white,
                                      ),
                                    ),
                                    Text(
                                      widget.title,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: "TmoneyRoundWind",
                                        fontSize:
                                            MediaQuery.of(context).size.width >
                                                    600
                                                ? 42
                                                : 32,
                                        letterSpacing: 5,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xff468aff),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height * 0.1,
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Flexible(
                                        flex: 1,
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Stack(
                                                children: [
                                                  Text(
                                                    Localizations.localeOf(
                                                                    context)
                                                                .toString() ==
                                                            "ko"
                                                        ? "맞힌 문제 "
                                                        : "Correct questions ",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                      .size
                                                                      .width >
                                                                  600
                                                              ? 24
                                                              : 16,
                                                      letterSpacing: 0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      foreground: Paint()
                                                        ..style =
                                                            PaintingStyle.stroke
                                                        ..strokeWidth = 4
                                                        ..color = Colors.white,
                                                    ),
                                                  ),
                                                  Text(
                                                    Localizations.localeOf(
                                                                    context)
                                                                .toString() ==
                                                            "ko"
                                                        ? "맞힌 문제 "
                                                        : "Correct questions ",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                      .size
                                                                      .width >
                                                                  600
                                                              ? 24
                                                              : 16,
                                                      letterSpacing: 0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Stack(
                                                children: [
                                                  Text(
                                                    " ${widget.answerNum}",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                      .size
                                                                      .width >
                                                                  600
                                                              ? 24
                                                              : 16,
                                                      letterSpacing: 0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      foreground: Paint()
                                                        ..style =
                                                            PaintingStyle.stroke
                                                        ..strokeWidth = 4
                                                        ..color = Colors.white,
                                                    ),
                                                  ),
                                                  Text(
                                                    " ${widget.answerNum}",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                      .size
                                                                      .width >
                                                                  600
                                                              ? 24
                                                              : 16,
                                                      letterSpacing: 0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: const Color(
                                                          0xff02CE6C),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Localizations.localeOf(context)
                                                          .toString() ==
                                                      "ko"
                                                  ? Stack(
                                                      children: [
                                                        Text(
                                                          " 개",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            fontSize: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width >
                                                                    600
                                                                ? 24
                                                                : 16,
                                                            letterSpacing: 0,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            foreground: Paint()
                                                              ..style =
                                                                  PaintingStyle
                                                                      .stroke
                                                              ..strokeWidth = 4
                                                              ..color =
                                                                  Colors.white,
                                                          ),
                                                        ),
                                                        Text(
                                                          " 개",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            fontSize: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width >
                                                                    600
                                                                ? 24
                                                                : 16,
                                                            letterSpacing: 0,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  : Container(),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height:
                                            MediaQuery.of(context).size.width >
                                                    600
                                                ? 28
                                                : 14,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 2,
                                                color:
                                                    const Color(0xffDFDFDF))),
                                      ),
                                      Flexible(
                                        flex: 1,
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Stack(
                                                children: [
                                                  Text(
                                                    Localizations.localeOf(
                                                                    context)
                                                                .toString() ==
                                                            "ko"
                                                        ? "틀린 문제 "
                                                        : "Incorrect questions ",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                      .size
                                                                      .width >
                                                                  600
                                                              ? 24
                                                              : 16,
                                                      letterSpacing: 0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      foreground: Paint()
                                                        ..style =
                                                            PaintingStyle.stroke
                                                        ..strokeWidth = 4
                                                        ..color = Colors.white,
                                                    ),
                                                  ),
                                                  Text(
                                                    Localizations.localeOf(
                                                                    context)
                                                                .toString() ==
                                                            "ko"
                                                        ? "틀린 문제 "
                                                        : "Incorrect questions ",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                      .size
                                                                      .width >
                                                                  600
                                                              ? 24
                                                              : 16,
                                                      letterSpacing: 0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Stack(
                                                children: [
                                                  Text(
                                                    "${4 - widget.answerNum}",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                      .size
                                                                      .width >
                                                                  600
                                                              ? 24
                                                              : 16,
                                                      letterSpacing: 0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      foreground: Paint()
                                                        ..style =
                                                            PaintingStyle.stroke
                                                        ..strokeWidth = 4
                                                        ..color = Colors.white,
                                                    ),
                                                  ),
                                                  Text(
                                                    "${4 - widget.answerNum}",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                      .size
                                                                      .width >
                                                                  600
                                                              ? 24
                                                              : 16,
                                                      letterSpacing: 0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: const Color(
                                                          0xffFF2C91),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Localizations.localeOf(context)
                                                          .toString() ==
                                                      "ko"
                                                  ? Stack(
                                                      children: [
                                                        Text(
                                                          " 개",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            fontSize: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width >
                                                                    600
                                                                ? 24
                                                                : 16,
                                                            letterSpacing: 0,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            foreground: Paint()
                                                              ..style =
                                                                  PaintingStyle
                                                                      .stroke
                                                              ..strokeWidth = 4
                                                              ..color =
                                                                  Colors.white,
                                                          ),
                                                        ),
                                                        Text(
                                                          " 개",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            fontSize: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width >
                                                                    600
                                                                ? 24
                                                                : 16,
                                                            letterSpacing: 0,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  : Container(),
                                            ],
                                          ),
                                        ),
                                      )
                                    ])),
                          ],
                        ),
                ),
              ),
              isResult
                  ? Container()
                  : Positioned(
                      bottom: 50,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isResult = true;
                                });
                              },
                              child: Container(
                                  width: MediaQuery.of(context).size.width - 40,
                                  height:
                                      MediaQuery.of(context).size.width > 600
                                          ? 90
                                          : 66,
                                  decoration: ShapeDecoration(
                                    color: const Color(0xff468aff),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          Localizations.localeOf(context)
                                                      .toString() ==
                                                  "ko"
                                              ? "정답 확인하기"
                                              : "Check Correct answers",
                                          style: TextStyle(
                                              fontSize: MediaQuery.of(context)
                                                          .size
                                                          .width >
                                                      600
                                                  ? 24
                                                  : 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  )),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context)
                                    .pushReplacement(MaterialPageRoute(
                                  builder: (context) => QuizMain(
                                    images: [
                                      widget.taleData["1"][0],
                                      widget.taleData["2"][0],
                                      widget.taleData["3"][0],
                                      widget.taleData["4"][0],
                                      widget.taleData["5"][0],
                                      widget.taleData["6"][0],
                                      widget.taleData["7"][0],
                                      widget.taleData["8"][0],
                                    ],
                                    texts: [
                                      [
                                        widget.taleData["1"][1],
                                        widget.taleData["2"][1],
                                        widget.taleData["3"][1],
                                        widget.taleData["4"][1],
                                        widget.taleData["5"][1],
                                        widget.taleData["6"][1],
                                        widget.taleData["7"][1],
                                        widget.taleData["8"][1]
                                      ],
                                      [
                                        widget.taleData["1"][2],
                                        widget.taleData["2"][2],
                                        widget.taleData["3"][2],
                                        widget.taleData["4"][2],
                                        widget.taleData["5"][2],
                                        widget.taleData["6"][2],
                                        widget.taleData["7"][2],
                                        widget.taleData["8"][2]
                                      ]
                                    ],
                                    userID: widget.userId,
                                    timeStamp: widget.timeStamp,
                                    quizData: widget.quizData,
                                    title: widget.title,
                                    taleData: widget.taleData,
                                    userType: widget.userType,
                                  ),
                                ));
                              },
                              child: Container(
                                  width: MediaQuery.of(context).size.width - 40,
                                  height:
                                      MediaQuery.of(context).size.width > 600
                                          ? 90
                                          : 66,
                                  decoration: ShapeDecoration(
                                    color: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 18, vertical: 21),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          Localizations.localeOf(context)
                                                      .toString() ==
                                                  "ko"
                                              ? "퀴즈 다시 풀기"
                                              : "Retake the quiz",
                                          style: TextStyle(
                                              fontSize: MediaQuery.of(context)
                                                          .size
                                                          .width >
                                                      600
                                                  ? 24
                                                  : 16,
                                              fontWeight: FontWeight.bold,
                                              color: const Color(0xff9B9B9B)),
                                        ),
                                      ],
                                    ),
                                  )),
                            ),
                          ],
                        ),
                      )),
              isLoading
                  ? Stack(
                      children: [
                        const Opacity(
                          opacity: 0.5,
                          child: ModalBarrier(
                              dismissible: false, color: Colors.black),
                        ),
                        Center(
                          child: SpinKitSpinningCircle(
                            itemBuilder: (context, index) {
                              return Center(
                                child: Image.asset("assets/turtle.png"),
                              );
                            },
                          ),
                        ),
                      ],
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}
