import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:bookfx/bookfx.dart';
import 'package:crepas/profile/setting_view_model.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kakao_flutter_sdk_share/kakao_flutter_sdk_share.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../quizs/sample_quiz_main.dart';

class SampleTaleViewer extends ConsumerStatefulWidget {
  final List<String> images;
  final List<dynamic> texts;
  final String userID;
  final String timeStamp;
  final Map<String, dynamic> taleData;
  final String title;
  final Map<String, dynamic> quizData;
  const SampleTaleViewer(
      {super.key,
      required this.images,
      required this.texts,
      required this.userID,
      required this.timeStamp,
      required this.taleData,
      required this.title,
      required this.quizData});

  @override
  SampleTaleViewerState createState() => SampleTaleViewerState();
}

List<String> images = [];

class SampleTaleViewerState extends ConsumerState<SampleTaleViewer> {
  BookController bookController = BookController();
  bool get isiOS =>
      foundation.defaultTargetPlatform == foundation.TargetPlatform.iOS;
  AudioPlayer player = AudioPlayer();

  @override
  void initState() {
    // 가로 화면 고정
    isiOS
        ? SystemChrome.setPreferredOrientations(
            [DeviceOrientation.landscapeRight])
        : SystemChrome.setPreferredOrientations(
            [DeviceOrientation.landscapeLeft]);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod();
    });
  }

  _asyncMethod() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      prefs.setBool("${widget.timeStamp}_isRead", true);
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

  bool isEnglish = false;
  @override
  void dispose() {
    // 세로 화면 고정
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  Map<String, dynamic> quizData = {};

  _alertEnd() async {
    return await showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            backgroundColor: Colors.white,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  Localizations.localeOf(context).toString() == "ko"
                      ? "동화를 모두 읽었어요 🎉"
                      : "You've read all the fairy tales!",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset("assets/ba.json",
                    width: 100, height: 100, fit: BoxFit.cover),
                const SizedBox(
                  height: 60,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        bookController.goTo(1);
                        context.pop();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: 140,
                        height: 48,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white),
                        child: Text(
                            Localizations.localeOf(context).toString() == "ko"
                                ? "이 동화 다시 보기"
                                : "Retell this",
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    GestureDetector(
                      onTap: () async {
                        FirebaseAnalytics.instance
                            .logEvent(name: "RequestQuiz");
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
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
                                  "'Oh my, I think it can see me!' the rabbit replied. 'I am called the Moon Rabbit. Nice to meet you, Ggomi!'",
                                  "The Moon Rabbit presented Ggomi with a special pair of shoes that allowed him to jump and play on the moon. Ggomi happily put on the shoes and started jumping on the moon.",
                                  "Ggomi was overjoyed. Ggomi and the Moon Rabbit had a conversation in the moonlight.",
                                  "Then, Ggomi saw a blurry earth. 'Our house is over there!' Ggomi told the Moon Rabbit about his story.",
                                  "As time passed, the full moon began to shrink and Ggomi had to return home. Ggomi said goodbye to the Moon Rabbit and returned the shoes.",
                                  "Since then, every time Ggomi looked at the full moon in the night sky, he remembered his memories with the Moon Rabbit. And Ggomi promised to visit the Moon Rabbit again on the next day when the giant full moon rises."
                                ]
                              ],
                              userID: widget.userID,
                              timeStamp: widget.timeStamp,
                              quizData: widget.quizData,
                              title:
                                  Localizations.localeOf(context).toString() ==
                                          "ko"
                                      ? "꼬미와 보름달 토끼"
                                      : "Sophia and Full Moon Bunny",
                              taleData: widget.taleData,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: 140,
                        height: 48,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color(0xff468AFF)),
                        child: Text(
                            Localizations.localeOf(context).toString() == "ko"
                                ? "퀴즈 풀러 가기"
                                : "Go to the quizzer",
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    GestureDetector(
                      onTap: () async {
                        FirebaseAnalytics.instance.logEvent(name: "ShareTale");
                        if (Localizations.localeOf(context).toString() ==
                            "ko") {
                          _shareKakao([
                            widget.taleData["1"][0],
                            widget.taleData["2"][0],
                            widget.taleData["3"][0]
                          ]);
                        } else {
                          final box = context.findRenderObject() as RenderBox?;

                          final http.Response responseData = await http
                              .get(Uri.parse(widget.taleData["1"][0]));
                          var uint8list = responseData.bodyBytes;
                          var buffer = uint8list.buffer;
                          ByteData byteData = ByteData.view(buffer);
                          var tempDir = await getTemporaryDirectory();
                          File file = await File('${tempDir.path}/img.jpg')
                              .writeAsBytes(buffer.asUint8List(
                                  byteData.offsetInBytes,
                                  byteData.lengthInBytes));
                          XFile files = XFile(file.path);

                          Share.shareXFiles([files],
                              subject: "AI Creates Children's Book",
                              text:
                                  "Create a fairy tale with your child as the main character",
                              sharePositionOrigin:
                                  box!.localToGlobal(Offset.zero) & box.size);
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: 140,
                        height: 48,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white),
                        child: Text(
                            Localizations.localeOf(context).toString() == "ko"
                                ? "이 동화 같이보기"
                                : "Share this tale",
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
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
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: BookFx(
                  lastCallBack: (index) {
                    if (!ref.watch(playbackConfigProvider).muted) {
                      AudioPlayer().play(AssetSource('turnpage.mp3'));
                    }
                  },
                  nextCallBack: (index) {
                    if (!ref.watch(playbackConfigProvider).muted) {
                      AudioPlayer().play(AssetSource('turnpage.mp3'));
                    }

                    if (index == 9) {
                      _alertEnd();
                    }
                  },
                  size: Size(
                    MediaQuery.of(context).size.height,
                    MediaQuery.of(context).size.width,
                  ),
                  pageCount: 9,
                  currentPage: (index) {
                    if (index == 8) {
                      return Stack(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image:
                                        Image.asset("assets/talebackground.png")
                                            .image,
                                    fit: BoxFit.cover)),
                          ),
                        ],
                      );
                    } else {
                      return SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: Row(
                          children: [
                            SizedBox(
                                width: MediaQuery.of(context).size.width * 0.5,
                                height: MediaQuery.of(context).size.height,
                                child: Image.asset(
                                  widget.images[index],
                                  fit: BoxFit.cover,
                                )),
                            Stack(
                              children: [
                                Image.asset(
                                  "assets/talebackground.png",
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  height: MediaQuery.of(context).size.height,
                                  fit: BoxFit.cover,
                                ),
                                Stack(
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      height:
                                          MediaQuery.of(context).size.height,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            alignment: Alignment.center,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.5,
                                            height: MediaQuery.of(context)
                                                .size
                                                .height,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 55),
                                              child: RichText(
                                                text: TextSpan(
                                                  text: isEnglish
                                                      ? widget.texts[1][index]
                                                      : Localizations.localeOf(
                                                                      context)
                                                                  .toString() ==
                                                              "ko"
                                                          ? widget.texts[0]
                                                              [index]
                                                          : widget.texts[1]
                                                              [index],
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      height: 1.5,
                                                      fontSize:
                                                          isEnglish ? 18 : 20,
                                                      fontFamily: "Yeongdeok"),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      );
                    }
                  },
                  nextPage: (index) {
                    if (index == 8) {
                      return Stack(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image:
                                        Image.asset("assets/talebackground.png")
                                            .image,
                                    fit: BoxFit.cover)),
                          ),
                        ],
                      );
                    } else {
                      return SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: Row(
                          children: [
                            SizedBox(
                                width: MediaQuery.of(context).size.width * 0.5,
                                height: MediaQuery.of(context).size.height,
                                child: Image.asset(
                                  widget.images[index],
                                  fit: BoxFit.cover,
                                )),
                            Stack(
                              children: [
                                Image.asset(
                                  "assets/talebackground.png",
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  height: MediaQuery.of(context).size.height,
                                  fit: BoxFit.cover,
                                ),
                                Stack(
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      height:
                                          MediaQuery.of(context).size.height,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            alignment: Alignment.center,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.5,
                                            height: MediaQuery.of(context)
                                                .size
                                                .height,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 55),
                                              child: RichText(
                                                text: TextSpan(
                                                  text: isEnglish
                                                      ? widget.texts[1][index]
                                                      : Localizations.localeOf(
                                                                      context)
                                                                  .toString() ==
                                                              "ko"
                                                          ? widget.texts[0]
                                                              [index]
                                                          : widget.texts[1]
                                                              [index],
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      height: 1.5,
                                                      fontSize:
                                                          isEnglish ? 18 : 20,
                                                      fontFamily: "Yeongdeok"),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      );
                    }
                  },
                  controller: bookController),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 30, horizontal: 50),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                            onTap: () {
                              context.pushReplacement("/home");
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.height > 600
                                  ? 60
                                  : 40,
                              height: MediaQuery.of(context).size.height > 600
                                  ? 60
                                  : 40,
                              decoration: BoxDecoration(
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x19000000),
                                      blurRadius: 10,
                                      offset: Offset(0, 4),
                                      spreadRadius: 0,
                                    )
                                  ],
                                  color: const Color(0xff333A44),
                                  borderRadius: BorderRadius.circular(50)),
                              child: Image.asset("assets/outtale.png"),
                            )),
                        // GestureDetector(
                        //   onTap: () {
                        //     bookController.last();
                        //   },
                        //   child: Container(
                        //     alignment: Alignment.center,
                        //     width: MediaQuery.of(context).size.height > 600
                        //         ? 60
                        //         : 40,
                        //     height: MediaQuery.of(context).size.height > 600
                        //         ? 60
                        //         : 40,
                        //     decoration: BoxDecoration(
                        //         boxShadow: const [
                        //           BoxShadow(
                        //             color: Color(0x19000000),
                        //             blurRadius: 10,
                        //             offset: Offset(0, 4),
                        //             spreadRadius: 0,
                        //           )
                        //         ],
                        //         color: Colors.white,
                        //         borderRadius: BorderRadius.circular(50)),
                        //     child: const FaIcon(FontAwesomeIcons.angleLeft),
                        //   ),
                        // ),
                        Row(
                          children: [
                            Localizations.localeOf(context).toString() == "ko"
                                ? GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isEnglish = !isEnglish;
                                      });
                                    },
                                    child: Container(
                                        alignment: Alignment.center,
                                        width:
                                            MediaQuery.of(context).size.height >
                                                    600
                                                ? 60
                                                : 40,
                                        height:
                                            MediaQuery.of(context).size.height >
                                                    600
                                                ? 60
                                                : 40,
                                        decoration: BoxDecoration(
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Color(0x19000000),
                                                blurRadius: 10,
                                                offset: Offset(0, 4),
                                                spreadRadius: 0,
                                              )
                                            ],
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(50)),
                                        child: isEnglish
                                            ? const Text("한글")
                                            : const Text("영어")))
                                : Container(),
                            // const SizedBox(
                            //   width: 30,
                            // ),
                            // GestureDetector(
                            //     onTap: () async {
                            //       // flutterTts.speak(widget.texts[0]
                            //       //     [bookController.currentIndex]);
                            //       final voicesResponse =
                            //           await TtsGoogle.getVoices();

                            //       //Print all available voices

                            //       //Pick an English Voice
                            //       final voice = voicesResponse.voices
                            //           .where((element) =>
                            //               element.locale.code.startsWith("ko-"))
                            //           .toList(growable: false)
                            //           .first;
                            //       const text =
                            //           '<speak> Google Speech Service Text-to-Speech API is awesome! </speak>';

                            //       TtsParamsGoogle params = TtsParamsGoogle(
                            //           voice: voice,
                            //           audioFormat: AudioOutputFormatGoogle.mp3,
                            //           text: text,
                            //           // text: widget.texts[0]
                            //           //     [bookController.currentIndex],
                            //           rate: 'slow', // optional
                            //           pitch: 'default' // optional
                            //           );
                            //       final ttsResponse =
                            //           await TtsGoogle.convertTts(params);
                            //       final audioByte =
                            //           ttsResponse.audio.buffer.asByteData();
                            //     },
                            //     child: Container(
                            //         alignment: Alignment.center,
                            //         width:
                            //             MediaQuery.of(context).size.height > 600
                            //                 ? 60
                            //                 : 40,
                            //         height:
                            //             MediaQuery.of(context).size.height > 600
                            //                 ? 60
                            //                 : 40,
                            //         decoration: BoxDecoration(
                            //             boxShadow: const [
                            //               BoxShadow(
                            //                 color: Color(0x19000000),
                            //                 blurRadius: 10,
                            //                 offset: Offset(0, 4),
                            //                 spreadRadius: 0,
                            //               )
                            //             ],
                            //             color: Colors.white,
                            //             borderRadius:
                            //                 BorderRadius.circular(50)),
                            //         child: const Text("듣기"))),
                            // const SizedBox(
                            //   width: 30,
                            // ),
                            // GestureDetector(
                            //   onTap: () {
                            //     bookController.next();
                            //   },
                            //   child: Container(
                            //     alignment: Alignment.center,
                            //     width: MediaQuery.of(context).size.height > 600
                            //         ? 60
                            //         : 40,
                            //     height: MediaQuery.of(context).size.height > 600
                            //         ? 60
                            //         : 40,
                            //     decoration: BoxDecoration(
                            //         boxShadow: const [
                            //           BoxShadow(
                            //             color: Color(0x19000000),
                            //             blurRadius: 10,
                            //             offset: Offset(0, 4),
                            //             spreadRadius: 0,
                            //           )
                            //         ],
                            //         color: Colors.white,
                            //         borderRadius: BorderRadius.circular(50)),
                            //     child:
                            //         const FaIcon(FontAwesomeIcons.angleRight),
                            //   ),
                            // ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
