import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:crepas/character/character_generate_screen.dart';
import 'package:crepas/character/models/character_view_model.dart';
import 'package:crepas/tale/type_select.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../apiPaths.dart';
import '../profile/setting_view_model.dart';

class TaleCharacterChoice extends ConsumerStatefulWidget {
  const TaleCharacterChoice({super.key});

  @override
  TaleCharacterChoiceState createState() => TaleCharacterChoiceState();
}

class TaleCharacterChoiceState extends ConsumerState<TaleCharacterChoice> {
  int _currentIndex = 0;
  String name = "";
  CarouselController carouselController = CarouselController();
  final _textController = TextEditingController();

  void _onCharacterGenerate() {
    if (!ref.watch(playbackConfigProvider).muted) {
      AudioPlayer().play(AssetSource('button_click.wav'));
    }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const CharacterGenerateScreen(),
      ),
    );
  }

  // int _currentIndex = 0;

  bool get isiOS =>
      foundation.defaultTargetPlatform == foundation.TargetPlatform.iOS;
  bool isFirst = false;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.initState();
    // SchedulerBinding.instance.addPostFrameCallback((_) {
    //   alertTale();
    // });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod();
    });
  }

  _asyncMethod() async {
    if (await _getCoin() == 0) {
      FirebaseAnalytics.instance.logEvent(name: "AlertNoCoin");
      alertCoin();
    }
  }

  _getCoin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      final String? value = prefs.getString('jwt');
      var headersList = {
        'Authorization': "Bearer $value",
      };
      var url = Uri.parse(getCoinURL);

      var req = http.Request('GET', url);
      req.headers.addAll(headersList);

      var res = await req.send();
      final resBody = await res.stream.bytesToString();

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final coin = jsonDecode(resBody)["coin_num"];
        print(coin);
        return coin;
      } else {}
    } catch (e) {
      final value = await FirebaseAuth.instance.currentUser!.getIdToken();
      await prefs.setString('jwt', value!);
      var headersList = {
        'Authorization': "Bearer $value",
      };
      var url = Uri.parse(getCoinURL);

      var req = http.Request('GET', url);
      req.headers.addAll(headersList);

      var res = await req.send();
      final resBody = await res.stream.bytesToString();

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final coin = jsonDecode(resBody)["coin_num"];
        print(coin);
        return coin;
      } else {}
    }
  }

  alertCoin() async {
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
                        ? "동화 생성 기회를 다 썻어요"
                        : "Use up creation opportunities",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(
                  height: 20,
                ),
                Text(
                    Localizations.localeOf(context).toString() == "ko"
                        ? "동화는 하루에"
                        : "create one fairy tale per day",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 16, color: Color(0xff8B8B8B))),
                Text(
                    Localizations.localeOf(context).toString() == "ko"
                        ? "한 번만 만들 수 있어요"
                        : "",
                    style: const TextStyle(
                        fontSize: 16, color: Color(0xff8B8B8B))),
                Text(
                    Localizations.localeOf(context).toString() == "ko"
                        ? "내일은 어떤 즐거움이 찾아올까요?"
                        : "What fun will tomorrow bring?",
                    style: const TextStyle(
                        fontSize: 16, color: Color(0xff8B8B8B))),
                const SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (!ref.watch(playbackConfigProvider).muted) {
                          AudioPlayer().play(AssetSource('button_click.wav'));
                        }
                        Navigator.pop(context, false);
                        context.pushReplacement("/mybook");
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
                                ? "알겠어요"
                                : "Okay",
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

  final boyandgirl = ["assets/girl.png", "assets/boy.png"];
  bool first = true;
  @override
  Widget build(BuildContext context) {
    return ref.watch(characterProviderModel).when(
        loading: () => Center(
              child: SpinKitSpinningCircle(
                itemBuilder: (context, index) {
                  return Center(
                    child: Image.asset("assets/turtle.png"),
                  );
                },
              ),
            ),
        error: (error, stackTrace) => Center(
              child: Text("$error 잠시 후 다시 시도해주세요"),
            ),
        data: (characters) {
          if (characters.isEmpty) {
            if (first) {
              Localizations.localeOf(context).toString() == "ko"
                  ? _textController.text = ["꼬미", "북이"][_currentIndex]
                  : _textController.text = ["Sophia", "James"][_currentIndex];
              setState(() {
                first = false;
              });
            }
          } else {
            if (first) {
              _textController.text = characters[characters.keys
                  .toList()[characters.length - _currentIndex - 1]]["name"];
              name = _textController.text;
              setState(() {
                first = false;
              });
            }
          }

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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
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
                                    width:
                                        MediaQuery.of(context).size.width > 600
                                            ? 200
                                            : 120,
                                    height:
                                        MediaQuery.of(context).size.width > 600
                                            ? 64
                                            : 32,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          Localizations.localeOf(context)
                                                      .toString() ==
                                                  "ko"
                                              ? "동화 만들기"
                                              : "Make Tale",
                                          style: TextStyle(
                                              fontSize: MediaQuery.of(context)
                                                          .size
                                                          .width >
                                                      600
                                                  ? 24
                                                  : Localizations.localeOf(
                                                                  context)
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
                                  if (!ref
                                      .watch(playbackConfigProvider)
                                      .muted) {
                                    AudioPlayer()
                                        .play(AssetSource('button_click.wav'));
                                  }
                                  Navigator.of(context)
                                      .popUntil((route) => route.isFirst);
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: Colors.white),
                                    width:
                                        MediaQuery.of(context).size.width > 600
                                            ? 200
                                            : 120,
                                    height:
                                        MediaQuery.of(context).size.width > 600
                                            ? 64
                                            : 32,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          Localizations.localeOf(context)
                                                      .toString() ==
                                                  "ko"
                                              ? "동화 읽기"
                                              : "Read Books",
                                          style: TextStyle(
                                              fontSize: MediaQuery.of(context)
                                                          .size
                                                          .width >
                                                      600
                                                  ? 24
                                                  : Localizations.localeOf(
                                                                  context)
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
                                    Localizations.localeOf(context)
                                                .toString() ==
                                            "ko"
                                        ? "동화의 주인공을"
                                        : "Choose main character",
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width >
                                                    600
                                                ? 32
                                                : 24,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: -0.02),
                                  ),
                                  Text(
                                    Localizations.localeOf(context)
                                                .toString() ==
                                            "ko"
                                        ? "선택해 주세요"
                                        : "in your fairy tale",
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width >
                                                    600
                                                ? 32
                                                : 24,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: -0.02),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: _onCharacterGenerate,
                                child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: const Color(0xff468AFF)),
                                    width: 120,
                                    height: 32,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.add_rounded,
                                          color: Colors.white,
                                        ),
                                        Text(
                                          Localizations.localeOf(context)
                                                      .toString() ==
                                                  "ko"
                                              ? "캐릭터 만들기"
                                              : "New Character",
                                          style: TextStyle(
                                              fontSize: Localizations.localeOf(
                                                              context)
                                                          .toString() ==
                                                      "ko"
                                                  ? 14
                                                  : 12,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        )
                                      ],
                                    )),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05,
                          ),
                          ref
                                  .watch(characterProviderModel.notifier)
                                  .character
                                  .isEmpty
                              ? Column(
                                  children: [
                                    Stack(
                                      children: [
                                        CarouselSlider.builder(
                                            carouselController:
                                                carouselController,
                                            itemCount: 2,
                                            itemBuilder: (BuildContext context,
                                                    index, realIndex) =>
                                                Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20)),
                                                    clipBehavior: Clip
                                                        .antiAliasWithSaveLayer,
                                                    child: Image.asset(
                                                      boyandgirl[index -
                                                          characters.length],
                                                      width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width >
                                                              600
                                                          ? MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              20 /
                                                              36
                                                          : MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              280 /
                                                              360,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              200 /
                                                              360,
                                                      fit: BoxFit.cover,
                                                    )),
                                            options: CarouselOptions(
                                              aspectRatio: 1,
                                              viewportFraction: 1,
                                              enableInfiniteScroll: false,
                                              height: MediaQuery.of(context)
                                                          .size
                                                          .width >
                                                      600
                                                  ? MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      20 /
                                                      36
                                                  : MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      28 /
                                                      36,
                                              enlargeCenterPage: true,
                                              onPageChanged: (index, reason) {
                                                setState(() {
                                                  _currentIndex = index;
                                                });

                                                if (index == 0) {
                                                  _textController.text =
                                                      Localizations.localeOf(
                                                                      context)
                                                                  .toString() ==
                                                              "ko"
                                                          ? "꼬미"
                                                          : "Sophia";
                                                  name = _textController.text;
                                                }
                                                if (index == 1) {
                                                  _textController.text =
                                                      Localizations.localeOf(
                                                                      context)
                                                                  .toString() ==
                                                              "ko"
                                                          ? "북이"
                                                          : "James";
                                                  name = _textController.text;
                                                }
                                              },
                                            )),
                                        _currentIndex == 0
                                            ? Container()
                                            : GestureDetector(
                                                onTap: () {
                                                  carouselController
                                                      .previousPage();
                                                },
                                                child: SizedBox(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  height: MediaQuery.of(context)
                                                              .size
                                                              .width >
                                                          600
                                                      ? MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          20 /
                                                          36
                                                      : MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          28 /
                                                          36,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Container(
                                                        alignment:
                                                            Alignment.center,
                                                        width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width >
                                                                600
                                                            ? 60
                                                            : 40,
                                                        height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width >
                                                                600
                                                            ? 60
                                                            : 40,
                                                        decoration: BoxDecoration(
                                                            boxShadow: const [
                                                              BoxShadow(
                                                                color: Color(
                                                                    0x19000000),
                                                                blurRadius: 10,
                                                                offset: Offset(
                                                                    0, 4),
                                                                spreadRadius: 0,
                                                              )
                                                            ],
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        50)),
                                                        child: const FaIcon(
                                                            FontAwesomeIcons
                                                                .angleLeft),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                        _currentIndex == characters.length + 1
                                            ? Container()
                                            : GestureDetector(
                                                onTap: () {
                                                  carouselController.nextPage();
                                                  // setState(() {
                                                  //   _currentIndex += 1;
                                                  // });
                                                },
                                                child: SizedBox(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  height: MediaQuery.of(context)
                                                              .size
                                                              .width >
                                                          600
                                                      ? MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          20 /
                                                          36
                                                      : MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          28 /
                                                          36,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Container(
                                                        alignment:
                                                            Alignment.center,
                                                        width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width >
                                                                600
                                                            ? 60
                                                            : 40,
                                                        height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width >
                                                                600
                                                            ? 60
                                                            : 40,
                                                        decoration: BoxDecoration(
                                                            boxShadow: const [
                                                              BoxShadow(
                                                                color: Color(
                                                                    0x19000000),
                                                                blurRadius: 10,
                                                                offset: Offset(
                                                                    0, 4),
                                                                spreadRadius: 0,
                                                              )
                                                            ],
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        50)),
                                                        child: const FaIcon(
                                                            FontAwesomeIcons
                                                                .angleRight),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 40,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        MediaQuery.of(context).size.width > 600
                                            ? Text(
                                                Localizations.localeOf(context)
                                                            .toString() ==
                                                        "ko"
                                                    ? "주인공의 이름은"
                                                    : "The main character's name is",
                                                style: const TextStyle(
                                                    fontSize: 24),
                                              )
                                            : Text(
                                                Localizations.localeOf(context)
                                                            .toString() ==
                                                        "ko"
                                                    ? "주인공의 이름은"
                                                    : "The main character's name is",
                                                style: const TextStyle(),
                                              ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        TextField(
                                          style: TextStyle(
                                              fontSize: MediaQuery.of(context)
                                                          .size
                                                          .width >
                                                      600
                                                  ? 24
                                                  : 16,
                                              fontWeight: FontWeight.bold,
                                              color: const Color(0xff468aff)),
                                          cursorHeight: 15,
                                          maxLength:
                                              Localizations.localeOf(context)
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
                                              counterText: "",
                                              constraints: const BoxConstraints(
                                                  maxHeight: 80, maxWidth: 160),
                                              suffixIcon: IconButton(
                                                  iconSize: 16,
                                                  onPressed: () {
                                                    _textController.clear();
                                                    setState(() {
                                                      name = "";
                                                    });
                                                  },
                                                  icon: _textController
                                                          .text.isNotEmpty
                                                      ? const FaIcon(
                                                          FontAwesomeIcons
                                                              .solidCircleXmark)
                                                      : const FaIcon(
                                                          FontAwesomeIcons
                                                              .pen)),
                                              enabledBorder:
                                                  const UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.grey))),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        MediaQuery.of(context).size.width > 600
                                            ? Text(
                                                Localizations.localeOf(context)
                                                            .toString() ==
                                                        "ko"
                                                    ? "예요"
                                                    : "",
                                                style: const TextStyle(
                                                    fontSize: 24),
                                              )
                                            : Text(
                                                Localizations.localeOf(context)
                                                            .toString() ==
                                                        "ko"
                                                    ? "예요"
                                                    : "")
                                      ],
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.width >
                                                  600
                                              ? 80
                                              : 20,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                BookTypeSelect(
                                              character_datetime:
                                                  _currentIndex >=
                                                          characters.length
                                                      ? "0"
                                                      : characters.keys
                                                              .toList()[
                                                          characters.length -
                                                              _currentIndex -
                                                              1],
                                              character_type: _currentIndex >=
                                                      characters.length
                                                  ? _currentIndex ==
                                                          characters.length
                                                      ? "2"
                                                      : "1"
                                                  : "0",
                                              character_name:
                                                  _textController.text,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                          width: MediaQuery.of(context)
                                                      .size
                                                      .width >
                                                  600
                                              ? MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.8
                                              : MediaQuery.of(context)
                                                  .size
                                                  .width,
                                          height: MediaQuery.of(context)
                                                      .size
                                                      .width >
                                                  600
                                              ? 90
                                              : 66,
                                          decoration: ShapeDecoration(
                                            color:
                                                _textController.text.isNotEmpty
                                                    ? const Color(0xff468AFF)
                                                    : const Color(0xffDFDFDF),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
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
                                                  Localizations.localeOf(
                                                                  context)
                                                              .toString() ==
                                                          "ko"
                                                      ? "다음"
                                                      : "Next",
                                                  style: TextStyle(
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                      .size
                                                                      .width >
                                                                  600
                                                              ? 22
                                                              : 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                                ),
                                              ],
                                            ),
                                          )),
                                    )
                                  ],
                                )
                              : Column(
                                  children: [
                                    Stack(
                                      children: [
                                        CarouselSlider.builder(
                                            carouselController:
                                                carouselController,
                                            itemCount: characters.length + 2,
                                            itemBuilder: (BuildContext context,
                                                    index, realIndex) =>
                                                Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20)),
                                                  clipBehavior: Clip
                                                      .antiAliasWithSaveLayer,
                                                  child:
                                                      index >= characters.length
                                                          ? Image.asset(
                                                              boyandgirl[index -
                                                                  characters
                                                                      .length])
                                                          : CachedNetworkImage(
                                                              imageUrl: characters[characters
                                                                  .keys
                                                                  .toList()[characters
                                                                      .length -
                                                                  index -
                                                                  1]]["img_url"],
                                                              width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width >
                                                                      600
                                                                  ? MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      20 /
                                                                      36
                                                                  : MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      280 /
                                                                      360,
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  200 /
                                                                  360,
                                                              fit: BoxFit.cover,
                                                            ),
                                                ),
                                            options: CarouselOptions(
                                              aspectRatio: 1,
                                              viewportFraction: 1,
                                              enableInfiniteScroll: false,
                                              height: MediaQuery.of(context)
                                                          .size
                                                          .width >
                                                      600
                                                  ? MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      20 /
                                                      36
                                                  : MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      28 /
                                                      36,
                                              enlargeCenterPage: true,
                                              onPageChanged: (index, reason) {
                                                setState(() {
                                                  _currentIndex = index;
                                                });
                                                if (index <=
                                                    characters.length - 1) {
                                                  _textController.text =
                                                      characters[characters.keys
                                                              .toList()[
                                                          characters.length -
                                                              _currentIndex -
                                                              1]]["name"];
                                                  name = _textController.text;
                                                }
                                                if (index ==
                                                    characters.length) {
                                                  _textController.text =
                                                      Localizations.localeOf(
                                                                      context)
                                                                  .toString() ==
                                                              "ko"
                                                          ? "꼬미"
                                                          : "Sophia";
                                                  name = _textController.text;
                                                }
                                                if (index ==
                                                    characters.length + 1) {
                                                  _textController.text =
                                                      Localizations.localeOf(
                                                                      context)
                                                                  .toString() ==
                                                              "ko"
                                                          ? "북이"
                                                          : "James";
                                                  name = _textController.text;
                                                }
                                              },
                                            )),
                                        _currentIndex == 0
                                            ? Container()
                                            : GestureDetector(
                                                onTap: () {
                                                  carouselController
                                                      .previousPage();
                                                },
                                                child: SizedBox(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  height: MediaQuery.of(context)
                                                              .size
                                                              .width >
                                                          600
                                                      ? MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          20 /
                                                          36
                                                      : MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          28 /
                                                          36,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Container(
                                                        alignment:
                                                            Alignment.center,
                                                        width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width >
                                                                600
                                                            ? 60
                                                            : 40,
                                                        height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width >
                                                                600
                                                            ? 60
                                                            : 40,
                                                        decoration: BoxDecoration(
                                                            boxShadow: const [
                                                              BoxShadow(
                                                                color: Color(
                                                                    0x19000000),
                                                                blurRadius: 10,
                                                                offset: Offset(
                                                                    0, 4),
                                                                spreadRadius: 0,
                                                              )
                                                            ],
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        50)),
                                                        child: const FaIcon(
                                                            FontAwesomeIcons
                                                                .angleLeft),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                        _currentIndex == characters.length + 1
                                            ? Container()
                                            : GestureDetector(
                                                onTap: () {
                                                  carouselController.nextPage();
                                                  // setState(() {
                                                  //   _currentIndex += 1;
                                                  // });
                                                },
                                                child: SizedBox(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  height: MediaQuery.of(context)
                                                              .size
                                                              .width >
                                                          600
                                                      ? MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          20 /
                                                          36
                                                      : MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          28 /
                                                          36,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Container(
                                                        alignment:
                                                            Alignment.center,
                                                        width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width >
                                                                600
                                                            ? 60
                                                            : 40,
                                                        height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width >
                                                                600
                                                            ? 60
                                                            : 40,
                                                        decoration: BoxDecoration(
                                                            boxShadow: const [
                                                              BoxShadow(
                                                                color: Color(
                                                                    0x19000000),
                                                                blurRadius: 10,
                                                                offset: Offset(
                                                                    0, 4),
                                                                spreadRadius: 0,
                                                              )
                                                            ],
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        50)),
                                                        child: const FaIcon(
                                                            FontAwesomeIcons
                                                                .angleRight),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 40,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        MediaQuery.of(context).size.width > 600
                                            ? Text(
                                                Localizations.localeOf(context)
                                                            .toString() ==
                                                        "ko"
                                                    ? "주인공의 이름은"
                                                    : "character's name is",
                                                style: const TextStyle(
                                                    fontSize: 24),
                                              )
                                            : Text(
                                                Localizations.localeOf(context)
                                                            .toString() ==
                                                        "ko"
                                                    ? "주인공의 이름은"
                                                    : "character's name is",
                                                style: const TextStyle(),
                                              ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        TextField(
                                          style: TextStyle(
                                              fontSize: MediaQuery.of(context)
                                                          .size
                                                          .width >
                                                      600
                                                  ? 24
                                                  : 16,
                                              fontWeight: FontWeight.bold,
                                              color: const Color(0xff468aff)),
                                          cursorHeight: 15,
                                          maxLength:
                                              Localizations.localeOf(context)
                                                          .toString() ==
                                                      "ko"
                                                  ? 6
                                                  : 16,
                                          controller: _textController,
                                          onChanged: (text) {
                                            setState(() {
                                              name = text;
                                            });
                                          },
                                          decoration: InputDecoration(
                                              counterText: "",
                                              constraints: const BoxConstraints(
                                                  maxHeight: 80, maxWidth: 160),
                                              suffixIcon: IconButton(
                                                  iconSize: 16,
                                                  onPressed: () {
                                                    _textController.clear();
                                                    setState(() {
                                                      name = "";
                                                    });
                                                  },
                                                  icon: _textController
                                                          .text.isNotEmpty
                                                      ? const FaIcon(
                                                          FontAwesomeIcons
                                                              .solidCircleXmark)
                                                      : const FaIcon(
                                                          FontAwesomeIcons
                                                              .pen)),
                                              enabledBorder:
                                                  const UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.grey))),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        MediaQuery.of(context).size.width > 600
                                            ? Text(
                                                Localizations.localeOf(context)
                                                            .toString() ==
                                                        "ko"
                                                    ? "예요"
                                                    : "",
                                                style: const TextStyle(
                                                    fontSize: 24),
                                              )
                                            : Text(
                                                Localizations.localeOf(context)
                                                            .toString() ==
                                                        "ko"
                                                    ? "예요"
                                                    : "")
                                      ],
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.width >
                                                  600
                                              ? 80
                                              : 20,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                BookTypeSelect(
                                              character_datetime:
                                                  _currentIndex >=
                                                          characters.length
                                                      ? "0"
                                                      : characters.keys
                                                              .toList()[
                                                          characters.length -
                                                              _currentIndex -
                                                              1],
                                              character_type: _currentIndex >=
                                                      characters.length
                                                  ? _currentIndex ==
                                                          characters.length
                                                      ? "2"
                                                      : "1"
                                                  : "0",
                                              character_name: name,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                          width: MediaQuery.of(context)
                                                      .size
                                                      .width >
                                                  600
                                              ? MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.8
                                              : MediaQuery.of(context)
                                                  .size
                                                  .width,
                                          height: MediaQuery.of(context)
                                                      .size
                                                      .width >
                                                  600
                                              ? 90
                                              : 66,
                                          decoration: ShapeDecoration(
                                            color:
                                                _textController.text.isNotEmpty
                                                    ? const Color(0xff468AFF)
                                                    : const Color(0xffDFDFDF),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
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
                                                  Localizations.localeOf(
                                                                  context)
                                                              .toString() ==
                                                          "ko"
                                                      ? "다음"
                                                      : "Next",
                                                  style: TextStyle(
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                      .size
                                                                      .width >
                                                                  600
                                                              ? 22
                                                              : 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                                ),
                                              ],
                                            ),
                                          )),
                                    )
                                  ],
                                )
                        ],
                      ),
                    ),
                  ),
                ),
              ));
        });
  }
}
