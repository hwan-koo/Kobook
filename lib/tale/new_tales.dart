import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crepas/tale/models/En_all_tale_model.dart';
import 'package:crepas/tale/models/all_tale_view_model.dart';
import 'package:crepas/tale/tale_detail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' as foundation;
import 'package:shared_preferences/shared_preferences.dart';

import '../apiPaths.dart';
import '../profile/setting_view_model.dart';

class NewTales extends ConsumerStatefulWidget {
  const NewTales({super.key});

  @override
  NewTalesState createState() => NewTalesState();
}

class NewTalesState extends ConsumerState<NewTales> {
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
  Map<String, dynamic> taleData = {};

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    // ref.watch(taleProviderModel.notifier).build();
    super.initState();
  }

  bool isLoading = false;
  bool get isiOS =>
      foundation.defaultTargetPlatform == foundation.TargetPlatform.iOS;
  @override
  Widget build(BuildContext context) {
    return ref
        .watch(Localizations.localeOf(context).toString() == "ko"
            ? allTaleProviderModel
            : allTaleProviderModelEn)
        .when(
            loading: () => Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: Colors.white,
                  child: Center(
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
                ),
            error: (error, stackTrace) => Center(
                  child: Text("$error 잠시 후 다시 시도해주세요"),
                ),
            data: (tales) => Scaffold(
                  appBar: isiOS
                      ? AppBar(
                          backgroundColor: Colors.white,
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
                      SafeArea(
                        child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
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
                                              ? "따끈따끈"
                                              : "New Books",
                                          style: TextStyle(
                                              fontSize: MediaQuery.of(context)
                                                          .size
                                                          .width >
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
                                              ? "새로 나왔어요!"
                                              : "Arrived!",
                                          style: TextStyle(
                                              fontSize: MediaQuery.of(context)
                                                          .size
                                                          .width >
                                                      600
                                                  ? 32
                                                  : 24,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: -0.02),
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
                                      Localizations.localeOf(context)
                                                  .toString() ==
                                              "ko"
                                          ? ref
                                              .watch(
                                                  allTaleProviderModel.notifier)
                                              .fetchAllTale()
                                          : ref
                                              .watch(allTaleProviderModelEn
                                                  .notifier)
                                              .fetchAllTaleEn();
                                    },
                                    child: GridView.builder(
                                        shrinkWrap: true,
                                        itemCount: Localizations.localeOf(
                                                        context)
                                                    .toString() ==
                                                "ko"
                                            ? ref
                                                .watch(allTaleProviderModel
                                                    .notifier)
                                                .tales
                                                .length
                                            : ref
                                                .watch(allTaleProviderModelEn
                                                    .notifier)
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
                                                childAspectRatio: 140 / 180,
                                                mainAxisSpacing: 28,
                                                crossAxisSpacing: 28),
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return GestureDetector(
                                            onTap: () async {
                                              final SharedPreferences prefs =
                                                  await SharedPreferences
                                                      .getInstance();

                                              setState(() {
                                                isLoading = true;
                                              });
                                              if (!ref
                                                  .watch(playbackConfigProvider)
                                                  .muted) {
                                                AudioPlayer().play(AssetSource(
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
                                                final data = Localizations
                                                                .localeOf(
                                                                    context)
                                                            .toString() ==
                                                        "ko"
                                                    ? {
                                                        "user_id": userID,
                                                        "time_stamp":
                                                            tales.keys.toList()[
                                                                tales.length -
                                                                    index -
                                                                    1],
                                                      }
                                                    : {
                                                        "user_id": userID,
                                                        "time_stamp":
                                                            tales.keys.toList()[
                                                                tales.length -
                                                                    index -
                                                                    1],
                                                        "ver": "global"
                                                      };

                                                var body = data;

                                                var req =
                                                    http.Request('POST', url);
                                                req.headers.addAll(headersList);
                                                req.body = json.encode(body);

                                                var res = await req.send();
                                                final resBody = await res.stream
                                                    .bytesToString();
                                                if (res.statusCode >= 200 &&
                                                    res.statusCode < 300) {
                                                  setState(() {
                                                    taleData =
                                                        jsonDecode(resBody);
                                                    isLoading = false;
                                                  });
                                                } else {
                                                  print(res.reasonPhrase);
                                                }
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        TaleDetail(
                                                      thumbnail: tales[
                                                          tales.keys.toList()[
                                                              tales.length -
                                                                  index -
                                                                  1]]["1"],
                                                      title: tales[
                                                          tales.keys.toList()[
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
                                                final value = await FirebaseAuth
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
                                                final data = Localizations
                                                                .localeOf(
                                                                    context)
                                                            .toString() ==
                                                        "ko"
                                                    ? {
                                                        "user_id": userID,
                                                        "time_stamp":
                                                            tales.keys.toList()[
                                                                tales.length -
                                                                    index -
                                                                    1],
                                                      }
                                                    : {
                                                        "user_id": userID,
                                                        "time_stamp":
                                                            tales.keys.toList()[
                                                                tales.length -
                                                                    index -
                                                                    1],
                                                        "ver": "global"
                                                      };
                                                var body = data;

                                                var req =
                                                    http.Request('POST', url);
                                                req.headers.addAll(headersList);
                                                req.body = json.encode(body);

                                                var res = await req.send();
                                                final resBody = await res.stream
                                                    .bytesToString();

                                                if (res.statusCode >= 200 &&
                                                    res.statusCode < 300) {
                                                  setState(() {
                                                    taleData =
                                                        jsonDecode(resBody);
                                                    isLoading = false;
                                                  });
                                                } else {
                                                  print(res.reasonPhrase);
                                                }

                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        TaleDetail(
                                                      thumbnail: tales[
                                                          tales.keys.toList()[
                                                              tales.length -
                                                                  index -
                                                                  1]]["1"],
                                                      title: tales[
                                                          tales.keys.toList()[
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
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      140 /
                                                      360,
                                                  height: MediaQuery.of(context)
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
                                                              ? 6
                                                              : 14,
                                                          right: 14),
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                100 /
                                                                360,
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                100 /
                                                                360,
                                                            clipBehavior:
                                                                Clip.antiAlias,
                                                            decoration: BoxDecoration(
                                                                border: Border.all(
                                                                    width: 3,
                                                                    color: Colors
                                                                        .white),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
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
                                                                color: Colors
                                                                    .white),
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
                            )),
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
                ));
  }
}
