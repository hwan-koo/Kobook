import 'dart:io';

import 'package:crepas/tale/sample_tale_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kakao_flutter_sdk_share/kakao_flutter_sdk_share.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../quizs/sample_quiz_main.dart';
import 'new_tales.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class SampleTaleDetail extends ConsumerStatefulWidget {
  final String thumbnail;
  String title;
  final Map<String, dynamic> taleData;
  final String userId;
  final String timeStamp;
  SampleTaleDetail(
      {super.key,
      required this.thumbnail,
      required this.title,
      required this.taleData,
      required this.userId,
      required this.timeStamp});

  @override
  SampleTaleDetailState createState() => SampleTaleDetailState();
}

class SampleTaleDetailState extends ConsumerState<SampleTaleDetail> {
  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod();
    });
  }

  late bool isLike = false;
  late bool isRead = false;
  bool isHelp = false;
  _asyncMethod() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        isLike = prefs.getBool("${widget.timeStamp}_isLike") ?? false;
        isRead = prefs.getBool("${widget.timeStamp}_isRead") ?? false;
      });
    }
  }

  final FeedTemplate defaultFeed = FeedTemplate(
    content: Content(
      title: '동화책 만들기',
      description: '동화책',
      imageUrl: Uri.parse(""),
      link: Link(
          webUrl: Uri.parse('https://developers.kakao.com'),
          mobileWebUrl: Uri.parse('https://developers.kakao.com')),
    ),
    buttons: [
      Button(
        title: '웹으로 보기',
        link: Link(
          webUrl: Uri.parse('https: //developers.kakao.com'),
          mobileWebUrl: Uri.parse('https: //developers.kakao.com'),
        ),
      ),
      Button(
        title: '앱으로보기',
        link: Link(
          androidExecutionParams: {'key1': 'value1', 'key2': 'value2'},
          iosExecutionParams: {'key1': 'value1', 'key2': 'value2'},
        ),
      ),
    ],
  );
  _shareKakao(img) async {
    int templateId = 98659;
    bool isKakaoTalkSharingAvailable =
        await ShareClient.instance.isKakaoTalkSharingAvailable();
    if (isKakaoTalkSharingAvailable) {
      try {
        Uri uri = await ShareClient.instance.shareCustom(
            templateId: templateId,
            templateArgs: {"tale1": img[0], "tale2": img[1], "tale3": img[2]});
        await ShareClient.instance.launchKakaoTalk(uri);
        print('카카오톡 공유 완료');
      } catch (error) {
        print('카카오톡 공유 실패 $error');
      }
    } else {
      try {
        Uri shareUrl = await WebSharerClient.instance
            .makeDefaultUrl(template: defaultFeed);
        await launchBrowserTab(shareUrl, popupOpen: true);
      } catch (error) {
        print('카카오톡 공유 실패 $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        toolbarHeight: MediaQuery.of(context).size.width > 600 ? 50 : 30,
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: Image.asset("assets/sample/1.png").image,
                    fit: BoxFit.cover)),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              const Color(0xff999999),
              const Color(0xff000000).withOpacity(0)
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Text(
                            Localizations.localeOf(context).toString() == "ko"
                                ? "꼬미와 보름달 토끼"
                                : "Sophia and Full Moon Bunny",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width > 600
                                  ? 42
                                  : 30,
                              fontFamily: "TmoneyRoundWind",
                              letterSpacing: 5,
                              fontWeight: FontWeight.bold,
                              foreground: Paint()
                                ..style = PaintingStyle.stroke
                                ..strokeWidth = Localizations.localeOf(context)
                                            .toString() ==
                                        "ko"
                                    ? 15
                                    : 8
                                ..color = Colors.white,
                            ),
                          ),
                          Text(
                            Localizations.localeOf(context).toString() == "ko"
                                ? "꼬미와 보름달 토끼"
                                : "Sophia and Full Moon Bunny",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: "TmoneyRoundWind",
                              fontSize: MediaQuery.of(context).size.width > 600
                                  ? 42
                                  : 30,
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
                  Container(
                    width: MediaQuery.of(context).size.width > 600
                        ? MediaQuery.of(context).size.width * 0.8
                        : MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width > 600
                        ? 140
                        : Localizations.localeOf(context).toString() == "ko"
                            ? 90
                            : 160,
                    decoration: BoxDecoration(
                        color: const Color(0xff333A44).withOpacity(0.8),
                        border: Border.all(
                            width: 1, color: const Color(0xff333A44)),
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        Localizations.localeOf(context).toString() == "ko"
                            ? "꼬미는 보름달 위에 토끼를 발견하고 특별한 신발을 선물 받아 달 위에서 뛰어놀게 되었는데, 보름달이 작아지기 전에 집으로 돌아와야 했고 그 후 꼬미는 달토끼와의 추억을 떠올리며 다음 보름달에 다시 만날 날을 기대했어요."
                            : "Sophia found a rabbit on the full moon and was given a special pair of shoes to play on the moon, but Sophia had to return home before the moon waned, and afterward, Sophia reminisced about her memories with the moon rabbit and looked forward to seeing her again on the next full moon.",
                        overflow: TextOverflow.ellipsis,
                        maxLines:
                            Localizations.localeOf(context).toString() == "ko"
                                ? MediaQuery.of(context).size.width > 600
                                    ? 5
                                    : 4
                                : MediaQuery.of(context).size.width > 600
                                    ? 8
                                    : 7,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: MediaQuery.of(context).size.width > 600
                                ? 20
                                : 14),
                      ),
                    ),
                  ),
                  SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.05,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                              flex: 1,
                              child: GestureDetector(
                                onTap: () async {
                                  if (isRead) {
                                    Navigator.of(context)
                                        .pushReplacement(MaterialPageRoute(
                                      builder: (context) => SampleQuizMain(
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
                                        quizData:
                                            Localizations.localeOf(context)
                                                        .toString() ==
                                                    "ko"
                                                ? {
                                                    "question_1":
                                                        "꼬미가 보름달을 보고 감탄한 이유는 무엇인가요?",
                                                    "choices_1": {
                                                      "1": "보름달이 작고 뾰족하다",
                                                      "2": "보름달이 크고 둥글다",
                                                      "3": "보름달에 별이 많다",
                                                      "4": "보름달이 반짝이고 있다",
                                                    },
                                                    "correct_answer_1":
                                                        "보름달이 크고 둥글다",
                                                    "question_2":
                                                        "보름달 위에 있던 것은 무엇인가요?",
                                                    "choices_2": {
                                                      "1": "꽃",
                                                      "2": "토끼",
                                                      "3": "나비",
                                                      "4": "달마시안"
                                                    },
                                                    "correct_answer_2": "토끼",
                                                    "question_3":
                                                        "달토끼가 꼬미에게 어떤 선물을 주었나요?",
                                                    "choices_3": {
                                                      "1": "신발",
                                                      "2": "책",
                                                      "3": "꽃",
                                                      "4": "포켓몬스터"
                                                    },
                                                    "correct_answer_3": "신발",
                                                    "question_4":
                                                        "꼬미가 보름달을 볼 때마다 떠올리는 것은 무엇인가요?",
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
                                                      "1":
                                                          "The full moon is small and pointed",
                                                      "2":
                                                          "The full moon is large and round",
                                                      "3":
                                                          "Many stars on a full moon",
                                                      "4":
                                                          "The full moon is shining"
                                                    },
                                                    "correct_answer_1":
                                                        "The full moon is large and round",
                                                    "question_2":
                                                        "What was on the full moon?",
                                                    "choices_2": {
                                                      "1": "Flower",
                                                      "2": "Rabbit",
                                                      "3": "Butterfly",
                                                      "4": "Dalmatian"
                                                    },
                                                    "correct_answer_2":
                                                        "Rabbit",
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
                                                    "correct_answer_4":
                                                        "Full Moon Bunny"
                                                  },
                                        title: Localizations.localeOf(context)
                                                    .toString() ==
                                                "ko"
                                            ? "꼬미와 보름달 토끼"
                                            : "Sophia and Full Moon Bunny",
                                        taleData: widget.taleData,
                                      ),
                                    ));
                                  } else {
                                    setState(() {
                                      isHelp = true;
                                    });
                                    Fluttertoast.showToast(
                                        msg: Localizations.localeOf(context)
                                                    .toString() ==
                                                "ko"
                                            ? "동화를 읽으면 퀴즈를 풀 수 있어요!"
                                            : "When you're done reading the story, you can take the quiz!",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: const Color(0xff333A44)
                                            .withAlpha(200),
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                  }
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      isRead
                                          ? Container()
                                          : FaIcon(
                                              FontAwesomeIcons.circleInfo,
                                              size: MediaQuery.of(context)
                                                          .size
                                                          .width >
                                                      600
                                                  ? 24
                                                  : 20,
                                              color: isRead
                                                  ? Colors.white
                                                  : const Color(0xffC1C1C1),
                                            ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width >
                                                    600
                                                ? 10
                                                : 5,
                                      ),
                                      Text(
                                          Localizations.localeOf(context)
                                                      .toString() ==
                                                  "ko"
                                              ? "퀴즈 풀기"
                                              : "Take a quiz",
                                          style: TextStyle(
                                              fontSize: MediaQuery.of(context)
                                                          .size
                                                          .width >
                                                      600
                                                  ? 24
                                                  : 20,
                                              color: isRead
                                                  ? Colors.white
                                                  : const Color(0xffC1C1C1),
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: 14,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 2,
                                      color: const Color(0xffDFDFDF))),
                            ),
                            Flexible(
                              flex: 1,
                              child: GestureDetector(
                                onTap: () async {
                                  if (Localizations.localeOf(context)
                                          .toString() ==
                                      "ko") {
                                    _shareKakao([
                                      "https://media.discordapp.net/attachments/1147441416008634408/1154711394504155166/1.png?width=936&height=936",
                                      "https://media.discordapp.net/attachments/1147441416008634408/1154711394881650728/2.png?width=936&height=936",
                                      "https://media.discordapp.net/attachments/1147441416008634408/1154711395233960036/3.png?width=936&height=936"
                                    ]);
                                  } else {
                                    final box = context.findRenderObject()
                                        as RenderBox?;

                                    final http.Response responseData =
                                        await http.get(Uri.parse(
                                            "https://media.discordapp.net/attachments/1147441416008634408/1154711394504155166/1.png?width=936&height=936"));
                                    var uint8list = responseData.bodyBytes;
                                    var buffer = uint8list.buffer;
                                    ByteData byteData = ByteData.view(buffer);
                                    var tempDir = await getTemporaryDirectory();
                                    File file =
                                        await File('${tempDir.path}/img.jpg')
                                            .writeAsBytes(buffer.asUint8List(
                                                byteData.offsetInBytes,
                                                byteData.lengthInBytes));
                                    XFile files = XFile(file.path);

                                    Share.shareXFiles([files],
                                        subject: "AI Creates Children's Book",
                                        text:
                                            "Create a fairy tale with your child as the main character",
                                        sharePositionOrigin:
                                            box!.localToGlobal(Offset.zero) &
                                                box.size);
                                  }
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    Localizations.localeOf(context)
                                                .toString() ==
                                            "ko"
                                        ? "공유 하기"
                                        : "Share Tale",
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width >
                                                    600
                                                ? 24
                                                : 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            )
                          ])),
                ],
              ),
            ),
          ),
          Positioned(
              bottom: 50,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
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
                            title: Localizations.localeOf(context).toString() ==
                                    "ko"
                                ? "꼬미와 보름달 토끼"
                                : "Sophia and Full Moon Bunny",
                            quizData: Localizations.localeOf(context)
                                        .toString() ==
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
                                    "question_4":
                                        "꼬미가 보름달을 볼 때마다 떠올리는 것은 무엇인가요?",
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
                          width: MediaQuery.of(context).size.width - 40,
                          height:
                              MediaQuery.of(context).size.width > 600 ? 90 : 66,
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  Localizations.localeOf(context).toString() ==
                                          "ko"
                                      ? "동화 읽기"
                                      : "Read This",
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width >
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
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => const NewTales()),
                        );
                      },
                      child: Container(
                          width: MediaQuery.of(context).size.width - 40,
                          height:
                              MediaQuery.of(context).size.width > 600 ? 90 : 66,
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  Localizations.localeOf(context).toString() ==
                                          "ko"
                                      ? "다른 동화 보기"
                                      : "Read other fairy tales",
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width >
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
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
