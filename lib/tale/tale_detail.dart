import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:crepas/apiPaths.dart';
import 'package:crepas/quizs/quiz_main.dart';
import 'package:crepas/testview.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kakao_flutter_sdk_share/kakao_flutter_sdk_share.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'new_tales.dart';
import 'package:fluttertoast/fluttertoast.dart';

// ignore: must_be_immutable
class TaleDetail extends ConsumerStatefulWidget {
  final String thumbnail;
  String title;
  final Map<String, dynamic> taleData;
  final String userId;
  final String timeStamp;
  TaleDetail(
      {super.key,
      required this.thumbnail,
      required this.title,
      required this.taleData,
      required this.userId,
      required this.timeStamp});

  @override
  TaleDetailState createState() => TaleDetailState();
}

class TaleDetailState extends ConsumerState<TaleDetail> {
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
  late int likeNum = int.parse(widget.taleData["like_num"]);
  bool isHelp = false;
  Map<String, dynamic> quizData = {};
  bool isLoading = false;

  _asyncMethod() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        isLike = prefs.getBool("${widget.timeStamp}_isLike") ?? false;
        isRead = prefs.getBool("${widget.timeStamp}_isRead") ?? false;
      });
    }
  }

  Future<void> requestQuiz() async {
    // Airbridge.trackEvent("requestQuiz");
    FirebaseAnalytics.instance.logEvent(name: "RequestQuiz");
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final String? value = prefs.getString('jwt');
      var headersList = {
        'Authorization': "Bearer $value",
        'Content-Type': 'application/json'
      };
      var url = Uri.parse(requestQuizURL);

      var body = {"time_stamp": widget.timeStamp, "user_id": widget.userId};

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
      var body = {"time_stamp": widget.timeStamp, "user_id": widget.userId};
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

  _like() async {
    FirebaseAnalytics.instance.logEvent(name: "TaleLike");
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isLike = true;
      likeNum += 1;
    });

    try {
      final String? value = prefs.getString('jwt');
      var headersList = {
        'Authorization': "Bearer $value",
        'Content-Type': 'application/json'
      };
      var url = Uri.parse(likeURL);

      var body = {
        "time_stamp": widget.timeStamp,
        "user_id": widget.userId,
        "check": "0"
      };
      var req = http.Request('POST', url);
      req.headers.addAll(headersList);
      req.body = json.encode(body);

      var res = await req.send();
      final resBody = await res.stream.bytesToString();

      if (res.statusCode >= 200 && res.statusCode < 300) {
        print(resBody);
        await prefs.setBool("${widget.timeStamp}_isLike", true);
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
      var url = Uri.parse(likeURL);
      var req = http.Request('GET', url);
      req.headers.addAll(headersList);

      var res = await req.send();
      final resBody = await res.stream.bytesToString();
      if (res.statusCode >= 200 && res.statusCode < 300) {
        print(resBody);
        widget.taleData["like_num"] += 1;
        await prefs.setBool("${widget.timeStamp}_isLike", true);
        isLike = true;
        setState(() {});
      } else {
        print(res.reasonPhrase);
      }
    }
  }

  _disLike() async {
    FirebaseAnalytics.instance.logEvent(name: "TaleDisLike");
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isLike = false;
      likeNum -= 1;
    });

    try {
      final String? value = prefs.getString('jwt');
      var headersList = {
        'Authorization': "Bearer $value",
        'Content-Type': 'application/json'
      };
      var url = Uri.parse(likeURL);

      var body = {
        "time_stamp": widget.timeStamp,
        "user_id": widget.userId,
        "check": "1"
      };
      var req = http.Request('POST', url);
      req.headers.addAll(headersList);
      req.body = json.encode(body);

      var res = await req.send();
      final resBody = await res.stream.bytesToString();

      if (res.statusCode >= 200 && res.statusCode < 300) {
        print(resBody);
        await prefs.setBool("${widget.timeStamp}_isLike", false);
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
      var url = Uri.parse(likeURL);
      var body = {
        "time_stamp": widget.timeStamp,
        "user_id": widget.userId,
        "check": "1"
      };
      var req = http.Request('POST', url);
      req.headers.addAll(headersList);
      req.body = json.encode(body);

      var res = await req.send();
      final resBody = await res.stream.bytesToString();
      if (res.statusCode >= 200 && res.statusCode < 300) {
        print(resBody);
        await prefs.setBool("${widget.timeStamp}_isLike", false);
        setState(() {});
      } else {
        print(res.reasonPhrase);
      }
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
        actions: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // GestureDetector(
              //   onTap: () async {
              //     // Airbridge.trackEvent("shareTale");
              //     FirebaseAnalytics.instance.logEvent(name: "ShareTale");
              //     if (Localizations.localeOf(context).toString() == "ko") {
              //       _shareKakao([
              //         widget.taleData["1"][0],
              //         widget.taleData["2"][0],
              //         widget.taleData["3"][0]
              //       ]);
              //     } else {
              //       final box = context.findRenderObject() as RenderBox?;

              //       final http.Response responseData =
              //           await http.get(Uri.parse(widget.taleData["1"][0]));
              //       var uint8list = responseData.bodyBytes;
              //       var buffer = uint8list.buffer;
              //       ByteData byteData = ByteData.view(buffer);
              //       var tempDir = await getTemporaryDirectory();
              //       File file = await File('${tempDir.path}/img.jpg')
              //           .writeAsBytes(buffer.asUint8List(
              //               byteData.offsetInBytes, byteData.lengthInBytes));
              //       XFile files = XFile(file.path);

              //       Share.shareXFiles([files],
              //           subject: "AI Creates Children's Book",
              //           text:
              //               "Create a fairy tale with your child as the main character",
              //           sharePositionOrigin:
              //               box!.localToGlobal(Offset.zero) & box.size);
              //     }
              //   },
              //   child: FaIcon(
              //     FontAwesomeIcons.shareFromSquare,
              //     size: MediaQuery.of(context).size.width > 600 ? 32 : 18,
              //   ),
              // ),
              // SizedBox(
              //   width: MediaQuery.of(context).size.width > 600 ? 40 : 20,
              // ),
              isLike
                  ? GestureDetector(
                      onTap: () async {
                        await _disLike();
                      },
                      child: FaIcon(
                        FontAwesomeIcons.solidHeart,
                        color: const Color(0xffFF2C91),
                        size: MediaQuery.of(context).size.width > 600 ? 32 : 20,
                      ),
                    )
                  : GestureDetector(
                      onTap: () async {
                        await _like();
                      },
                      child: FaIcon(
                        FontAwesomeIcons.heart,
                        size: MediaQuery.of(context).size.width > 600 ? 32 : 20,
                      ),
                    ),
              SizedBox(
                width: MediaQuery.of(context).size.width > 600 ? 10 : 5,
              ),
              Text(
                "$likeNum",
                style: TextStyle(
                    fontSize:
                        MediaQuery.of(context).size.width > 600 ? 32 : 20),
              ),
              const SizedBox(
                width: 30,
              ),
            ],
          ),
        ],
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
                    image: CachedNetworkImageProvider(widget.thumbnail),
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
                            widget.title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width > 600
                                  ? 42
                                  : 32,
                              fontFamily: "TmoneyRoundWind",
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
                              fontSize: MediaQuery.of(context).size.width > 600
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
                  Container(
                    width: MediaQuery.of(context).size.width > 600
                        ? MediaQuery.of(context).size.width * 0.8
                        : MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width > 600 ? 150 : 110,
                    decoration: BoxDecoration(
                        color: const Color(0xff333A44).withOpacity(0.8),
                        border: Border.all(
                            width: 1, color: const Color(0xff333A44)),
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        widget.taleData["summary"],
                        overflow: TextOverflow.ellipsis,
                        maxLines: MediaQuery.of(context).size.width > 600
                            ? 4
                            : Localizations.localeOf(context).toString() == "ko"
                                ? 4
                                : 4,
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
                                    setState(() {
                                      isLoading = true;
                                    });
                                    await requestQuiz();
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
                                        quizData: quizData,
                                        title: widget.title,
                                        taleData: widget.taleData,
                                        userType: 'notme',
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
                                            : "Read a fairy tale and you can take a quiz!",
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
                                      FaIcon(
                                        FontAwesomeIcons.circleInfo,
                                        size:
                                            MediaQuery.of(context).size.width >
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
                                  // Airbridge.trackEvent("shareTale");
                                  FirebaseAnalytics.instance
                                      .logEvent(name: "ShareTale");
                                  if (Localizations.localeOf(context)
                                          .toString() ==
                                      "ko") {
                                    _shareKakao([
                                      widget.taleData["1"][0],
                                      widget.taleData["2"][0],
                                      widget.taleData["3"][0]
                                    ]);
                                  } else {
                                    final box = context.findRenderObject()
                                        as RenderBox?;

                                    final http.Response responseData =
                                        await http.get(
                                            Uri.parse(widget.taleData["1"][0]));
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
              bottom: 20,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        FirebaseAnalytics.instance
                            .logEvent(name: "ReadOtherTale");
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
                            userType: 'notme',
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
                        // Airbridge.trackEvent("readOtherTale");
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
          isLoading
              ? Stack(
                  children: [
                    const Opacity(
                      opacity: 0.5,
                      child:
                          ModalBarrier(dismissible: false, color: Colors.black),
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
    );
  }
}
