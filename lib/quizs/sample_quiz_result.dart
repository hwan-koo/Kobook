import 'package:crepas/quizs/sample_quiz_main.dart';
import 'package:crepas/tale/sample_tale_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

// ignore: must_be_immutable
class SampleQuizResult extends ConsumerStatefulWidget {
  final String title;
  final Map<String, dynamic> taleData;
  final String userId;
  final String timeStamp;
  final Map<String, dynamic> quizData;
  final List<String> quizTitle;
  final List<String> quizAnswer;
  final int answerNum;
  const SampleQuizResult(
      {super.key,
      required this.title,
      required this.taleData,
      required this.userId,
      required this.timeStamp,
      required this.quizAnswer,
      required this.quizTitle,
      required this.answerNum,
      required this.quizData});

  @override
  SampleQuizResultState createState() => SampleQuizResultState();
}

class SampleQuizResultState extends ConsumerState<SampleQuizResult> {
  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.initState();
  }

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

  bool isLoading = false;
  bool isResult = false;

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
                      builder: (context) => SampleTaleViewer(
                        images: const [
                          "assets/sample/1.png",
                          "assets/sample/2.png",
                          "assets/sample/3.png",
                          "assets/sample/4.png",
                          "assets/sample/5.png",
                          "assets/sample/6.png",
                          "assets/sample/7.png",
                          "assets/sample/8.png",
                        ],
                        texts: const [
                          [
                            "어느 날, 꼬미가 밤하늘에 뜬 거대한 보름달을 보고 있었어요. '우와, 보름달이 정말 크고 둥글다!' 꼬미는 감탄했어요",
                            "그 때, 뭔가 움직이는 것을 봤어요. 보름달 위에 서있는 건 토끼였어요. '와~ 진짜로 달에 토끼가 있네!'",
                            "'어머낫!!, 날 볼 수 있나봐!' 토끼가 대답했어요. '나는 달토끼라고 해. 반가워 꼬미야!'",
                            "달토끼는 꼬미에게 달 위에서 뛰어놀 수 있는 특별한 신발을 선물했어요. 꼬미는 신발을 신고 달 위에서 뛰어놀 수 있게 되었어요.",
                            "꼬미는 정말 행복했어요. 꼬미와 달토끼는 달빛 아래에서 얘기도 나눴어요.",
                            "그러다가 꼬미가 흐릿한 지구를 보았어요. '우리 집은 저기야!' 꼬미는 달토끼에게 자신의 이야기를 들려주었어요.",
                            "시간이 흘러 보름달은 작아지기 시작했고, 꼬미는 집으로 돌아가야 했어요. 꼬미는 달토끼에게 신발을 돌려주며 작별 인사를 했어요.",
                            "그 후로 꼬미는 밤하늘의 보름달을 볼 때마다 달토끼와의 추억을 떠올렸어요. 그리고 꼬미는 다음 거대한 보름달이 뜨는 날 꼭 다시 달토끼를 보러 갈거라고 다짐했어요."
                          ],
                          [
                            "One day, Ggomi was looking at the huge full moon in the night sky and exclaimed, 'Wow, the moon is really big and round!",
                            "At that moment, Ggomi spotted something moving on the moon. It was a rabbit standing on the surface of the moon. 'Wow, there really is a rabbit on the moon!",
                            "Oh my, I think it can see me!' the rabbit replied. 'I am called the Moon Rabbit. Nice to meet you, Ggomi!",
                            "The Moon Rabbit presented Ggomi with a special pair of shoes that allowed him to jump and play on the moon. Ggomi happily put on the shoes and started jumping on the moon.",
                            "Ggomi was overjoyed. Ggomi and the Moon Rabbit had a conversation in the moonlight.",
                            "Then, Ggomi saw a blurry earth. 'Our house is over there!' Ggomi told the Moon Rabbit about his story.",
                            "As time passed, the full moon began to shrink and Ggomi had to return home. Ggomi said goodbye to the Moon Rabbit and returned the shoes.",
                            "Since then, every time Ggomi looked at the full moon in the night sky, he remembered his memories with the Moon Rabbit. And Ggomi promised to visit the Moon Rabbit again on the next day when the giant full moon rises."
                          ]
                        ],
                        userID: widget.userId,
                        timeStamp: widget.timeStamp,
                        taleData: widget.taleData,
                        title: widget.title,
                        quizData: Localizations.localeOf(context).toString() ==
                                "ko"
                            ? {
                                "question_1": "꼬미가 보름달을 보고 감탄한 이유는 무엇인가요?",
                                "choices_1": {
                                  "1": "보름달이 작고 뾰족하다",
                                  "2": "보름달이 크고 둥글다",
                                  "3": "보름달에 별이 많다",
                                  "4": "보름달이 반짝이고 있다",
                                },
                                "correct_answer_1": "보름달이 크고 둥글다",
                                "question_2": "보름달 위에 있던 것은 무엇인가요?",
                                "choices_2": {
                                  "1": "꽃",
                                  "2": "토끼",
                                  "3": "나비",
                                  "4": "달마시안"
                                },
                                "correct_answer_2": "토끼",
                                "question_3": "달토끼가 꼬미에게 어떤 선물을 주었나요?",
                                "choices_3": {
                                  "1": "신발",
                                  "2": "책",
                                  "3": "꽃",
                                  "4": "포켓몬스터"
                                },
                                "correct_answer_3": "신발",
                                "question_4": "꼬미가 보름달을 볼 때마다 떠올리는 것은 무엇인가요?",
                                "choices_4": {
                                  "1": "집",
                                  "2": "달토끼",
                                  "3": "친구",
                                  "4": "별"
                                },
                                "correct_answer_4": "달토끼"
                              }
                            : {
                                "question_1":
                                    "Why did Sophia marvel at the full moon?",
                                "choices_1": {
                                  "1": "The full moon is small and pointed",
                                  "2": "The full moon is large and round",
                                  "3": "Many stars on a full moon",
                                  "4": "The full moon is shining"
                                },
                                "correct_answer_1":
                                    "The full moon is large and round",
                                "question_2": "What was on the full moon?",
                                "choices_2": {
                                  "1": "Flower",
                                  "2": "Rabbit",
                                  "3": "Butterfly",
                                  "4": "Dalmatian"
                                },
                                "correct_answer_2": "Rabbit",
                                "question_3":
                                    "What gift did the moon rabbit give to Sophia?",
                                "choices_3": {
                                  "1": "Shoes",
                                  "2": "Book",
                                  "3": "Flower",
                                  "4": "Poketmon"
                                },
                                "correct_answer_3": "Shoes",
                                "question_4":
                                    "What does Sophia think of every time she sees a full moon?",
                                "choices_4": {
                                  "1": "House",
                                  "2": "Full Moon Bunny",
                                  "3": "Friend",
                                  "4": "Star"
                                },
                                "correct_answer_4": "Full Moon Bunny"
                              },
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
                          : "Retell this",
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
                                                    "맞힌 문제 ",
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
                                                    "맞힌 문제 ",
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
                                              Stack(
                                                children: [
                                                  Text(
                                                    " 개",
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
                                                    " 개",
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
                                                    " 틀린 문제 ",
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
                                                    " 틀린 문제 ",
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
                                              Stack(
                                                children: [
                                                  Text(
                                                    " 개",
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
                                                    " 개",
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
                                          "정답 확인하기",
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
                                  builder: (context) => SampleQuizMain(
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
                                      widget.taleData["1"][1],
                                      widget.taleData["2"][1],
                                      widget.taleData["3"][1],
                                      widget.taleData["4"][1],
                                      widget.taleData["5"][1],
                                      widget.taleData["6"][1],
                                      widget.taleData["7"][1],
                                      widget.taleData["8"][1]
                                    ],
                                    userID: widget.userId,
                                    timeStamp: widget.timeStamp,
                                    quizData: widget.quizData,
                                    title: widget.title,
                                    taleData: widget.taleData,
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
                                          "퀴즈 다시 풀기",
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
