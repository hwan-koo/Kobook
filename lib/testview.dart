import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:bookfx/bookfx.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crepas/profile/playingStatus.dart';
import 'package:crepas/profile/setting_view_model.dart';
import 'package:crepas/profile/voice_setting.dart';
import 'package:crepas/profile/voice_setting_view_model.dart';
import 'package:crepas/quizs/quiz_main.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';
import 'package:kakao_flutter_sdk_share/kakao_flutter_sdk_share.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'apiPaths.dart';

class TestViewer extends ConsumerStatefulWidget {
  final List<String> images;
  final List<dynamic> texts;
  final String userID;
  final String timeStamp;
  final Map<String, dynamic> taleData;
  final String title;
  final String userType;
  const TestViewer(
      {super.key,
      required this.images,
      required this.texts,
      required this.userID,
      required this.timeStamp,
      required this.taleData,
      required this.title,
      required this.userType});

  @override
  TestViewerState createState() => TestViewerState();
}

List<String> images = [];
final _textController = TextEditingController();

class TestViewerState extends ConsumerState<TestViewer>
    with SingleTickerProviderStateMixin {
  bool _visible = false;
  BookController bookController = BookController();
  bool get isiOS =>
      foundation.defaultTargetPlatform == foundation.TargetPlatform.iOS;
  late AnimationController _controller;
  late Animation<Color?> _iconColor;

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
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _iconColor = ColorTween(
      begin: const Color(0xff468aff),
      end: const Color(0xffC8DCFF),
    ).animate(_controller);
  }

  _asyncMethod() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      prefs.setBool("${widget.timeStamp}_isRead", true);
      ref.read(playingStatusProvider.notifier).setIsPlaying(false);
    }
  }

  @override
  void dispose() {
    // 세로 화면 고정
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    _controller.dispose();
    player.dispose();

    super.dispose();
  }

  Map<String, dynamic> quizData = {};
  bool isLoading = false;
  final player = AudioPlayer();

  Future<void> requestQuiz() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final String? value = prefs.getString('jwt');
      var headersList = {
        'Authorization': "Bearer $value",
        'Content-Type': 'application/json'
      };
      var url = Uri.parse(requestQuizURL);

      var body = {"time_stamp": widget.timeStamp, "user_id": widget.userID};

      var req = http.Request('POST', url);
      req.headers.addAll(headersList);
      req.body = json.encode(body);

      var res = await req.send();
      final resBody = await res.stream.bytesToString();

      if (res.statusCode >= 200 && res.statusCode < 300) {
        print(resBody);
        setState(() {
          quizData = jsonDecode(resBody);
          isLoading = false;
        });
      } else {
        print(res.reasonPhrase);
      }
    } catch (e) {
      final value = await FirebaseAuth.instance.currentUser!.getIdToken();
      await prefs.setString('jwt', value!);

      var headersList = {
        'Authorization': "Bearer $value",
        'Content-Type': 'application/json'
      };
      var url = Uri.parse(requestQuizURL);
      var body = {"time_stamp": widget.timeStamp, "user_id": widget.userID};
      var req = http.Request('POST', url);
      req.headers.addAll(headersList);
      req.body = json.encode(body);

      var res = await req.send();
      final resBody = await res.stream.bytesToString();
      if (res.statusCode >= 200 && res.statusCode < 300) {
        print(resBody);
        setState(() {
          quizData = jsonDecode(resBody);
          isLoading = false;
        });
      } else {
        print(res.reasonPhrase);
      }
    }
  }

  alertEditComplete() async {
    return await showDialog(
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
                const Text("스토리 수정 완료!",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color(0xff468AFF)),
                        child: const Text("확인",
                            style: TextStyle(
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

  alertNoTTS() async {
    return await showDialog(
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
                const Text("현재 재생 서비스 이용이 어려워요",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color(0xff468AFF)),
                        child: const Text("확인",
                            style: TextStyle(
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
  Future<void> rerollImage(String pageNum) async {
    FirebaseAnalytics.instance.logEvent(name: "RerollImage");
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    print("페이지 넘버는 $pageNum");

    try {
      final String? value = prefs.getString('jwt');
      var headersList = {
        'Authorization': "Bearer $value",
        'Content-Type': 'application/json'
      };
      var url = Uri.parse(pageRerollURL);

// datetime type: str!!!
      var body = {
        "time_stamp": widget.timeStamp,
        "user_id": widget.userID,
        "page_num": pageNum
      };

      var req = http.Request('POST', url);
      req.headers.addAll(headersList);
      req.body = json.encode(body);

      var res = await req.send();
      final resBody = await res.stream.bytesToString();

      if (res.statusCode >= 200 && res.statusCode < 300) {
        print(resBody);
        widget.images[int.parse(pageNum) - 1] = jsonDecode(resBody)["img_url"];
        setState(() {});
      } else {
        print(res.reasonPhrase);
      }
    } catch (e) {
      final value = await FirebaseAuth.instance.currentUser!.getIdToken();
      await prefs.setString('jwt', value!);

      var headersList = {
        'Authorization': "Bearer $value",
        'Content-Type': 'application/json'
      };
      var url = Uri.parse(pageRerollURL);
      var body = {
        "time_stamp": widget.timeStamp,
        "user_id": widget.userID,
        "page_num": pageNum
      };
      var req = http.Request('POST', url);
      req.headers.addAll(headersList);
      req.body = json.encode(body);

      var res = await req.send();
      final resBody = await res.stream.bytesToString();
      if (res.statusCode >= 200 && res.statusCode < 300) {
        print(resBody);
        widget.images[int.parse(pageNum) - 1] = jsonDecode(resBody)["img_url"];
        setState(() {});
      } else {
        print(res.reasonPhrase);
      }
    }
  }

  callVoice(encText) async {
    FirebaseAnalytics.instance.logEvent(name: "callTTS");
    ref.read(playingStatusProvider.notifier).setIsPlaying(true);
    final response = await http.post(
      Uri.parse(callVoiceUrl),
      headers: {
        'X-NCP-APIGW-API-KEY-ID': "8agelm8e1k",
        'X-NCP-APIGW-API-KEY': "0y9AZxiidABDWTg3MK1hwP4kbtrPBG2jpbAHB9IA",
        "Content-Type": "application/x-www-form-urlencoded"
      },
      body: Localizations.localeOf(context).toString() == "ko"
          ? isEnglish
              ? {
                  'speaker': "clara",
                  'volume': '0',
                  'speed': "0",
                  'pitch': '0',
                  'text': encText,
                  'format': 'mp3',
                }
              : {
                  'speaker': ref.watch(voiceSettingProvider).gender == 0
                      ? "vmikyung"
                      : ref.watch(voiceSettingProvider).gender == 1
                          ? "vdaeseong"
                          : "vdain",
                  'volume': '0',
                  'speed': ref.watch(voiceSettingProvider).speed == 0
                      ? "2"
                      : ref.watch(voiceSettingProvider).speed == 1
                          ? "0"
                          : "-2",
                  'pitch': '0',
                  "emotion": ref.watch(voiceSettingProvider).emotion == 0
                      ? "2"
                      : ref.watch(voiceSettingProvider).emotion == 1
                          ? "1"
                          : "3",
                  'text': encText,
                  'format': 'mp3',
                }
          : {
              'speaker': "clara",
              'volume': '0',
              'speed': "0",
              'pitch': '0',
              'text': encText,
              'format': 'mp3',
            },
    );

    if (response.statusCode == 200) {
      print("TTS 전송 성공!");
      Uint8List audioData = response.bodyBytes;

      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/temp.mp3').create();
      await file.writeAsBytes(audioData);
      await player.setFilePath(file.path);
      player.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          print("음성 재생 끝");
          ref.read(playingStatusProvider.notifier).setIsPlaying(false);

          // file.delete();
        }
      });
      await player.play();

      // var duration = await player.getDuration();

      // print(player.state.toString());
    } else {
      print('API 호출 실패: ${response.statusCode}');
      alertNoTTS();
    }
  }

  Future<void> editText(String pageNum) async {
    FirebaseAnalytics.instance.logEvent(name: "EditTaleText");
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    print("페이지 넘버는 $pageNum");

    try {
      final String? value = prefs.getString('jwt');
      var headersList = {
        'Authorization': "Bearer $value",
        'Content-Type': 'application/json'
      };
      var url = Uri.parse(editTextURL);

// datetime type: str!!!
      var body = {
        "time_stamp": widget.timeStamp,
        "user_id": widget.userID,
        "page_num": pageNum,
        "text": _textController.text
      };

      var req = http.Request('POST', url);
      req.headers.addAll(headersList);
      req.body = json.encode(body);

      var res = await req.send();
      final resBody = await res.stream.bytesToString();

      if (res.statusCode >= 200 && res.statusCode < 300) {
        print(resBody);
        isEnglish
            ? widget.texts[1][int.parse(pageNum) - 1] = _textController.text
            : Localizations.localeOf(context).toString() == "ko"
                ? widget.texts[0][int.parse(pageNum) - 1] = _textController.text
                : widget.texts[1][int.parse(pageNum) - 1] =
                    _textController.text;
        setState(() {});
      } else {
        print(res.reasonPhrase);
      }
    } catch (e) {
      final value = await FirebaseAuth.instance.currentUser!.getIdToken();
      await prefs.setString('jwt', value!);

      var headersList = {
        'Authorization': "Bearer $value",
        'Content-Type': 'application/json'
      };
      var url = Uri.parse(editTextURL);
      var body = {
        "time_stamp": widget.timeStamp,
        "user_id": widget.userID,
        "page_num": pageNum,
        "text": _textController.text
      };
      var req = http.Request('POST', url);
      req.headers.addAll(headersList);
      req.body = json.encode(body);

      var res = await req.send();
      final resBody = await res.stream.bytesToString();
      if (res.statusCode >= 200 && res.statusCode < 300) {
        print(resBody);
        isEnglish
            ? widget.texts[1][int.parse(pageNum) - 1] = _textController.text
            : widget.texts[0][int.parse(pageNum) - 1] = _textController.text;
        setState(() {});
      } else {
        print(res.reasonPhrase);
      }
    }
  }

  bool _isEdit = false;
  bool _isEditStroy = false;
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
                        // Airbridge.trackEvent("requestQuiz");
                        FirebaseAnalytics.instance
                            .logEvent(name: "SampleTaleClick");
                        setState(() {
                          isLoading = true;
                        });
                        await requestQuiz();
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
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
                              userID: widget.userID,
                              timeStamp: widget.timeStamp,
                              quizData: quizData,
                              title: widget.title,
                              taleData: widget.taleData,
                              userType: widget.userType,
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
                        // Airbridge.trackEvent("shareTale");
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
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   iconTheme: const IconThemeData(color: Colors.black),
      //   elevation: 0,
      // ),
      // extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: BookFx(
                  lastCallBack: (index) {
                    player.stop();
                    ref
                        .read(playingStatusProvider.notifier)
                        .setIsPlaying(false);

                    if (!ref.watch(playbackConfigProvider).muted) {
                      // AudioPlayer().play(AssetSource('turnpage.mp3'));
                    }
                  },
                  nextCallBack: (index) {
                    player.stop();
                    ref
                        .read(playingStatusProvider.notifier)
                        .setIsPlaying(false);

                    if (!ref.watch(playbackConfigProvider).muted) {
                      // AudioPlayer().play(AssetSource('turnpage.mp3'));
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
                                child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl: widget.images[index],
                                    placeholder: (context, url) =>
                                        const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error))),
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
                                                  text: _isEditStroy
                                                      ? ""
                                                      : isEnglish
                                                          ? widget.texts[1]
                                                              [index]
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
                                child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl: widget.images[index],
                                    placeholder: (context, url) =>
                                        const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error))),
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
                                                  text: _isEditStroy
                                                      ? ""
                                                      : isEnglish
                                                          ? widget.texts[1]
                                                              [index]
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
            _isEdit
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        _isEdit = false;
                      });
                    },
                    child: Stack(
                      children: [
                        BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                          child: Container(
                            color: Colors.black.withOpacity(0),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          decoration: BoxDecoration(
                            color: const Color(0xff000000).withOpacity(0.8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 30, horizontal: 50),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                        onTap: () {
                                          // context.pushReplacement("/mybook");
                                          Navigator.of(context).popUntil(
                                              (route) => route.isFirst);
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          width: MediaQuery.of(context)
                                                      .size
                                                      .height >
                                                  600
                                              ? 60
                                              : 40,
                                          height: MediaQuery.of(context)
                                                      .size
                                                      .height >
                                                  600
                                              ? 60
                                              : 40,
                                          decoration: BoxDecoration(
                                              boxShadow: const [],
                                              color: Colors.transparent,
                                              borderRadius:
                                                  BorderRadius.circular(50)),
                                          child: Container(),
                                        )),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 264,
                                          height: 156,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    _isEdit = false;
                                                  });
                                                },
                                                child: Container(
                                                    alignment: Alignment.center,
                                                    width:
                                                        MediaQuery.of(context)
                                                                    .size
                                                                    .height >
                                                                600
                                                            ? 60
                                                            : 40,
                                                    height:
                                                        MediaQuery.of(context)
                                                                    .size
                                                                    .height >
                                                                600
                                                            ? 60
                                                            : 40,
                                                    decoration: BoxDecoration(
                                                        boxShadow: const [
                                                          BoxShadow(
                                                            color: Color(
                                                                0x19000000),
                                                            blurRadius: 10,
                                                            offset:
                                                                Offset(0, 4),
                                                            spreadRadius: 0,
                                                          )
                                                        ],
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50)),
                                                    child: const FaIcon(
                                                      FontAwesomeIcons.xmark,
                                                    )),
                                              ),
                                              const SizedBox(
                                                height: 24,
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    _isEdit = false;
                                                    _isEditStroy = true;
                                                  });
                                                  isEnglish
                                                      ? _textController.text =
                                                          widget.texts[1][
                                                              bookController
                                                                  .currentIndex]
                                                      : Localizations.localeOf(context)
                                                                  .toString() ==
                                                              "ko"
                                                          ? _textController.text =
                                                              widget.texts[0][
                                                                  bookController
                                                                      .currentIndex]
                                                          : _textController.text =
                                                              widget.texts[1]
                                                                  [bookController.currentIndex];
                                                },
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  width: 106,
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      border: Border.all(
                                                          width: 1,
                                                          color: const Color(
                                                              0xff468aff)),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              40)),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Image.asset(
                                                        "assets/penIcon.png",
                                                        width: 20,
                                                        height: 20,
                                                        color: const Color(
                                                            0xff468aff),
                                                      ),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        Localizations.localeOf(
                                                                        context)
                                                                    .toString() ==
                                                                "ko"
                                                            ? "스토리 수정"
                                                            : "Edit Story",
                                                        style: const TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 12,
                                              ),
                                              GestureDetector(
                                                onTap: () async {
                                                  await rerollImage(
                                                      "${bookController.currentIndex + 1}");
                                                  setState(() {
                                                    _isEdit = true;
                                                  });
                                                },
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  width: 106,
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      border: Border.all(
                                                          width: 1,
                                                          color: const Color(
                                                              0xff468aff)),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              40)),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Image.asset(
                                                        "assets/rerollImage.png",
                                                        width: 20,
                                                        height: 20,
                                                      ),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        Localizations.localeOf(
                                                                        context)
                                                                    .toString() ==
                                                                "ko"
                                                            ? "그림 바꾸기"
                                                            : "Picture Change",
                                                        style: const TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        // const SizedBox(
                                        //   width: 16,
                                        // ),
                                        // Localizations.localeOf(context)
                                        //             .toString() ==
                                        //         "ko"
                                        //     ? Container(
                                        //         alignment: Alignment.center,
                                        //         width: MediaQuery.of(context)
                                        //                     .size
                                        //                     .height >
                                        //                 600
                                        //             ? 60
                                        //             : 40,
                                        //         height: MediaQuery.of(context)
                                        //                     .size
                                        //                     .height >
                                        //                 600
                                        //             ? 60
                                        //             : 40,
                                        //         decoration: BoxDecoration(
                                        //             boxShadow: const [],
                                        //             color: Colors.transparent,
                                        //             borderRadius:
                                        //                 BorderRadius.circular(50)),
                                        //         child: Container(),
                                        //       )
                                        //     : Container(),
                                        // const SizedBox(
                                        //   width: 16,
                                        // ),
                                        // Container(
                                        //     alignment: Alignment.center,
                                        //     width:
                                        //         MediaQuery.of(context).size.height >
                                        //                 600
                                        //             ? 60
                                        //             : 40,
                                        //     height:
                                        //         MediaQuery.of(context).size.height >
                                        //                 600
                                        //             ? 60
                                        //             : 40,
                                        //     decoration: BoxDecoration(
                                        //         boxShadow: const [],
                                        //         color: Colors.transparent,
                                        //         borderRadius:
                                        //             BorderRadius.circular(50)),
                                        //     child: Container()),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _isEdit = false;
                                        });
                                      },
                                      child: Container(
                                          alignment: Alignment.center,
                                          width: MediaQuery.of(context)
                                                      .size
                                                      .height >
                                                  600
                                              ? 60
                                              : 40,
                                          height: MediaQuery.of(context)
                                                      .size
                                                      .height >
                                                  600
                                              ? 60
                                              : 40,
                                          decoration: BoxDecoration(
                                              boxShadow: const [],
                                              color: Colors.transparent,
                                              borderRadius:
                                                  BorderRadius.circular(50)),
                                          child: Container()),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : _isEditStroy
                    ? SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 30, horizontal: 50),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                              1 /
                                              2 -
                                          50),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                            1 /
                                            2 -
                                        50,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 50),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  isEnglish
                                                      ? _textController.text =
                                                          widget.texts[1][
                                                              bookController
                                                                  .currentIndex]
                                                      : Localizations.localeOf(context)
                                                                  .toString() ==
                                                              "ko"
                                                          ? _textController.text =
                                                              widget.texts[0][
                                                                  bookController
                                                                      .currentIndex]
                                                          : _textController.text =
                                                              widget.texts[1]
                                                                  [bookController.currentIndex];
                                                },
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  width: MediaQuery.of(context)
                                                              .size
                                                              .height >
                                                          600
                                                      ? 60
                                                      : 40,
                                                  height: MediaQuery.of(context)
                                                              .size
                                                              .height >
                                                          600
                                                      ? 60
                                                      : 40,
                                                  decoration: BoxDecoration(
                                                      boxShadow: const [
                                                        BoxShadow(
                                                          color:
                                                              Color(0x19000000),
                                                          blurRadius: 10,
                                                          offset: Offset(0, 4),
                                                          spreadRadius: 0,
                                                        )
                                                      ],
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50)),
                                                  child: const FaIcon(
                                                      FontAwesomeIcons
                                                          .rotateRight),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () async {
                                                  setState(() {
                                                    _isEdit = false;
                                                    _isEditStroy = false;
                                                  });
                                                  alertEditComplete();
                                                  await editText(
                                                      "${bookController.currentIndex + 1}");
                                                },
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  width: 130,
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                      color: const Color(
                                                          0xff468aff),
                                                      border: Border.all(
                                                          width: 1,
                                                          color: const Color(
                                                              0xff468aff)),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              40)),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      const FaIcon(
                                                        FontAwesomeIcons.pen,
                                                        color: Colors.white,
                                                        size: 18,
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(
                                                        Localizations.localeOf(
                                                                        context)
                                                                    .toString() ==
                                                                "ko"
                                                            ? "저장하기"
                                                            : "Save",
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.white),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          TextField(
                                            style: const TextStyle(
                                              shadows: [
                                                Shadow(
                                                    color: Color(0xff468aff),
                                                    offset: Offset(0, -5))
                                              ],
                                              fontFamily: "Yeongdeok",
                                              fontSize: 20,
                                              color: Colors.transparent,
                                              decoration:
                                                  TextDecoration.underline,
                                              decorationColor:
                                                  Color(0xffB4D4FE),
                                              decorationThickness: 1,
                                              decorationStyle:
                                                  TextDecorationStyle.dashed,
                                            ),
                                            maxLines: 7,
                                            controller: _textController,
                                            decoration: const InputDecoration(
                                                border: InputBorder.none,
                                                focusedBorder:
                                                    InputBorder.none),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _isEdit = true;
                                        _isEditStroy = false;
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
                                      child: const FaIcon(
                                        FontAwesomeIcons.xmark,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      )
                    : SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 30, horizontal: 50),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                      onTap: () {
                                        // context.pushReplacement("/mybook");
                                        Navigator.of(context)
                                            .popUntil((route) => route.isFirst);
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
                                            color: const Color(0xff333A44),
                                            borderRadius:
                                                BorderRadius.circular(50)),
                                        child:
                                            Image.asset("assets/outtale.png"),
                                      )),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Row(
                                        children: [
                                          widget.userType == "me"
                                              ? GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      _isEdit = true;
                                                    });
                                                  },
                                                  child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      width:
                                                          MediaQuery.of(context)
                                                                      .size
                                                                      .height >
                                                                  600
                                                              ? 60
                                                              : 40,
                                                      height:
                                                          MediaQuery.of(context)
                                                                      .size
                                                                      .height >
                                                                  600
                                                              ? 60
                                                              : 40,
                                                      decoration: BoxDecoration(
                                                          boxShadow: const [
                                                            BoxShadow(
                                                              color: Color(
                                                                  0x19000000),
                                                              blurRadius: 10,
                                                              offset:
                                                                  Offset(0, 4),
                                                              spreadRadius: 0,
                                                            )
                                                          ],
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      50)),
                                                      child: Image.asset(
                                                        "assets/penIcon.png",
                                                        width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height >
                                                                600
                                                            ? 32
                                                            : 18,
                                                        height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height >
                                                                600
                                                            ? 32
                                                            : 18,
                                                      )),
                                                )
                                              : Container(),
                                          const SizedBox(
                                            width: 16,
                                          ),
                                          Localizations.localeOf(context)
                                                      .toString() ==
                                                  "ko"
                                              ? GestureDetector(
                                                  onTap: () {
                                                    FirebaseAnalytics.instance
                                                        .logEvent(
                                                            name:
                                                                "TaleEnglish");
                                                    setState(() {
                                                      isEnglish = !isEnglish;
                                                    });
                                                  },
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    width:
                                                        MediaQuery.of(context)
                                                                    .size
                                                                    .height >
                                                                600
                                                            ? 60
                                                            : 40,
                                                    height:
                                                        MediaQuery.of(context)
                                                                    .size
                                                                    .height >
                                                                600
                                                            ? 60
                                                            : 40,
                                                    decoration: BoxDecoration(
                                                        boxShadow: const [
                                                          BoxShadow(
                                                            color: Color(
                                                                0x19000000),
                                                            blurRadius: 10,
                                                            offset:
                                                                Offset(0, 4),
                                                            spreadRadius: 0,
                                                          )
                                                        ],
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50)),
                                                    child: isEnglish
                                                        ? const Text(
                                                            "한글",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 14),
                                                          )
                                                        : const Text("영어",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 14)),
                                                  ))
                                              : Container(),
                                          const SizedBox(
                                            width: 16,
                                          ),

                                          AnimatedBuilder(
                                            animation: _iconColor,
                                            builder: (BuildContext context,
                                                Widget? child) {
                                              return GestureDetector(
                                                  onTap: () async {
                                                    setState(() {
                                                      _visible = true;
                                                    });
                                                    Future.delayed(
                                                        const Duration(
                                                            seconds: 3), () {
                                                      setState(() {
                                                        _visible = false;
                                                      });
                                                    });

                                                    if (player.playing) {
                                                      player.stop();
                                                      ref
                                                          .read(
                                                              playingStatusProvider
                                                                  .notifier)
                                                          .setIsPlaying(false);
                                                    } else {
                                                      await callVoice(isEnglish
                                                          ? widget.texts[1][
                                                              bookController
                                                                  .currentIndex]
                                                          : Localizations.localeOf(
                                                                          context)
                                                                      .toString() ==
                                                                  "ko"
                                                              ? widget.texts[0][
                                                                  bookController
                                                                      .currentIndex]
                                                              : widget.texts[1][
                                                                  bookController
                                                                      .currentIndex]);
                                                    }
                                                  },
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    width:
                                                        MediaQuery.of(context)
                                                                    .size
                                                                    .height >
                                                                600
                                                            ? 60
                                                            : 40,
                                                    height:
                                                        MediaQuery.of(context)
                                                                    .size
                                                                    .height >
                                                                600
                                                            ? 60
                                                            : 40,
                                                    decoration: BoxDecoration(
                                                        boxShadow: const [
                                                          BoxShadow(
                                                            color: Color(
                                                                0x19000000),
                                                            blurRadius: 10,
                                                            offset:
                                                                Offset(0, 4),
                                                            spreadRadius: 0,
                                                          )
                                                        ],
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50)),
                                                    child: Image.asset(
                                                      "assets/ttsStart.png",
                                                      width:
                                                          MediaQuery.of(context)
                                                                      .size
                                                                      .height >
                                                                  600
                                                              ? 30
                                                              : 20,
                                                      height:
                                                          MediaQuery.of(context)
                                                                      .size
                                                                      .height >
                                                                  600
                                                              ? 30
                                                              : 20.74,
                                                      color: ref
                                                              .watch(
                                                                  playingStatusProvider)
                                                              .isPlaying
                                                          ? _iconColor.value
                                                          : Colors.black,
                                                    ),
                                                  ));
                                            },
                                          ),

                                          // const SizedBox(
                                          //   width: 30,
                                          // ),
                                          // GestureDetector(
                                          //   onTap: () {
                                          //     bookController.next();
                                          //   },
                                          //   child: Container(
                                          //     alignment: Alignment.center,
                                          //     width: MediaQuery.of(context)
                                          //                 .size
                                          //                 .height >
                                          //             600
                                          //         ? 60
                                          //         : 40,
                                          //     height: MediaQuery.of(context)
                                          //                 .size
                                          //                 .height >
                                          //             600
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
                                          //         borderRadius:
                                          //             BorderRadius.circular(50)),
                                          //     child: const FaIcon(
                                          //         FontAwesomeIcons.angleRight),
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 14,
                                      ),
                                      Localizations.localeOf(context)
                                                  .toString() ==
                                              "ko"
                                          ? Row(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            const VoiceSettingScreen(
                                                          comeSource: 'tale',
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: _visible
                                                      ? const Text("설정",
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              color: Color(
                                                                  0xffA3C5FF),
                                                              decoration:
                                                                  TextDecoration
                                                                      .underline))
                                                      : const Text(""),
                                                ),
                                                _visible
                                                    ? const Text(
                                                        "에서 다양한 음성으로 설정할 수 있어요",
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color: Color(
                                                                0xffA3C5FF)),
                                                      )
                                                    : const Text(""),
                                              ],
                                            )
                                          : Container(),
                                    ],
                                  ),
                                  // GestureDetector(
                                  //     onTap: () async {
                                  //       await rerollImage("$_index");
                                  //     },
                                  //     child: FaIcon(FontAwesomeIcons.rotate,
                                  //         size: MediaQuery.of(context).size.width > 600
                                  //             ? 36
                                  //             : 18)),
                                ],
                              ),
                              // Row(
                              //   mainAxisAlignment:
                              //       MainAxisAlignment.spaceBetween,
                              //   children: [
                              //     GestureDetector(
                              //       onTap: () {
                              //         bookController.last();
                              //       },
                              //       child: Container(
                              //         alignment: Alignment.centerLeft,
                              //         width: 100,
                              //         height: 100,
                              //         child: FaIcon(
                              //           FontAwesomeIcons.chevronLeft,
                              //           size: 50,
                              //           color: Colors.black.withOpacity(0.2),
                              //         ),
                              //       ),
                              //     ),
                              // GestureDetector(
                              //   onTap: () {
                              //     bookController.next();
                              //   },
                              //   child: Container(
                              //     alignment: Alignment.centerRight,
                              //     width: 100,
                              //     height: 100,
                              //     child: FaIcon(
                              //       FontAwesomeIcons.chevronRight,
                              //       size: 50,
                              //       color: Colors.black.withOpacity(0.2),
                              //     ),
                              //   ),
                              // )
                              //   ],
                              // ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      bookController.next();
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
                                      child: const FaIcon(
                                        FontAwesomeIcons.angleRight,
                                        size: 22,
                                        color: Color(0xff468aff),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
            isLoading
                ? SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Stack(
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
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
