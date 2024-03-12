import 'package:crepas/character/components/book_progress1.dart';
import 'package:crepas/character/components/book_progress2.dart';
import 'package:crepas/character/components/book_progress3.dart';
import 'package:crepas/character/components/book_progress4.dart';
import 'package:crepas/quizs/sample_quiz_result.dart';
import 'package:crepas/tale/sample_tale_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class SampleQuizMain extends ConsumerStatefulWidget {
  final List<String> images;
  final List<dynamic> texts;
  final String userID;
  final String timeStamp;
  final String title;
  final Map<String, dynamic> quizData;
  final Map<String, dynamic> taleData;

  const SampleQuizMain(
      {super.key,
      required this.images,
      required this.texts,
      required this.timeStamp,
      required this.userID,
      required this.quizData,
      required this.title,
      required this.taleData});

  @override
  SampleQuizMainState createState() => SampleQuizMainState();
}

class SampleQuizMainState extends ConsumerState<SampleQuizMain> {
  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod();
    });
  }

  bool isFirst = false;
  bool isSecond = false;
  bool isThird = false;
  bool isFourth = false;
  bool isAnswer = false;
  bool isChoice_1 = false;
  bool isChoice_2 = false;
  bool isChoice_3 = false;
  bool isChoice_4 = false;
  bool isError_1 = false;
  bool isError_2 = false;
  bool isError_3 = false;
  bool isError_4 = false;
  bool isFinal = false;
  int isCorrect = 0;
  int step = 0;
  int answerNum = 0;
  List<String> quizTitle = [""];
  List<String> quizAnswer = [""];
  List<Map<String, dynamic>> quizChoices = [
    {"1": "", "2": "", "3": "", "4": ""}
  ];

  _asyncMethod() {
    if (mounted) {
      setState(() {
        quizTitle = [
          widget.quizData["question_1"],
          widget.quizData["question_2"],
          widget.quizData["question_3"],
          widget.quizData["question_4"],
        ];
        quizAnswer = [
          widget.quizData["correct_answer_1"],
          widget.quizData["correct_answer_2"],
          widget.quizData["correct_answer_3"],
          widget.quizData["correct_answer_4"],
        ];
        quizChoices = [
          widget.quizData["choices_1"],
          widget.quizData["choices_2"],
          widget.quizData["choices_3"],
          widget.quizData["choices_4"]
        ];
      });
    }
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
                      ? "퀴즈를 풀고 있어요"
                      : "You're taking a quiz",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                    Localizations.localeOf(context).toString() == "ko"
                        ? "그만하시겠어요?"
                        : "Do you want to stop?",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context, true);
                        context.pushReplacement("/home");
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: 134,
                        height: 48,
                        child: Text(
                            Localizations.localeOf(context).toString() == "ko"
                                ? "다른 동화 보기"
                                : "See other tales",
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context, false);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: 124,
                        height: 48,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color(0xff468AFF)),
                        child: Text(
                            Localizations.localeOf(context).toString() == "ko"
                                ? "계속할래요"
                                : "Cancel",
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

  bool get isiOS =>
      foundation.defaultTargetPlatform == foundation.TargetPlatform.iOS;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return _onBackKey();
      },
      child: Scaffold(
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
                        userID: widget.userID,
                        timeStamp: widget.timeStamp,
                        taleData: widget.taleData,
                        title: widget.title,
                        quizData: widget.quizData,
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
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 5 / 6,
                          child: Text(
                            isCorrect == 0
                                ? "Q${step + 1}. ${quizTitle[step]}"
                                : isCorrect == 1
                                    ? Localizations.localeOf(context)
                                                .toString() ==
                                            "ko"
                                        ? "딩동댕! 정답입니다!"
                                        : "Ding dong, that's the answer! 🥳"
                                    : Localizations.localeOf(context)
                                                .toString() ==
                                            "ko"
                                        ? "땡! 다시한번 생각해보세요"
                                        : "Bam! Think again",
                            maxLines: 4,
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width > 600
                                        ? 32
                                        : 20,
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.02),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width > 600 ? 100 : 30,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isFirst = !isFirst;
                      isSecond = false;
                      isThird = false;
                      isFourth = false;
                    });
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width > 600 ? 90 : 66,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            width: 1,
                            color: isChoice_1
                                ? const Color(0xff02CE6C)
                                : isError_1
                                    ? const Color(0xffFF2C91)
                                    : isFirst
                                        ? const Color(0xff468AFF)
                                        : const Color(0xffECEDED)),
                        color: isFirst
                            ? const Color(0xffF9FBFF)
                            : isChoice_1
                                ? const Color(0xfff4fff9)
                                : isError_1
                                    ? const Color(0xfffff8fa)
                                    : Colors.white),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            quizChoices[step]["1"],
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width > 600
                                        ? 22
                                        : 14,
                                color: isChoice_1
                                    ? const Color(0xff02CE6C)
                                    : isError_1
                                        ? const Color(0xffFF2C91)
                                        : Colors.black),
                          ),
                          isFirst
                              ? Container(
                                  alignment: Alignment.center,
                                  width: MediaQuery.of(context).size.width > 600
                                      ? 30
                                      : 20,
                                  height:
                                      MediaQuery.of(context).size.width > 600
                                          ? 30
                                          : 20,
                                  decoration: BoxDecoration(
                                      color: const Color(0xff468AFF),
                                      borderRadius: BorderRadius.circular(50)),
                                  child: FaIcon(
                                    FontAwesomeIcons.check,
                                    color: Colors.white,
                                    size:
                                        MediaQuery.of(context).size.width > 600
                                            ? 18
                                            : 12,
                                  ),
                                )
                              : isChoice_1
                                  ? Container(
                                      alignment: Alignment.center,
                                      width: MediaQuery.of(context).size.width >
                                              600
                                          ? 30
                                          : 20,
                                      height:
                                          MediaQuery.of(context).size.width >
                                                  600
                                              ? 30
                                              : 20,
                                      decoration: BoxDecoration(
                                          color: const Color(0xff02CE6C),
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      child: FaIcon(
                                        FontAwesomeIcons.check,
                                        color: Colors.white,
                                        size:
                                            MediaQuery.of(context).size.width >
                                                    600
                                                ? 18
                                                : 12,
                                      ),
                                    )
                                  : isError_1
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
                                              color: const Color(0xffFF2C91),
                                              borderRadius:
                                                  BorderRadius.circular(50)),
                                          child: FaIcon(
                                            FontAwesomeIcons.xmark,
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
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isSecond = !isSecond;
                      isFirst = false;
                      isThird = false;
                      isFourth = false;
                    });
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width > 600 ? 90 : 66,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            width: 1,
                            color: isChoice_2
                                ? const Color(0xff02CE6C)
                                : isError_2
                                    ? const Color(0xffFF2C91)
                                    : isSecond
                                        ? const Color(0xff468AFF)
                                        : const Color(0xffECEDED)),
                        color: isSecond
                            ? const Color(0xffF9FBFF)
                            : isChoice_2
                                ? const Color(0xfff4fff9)
                                : isError_2
                                    ? const Color(0xfffff8fa)
                                    : Colors.white),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            quizChoices[step]["2"],
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width > 600
                                        ? 22
                                        : 14,
                                color: isChoice_2
                                    ? const Color(0xff02CE6C)
                                    : isError_2
                                        ? const Color(0xffFF2C91)
                                        : Colors.black),
                          ),
                          isSecond
                              ? Container(
                                  alignment: Alignment.center,
                                  width: MediaQuery.of(context).size.width > 600
                                      ? 30
                                      : 20,
                                  height:
                                      MediaQuery.of(context).size.width > 600
                                          ? 30
                                          : 20,
                                  decoration: BoxDecoration(
                                      color: const Color(0xff468AFF),
                                      borderRadius: BorderRadius.circular(50)),
                                  child: FaIcon(
                                    FontAwesomeIcons.check,
                                    color: Colors.white,
                                    size:
                                        MediaQuery.of(context).size.width > 600
                                            ? 18
                                            : 12,
                                  ),
                                )
                              : isChoice_2
                                  ? Container(
                                      alignment: Alignment.center,
                                      width: MediaQuery.of(context).size.width >
                                              600
                                          ? 30
                                          : 20,
                                      height:
                                          MediaQuery.of(context).size.width >
                                                  600
                                              ? 30
                                              : 20,
                                      decoration: BoxDecoration(
                                          color: const Color(0xff02CE6C),
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      child: FaIcon(
                                        FontAwesomeIcons.check,
                                        color: Colors.white,
                                        size:
                                            MediaQuery.of(context).size.width >
                                                    600
                                                ? 18
                                                : 12,
                                      ),
                                    )
                                  : isError_2
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
                                              color: const Color(0xffFF2C91),
                                              borderRadius:
                                                  BorderRadius.circular(50)),
                                          child: FaIcon(
                                            FontAwesomeIcons.xmark,
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
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isThird = !isThird;
                      isFirst = false;
                      isSecond = false;
                      isFourth = false;
                    });
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width > 600 ? 90 : 66,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            width: 1,
                            color: isChoice_3
                                ? const Color(0xff02CE6C)
                                : isError_3
                                    ? const Color(0xffFF2C91)
                                    : isThird
                                        ? const Color(0xff468AFF)
                                        : const Color(0xffECEDED)),
                        color: isThird
                            ? const Color(0xffF9FBFF)
                            : isChoice_3
                                ? const Color(0xfff4fff9)
                                : isError_3
                                    ? const Color(0xfffff8fa)
                                    : Colors.white),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            quizChoices[step]["3"],
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width > 600
                                        ? 22
                                        : 14,
                                color: isChoice_3
                                    ? const Color(0xff02CE6C)
                                    : isError_3
                                        ? const Color(0xffFF2C91)
                                        : Colors.black),
                          ),
                          isThird
                              ? Container(
                                  alignment: Alignment.center,
                                  width: MediaQuery.of(context).size.width > 600
                                      ? 30
                                      : 20,
                                  height:
                                      MediaQuery.of(context).size.width > 600
                                          ? 30
                                          : 20,
                                  decoration: BoxDecoration(
                                      color: const Color(0xff468AFF),
                                      borderRadius: BorderRadius.circular(50)),
                                  child: FaIcon(
                                    FontAwesomeIcons.check,
                                    color: Colors.white,
                                    size:
                                        MediaQuery.of(context).size.width > 600
                                            ? 18
                                            : 12,
                                  ),
                                )
                              : isChoice_3
                                  ? Container(
                                      alignment: Alignment.center,
                                      width: MediaQuery.of(context).size.width >
                                              600
                                          ? 30
                                          : 20,
                                      height:
                                          MediaQuery.of(context).size.width >
                                                  600
                                              ? 30
                                              : 20,
                                      decoration: BoxDecoration(
                                          color: const Color(0xff02CE6C),
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      child: FaIcon(
                                        FontAwesomeIcons.check,
                                        color: Colors.white,
                                        size:
                                            MediaQuery.of(context).size.width >
                                                    600
                                                ? 18
                                                : 12,
                                      ),
                                    )
                                  : isError_3
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
                                              color: const Color(0xffFF2C91),
                                              borderRadius:
                                                  BorderRadius.circular(50)),
                                          child: FaIcon(
                                            FontAwesomeIcons.xmark,
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
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isFourth = !isFourth;
                      isFirst = false;
                      isThird = false;
                      isSecond = false;
                    });
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width > 600 ? 90 : 66,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            width: 1,
                            color: isChoice_4
                                ? const Color(0xff02CE6C)
                                : isError_4
                                    ? const Color(0xffFF2C91)
                                    : isFourth
                                        ? const Color(0xff468AFF)
                                        : const Color(0xffECEDED)),
                        color: isFourth
                            ? const Color(0xffF9FBFF)
                            : isChoice_4
                                ? const Color(0xfff4fff9)
                                : isError_4
                                    ? const Color(0xfffff8fa)
                                    : Colors.white),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            quizChoices[step]["4"],
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width > 600
                                        ? 22
                                        : 14,
                                color: isChoice_4
                                    ? const Color(0xff02CE6C)
                                    : isError_4
                                        ? const Color(0xffFF2C91)
                                        : Colors.black),
                          ),
                          isFourth
                              ? Container(
                                  alignment: Alignment.center,
                                  width: MediaQuery.of(context).size.width > 600
                                      ? 30
                                      : 20,
                                  height:
                                      MediaQuery.of(context).size.width > 600
                                          ? 30
                                          : 20,
                                  decoration: BoxDecoration(
                                      color: const Color(0xff468AFF),
                                      borderRadius: BorderRadius.circular(50)),
                                  child: FaIcon(
                                    FontAwesomeIcons.check,
                                    color: Colors.white,
                                    size:
                                        MediaQuery.of(context).size.width > 600
                                            ? 18
                                            : 12,
                                  ),
                                )
                              : isChoice_4
                                  ? Container(
                                      alignment: Alignment.center,
                                      width: MediaQuery.of(context).size.width >
                                              600
                                          ? 30
                                          : 20,
                                      height:
                                          MediaQuery.of(context).size.width >
                                                  600
                                              ? 30
                                              : 20,
                                      decoration: BoxDecoration(
                                          color: const Color(0xff02CE6C),
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      child: FaIcon(
                                        FontAwesomeIcons.check,
                                        color: Colors.white,
                                        size:
                                            MediaQuery.of(context).size.width >
                                                    600
                                                ? 18
                                                : 12,
                                      ),
                                    )
                                  : isError_4
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
                                              color: const Color(0xffFF2C91),
                                              borderRadius:
                                                  BorderRadius.circular(50)),
                                          child: FaIcon(
                                            FontAwesomeIcons.xmark,
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
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 1 / 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    step == 0
                        ? const BookProgress1()
                        : step == 1
                            ? const BookProgress2()
                            : step == 2
                                ? const BookProgress3()
                                : step == 3
                                    ? const BookProgress4()
                                    : Container()
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width > 600 ? 20 : 10,
                ),
                GestureDetector(
                  onTap: () {
                    if (!isAnswer) {
                      if (step == 3) {
                        setState(() {
                          isFinal = true;
                        });
                      }
                      setState(() {
                        isAnswer = true;
                      });
                      if (isFirst) {
                        if (quizChoices[step]["1"] == quizAnswer[step]) {
                          setState(() {
                            isChoice_1 = true;
                            isFirst = false;
                            answerNum += 1;
                            isCorrect = 1;
                          });
                        } else {
                          if (quizChoices[step]["2"] == quizAnswer[step]) {
                            setState(() {
                              isError_1 = true;
                              isChoice_2 = true;
                              isFirst = false;
                              isCorrect = 2;
                            });
                          }
                          if (quizChoices[step]["3"] == quizAnswer[step]) {
                            setState(() {
                              isError_1 = true;
                              isChoice_3 = true;
                              isFirst = false;
                              isCorrect = 2;
                            });
                          }
                          if (quizChoices[step]["4"] == quizAnswer[step]) {
                            setState(() {
                              isError_1 = true;
                              isChoice_4 = true;
                              isFirst = false;
                              isCorrect = 2;
                            });
                          }
                        }
                      }
                      if (isSecond) {
                        if (quizChoices[step]["2"] == quizAnswer[step]) {
                          setState(() {
                            isChoice_2 = true;
                            isSecond = false;
                            answerNum += 1;
                            isCorrect = 1;
                          });
                        } else {
                          if (quizChoices[step]["1"] == quizAnswer[step]) {
                            setState(() {
                              isError_2 = true;
                              isChoice_1 = true;
                              isSecond = false;
                              isCorrect = 2;
                            });
                          }
                          if (quizChoices[step]["3"] == quizAnswer[step]) {
                            setState(() {
                              isError_2 = true;
                              isChoice_3 = true;
                              isSecond = false;
                              isCorrect = 2;
                            });
                          }
                          if (quizChoices[step]["4"] == quizAnswer[step]) {
                            setState(() {
                              isError_2 = true;
                              isChoice_4 = true;
                              isSecond = false;
                              isCorrect = 2;
                            });
                          }
                        }
                      }
                      if (isThird) {
                        if (quizChoices[step]["3"] == quizAnswer[step]) {
                          setState(() {
                            isChoice_3 = true;
                            isThird = false;
                            answerNum += 1;
                            isCorrect = 1;
                          });
                        } else {
                          if (quizChoices[step]["1"] == quizAnswer[step]) {
                            setState(() {
                              isError_3 = true;
                              isChoice_1 = true;
                              isThird = false;
                              isCorrect = 2;
                            });
                          }
                          if (quizChoices[step]["2"] == quizAnswer[step]) {
                            setState(() {
                              isError_3 = true;
                              isChoice_2 = true;
                              isThird = false;
                              isCorrect = 2;
                            });
                          }
                          if (quizChoices[step]["4"] == quizAnswer[step]) {
                            setState(() {
                              isError_3 = true;
                              isChoice_4 = true;
                              isThird = false;
                              isCorrect = 2;
                            });
                          }
                        }
                      }
                      if (isFourth) {
                        if (quizChoices[step]["4"] == quizAnswer[step]) {
                          setState(() {
                            isChoice_4 = true;
                            isFourth = false;
                            answerNum += 1;
                            isCorrect = 1;
                          });
                        } else {
                          if (quizChoices[step]["1"] == quizAnswer[step]) {
                            setState(() {
                              isError_4 = true;
                              isChoice_1 = true;
                              isFourth = false;
                              isCorrect = 2;
                            });
                          }
                          if (quizChoices[step]["2"] == quizAnswer[step]) {
                            setState(() {
                              isError_4 = true;
                              isChoice_2 = true;
                              isFourth = false;
                              isCorrect = 2;
                            });
                          }
                          if (quizChoices[step]["3"] == quizAnswer[step]) {
                            setState(() {
                              isError_4 = true;
                              isChoice_3 = true;
                              isFourth = false;
                              isCorrect = 2;
                            });
                          }
                        }
                      }
                    } else {
                      setState(() {
                        isChoice_1 = false;
                        isChoice_2 = false;
                        isChoice_3 = false;
                        isChoice_4 = false;
                        isError_1 = false;
                        isError_2 = false;
                        isError_3 = false;
                        isError_4 = false;
                        isAnswer = false;
                        isCorrect = 0;
                        if (step == 3) {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (context) => SampleQuizResult(
                                      title: widget.title,
                                      taleData: widget.taleData,
                                      timeStamp: widget.timeStamp,
                                      userId: widget.userID,
                                      quizAnswer: quizAnswer,
                                      quizTitle: quizTitle,
                                      answerNum: answerNum,
                                      quizData: widget.quizData,
                                    )),
                          );
                        } else {
                          step += 1;
                        }
                      });
                    }
                  },
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width > 600 ? 90 : 66,
                      decoration: ShapeDecoration(
                        color: isFirst ||
                                isSecond ||
                                isThird ||
                                isFourth ||
                                isAnswer
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
                              isFinal
                                  ? Localizations.localeOf(context)
                                              .toString() ==
                                          "ko"
                                      ? "결과 확인하기"
                                      : "Check the results"
                                  : isAnswer
                                      ? Localizations.localeOf(context)
                                                  .toString() ==
                                              "ko"
                                          ? "다음"
                                          : "Next"
                                      : Localizations.localeOf(context)
                                                  .toString() ==
                                              "ko"
                                          ? "정답보기"
                                          : "Check the answer",
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
    );
  }
}
