import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:crepas/apiPaths.dart';
import 'package:crepas/character/character_name_screen.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' as foundation;
import 'package:shared_preferences/shared_preferences.dart';

import '../profile/setting_view_model.dart';

class CharacterStyleScreen extends ConsumerStatefulWidget {
  final int age;
  final String gender;
  final sendImage;
  final String cloth;
  const CharacterStyleScreen(
      {super.key,
      required this.age,
      required this.gender,
      this.sendImage,
      required this.cloth});

  @override
  CharacterStyleScreenState createState() => CharacterStyleScreenState();
}

class CharacterStyleScreenState extends ConsumerState<CharacterStyleScreen> {
  // final styleImages = [
  //   "assets/drawingstyle/animation.png",
  //   "assets/drawingstyle/pixar.png",
  //   "assets/drawingstyle/children.png",
  //   "assets/drawingstyle/watercolor.png",
  //   "assets/drawingstyle/folkart.png",
  //   "assets/drawingstyle/pencilsketch.png",
  //   "assets/drawingstyle/asian.png",
  // ];
  final styleImages = [
    "assets/drawingstyle/children.png",
    "assets/drawingstyle/watercolor.png",
    "assets/drawingstyle/pencilsketch.png",
  ];
  // final styleName = [
  //   "Animation",
  //   "Pixar",
  //   "Children's book Illustration",
  //   "Water Color",
  //   "Folk Art",
  //   "Pencil Sketch",
  //   "Ukiyo-e",
  // ];
  final styleName = [
    "Children's book Illustration",
    "Water Color",
    "Pencil Sketch",
  ];
  // final styleText = ["애니메이션", "픽사", "동화", "수채화", "해외 동화", "손그림", "동양화"];
  final styleText = [
    "동화",
    "수채화",
    "손그림",
  ];

  final styleTextEn = ["Fairy Tale", "Water Color", "Drawing"];
  int _currentItem = 0;

  // Future _sendImage(presignedUrl) async {
  //   var headersList = {'Content-Type': 'application/octet-stream'};
  //   var url = Uri.parse(presignedUrl);

  //   var file = widget.sendImage;

  //   var body = await file.readAsBytes();
  //   var req = http.Request('PUT', url);
  //   req.headers.addAll(headersList);
  //   req.bodyBytes = body;

  //   var res = await req.send();
  //   final resBody = await res.stream.bytesToString();

  //   if (res.statusCode >= 200 && res.statusCode < 300) {
  //     print(resBody);
  //   } else {
  //     print(res.reasonPhrase);
  //   }
  // }

  Map characterData = {};

  _onCompleteCharacter() {
    setState(() {
      characterData['age'] = widget.age;
      characterData['gender'] = widget.gender;
      characterData['cloth'] = widget.cloth;
      characterData['style'] = styleName[_currentItem];
      if (Localizations.localeOf(context).toString() != "ko") {
        characterData['ver'] = "global";
      }
    });
  }

  Future apiRequest() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      _onCompleteCharacter();
      final String? value = prefs.getString('jwt');

      var headersList = {
        'Authorization': "Bearer $value",
        'Content-Type': 'application/json'
      };
      var url = Uri.parse(characerMakeURL);

      var body = characterData;

      var req = http.Request('POST', url);
      req.headers.addAll(headersList);
      req.body = json.encode(body);

      var res = await req.send();
      // final resBody = await res.stream.bytesToString();
      if (res.statusCode >= 200 && res.statusCode < 300) {
      } else {}
    } catch (e) {
      final value = await FirebaseAuth.instance.currentUser!.getIdToken();
      await prefs.setString('jwt', value!);
      _onCompleteCharacter();

      var headersList = {
        'Authorization': "Bearer $value",
        'Content-Type': 'application/json'
      };
      var url = Uri.parse(characerMakeURL);

      var body = characterData;

      var req = http.Request('POST', url);
      req.headers.addAll(headersList);
      req.body = json.encode(body);

      var res = await req.send();
      // final resBody = await res.stream.bytesToString();
      if (res.statusCode >= 200 && res.statusCode < 300) {
      } else {}
    }
  }

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    super.initState();
  }

  void _onNextName() async {
    // Airbridge.trackEvent("characterNaming");
    FirebaseAnalytics.instance.logEvent(name: "RequestCharacterMaking");

    if (!ref.watch(playbackConfigProvider).muted) {
      AudioPlayer().play(AssetSource('button_click.wav'));
    }
    setState(() {
      isLoading = true;
    });
    await apiRequest();

    // await _sendImage();
    if (!mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const CharacterNameScreen(),
      ),
    );
  }

  bool get isiOS =>
      foundation.defaultTargetPlatform == foundation.TargetPlatform.iOS;
  var isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isiOS
          ? AppBar(
              backgroundColor:
                  isLoading ? Colors.black.withOpacity(0.5) : Colors.white,
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
          Column(
            children: [
              SafeArea(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
                                    ? "캐릭터가 그려질"
                                    : "Choose a drawing style",
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width > 600
                                            ? 32
                                            : 20,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: -0.02,
                                    fontFamily: "TmoneyRoundWind"),
                              ),
                              Text(
                                Localizations.localeOf(context).toString() ==
                                        "ko"
                                    ? "그림체를 골라 주세요"
                                    : "for your character",
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width > 600
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
                      SizedBox(
                        height:
                            MediaQuery.of(context).size.width > 600 ? 40 : 22,
                      ),
                      CarouselSlider.builder(
                          itemCount: 3,
                          itemBuilder: (BuildContext context, index,
                                  realIndex) =>
                              GestureDetector(
                                onTap: _onNextName,
                                child: Container(
                                    decoration: ShapeDecoration(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    width: MediaQuery.of(context).size.width *
                                        240 /
                                        360,
                                    height: MediaQuery.of(context).size.height *
                                        0.7,
                                    child: Column(
                                      children: [
                                        Stack(
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.25,
                                              clipBehavior: Clip.antiAlias,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              child: Image.asset(
                                                styleImages[index],
                                                color: _currentItem == index
                                                    ? null
                                                    : Colors.white
                                                        .withOpacity(0.5),
                                                colorBlendMode:
                                                    BlendMode.modulate,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.25,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            Positioned(
                                              top: 10,
                                              left: 10,
                                              child: Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  Text(
                                                    Localizations.localeOf(
                                                                    context)
                                                                .toString() ==
                                                            "ko"
                                                        ? styleText[index]
                                                        : styleTextEn[index],
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontFamily:
                                                          "TmoneyRoundWind",
                                                      letterSpacing: 2,
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
                                                        ? styleText[index]
                                                        : styleTextEn[index],
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                      fontFamily:
                                                          "TmoneyRoundWind",
                                                      fontSize: 20,
                                                      letterSpacing: 2,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Color(0xff468aff),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              // child: Text(
                                              //   styleText[index],
                                              //   style: TextStyle(
                                              //       fontSize:
                                              //           MediaQuery.of(context)
                                              //                       .size
                                              //                       .width >
                                              //                   600
                                              //               ? 22
                                              //               : 16,
                                              //       fontWeight: FontWeight.bold,
                                              //       color: _currentItem == index
                                              //           ? Colors.deepOrange
                                              //           : Colors.black38),
                                              // ),
                                            )
                                          ],
                                        ),
                                      ],
                                    )),
                              ),
                          options: CarouselOptions(
                            viewportFraction: 0.4,
                            enlargeFactor: 0.4,
                            scrollDirection: Axis.vertical,
                            enlargeCenterPage: true,
                            height: MediaQuery.of(context).size.height * 0.7,
                            onPageChanged: (index, reason) {
                              _currentItem = index;
                              setState(() {});
                            },
                          )),
                    ],
                  ),
                ),
              ),
            ],
          ),
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
