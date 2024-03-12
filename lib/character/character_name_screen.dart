import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:crepas/apiPaths.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' as foundation;

import 'package:crepas/character/character_choice_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as imglib;

import '../profile/setting_view_model.dart';

class CharacterNameScreen extends ConsumerStatefulWidget {
  const CharacterNameScreen({
    super.key,
  });

  @override
  CharacterNameScreenState createState() => CharacterNameScreenState();
}

bool write = false;
String name = "";
Timer? _timer;

final loadingMessage = [
  "캐릭터의 눈, 코, 입을 그리고 있어요",
  "밑그림이 완성되고 있어요",
  "캐릭터를 색칠하고 있어요",
  "캐릭터에게 입힐 옷을 만들고 있어요",
  "캐릭터의 옷매무새를 정리하고 있어요",
  "캐릭터가 외출 준비를 하고 있어요",
];
final loadingMessageEn = [
  "drawing my character's eyes, nose, and mouth.",
  "The sketch is coming together",
  "Coloring a character",
  "making clothes for character",
  "organizing character's clothing.",
  "The character is getting ready to go out"
];

class CharacterNameScreenState extends ConsumerState<CharacterNameScreen>
    with TickerProviderStateMixin {
  final _textController = TextEditingController();
  late AnimationController controller1;
  late Animation<Color?> _colorTween;

  var time = 1;
  bool midError = false;
  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    controller1 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 45),
    )..addListener(() {
        setState(() {});
      });

    setState(() {
      _timer =
          Timer.periodic(const Duration(milliseconds: 1000), (timer) async {
        time += 1;
        if (time >= 5 && !isComplete) {
          await _getImage();
          if (time >= 91) {
            midError = true;
            isComplete = true;
          }
        }
      });
    });

    _colorTween =
        controller1.drive(ColorTween(begin: Colors.yellow, end: Colors.blue));

    controller1.forward();

    super.initState();
  }

  @override
  void dispose() {
    controller1.dispose();
    super.dispose();
  }

  bool isComplete = false;
  String characterName = "";
  Map characterData = {};
  String imageUrl = "";

  Future _getImage() async {
    final value = await FirebaseAuth.instance.currentUser!.getIdToken();
    var headersList = {
      'Authorization': "Bearer $value",
    };
    var url = Uri.parse(characterFirstGetURL);

    var req = http.Request('GET', url);
    req.headers.addAll(headersList);

    var res = await req.send();
    var resBody = await res.stream.bytesToString();

    if (res.statusCode >= 200 && res.statusCode < 300) {
      print(resBody);
      if (resBody != "Service Unavailable" &&
          resBody != "Internal Server Error") {
        setState(() {
          imageUrl = jsonDecode(resBody)['img_url'];
          isComplete = true;
        });
        controller1.fling(velocity: 0.0001);
        // controller2.value = controller1.value;
        // controller2.forward();
      }
    } else {
      print(res.reasonPhrase);
    }
  }

  final people = Random().nextInt(30) + 10;

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
                      ? "캐릭터를 만들고 있어요"
                      : "Now Creating a character..",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                    Localizations.localeOf(context).toString() == "ko"
                        ? "정말 그만하시겠어요?"
                        : "Are you sure stop?",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(
                  height: 20,
                ),
                Text(
                    Localizations.localeOf(context).toString() == "ko"
                        ? "입력한 캐릭터 정보는 저장되지 않아요"
                        : "The character information entered is not saved",
                    style: const TextStyle(
                        fontSize: 12, color: Color(0xff8B8B8B))),
                const SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isComplete = true;
                        });
                        Navigator.pop(context, true);
                        context.pushReplacement("/home");
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: 124,
                        height: 48,
                        child: Text(
                            Localizations.localeOf(context).toString() == "ko"
                                ? "그만할래요"
                                : "Stop Making",
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

  Future<Uint8List> getImage(url) async {
    Uri urll = Uri.parse(url);
    http.Response response = await http.get(
      urll,
    );
    return response.bodyBytes;
  }

  _onChoiceCharacter() async {
    setState(() {
      isLoading = true;
    });
    final pleaseSplit = await getImage(imageUrl);
    final output = splitImage(pleaseSplit);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CharacterChoiceFinalScreen(
          image: output,
          name: name,
        ),
      ),
    );
  }

  List<Image> output = <Image>[];

  List<Image> splitImage(img) {
    imglib.Image image = imglib.decodePng(img)!;
    List<imglib.Image> parts = <imglib.Image>[];
    int x = 0, y = 0;
    int width = (image.width / 2).round();
    int height = (image.height / 2).round();
    for (int i = 0; i < 2; i++) {
      for (int j = 0; j < 2; j++) {
        parts.add(
            imglib.copyCrop(image, x: x, y: y, width: width, height: height));
        x += width;
      }
      x = 0;
      y += height;
    }

    for (var img in parts) {
      output.add(Image.memory(imglib.encodeJpg(img)));
    }

    return output;
  }

  bool get isiOS =>
      foundation.defaultTargetPlatform == foundation.TargetPlatform.iOS;
  var isLoading = false;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return _onBackKey();
      },
      child: Scaffold(
        appBar: isiOS
            ? AppBar(
                backgroundColor: isLoading || midError
                    ? Colors.black.withOpacity(0.5)
                    : Colors.white,
                toolbarOpacity: isLoading || midError ? 0.5 : 1.0,
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
        body: Stack(
          children: [
            GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: SafeArea(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: SingleChildScrollView(
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
                                  Localizations.localeOf(context).toString() ==
                                          "ko"
                                      ? "캐릭터를 만드는 동안"
                                      : "Give your character a name",
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width >
                                                  600
                                              ? 32
                                              : 20,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: -0.02,
                                      fontFamily: "TmoneyRoundWind"),
                                ),
                                Text(
                                  Localizations.localeOf(context).toString() ==
                                          "ko"
                                      ? "이름을 지어 주세요"
                                      : "while you're creating it",
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width >
                                                  600
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
                        const SizedBox(
                          height: 14,
                        ),
                        Text(
                          Localizations.localeOf(context).toString() == "ko"
                              ? "멋진 캐릭터를 만들기 위해"
                              : "It can take a minute or more",
                          style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width > 600
                                  ? 18
                                  : Localizations.localeOf(context)
                                              .toString() ==
                                          "ko"
                                      ? 12
                                      : 16,
                              color: const Color(0xff8B8B8B)),
                        ),
                        Text(
                          Localizations.localeOf(context).toString() == "ko"
                              ? "1분 이상 걸릴 수 있어요"
                              : "to create a great character",
                          style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width > 600
                                  ? 18
                                  : Localizations.localeOf(context)
                                              .toString() ==
                                          "ko"
                                      ? 12
                                      : 16,
                              color: const Color(0xff8B8B8B)),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.width * 80 / 360,
                        ),
                        Center(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 2 / 3,
                            height: MediaQuery.of(context).size.width * 2 / 3,
                            child:
                                Stack(alignment: Alignment.center, children: [
                              SizedBox(
                                width:
                                    MediaQuery.of(context).size.width * 2 / 3,
                                height:
                                    MediaQuery.of(context).size.width * 2 / 3,
                                child: const CircularProgressIndicator(
                                  color: Color(0xffDFDFDF),
                                  strokeWidth: 10,
                                  value: 1,
                                  // value: isComplete
                                  //     ? controller2.value
                                  //     : controller1.value,
                                ),
                              ),
                              SizedBox(
                                width:
                                    MediaQuery.of(context).size.width * 2 / 3,
                                height:
                                    MediaQuery.of(context).size.width * 2 / 3,
                                child: CircularProgressIndicator(
                                  strokeWidth: 10,
                                  value: controller1.value,
                                  // value: isComplete
                                  //     ? controller2.value
                                  //     : controller1.value,
                                  valueColor: _colorTween,
                                ),
                              ),
                              TextField(
                                maxLength: Localizations.localeOf(context)
                                            .toString() ==
                                        "ko"
                                    ? 6
                                    : 18,
                                controller: _textController,
                                onChanged: (text) {
                                  setState(() {
                                    name = text;
                                  });
                                },
                                decoration: InputDecoration(
                                    hintText: Localizations.localeOf(context)
                                                .toString() ==
                                            "ko"
                                        ? "이름을 작성해주세요"
                                        : "Write a name",
                                    hintStyle: const TextStyle(fontSize: 12),
                                    constraints: const BoxConstraints(
                                        maxHeight: 60, maxWidth: 160),
                                    suffixIcon: IconButton(
                                        onPressed: () {
                                          _textController.clear();
                                          setState(() {
                                            name = "";
                                          });
                                        },
                                        icon: _textController.text.isNotEmpty
                                            ? const FaIcon(FontAwesomeIcons
                                                .solidCircleXmark)
                                            : const FaIcon(
                                                FontAwesomeIcons.pen)),
                                    enabledBorder: const UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey))),
                              )
                            ]),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            AnimatedTextKit(
                              pause: const Duration(seconds: 2),
                              repeatForever: true,
                              animatedTexts: [
                                TypewriterAnimatedText(
                                    Localizations.localeOf(context)
                                                .toString() ==
                                            "ko"
                                        ? "밑그림을 그리고 있어요"
                                        : "sketching it out",
                                    speed: const Duration(milliseconds: 200),
                                    textStyle: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey)),
                                TypewriterAnimatedText(
                                    Localizations.localeOf(context)
                                                .toString() ==
                                            "ko"
                                        ? "캐릭터의 눈, 코, 입을 그리고 있어요"
                                        : "drawing my character's eyes, nose, and mouth.",
                                    speed: const Duration(milliseconds: 200),
                                    textStyle: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey)),
                                TypewriterAnimatedText(
                                    Localizations.localeOf(context)
                                                .toString() ==
                                            "ko"
                                        ? "캐릭터를 색칠하고 있어요"
                                        : "Coloring a character",
                                    speed: const Duration(milliseconds: 200),
                                    textStyle: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey)),
                                TypewriterAnimatedText(
                                    Localizations.localeOf(context)
                                                .toString() ==
                                            "ko"
                                        ? "캐릭터에게 입힐 옷을 만들고 있어요"
                                        : "making clothes for character",
                                    speed: const Duration(milliseconds: 200),
                                    textStyle: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey)),
                                TypewriterAnimatedText(
                                    Localizations.localeOf(context)
                                                .toString() ==
                                            "ko"
                                        ? "캐릭터의 옷매무새를 정리하고 있어요"
                                        : "organizing character's clothing.",
                                    speed: const Duration(milliseconds: 200),
                                    textStyle: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey)),
                                TypewriterAnimatedText(
                                    Localizations.localeOf(context)
                                                .toString() ==
                                            "ko"
                                        ? "캐릭터가 외출 준비를 하고 있어요"
                                        : "The character is getting ready to go out",
                                    speed: const Duration(milliseconds: 200),
                                    textStyle: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey)),
                                TypewriterAnimatedText(
                                    Localizations.localeOf(context)
                                                .toString() ==
                                            "ko"
                                        ? "캐릭터가 출발하고 있어요"
                                        : "The character is leaving",
                                    speed: const Duration(milliseconds: 200),
                                    textStyle: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey)),
                                TypewriterAnimatedText(
                                    Localizations.localeOf(context)
                                                .toString() ==
                                            "ko"
                                        ? "만들어진 캐릭터를 확인중이에요"
                                        : "Checking the created character",
                                    speed: const Duration(milliseconds: 200),
                                    textStyle: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey)),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 60,
                        ),
                        GestureDetector(
                          onTap: () async {
                            if (isComplete && name.isNotEmpty) {
                              if (!ref.watch(playbackConfigProvider).muted) {
                                AudioPlayer()
                                    .play(AssetSource('button_click.wav'));
                              }
                              await _onChoiceCharacter();
                            }
                          }, //활성화될때만 가능하게
                          child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 66,
                              decoration: ShapeDecoration(
                                color: isComplete && name.isNotEmpty
                                    ? Colors.blue
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
                                      isComplete && name.isNotEmpty
                                          ? Localizations.localeOf(context)
                                                      .toString() ==
                                                  "ko"
                                              ? "다음"
                                              : "Next"
                                          : Localizations.localeOf(context)
                                                      .toString() ==
                                                  "ko"
                                              ? "잠시만 기다려주세요"
                                              : "Wait for a minute",
                                      style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width >
                                                  600
                                              ? 20
                                              : 16,
                                          fontWeight: FontWeight.bold,
                                          color: isComplete && name.isNotEmpty
                                              ? Colors.white
                                              : const Color(0xffC1C1C1)),
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
                      )
                    ],
                  )
                : Container(),
            midError
                ? Stack(
                    children: [
                      const Opacity(
                        opacity: 0.5,
                        child: ModalBarrier(
                            dismissible: false, color: Colors.black),
                      ),
                      AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        backgroundColor: Colors.white,
                        title: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FaIcon(
                              FontAwesomeIcons.circleExclamation,
                              color: Colors.red,
                              size: 50,
                            )
                          ],
                        ),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              "현재 서비스 이용이 어렵습니다.",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const Text(
                              "다시 한 번 시도해주세요 🙇🏻",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isComplete = true;
                                    });
                                    Navigator.pop(context, true);
                                    Navigator.of(context)
                                        .popUntil((route) => route.isFirst);
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: 124,
                                    height: 48,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: const Color(0xff468AFF)),
                                    child: const Text("다시 만들래요",
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
                      ),
                    ],
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
