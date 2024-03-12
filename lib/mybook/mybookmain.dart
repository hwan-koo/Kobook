import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crepas/apiPaths.dart';
import 'package:crepas/tale/makingTime_view_model.dart';
import 'package:crepas/tale/making_tale.dart';
import 'package:crepas/tale/models/tale_view_model.dart';
import 'package:crepas/tale/tale_character_choice.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../profile/setting_view_model.dart';
import '../tale/myTale_detail.dart';

class MyBookMainScreen extends ConsumerStatefulWidget {
  const MyBookMainScreen({super.key});

  @override
  MyBookMainScreenState createState() => MyBookMainScreenState();
}

class MyBookMainScreenState extends ConsumerState<MyBookMainScreen> {
  _onTaleGenerate() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const TaleCharacterChoice(),
      ),
    );
  }

  Map<String, dynamic> taleData = {};

  final books = [
    "assets/books/bookblue.png",
    "assets/books/bookgreen.png",
    "assets/books/bookorange.png",
    "assets/books/bookpink.png",
    "assets/books/bookpurple.png",
    "assets/books/bookred.png",
  ];
  final openbooks = [
    "assets/books/openbookblue.png",
    "assets/books/openbookgreen.png",
    "assets/books/openbookorange.png",
    "assets/books/openbookpink.png",
    "assets/books/openbookpurple.png",
    "assets/books/openbookred.png",
  ];
  final openbooksEn = [
    "assets/books/openbookblueEn.png",
    "assets/books/openbookgreenEn.png",
    "assets/books/openbookorangeEn.png",
    "assets/books/openbookpinkEn.png",
    "assets/books/openbookpurpleEn.png",
    "assets/books/openbookredEn.png",
  ];

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    // ref.watch(taleProviderModel.notifier).build();
    super.initState();
  }

  bool isLoading = false;
  alertMaking() async {
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
            content: Localizations.localeOf(context).toString() == "ko"
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("동화를 만들고 있어요!",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text("동화는 한 번에",
                          style: TextStyle(
                              fontSize: 16, color: Color(0xff8B8B8B))),
                      const Text("하나만 만들 수 있어요",
                          style: TextStyle(
                              fontSize: 16, color: Color(0xff8B8B8B))),
                      const Text("다른 동화들을 둘러보세요!",
                          style: TextStyle(
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
                                AudioPlayer()
                                    .play(AssetSource('button_click.wav'));
                              }
                              Navigator.pop(context, false);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: 124,
                              height: 48,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: const Color(0xff468AFF)),
                              child: const Text("알겠어요",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                            ),
                          )
                        ],
                      )
                    ],
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("A fairy tale is in the making!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text("only create",
                          style: TextStyle(
                              fontSize: 16, color: Color(0xff8B8B8B))),
                      const Text("one fairy tale at a time",
                          style: TextStyle(
                              fontSize: 16, color: Color(0xff8B8B8B))),
                      const Text("Explore other fairy tales!",
                          style: TextStyle(
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
                                AudioPlayer()
                                    .play(AssetSource('button_click.wav'));
                              }
                              Navigator.pop(context, false);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: 124,
                              height: 48,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: const Color(0xff468AFF)),
                              child: const Text("Okay",
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

  @override
  Widget build(BuildContext context) {
    return ref.watch(taleProviderModel).when(
        loading: () => Center(
              child: SpinKitSpinningCircle(
                itemBuilder: (context, index) {
                  return Center(
                    child: Image.asset(
                      "assets/turtle.png",
                      fit: BoxFit.fill,
                      width: 200,
                      height: 200,
                    ),
                  );
                },
              ),
            ),
        error: (error, stackTrace) => Center(
              child: Text("$error 잠시 후 다시 시도해주세요"),
            ),
        data: (tales) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
              children: [
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 16),
                    child: ref.watch(taleProviderModel.notifier).tales.isEmpty
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                Localizations.localeOf(context).toString() ==
                                        "ko"
                                    ? "우리 아이가"
                                    : "If my child",
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width > 600
                                            ? 32
                                            : 24,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: -0.02),
                              ),
                              Text(
                                Localizations.localeOf(context).toString() ==
                                        "ko"
                                    ? "책에 나온다면?"
                                    : "is in My Book?",
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width > 600
                                            ? 32
                                            : 24,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: -0.02),
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.width > 600
                                    ? MediaQuery.of(context).size.height * 0.2
                                    : MediaQuery.of(context).size.width *
                                        158 /
                                        360,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        1 /
                                        2,
                                    height: MediaQuery.of(context).size.width *
                                        20 /
                                        36,
                                    child: Stack(
                                      children: [
                                        Image.asset(
                                          "assets/books/bookblue.png",
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              1 /
                                              2,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              20 /
                                              36,
                                        ),
                                        Container(
                                          alignment: Alignment.center,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                Localizations.localeOf(context)
                                                            .toString() ==
                                                        "ko"
                                                    ? "아직 만든 책이 없어요"
                                                    : "No books have been created yet",
                                                style: TextStyle(
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                    .size
                                                                    .width >
                                                                600
                                                            ? 24
                                                            : 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                              const SizedBox(
                                                height: 12,
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  if (!ref
                                                      .watch(
                                                          playbackConfigProvider)
                                                      .muted) {
                                                    AudioPlayer().play(
                                                        AssetSource(
                                                            'button_click.wav'));
                                                  }
                                                  _onTaleGenerate();
                                                },
                                                child: Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50),
                                                        color: const Color(
                                                            0xff468AFF)),
                                                    width: MediaQuery
                                                                    .of(context)
                                                                .size
                                                                .width >
                                                            600
                                                        ? 180
                                                        : 120,
                                                    height:
                                                        MediaQuery.of(context)
                                                                    .size
                                                                    .width >
                                                                600
                                                            ? 60
                                                            : 32,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        const Icon(
                                                          Icons.add_rounded,
                                                          color: Colors.white,
                                                        ),
                                                        Text(
                                                          Localizations.localeOf(
                                                                          context)
                                                                      .toString() ==
                                                                  "ko"
                                                              ? "새로 만들기"
                                                              : "New Book",
                                                          style: TextStyle(
                                                              fontSize: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width >
                                                                      600
                                                                  ? 18
                                                                  : 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white),
                                                        )
                                                      ],
                                                    )),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : tales[tales.keys.toList().last].length > 1
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          if (!ref
                                              .watch(playbackConfigProvider)
                                              .muted) {
                                            AudioPlayer().play(AssetSource(
                                                'button_click.wav'));
                                          }
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const TaleCharacterChoice()),
                                          );
                                        },
                                        child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                color: Colors.white),
                                            width: MediaQuery.of(context)
                                                        .size
                                                        .width >
                                                    600
                                                ? 200
                                                : 120,
                                            height: MediaQuery.of(context)
                                                        .size
                                                        .width >
                                                    600
                                                ? 64
                                                : 32,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  Localizations.localeOf(
                                                                  context)
                                                              .toString() ==
                                                          "ko"
                                                      ? "동화 만들기"
                                                      : "Make Tale",
                                                  style: TextStyle(
                                                      fontSize: MediaQuery.of(
                                                                      context)
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
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: const Color(
                                                          0xffC1C1C1)),
                                                )
                                              ],
                                            )),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          if (!ref
                                              .watch(playbackConfigProvider)
                                              .muted) {
                                            AudioPlayer().play(AssetSource(
                                                'button_click.wav'));
                                          }
                                        },
                                        child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                color: const Color(0xff468AFF)),
                                            width: MediaQuery.of(context)
                                                        .size
                                                        .width >
                                                    600
                                                ? 200
                                                : 120,
                                            height: MediaQuery.of(context)
                                                        .size
                                                        .width >
                                                    600
                                                ? 64
                                                : 32,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  Localizations.localeOf(
                                                                  context)
                                                              .toString() ==
                                                          "ko"
                                                      ? "동화 읽기"
                                                      : "Read Books",
                                                  style: TextStyle(
                                                      fontSize: MediaQuery.of(
                                                                      context)
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
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            Localizations.localeOf(context)
                                                        .toString() ==
                                                    "ko"
                                                ? "우리 아이가"
                                                : "Fairy tales",
                                            style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                            .size
                                                            .width >
                                                        600
                                                    ? 32
                                                    : 20,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: -0.02,
                                                fontFamily: "TmoneyRoundWind"),
                                          ),
                                          Text(
                                            Localizations.localeOf(context)
                                                        .toString() ==
                                                    "ko"
                                                ? "등장하는 동화"
                                                : "Featuring your child",
                                            style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                            .size
                                                            .width >
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
                                  SizedBox(
                                    height:
                                        MediaQuery.of(context).size.width > 600
                                            ? 60
                                            : 30,
                                  ),
                                  Expanded(
                                    child: RefreshIndicator(
                                      onRefresh: () async {
                                        await ref
                                            .watch(taleProviderModel.notifier)
                                            .fetchTale();
                                      },
                                      child: GridView.builder(
                                          shrinkWrap: true,
                                          itemCount: ref
                                              .watch(taleProviderModel.notifier)
                                              .tales
                                              .length,
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount:
                                                      MediaQuery.of(context)
                                                                  .size
                                                                  .width >
                                                              600
                                                          ? 3
                                                          : 2,
                                                  childAspectRatio:
                                                      MediaQuery.of(context)
                                                                  .size
                                                                  .width >
                                                              600
                                                          ? 140 / 190
                                                          : 140 / 180,
                                                  mainAxisSpacing: 28,
                                                  crossAxisSpacing: 28),
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return GestureDetector(
                                              onTap: () async {
                                                final SharedPreferences prefs =
                                                    await SharedPreferences
                                                        .getInstance();

                                                setState(() {
                                                  isLoading = true;
                                                });
                                                if (!ref
                                                    .watch(
                                                        playbackConfigProvider)
                                                    .muted) {
                                                  AudioPlayer().play(
                                                      AssetSource(
                                                          'button_click.wav'));
                                                }

                                                try {
                                                  final String? value =
                                                      prefs.getString('jwt');
                                                  final userID = tales[
                                                      tales.keys.toList()[
                                                          tales.length -
                                                              index -
                                                              1]]["user_id"];

                                                  var headersList = {
                                                    'Authorization':
                                                        "Bearer $value",
                                                    'Content-Type':
                                                        'application/json'
                                                  };
                                                  var url =
                                                      Uri.parse(getTaleDetail);
                                                  final data =
                                                      Localizations.localeOf(
                                                                      context)
                                                                  .toString() ==
                                                              "ko"
                                                          ? {
                                                              "user_id": userID,
                                                              "time_stamp": tales
                                                                      .keys
                                                                      .toList()[
                                                                  tales.length -
                                                                      index -
                                                                      1],
                                                            }
                                                          : {
                                                              "user_id": userID,
                                                              "time_stamp": tales
                                                                      .keys
                                                                      .toList()[
                                                                  tales.length -
                                                                      index -
                                                                      1],
                                                              "ver": "global"
                                                            };

                                                  var body = data;

                                                  var req =
                                                      http.Request('POST', url);
                                                  req.headers
                                                      .addAll(headersList);
                                                  req.body = json.encode(body);

                                                  var res = await req.send();
                                                  final resBody = await res
                                                      .stream
                                                      .bytesToString();
                                                  if (res.statusCode >= 200 &&
                                                      res.statusCode < 300) {
                                                    setState(() {
                                                      taleData =
                                                          jsonDecode(resBody);
                                                      isLoading = false;
                                                    });
                                                  } else {}
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          MyTaleDetail(
                                                        thumbnail: tales[
                                                            tales.keys.toList()[
                                                                tales.length -
                                                                    index -
                                                                    1]]["1"],
                                                        title: tales[tales.keys
                                                                .toList()[
                                                            tales.length -
                                                                index -
                                                                1]]["title"],
                                                        taleData: taleData,
                                                        userId: tales[tales.keys
                                                                .toList()[
                                                            tales.length -
                                                                index -
                                                                1]]["user_id"],
                                                        timeStamp:
                                                            tales.keys.toList()[
                                                                tales.length -
                                                                    index -
                                                                    1],
                                                      ),
                                                    ),
                                                  );
                                                } catch (e) {
                                                  final value =
                                                      await FirebaseAuth
                                                          .instance.currentUser!
                                                          .getIdToken();
                                                  await prefs.setString(
                                                      'jwt', value!);
                                                  final userID = tales[
                                                      tales.keys.toList()[
                                                          tales.length -
                                                              index -
                                                              1]]["user_id"];

                                                  var headersList = {
                                                    'Authorization':
                                                        "Bearer $value",
                                                    'Content-Type':
                                                        'application/json'
                                                  };
                                                  var url =
                                                      Uri.parse(getTaleDetail);
                                                  final data =
                                                      Localizations.localeOf(
                                                                      context)
                                                                  .toString() ==
                                                              "ko"
                                                          ? {
                                                              "user_id": userID,
                                                              "time_stamp": tales
                                                                      .keys
                                                                      .toList()[
                                                                  tales.length -
                                                                      index -
                                                                      1],
                                                            }
                                                          : {
                                                              "user_id": userID,
                                                              "time_stamp": tales
                                                                      .keys
                                                                      .toList()[
                                                                  tales.length -
                                                                      index -
                                                                      1],
                                                              "ver": "global"
                                                            };

                                                  var body = data;

                                                  var req =
                                                      http.Request('POST', url);
                                                  req.headers
                                                      .addAll(headersList);
                                                  req.body = json.encode(body);

                                                  var res = await req.send();
                                                  final resBody = await res
                                                      .stream
                                                      .bytesToString();

                                                  if (res.statusCode >= 200 &&
                                                      res.statusCode < 300) {
                                                    setState(() {
                                                      taleData =
                                                          jsonDecode(resBody);
                                                      isLoading = false;
                                                    });
                                                  } else {}

                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          MyTaleDetail(
                                                        thumbnail: tales[
                                                            tales.keys.toList()[
                                                                tales.length -
                                                                    index -
                                                                    1]]["1"],
                                                        title: tales[tales.keys
                                                                .toList()[
                                                            tales.length -
                                                                index -
                                                                1]]["title"],
                                                        taleData: taleData,
                                                        userId: tales[tales.keys
                                                                .toList()[
                                                            tales.length -
                                                                index -
                                                                1]]["user_id"],
                                                        timeStamp:
                                                            tales.keys.toList()[
                                                                tales.length -
                                                                    index -
                                                                    1],
                                                      ),
                                                    ),
                                                  );
                                                }
                                              },
                                              child: Stack(
                                                children: [
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            140 /
                                                            360,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            190 /
                                                            360,
                                                    child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              140 /
                                                              360,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              180 /
                                                              360,
                                                      decoration: BoxDecoration(
                                                          image: DecorationImage(
                                                              image: Image.asset(books[int.parse(tales[tales
                                                                      .keys
                                                                      .toList()[tales
                                                                          .length -
                                                                      index -
                                                                      1]]["num"])])
                                                                  .image)),
                                                      child: Padding(
                                                        padding: EdgeInsets.only(
                                                            left: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width >
                                                                    600
                                                                ? 18
                                                                : 26,
                                                            top: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width >
                                                                    600
                                                                ? 16
                                                                : 14,
                                                            right: 14),
                                                        child: Column(
                                                          children: [
                                                            Container(
                                                              width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width >
                                                                      600
                                                                  ? MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      90 /
                                                                      360
                                                                  : MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      100 /
                                                                      360,
                                                              height: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width >
                                                                      600
                                                                  ? MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      90 /
                                                                      360
                                                                  : MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      100 /
                                                                      360,
                                                              clipBehavior: Clip
                                                                  .antiAlias,
                                                              decoration: BoxDecoration(
                                                                  border: Border.all(
                                                                      width: 3,
                                                                      color: Colors
                                                                          .white),
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                          10),
                                                                  image: DecorationImage(
                                                                      image: CachedNetworkImageProvider(tales[tales
                                                                          .keys
                                                                          .toList()[tales
                                                                              .length -
                                                                          index -
                                                                          1]]["1"]),
                                                                      fit: BoxFit.cover)),
                                                            ),
                                                            SizedBox(
                                                              height: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width >
                                                                      600
                                                                  ? 10
                                                                  : 5,
                                                            ),
                                                            Text(
                                                              tales[tales.keys
                                                                  .toList()[tales
                                                                      .length -
                                                                  index -
                                                                  1]]["title"],
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      MediaQuery.of(context).size.width >
                                                                              600
                                                                          ? 18
                                                                          : 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .white,
                                                                  fontFamily:
                                                                      "TmoneyRoundWind"),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  index == 0
                                                      ? Positioned(
                                                          right: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              8 /
                                                              360,
                                                          top: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width >
                                                                  600
                                                              ? MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  -2 /
                                                                  360
                                                              : MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  -2 /
                                                                  360,
                                                          child: Image.asset(
                                                            "assets/badge_new.png",
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                38 /
                                                                360,
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                18 /
                                                                360,
                                                          ))
                                                      : Container()
                                                ],
                                              ),
                                            );
                                          }),
                                    ),
                                  )
                                ],
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          if (!ref
                                              .watch(playbackConfigProvider)
                                              .muted) {
                                            AudioPlayer().play(AssetSource(
                                                'button_click.wav'));
                                          }
                                          alertMaking();
                                        },
                                        child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                color: Colors.white),
                                            width: MediaQuery.of(context)
                                                        .size
                                                        .width >
                                                    600
                                                ? 200
                                                : 120,
                                            height: MediaQuery.of(context)
                                                        .size
                                                        .width >
                                                    600
                                                ? 64
                                                : 32,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  Localizations.localeOf(
                                                                  context)
                                                              .toString() ==
                                                          "ko"
                                                      ? "동화 만들기"
                                                      : "Make Tale",
                                                  style: TextStyle(
                                                      fontSize: MediaQuery.of(
                                                                      context)
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
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: const Color(
                                                          0xffC1C1C1)),
                                                )
                                              ],
                                            )),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          if (!ref
                                              .watch(playbackConfigProvider)
                                              .muted) {
                                            AudioPlayer().play(AssetSource(
                                                'button_click.wav'));
                                          }
                                        },
                                        child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                color: const Color(0xff468AFF)),
                                            width: MediaQuery.of(context)
                                                        .size
                                                        .width >
                                                    600
                                                ? 200
                                                : 120,
                                            height: MediaQuery.of(context)
                                                        .size
                                                        .width >
                                                    600
                                                ? 64
                                                : 32,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  Localizations.localeOf(
                                                                  context)
                                                              .toString() ==
                                                          "ko"
                                                      ? "동화 읽기"
                                                      : "Read Books",
                                                  style: TextStyle(
                                                      fontSize: MediaQuery.of(
                                                                      context)
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
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            Localizations.localeOf(context)
                                                        .toString() ==
                                                    "ko"
                                                ? "우리 아이가"
                                                : "Fairy tales",
                                            style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                            .size
                                                            .width >
                                                        600
                                                    ? 32
                                                    : 20,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: -0.02,
                                                fontFamily: "TmoneyRoundWind"),
                                          ),
                                          Text(
                                            Localizations.localeOf(context)
                                                        .toString() ==
                                                    "ko"
                                                ? "등장하는 동화"
                                                : "Featuring your child",
                                            style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                            .size
                                                            .width >
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
                                  SizedBox(
                                    height:
                                        MediaQuery.of(context).size.width > 600
                                            ? 60
                                            : 30,
                                  ),
                                  Expanded(
                                    child: RefreshIndicator(
                                      onRefresh: () async {
                                        await ref
                                            .watch(taleProviderModel.notifier)
                                            .fetchTale();
                                      },
                                      child: GridView.builder(
                                          shrinkWrap: true,
                                          itemCount: ref
                                              .watch(taleProviderModel.notifier)
                                              .tales
                                              .length,
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount:
                                                      MediaQuery.of(context)
                                                                  .size
                                                                  .width >
                                                              600
                                                          ? 3
                                                          : 2,
                                                  childAspectRatio:
                                                      MediaQuery.of(context)
                                                                  .size
                                                                  .width >
                                                              600
                                                          ? 140 / 190
                                                          : 140 / 180,
                                                  mainAxisSpacing: 28,
                                                  crossAxisSpacing: 28),
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return GestureDetector(
                                              onTap: () {
                                                if (!ref
                                                    .watch(
                                                        playbackConfigProvider)
                                                    .muted) {
                                                  AudioPlayer().play(
                                                      AssetSource(
                                                          'button_click.wav'));
                                                }
                                              },
                                              child: index == 0
                                                  ? GestureDetector(
                                                      onTap: () {
                                                        if (!ref
                                                            .watch(
                                                                playbackConfigProvider)
                                                            .muted) {
                                                          AudioPlayer().play(
                                                              AssetSource(
                                                                  'button_click.wav'));
                                                        }
                                                        if (tales[tales.keys
                                                                    .toList()
                                                                    .last]
                                                                .length ==
                                                            1) {
                                                          Navigator.of(context)
                                                              .push(
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        const MakingTale()),
                                                          );
                                                        }
                                                      },
                                                      child: Stack(
                                                        children: [
                                                          Image.asset(
                                                            Localizations.localeOf(
                                                                            context)
                                                                        .toString() ==
                                                                    "ko"
                                                                ? openbooks[int.parse(tales[tales
                                                                        .keys
                                                                        .toList()
                                                                        .last]
                                                                    ["num"])]
                                                                : openbooksEn[int.parse(
                                                                    tales[tales
                                                                        .keys
                                                                        .toList()
                                                                        .last]["num"])],
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                140 /
                                                                360,
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                180 /
                                                                360,
                                                          ),
                                                          Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  140 /
                                                                  360,
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  180 /
                                                                  360,
                                                              child: Text(
                                                                Localizations.localeOf(context)
                                                                            .toString() ==
                                                                        "ko"
                                                                    ? "${ref.watch(makingTimeProvider).completeTime} 완성 예정!"
                                                                    : "${ref.watch(makingTimeProvider).completeTime} To Be Completed!",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        MediaQuery.of(context).size.width >
                                                                                600
                                                                            ? 18
                                                                            : 12),
                                                              ))
                                                        ],
                                                      ),
                                                    )
                                                  : GestureDetector(
                                                      onTap: () async {
                                                        final SharedPreferences
                                                            prefs =
                                                            await SharedPreferences
                                                                .getInstance();

                                                        setState(() {
                                                          isLoading = true;
                                                        });
                                                        if (!ref
                                                            .watch(
                                                                playbackConfigProvider)
                                                            .muted) {
                                                          AudioPlayer().play(
                                                              AssetSource(
                                                                  'button_click.wav'));
                                                        }

                                                        try {
                                                          final String? value =
                                                              prefs.getString(
                                                                  'jwt');
                                                          final userID = tales[
                                                              tales
                                                                  .keys
                                                                  .toList()[tales
                                                                      .length -
                                                                  index -
                                                                  1]]["user_id"];

                                                          var headersList = {
                                                            'Authorization':
                                                                "Bearer $value",
                                                            'Content-Type':
                                                                'application/json'
                                                          };
                                                          var url = Uri.parse(
                                                              getTaleDetail);
                                                          final data = Localizations
                                                                          .localeOf(
                                                                              context)
                                                                      .toString() ==
                                                                  "ko"
                                                              ? {
                                                                  "user_id":
                                                                      userID,
                                                                  "time_stamp": tales
                                                                      .keys
                                                                      .toList()[tales
                                                                          .length -
                                                                      index -
                                                                      1],
                                                                }
                                                              : {
                                                                  "user_id":
                                                                      userID,
                                                                  "time_stamp": tales
                                                                      .keys
                                                                      .toList()[tales
                                                                          .length -
                                                                      index -
                                                                      1],
                                                                  "ver":
                                                                      "global"
                                                                };

                                                          var body = data;

                                                          var req =
                                                              http.Request(
                                                                  'POST', url);
                                                          req.headers.addAll(
                                                              headersList);
                                                          req.body =
                                                              json.encode(body);

                                                          var res =
                                                              await req.send();
                                                          final resBody = await res
                                                              .stream
                                                              .bytesToString();
                                                          if (res.statusCode >=
                                                                  200 &&
                                                              res.statusCode <
                                                                  300) {
                                                            setState(() {
                                                              taleData =
                                                                  jsonDecode(
                                                                      resBody);
                                                              isLoading = false;
                                                            });
                                                          } else {
                                                            print(res
                                                                .reasonPhrase);
                                                          }
                                                          Navigator.of(context)
                                                              .push(
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  MyTaleDetail(
                                                                thumbnail: tales[tales
                                                                    .keys
                                                                    .toList()[tales
                                                                        .length -
                                                                    index -
                                                                    1]]["1"],
                                                                title: tales[tales
                                                                    .keys
                                                                    .toList()[tales
                                                                        .length -
                                                                    index -
                                                                    1]]["title"],
                                                                taleData:
                                                                    taleData,
                                                                userId: tales[tales
                                                                    .keys
                                                                    .toList()[tales
                                                                        .length -
                                                                    index -
                                                                    1]]["user_id"],
                                                                timeStamp: tales
                                                                        .keys
                                                                        .toList()[
                                                                    tales.length -
                                                                        index -
                                                                        1],
                                                              ),
                                                            ),
                                                          );
                                                        } catch (e) {
                                                          final value =
                                                              await FirebaseAuth
                                                                  .instance
                                                                  .currentUser!
                                                                  .getIdToken();
                                                          await prefs.setString(
                                                              'jwt', value!);
                                                          final userID = tales[
                                                              tales
                                                                  .keys
                                                                  .toList()[tales
                                                                      .length -
                                                                  index -
                                                                  1]]["user_id"];

                                                          var headersList = {
                                                            'Authorization':
                                                                "Bearer $value",
                                                            'Content-Type':
                                                                'application/json'
                                                          };
                                                          var url = Uri.parse(
                                                              getTaleDetail);
                                                          final data = Localizations
                                                                          .localeOf(
                                                                              context)
                                                                      .toString() ==
                                                                  "ko"
                                                              ? {
                                                                  "user_id":
                                                                      userID,
                                                                  "time_stamp": tales
                                                                      .keys
                                                                      .toList()[tales
                                                                          .length -
                                                                      index -
                                                                      1],
                                                                }
                                                              : {
                                                                  "user_id":
                                                                      userID,
                                                                  "time_stamp": tales
                                                                      .keys
                                                                      .toList()[tales
                                                                          .length -
                                                                      index -
                                                                      1],
                                                                  "ver":
                                                                      "global"
                                                                };

                                                          var body = data;

                                                          var req =
                                                              http.Request(
                                                                  'POST', url);
                                                          req.headers.addAll(
                                                              headersList);
                                                          req.body =
                                                              json.encode(body);

                                                          var res =
                                                              await req.send();
                                                          final resBody = await res
                                                              .stream
                                                              .bytesToString();

                                                          if (res.statusCode >=
                                                                  200 &&
                                                              res.statusCode <
                                                                  300) {
                                                            setState(() {
                                                              taleData =
                                                                  jsonDecode(
                                                                      resBody);
                                                              isLoading = false;
                                                            });
                                                          } else {
                                                            print(res
                                                                .reasonPhrase);
                                                          }

                                                          Navigator.of(context)
                                                              .push(
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  MyTaleDetail(
                                                                thumbnail: tales[tales
                                                                    .keys
                                                                    .toList()[tales
                                                                        .length -
                                                                    index -
                                                                    1]]["1"],
                                                                title: tales[tales
                                                                    .keys
                                                                    .toList()[tales
                                                                        .length -
                                                                    index -
                                                                    1]]["title"],
                                                                taleData:
                                                                    taleData,
                                                                userId: tales[tales
                                                                    .keys
                                                                    .toList()[tales
                                                                        .length -
                                                                    index -
                                                                    1]]["user_id"],
                                                                timeStamp: tales
                                                                        .keys
                                                                        .toList()[
                                                                    tales.length -
                                                                        index -
                                                                        1],
                                                              ),
                                                            ),
                                                          );
                                                        }
                                                      },
                                                      child: Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            140 /
                                                            360,
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            180 /
                                                            360,
                                                        decoration: BoxDecoration(
                                                            image: DecorationImage(
                                                                image: Image.asset(books[int.parse(tales[tales
                                                                        .keys
                                                                        .toList()[tales
                                                                            .length -
                                                                        index -
                                                                        1]]["num"])])
                                                                    .image)),
                                                        child: Padding(
                                                          padding: EdgeInsets.only(
                                                              left: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width >
                                                                      600
                                                                  ? 18
                                                                  : 26,
                                                              top: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width >
                                                                      600
                                                                  ? 18
                                                                  : 14,
                                                              right: 14),
                                                          child: Column(
                                                            children: [
                                                              Container(
                                                                width: MediaQuery.of(context)
                                                                            .size
                                                                            .width >
                                                                        600
                                                                    ? MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        90 /
                                                                        360
                                                                    : MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        100 /
                                                                        360,
                                                                height: MediaQuery.of(context)
                                                                            .size
                                                                            .width >
                                                                        600
                                                                    ? MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        90 /
                                                                        360
                                                                    : MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        100 /
                                                                        360,
                                                                clipBehavior: Clip
                                                                    .antiAlias,
                                                                decoration: BoxDecoration(
                                                                    border: Border.all(
                                                                        width:
                                                                            3,
                                                                        color: Colors
                                                                            .white),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                    image: DecorationImage(
                                                                        image: CachedNetworkImageProvider(tales[tales
                                                                            .keys
                                                                            .toList()[tales
                                                                                .length -
                                                                            index -
                                                                            1]]["1"]))),
                                                              ),
                                                              SizedBox(
                                                                height: MediaQuery.of(context)
                                                                            .size
                                                                            .width >
                                                                        600
                                                                    ? 10
                                                                    : 5,
                                                              ),
                                                              Text(
                                                                tales[tales.keys
                                                                    .toList()[tales
                                                                        .length -
                                                                    index -
                                                                    1]]["title"],
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        MediaQuery.of(context).size.width > 600
                                                                            ? 18
                                                                            : 14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .white,
                                                                    fontFamily:
                                                                        "TmoneyRoundWind"),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                            );
                                          }),
                                    ),
                                  )
                                ],
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
                          ),
                        ],
                      )
                    : Container()
              ],
            ),
          );
        });
  }
}
