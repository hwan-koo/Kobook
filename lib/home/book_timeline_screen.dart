import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crepas/character/character_generate_screen.dart';
import 'package:crepas/profile/myprofile.dart';
import 'package:crepas/tale/models/En_top_ranking_tales_view_model.dart';
import 'package:crepas/tale/models/all_tale_view_model.dart';
import 'package:crepas/tale/models/top_ranking_tales_view_model.dart';
import 'package:crepas/tale/new_tales.dart';
import 'package:crepas/tale/sample_tale_detail.dart';
import 'package:crepas/tale/tale_character_choice.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_redirect/store_redirect.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' as foundation;

import '../apiPaths.dart';
import '../character/models/character_view_model.dart';
import '../profile/setting_view_model.dart';
import '../tale/models/En_all_tale5_model.dart';
import '../tale/models/all_tales5_view_model.dart';
import '../tale/models/tale_view_model.dart';
import '../tale/tale_detail.dart';

class BookTimelineScreen extends ConsumerStatefulWidget {
  const BookTimelineScreen({super.key});

  @override
  BookTimelineScreenState createState() => BookTimelineScreenState();
}

class BookTimelineScreenState extends ConsumerState<BookTimelineScreen> {
  // void _onViewTap() {
  //   Navigator.of(context).push(MaterialPageRoute(
  //     builder: (context) => const CharacterNameScreen(),
  //   ));
  // }

  _onCharacterGenerate() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const CharacterGenerateScreen(),
      ),
    );
  }

  _onTaleGenerate() {
    if (!ref.watch(playbackConfigProvider).muted) {
      AudioPlayer().play(AssetSource('button_click.wav'));
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const TaleCharacterChoice(),
      ),
    );
  }

  Map<String, dynamic> taleData = {};
  Map<String, dynamic> rankingTales = {};

  // _onTest() {
  //   AudioPlayer().play(AssetSource('button_click.wav'));
  //   Navigator.of(context).push(
  //     MaterialPageRoute(
  //       builder: (context) => const TestViewer(),
  //     ),
  //   );
  // }

  final books = [
    "assets/books/bookblue.png",
    "assets/books/bookgreen.png",
    "assets/books/bookorange.png",
    "assets/books/bookpink.png",
    "assets/books/bookpurple.png",
    "assets/books/bookred.png",
  ];
  final homebooks = [
    "assets/books/homeBookBlue.png",
    "assets/books/homeBookGreen.png",
    "assets/books/homeBookOrange.png",
    "assets/books/homeBookPink.png",
    "assets/books/homeBookPurple.png",
    "assets/books/homeBookRed.png",
  ];
  final homeNewbooks = [
    "assets/books/homeNewBookBlue.png",
    "assets/books/homeNewBookGreen.png",
    "assets/books/homeNewBookOrange.png",
    "assets/books/homeNewBookPink.png",
    "assets/books/homeNewBookPurple.png",
    "assets/books/homeNewBookRed.png",
  ];
  final openbooks = [
    "assets/books/openbookblue.png",
    "assets/books/openbookgreen.png",
    "assets/books/openbookorange.png",
    "assets/books/openbookpink.png",
    "assets/books/openbookpurple.png",
    "assets/books/openbookred.png",
  ];
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
                      const Text("🍯오픈 기념 무료 이벤트🍯",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text("하루에 딱 한 번",
                          style: TextStyle(
                              fontSize: 16, color: Color(0xff8B8B8B))),
                      const Text("무료로 동화를 만들어보세요!",
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
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("🍯 Launch Event 🍯",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text("Create a fairy tale",
                          style: TextStyle(
                              fontSize: 16, color: Color(0xff8B8B8B))),
                      const Text("for free one time a day!",
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

  alertUpdate() async {
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
            content: Localizations.localeOf(context).toString() == "ko"
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("업데이트가 필요해요",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text("더 나은 서비스를 위해",
                          style: TextStyle(
                              fontSize: 16, color: Color(0xff8B8B8B))),
                      const Text("업데이트 해주세요!",
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
                            onTap: () async {
                              StoreRedirect.redirect(
                                  androidAppId: "com.filo.crepas",
                                  iOSAppId: "6458048423");
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: 124,
                              height: 48,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: const Color(0xff468AFF)),
                              child: const Text("업데이트 하러 가기",
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
                      const Text("Needs an update",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text("Please update right now",
                          style: TextStyle(
                              fontSize: 16, color: Color(0xff8B8B8B))),
                      const Text("for better service",
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
                            onTap: () async {
                              StoreRedirect.redirect(
                                  androidAppId: "com.filo.crepas",
                                  iOSAppId: "6458048423");
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

  bool isNew = true;
  bool get isiOS =>
      foundation.defaultTargetPlatform == foundation.TargetPlatform.iOS;
  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        fetchData();
      }
    });

    super.initState();
  }

  Future<bool> verifyLogin() async {
    final FirebaseFirestore db = FirebaseFirestore.instance;
    var data = await db.collection("minVer").doc("android").get();
    if (data.data()!["minVer"] > currentVer) {
      alertUpdate();
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var value = prefs.getBool("refreshRequirement");
    print("새로고침 값은 $value");
    value ??= false;

    if (value) {
      print("새로 고침 시작");
      return true;
    } else {
      print("새로 고침 실패");
      return false;
    }
  }

  fetchData() async {
    if (Localizations.localeOf(context).toString() == "ko") {
      await ref.watch(rankingTaleProviderModel.notifier).fetchrankingTale();
    } else {
      await ref.watch(enrankingTaleProviderModel.notifier).fetchrankingTale();
    }

    setState(() {});
    print("랭킹 동화 알려줄게 $rankingTales");

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (await verifyLogin()) {
      print("새로 고침 중");
      await ref.watch(characterProviderModel.notifier).fetchCharacter();
      await ref.watch(taleProviderModel.notifier).fetchTale();
      await ref.watch(allTaleProviderModel.notifier).fetchAllTale();

      prefs.setBool("refreshRequirement", false);
    }
    final user = FirebaseAuth.instance.currentUser!;
    final FirebaseFirestore db = FirebaseFirestore.instance;
    coin = await _getCoin();
    setState(() {});

    await db
        .collection("users")
        .doc(user.uid)
        .update({"country": Localizations.localeOf(context).toString()});
  }

  goMakingTale() async {
    if (ref.watch(taleProviderModel.notifier).tales.isNotEmpty) {
      if (ref
              .watch(taleProviderModel.notifier)
              .tales[ref
                  .watch(taleProviderModel.notifier)
                  .tales
                  .keys
                  .toList()
                  .last]
              .length >
          1) {
        if (!ref.watch(playbackConfigProvider).muted) {
          AudioPlayer().play(AssetSource('button_click.wav'));
        }
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const TaleCharacterChoice()),
        );
      } else {
        alertMaking();
      }
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const TaleCharacterChoice()),
      );
    }
  }

  final _textController = TextEditingController();
  confirmParent() async {
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            backgroundColor: Colors.white,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Localizations.localeOf(context).toString() == "ko"
                    ? const Text("부모님 확인이 필요해요",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold))
                    : const Text("Parental Verification",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Localizations.localeOf(context).toString() == "ko"
                    ? const Text("7 x 7 은 무엇인가요?")
                    : const Text("What is 7 x 7?"),
                TextField(
                  style: TextStyle(
                      fontSize:
                          MediaQuery.of(context).size.width > 600 ? 24 : 16,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xff468aff)),
                  cursorHeight: 15,
                  maxLength: 12,
                  controller: _textController,
                  decoration: InputDecoration(
                      counterText: "",
                      suffixIcon: IconButton(
                          iconSize: 16,
                          onPressed: () {
                            _textController.clear();
                          },
                          icon: _textController.text.isNotEmpty
                              ? const FaIcon(FontAwesomeIcons.solidCircleXmark)
                              : const FaIcon(FontAwesomeIcons.pen)),
                      enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey))),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        if (_textController.text == "49") {
                          Navigator.pop(context, false);
                          _textController.text = "";
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const MyProfileScreen()));
                        } else {
                          _textController.text = "";
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: 240,
                        height: 48,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color(0xff468AFF)),
                        child:
                            Localizations.localeOf(context).toString() == "ko"
                                ? const Text("확인하기",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white))
                                : const Text("Check",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                      ),
                    )
                  ],
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
                        width: 240,
                        height: 48,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white),
                        child:
                            Localizations.localeOf(context).toString() == "ko"
                                ? const Text("취소",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff9B9B9B)))
                                : const Text("Cancel",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff9B9B9B))),
                      ),
                    )
                  ],
                )
              ],
            ),
          );
        });
  }

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

  bool isLoading = false;
  int coin = 0;

  @override
  Widget build(BuildContext context) {
    // S.load(const Locale("en"));
    return ref
        .watch(Localizations.localeOf(context).toString() == "ko"
            ? allTale5ProviderModel
            : allTale5ProviderModelEn)
        .when(
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
            data: (tales) => Scaffold(
                  backgroundColor: Colors.white,
                  appBar: AppBar(
                    backgroundColor: Colors.white,
                    elevation: 0,
                    toolbarHeight: 0,
                  ),
                  body: Stack(
                    children: [
                      SafeArea(
                        child: SingleChildScrollView(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24),
                                  child: Container(
                                    height: 60,
                                    alignment: Alignment.center,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Image.asset(
                                          "assets/typoLogo.png",
                                          width: 84,
                                          height: 18,
                                        ),
                                        Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                alertCoin();
                                              },
                                              child: Container(
                                                alignment: Alignment.center,
                                                width: MediaQuery.of(context)
                                                            .size
                                                            .width >
                                                        600
                                                    ? 100
                                                    : 60,
                                                height: MediaQuery.of(context)
                                                            .size
                                                            .width >
                                                        600
                                                    ? 50
                                                    : 30,
                                                decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xfff9fbff),
                                                    border: Border.all(
                                                        width: 1,
                                                        color: const Color(
                                                            0xffabcdff)),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30)),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10, right: 12),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Image.asset(
                                                        "assets/coin.png",
                                                        width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width >
                                                                600
                                                            ? 22
                                                            : 16,
                                                        height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width >
                                                                600
                                                            ? 22
                                                            : 16,
                                                      ),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text("$coin")
                                                      // const SizedBox(
                                                      //   width: 10,
                                                      // ),
                                                      // MediaQuery.of(context)
                                                      //             .size
                                                      //             .width >
                                                      //         600
                                                      //     ? const Text(
                                                      //         "0",
                                                      //         style: TextStyle(
                                                      //             fontSize: 18),
                                                      //       )
                                                      //     : const Text(
                                                      //         "0",
                                                      //         style: TextStyle(
                                                      //             fontSize: 12),
                                                      //       )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 16,
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

                                                // Navigator.of(context).push(
                                                //     MaterialPageRoute(
                                                //         builder: (context) =>
                                                //             const MyProfileScreen()));
                                                confirmParent();
                                              },
                                              child: FaIcon(
                                                FontAwesomeIcons.gear,
                                                size: MediaQuery.of(context)
                                                            .size
                                                            .width >
                                                        600
                                                    ? 36
                                                    : 24,
                                              ),
                                              // child: Container(
                                              //     width: MediaQuery.of(context)
                                              //                 .size
                                              //                 .width >
                                              //             600
                                              //         ? 56
                                              //         : 28,
                                              //     height: MediaQuery.of(context)
                                              //                 .size
                                              //                 .width >
                                              //             600
                                              //         ? 56
                                              //         : 28,
                                              //     decoration: BoxDecoration(
                                              //       borderRadius:
                                              //           BorderRadius.circular(100),
                                              //       color: const Color(0xffB4D4FE),
                                              //     ),
                                              //     child: Icon(
                                              //       Icons.person,
                                              //       color: Colors.white,
                                              //       size: MediaQuery.of(context)
                                              //                   .size
                                              //                   .width >
                                              //               600
                                              //           ? 40
                                              //           : 22,
                                              //     )),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Stack(
                                  children: [
                                    Image.asset(
                                      "assets/homeImage.png",
                                      width: MediaQuery.of(context).size.width,
                                      height: 400,
                                      fit: BoxFit.cover,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      height: 400,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const SizedBox(
                                            height: 43,
                                          ),
                                          Text(
                                            Localizations.localeOf(context)
                                                        .toString() ==
                                                    "ko"
                                                ? "우리 아이가 주인공인"
                                                : "an exciting fairy tale where",
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "TmoneyRoundWind",
                                                color: Colors.white,
                                                height: 1.6),
                                          ),
                                          Text(
                                              Localizations.localeOf(context)
                                                          .toString() ==
                                                      "ko"
                                                  ? "흥미로운 동화를 만들어보세요!"
                                                  : "your child is the main character",
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: "TmoneyRoundWind",
                                                  color: Colors.white,
                                                  height: 1.6)),
                                          const SizedBox(
                                            height: 219,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              goMakingTale();
                                            },
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  327 /
                                                  360,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xff468aff),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          32)),
                                              alignment: Alignment.center,
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
                                                        ? "동화책 만들기"
                                                        : "Go to Make Tale",
                                                    style: const TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  const SizedBox(
                                                    width: 4,
                                                  ),
                                                  const Icon(
                                                    FontAwesomeIcons.angleRight,
                                                    size: 18,
                                                    color: Colors.white,
                                                  )
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                Localizations.localeOf(context).toString() ==
                                        "ko"
                                    ? const SizedBox(
                                        height: 25,
                                      )
                                    : Container(),
                                Localizations.localeOf(context).toString() ==
                                        "ko"
                                    ? GestureDetector(
                                        onTap: () async {
                                          FirebaseAnalytics.instance
                                              .logEvent(name: "BannerClick");
                                          if (await canLaunchUrl(Uri.parse(
                                              "https://abr.ge/hg7uhh"))) {
                                            await launchUrl(
                                                Uri.parse(
                                                    "https://abr.ge/hg7uhh"),
                                                mode: LaunchMode
                                                    .externalApplication);
                                          } else {
                                            throw 'Could not launch';
                                          }
                                        },
                                        child: Image.network(
                                          "https://s3-kkobook-public-asset.s3.ap-northeast-2.amazonaws.com/banner/event.png",
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: MediaQuery.of(context)
                                                      .size
                                                      .width >
                                                  600
                                              ? 160
                                              : 80,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : Container(),
                                const SizedBox(
                                  height: 32,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24),
                                  child: Localizations.localeOf(context)
                                              .toString() ==
                                          "ko"
                                      ? Text(
                                          "꼬북이 고른 재미있는 동화책 👍🏻",
                                          style: TextStyle(
                                              fontSize: MediaQuery.of(context)
                                                          .size
                                                          .width >
                                                      600
                                                  ? 28
                                                  : 18,
                                              fontWeight: FontWeight.bold),
                                        )
                                      : Text(
                                          "Kobook's Pick",
                                          style: TextStyle(
                                              fontSize: MediaQuery.of(context)
                                                          .size
                                                          .width >
                                                      600
                                                  ? 28
                                                  : 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                ),
                                const SizedBox(height: 12),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24),
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.width >
                                            600
                                        ? MediaQuery.of(context).size.width *
                                            16 /
                                            36
                                        : MediaQuery.of(context).size.width *
                                            180 /
                                            360,
                                    child: ListView.separated(
                                      itemCount: 1,
                                      primary: false,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder:
                                          (BuildContext context, index) {
                                        return GestureDetector(
                                          onTap: () async {
                                            FirebaseAnalytics.instance.logEvent(
                                                name: "SampleTaleClick");
                                            if (!ref
                                                .watch(playbackConfigProvider)
                                                .muted) {
                                              AudioPlayer().play(AssetSource(
                                                  'button_click.wav'));
                                            }
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    SampleTaleDetail(
                                                  thumbnail: "",
                                                  title: "",
                                                  taleData: const {},
                                                  userId: tales[
                                                      tales.keys.toList()[
                                                          tales.length -
                                                              index -
                                                              1]]["user_id"],
                                                  timeStamp: tales.keys
                                                          .toList()[
                                                      tales.length - index - 1],
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
                                                    14 /
                                                    36
                                                : MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    150 /
                                                    360,
                                            height: MediaQuery.of(context)
                                                        .size
                                                        .width >
                                                    600
                                                ? MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    16 /
                                                    36
                                                : MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    180 /
                                                    360,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                              fit: BoxFit.contain,
                                              image: Image.asset(
                                                      "assets/books/homeBookBlue.png")
                                                  .image,
                                            )),
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: MediaQuery.of(context)
                                                              .size
                                                              .width >
                                                          600
                                                      ? 40
                                                      : MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          32 /
                                                          360,
                                                  top: MediaQuery.of(context)
                                                              .size
                                                              .width >
                                                          600
                                                      ? 20
                                                      : MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          14 /
                                                          360,
                                                  right: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      14 /
                                                      360),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width >
                                                            600
                                                        ? MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            100 /
                                                            360
                                                        : MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            100 /
                                                            360,
                                                    height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width >
                                                            600
                                                        ? MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            100 /
                                                            360
                                                        : MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            100 /
                                                            360,
                                                    clipBehavior:
                                                        Clip.antiAlias,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            width: 3,
                                                            color:
                                                                Colors.white),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10)),
                                                    child: Container(
                                                        clipBehavior:
                                                            Clip.antiAlias,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        child: Image.asset(
                                                          "assets/sample/1.png",
                                                          width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width >
                                                                  600
                                                              ? MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  100 /
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
                                                                  100 /
                                                                  360
                                                              : MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  100 /
                                                                  360,
                                                        )),
                                                  ),
                                                  const SizedBox(
                                                    height: 8,
                                                  ),
                                                  Localizations.localeOf(
                                                                  context)
                                                              .toString() ==
                                                          "ko"
                                                      ? Text(
                                                          "꼬미와 보름달 토끼",
                                                          style: TextStyle(
                                                              fontSize: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width >
                                                                      600
                                                                  ? 20
                                                                  : 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white,
                                                              fontFamily:
                                                                  "TmoneyRoundWind"),
                                                        )
                                                      : Text(
                                                          "Sophia and the Full Moon Bunny",
                                                          style: TextStyle(
                                                              fontSize: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width >
                                                                      600
                                                                  ? 20
                                                                  : 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      separatorBuilder:
                                          (BuildContext context, index) {
                                        return const SizedBox(
                                          width: 1,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 32,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Localizations.localeOf(context)
                                                  .toString() ==
                                              "ko"
                                          ? Text(
                                              "따끈따끈 새 책 🔥",
                                              style: TextStyle(
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                                  .size
                                                                  .width >
                                                              600
                                                          ? 28
                                                          : 18,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          : Text(
                                              "New Books!",
                                              style: TextStyle(
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                                  .size
                                                                  .width >
                                                              600
                                                          ? 28
                                                          : 14,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                      GestureDetector(
                                        onTap: () {
                                          FirebaseAnalytics.instance.logEvent(
                                              name: "NewTalesPageClick");
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const NewTales()),
                                          );
                                        },
                                        child: Localizations.localeOf(context)
                                                    .toString() ==
                                                "ko"
                                            ? const Text(
                                                "더보기 ＞",
                                                style: TextStyle(
                                                    color: Color(0xff9B9B9B),
                                                    fontSize: 14),
                                              )
                                            : const Text(
                                                "See more ＞",
                                                style: TextStyle(
                                                    color: Color(0xff9B9B9B),
                                                    fontSize: 12),
                                              ),
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.width > 600
                                          ? MediaQuery.of(context).size.width *
                                              16 /
                                              36
                                          : MediaQuery.of(context).size.width *
                                              186 /
                                              360,
                                  child: ListView.separated(
                                    itemCount: 5,
                                    primary: false,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (BuildContext context, index) {
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
                                            final userID = tales[tales.keys
                                                        .toList()[
                                                    tales.length - index - 1]]
                                                ["user_id"];

                                            var headersList = {
                                              'Authorization': "Bearer $value",
                                              'Content-Type': 'application/json'
                                            };
                                            var url = Uri.parse(getTaleDetail);
                                            final data =
                                                Localizations.localeOf(context)
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

                                            var req = http.Request('POST', url);
                                            req.headers.addAll(headersList);
                                            req.body = json.encode(body);

                                            var res = await req.send();
                                            final resBody = await res.stream
                                                .bytesToString();
                                            if (res.statusCode >= 200 &&
                                                res.statusCode < 300) {
                                              setState(() {
                                                taleData = jsonDecode(resBody);
                                                isLoading = false;
                                              });
                                            } else {}
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
                                                  userId: tales[
                                                      tales.keys.toList()[
                                                          tales.length -
                                                              index -
                                                              1]]["user_id"],
                                                  timeStamp: tales.keys
                                                          .toList()[
                                                      tales.length - index - 1],
                                                ),
                                              ),
                                            );
                                          } catch (e) {
                                            final value = await FirebaseAuth
                                                .instance.currentUser!
                                                .getIdToken();
                                            await prefs.setString(
                                                'jwt', value!);
                                            final userID = tales[tales.keys
                                                        .toList()[
                                                    tales.length - index - 1]]
                                                ["user_id"];

                                            var headersList = {
                                              'Authorization': "Bearer $value",
                                              'Content-Type': 'application/json'
                                            };
                                            var url = Uri.parse(getTaleDetail);
                                            final data =
                                                Localizations.localeOf(context)
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

                                            var req = http.Request('POST', url);
                                            req.headers.addAll(headersList);
                                            req.body = json.encode(body);

                                            var res = await req.send();
                                            final resBody = await res.stream
                                                .bytesToString();

                                            if (res.statusCode >= 200 &&
                                                res.statusCode < 300) {
                                              setState(() {
                                                taleData = jsonDecode(resBody);
                                                isLoading = false;
                                              });
                                            } else {}

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
                                                  userId: tales[
                                                      tales.keys.toList()[
                                                          tales.length -
                                                              index -
                                                              1]]["user_id"],
                                                  timeStamp: tales.keys
                                                          .toList()[
                                                      tales.length - index - 1],
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 24),
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                        .size
                                                        .width >
                                                    600
                                                ? MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    14 /
                                                    36
                                                : MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    150 /
                                                    360,
                                            height: MediaQuery.of(context)
                                                        .size
                                                        .width >
                                                    600
                                                ? MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    16 /
                                                    36
                                                : MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    186 /
                                                    360,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: Image.asset(homeNewbooks[
                                                            int.parse(tales[tales
                                                                .keys
                                                                .toList()[tales
                                                                    .length -
                                                                index -
                                                                1]]["num"])])
                                                        .image)),
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: MediaQuery.of(context)
                                                              .size
                                                              .width >
                                                          600
                                                      ? 40
                                                      : MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          32 /
                                                          360,
                                                  top: MediaQuery.of(context)
                                                              .size
                                                              .width >
                                                          600
                                                      ? 40
                                                      : MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          14 /
                                                          360,
                                                  right: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      14 /
                                                      360),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width >
                                                            600
                                                        ? MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            100 /
                                                            360
                                                        : MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            100 /
                                                            360,
                                                    height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width >
                                                            600
                                                        ? MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            100 /
                                                            360
                                                        : MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            100 /
                                                            360,
                                                    clipBehavior:
                                                        Clip.antiAlias,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            width: 3,
                                                            color:
                                                                Colors.white),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10)),
                                                    child: Container(
                                                      clipBehavior:
                                                          Clip.antiAlias,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      child: CachedNetworkImage(
                                                        width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width >
                                                                600
                                                            ? MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                100 /
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
                                                                100 /
                                                                360
                                                            : MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                100 /
                                                                360,
                                                        imageUrl: tales[
                                                            tales.keys.toList()[
                                                                tales.length -
                                                                    index -
                                                                    1]]["1"],
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 8,
                                                  ),
                                                  Text(
                                                    tales[tales.keys.toList()[
                                                        tales.length -
                                                            index -
                                                            1]]["title"],
                                                    style: TextStyle(
                                                        fontSize: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width >
                                                                600
                                                            ? 20
                                                            : 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white,
                                                        fontFamily:
                                                            "TmoneyRoundWind"),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    separatorBuilder:
                                        (BuildContext context, index) {
                                      return const SizedBox(
                                        width: 0,
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  height: 32,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Localizations.localeOf(context)
                                                  .toString() ==
                                              "ko"
                                          ? Text(
                                              "꼬북에서 제일 인기 많은 책이에요 ❤️",
                                              style: TextStyle(
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                                  .size
                                                                  .width >
                                                              600
                                                          ? 28
                                                          : 18,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          : Text(
                                              "Hot Books!",
                                              style: TextStyle(
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                                  .size
                                                                  .width >
                                                              600
                                                          ? 28
                                                          : 14,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20),
                                ref
                                    .watch(Localizations.localeOf(context)
                                                .toString() ==
                                            "ko"
                                        ? rankingTaleProviderModel
                                        : enrankingTaleProviderModel)
                                    .when(
                                        loading: () => Center(
                                              child: SpinKitSpinningCircle(
                                                itemBuilder: (context, index) {
                                                  return Center(
                                                    child: Image.asset(
                                                        "assets/turtle.png"),
                                                  );
                                                },
                                              ),
                                            ),
                                        error: (error, stackTrace) => Center(
                                              child:
                                                  Text("$error 잠시 후 다시 시도해주세요"),
                                            ),
                                        data: (rankingTales) => Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 24),
                                              child: GridView.builder(
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  itemCount: 4,
                                                  shrinkWrap: true,
                                                  gridDelegate:
                                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                                          crossAxisCount: 2,
                                                          childAspectRatio:
                                                              150 / 267,
                                                          mainAxisSpacing: 0,
                                                          crossAxisSpacing: 24),
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int indexNum) {
                                                    return Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            GestureDetector(
                                                              onTap: () async {
                                                                final SharedPreferences
                                                                    prefs =
                                                                    await SharedPreferences
                                                                        .getInstance();

                                                                setState(() {
                                                                  isLoading =
                                                                      true;
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
                                                                  final String?
                                                                      value =
                                                                      prefs.getString(
                                                                          'jwt');
                                                                  final userID = Localizations.localeOf(context)
                                                                              .toString() ==
                                                                          "ko"
                                                                      ? ref.watch(rankingTaleProviderModel.notifier).tales[ref
                                                                              .watch(rankingTaleProviderModel
                                                                                  .notifier)
                                                                              .tales
                                                                              .keys
                                                                              .toList()[indexNum]]
                                                                          [
                                                                          "user_id"]
                                                                      : ref.watch(enrankingTaleProviderModel.notifier).tales[ref
                                                                          .watch(
                                                                              enrankingTaleProviderModel.notifier)
                                                                          .tales
                                                                          .keys
                                                                          .toList()[indexNum]]["user_id"];

                                                                  var headersList =
                                                                      {
                                                                    'Authorization':
                                                                        "Bearer $value",
                                                                    'Content-Type':
                                                                        'application/json'
                                                                  };
                                                                  var url =
                                                                      Uri.parse(
                                                                          getTaleDetail);
                                                                  final data =
                                                                      Localizations.localeOf(context).toString() ==
                                                                              "ko"
                                                                          ? {
                                                                              "user_id": userID,
                                                                              "time_stamp": ref.watch(rankingTaleProviderModel.notifier).tales.keys.toList()[indexNum],
                                                                            }
                                                                          : {
                                                                              "user_id": userID,
                                                                              "time_stamp": ref.watch(enrankingTaleProviderModel.notifier).tales.keys.toList()[indexNum],
                                                                              "ver": "global"
                                                                            };

                                                                  var body =
                                                                      data;

                                                                  var req = http
                                                                      .Request(
                                                                          'POST',
                                                                          url);
                                                                  req.headers
                                                                      .addAll(
                                                                          headersList);
                                                                  req.body = json
                                                                      .encode(
                                                                          body);

                                                                  var res =
                                                                      await req
                                                                          .send();
                                                                  final resBody =
                                                                      await res
                                                                          .stream
                                                                          .bytesToString();
                                                                  if (res.statusCode >=
                                                                          200 &&
                                                                      res.statusCode <
                                                                          300) {
                                                                    setState(
                                                                        () {
                                                                      taleData =
                                                                          jsonDecode(
                                                                              resBody);
                                                                      isLoading =
                                                                          false;
                                                                    });
                                                                  } else {}
                                                                  Navigator.of(
                                                                          context)
                                                                      .push(
                                                                    MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              TaleDetail(
                                                                        thumbnail: Localizations.localeOf(context).toString() ==
                                                                                "ko"
                                                                            ? ref.watch(rankingTaleProviderModel.notifier).tales[ref.watch(rankingTaleProviderModel.notifier).tales.keys.toList()[indexNum]]["1"]
                                                                            : ref.watch(enrankingTaleProviderModel.notifier).tales[ref.watch(enrankingTaleProviderModel.notifier).tales.keys.toList()[indexNum]]["1"],
                                                                        title: Localizations.localeOf(context).toString() ==
                                                                                "ko"
                                                                            ? ref.watch(rankingTaleProviderModel.notifier).tales[ref.watch(rankingTaleProviderModel.notifier).tales.keys.toList()[indexNum]]["title"]
                                                                            : ref.watch(enrankingTaleProviderModel.notifier).tales[ref.watch(enrankingTaleProviderModel.notifier).tales.keys.toList()[indexNum]]["title"],
                                                                        taleData:
                                                                            taleData,
                                                                        userId: Localizations.localeOf(context).toString() ==
                                                                                "ko"
                                                                            ? ref.watch(rankingTaleProviderModel.notifier).tales[ref.watch(rankingTaleProviderModel.notifier).tales.keys.toList()[indexNum]]["user_id"]
                                                                            : ref.watch(enrankingTaleProviderModel.notifier).tales[ref.watch(enrankingTaleProviderModel.notifier).tales.keys.toList()[indexNum]]["user_id"],
                                                                        timeStamp: Localizations.localeOf(context).toString() ==
                                                                                "ko"
                                                                            ? ref.watch(rankingTaleProviderModel.notifier).tales.keys.toList()[indexNum]
                                                                            : ref.watch(enrankingTaleProviderModel.notifier).tales.keys.toList()[indexNum],
                                                                      ),
                                                                    ),
                                                                  );
                                                                } catch (e) {
                                                                  final value = await FirebaseAuth
                                                                      .instance
                                                                      .currentUser!
                                                                      .getIdToken();
                                                                  await prefs
                                                                      .setString(
                                                                          'jwt',
                                                                          value!);
                                                                  final userID = Localizations.localeOf(context)
                                                                              .toString() ==
                                                                          "ko"
                                                                      ? ref.watch(rankingTaleProviderModel.notifier).tales[ref
                                                                              .watch(rankingTaleProviderModel
                                                                                  .notifier)
                                                                              .tales
                                                                              .keys
                                                                              .toList()[indexNum]]
                                                                          [
                                                                          "user_id"]
                                                                      : ref.watch(enrankingTaleProviderModel.notifier).tales[ref
                                                                          .watch(
                                                                              enrankingTaleProviderModel.notifier)
                                                                          .tales
                                                                          .keys
                                                                          .toList()[indexNum]]["user_id"];

                                                                  var headersList =
                                                                      {
                                                                    'Authorization':
                                                                        "Bearer $value",
                                                                    'Content-Type':
                                                                        'application/json'
                                                                  };
                                                                  var url =
                                                                      Uri.parse(
                                                                          getTaleDetail);
                                                                  final data =
                                                                      Localizations.localeOf(context).toString() ==
                                                                              "ko"
                                                                          ? {
                                                                              "user_id": userID,
                                                                              "time_stamp": ref.watch(rankingTaleProviderModel.notifier).tales.keys.toList()[indexNum],
                                                                            }
                                                                          : {
                                                                              "user_id": userID,
                                                                              "time_stamp": ref.watch(enrankingTaleProviderModel.notifier).tales.keys.toList()[indexNum],
                                                                              "ver": "global"
                                                                            };

                                                                  var body =
                                                                      data;

                                                                  var req = http
                                                                      .Request(
                                                                          'POST',
                                                                          url);
                                                                  req.headers
                                                                      .addAll(
                                                                          headersList);
                                                                  req.body = json
                                                                      .encode(
                                                                          body);

                                                                  var res =
                                                                      await req
                                                                          .send();
                                                                  final resBody =
                                                                      await res
                                                                          .stream
                                                                          .bytesToString();

                                                                  if (res.statusCode >=
                                                                          200 &&
                                                                      res.statusCode <
                                                                          300) {
                                                                    setState(
                                                                        () {
                                                                      taleData =
                                                                          jsonDecode(
                                                                              resBody);
                                                                      isLoading =
                                                                          false;
                                                                    });
                                                                  } else {}

                                                                  Navigator.of(
                                                                          context)
                                                                      .push(
                                                                    MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              TaleDetail(
                                                                        thumbnail: Localizations.localeOf(context).toString() ==
                                                                                "ko"
                                                                            ? ref.watch(rankingTaleProviderModel.notifier).tales[ref.watch(rankingTaleProviderModel.notifier).tales.keys.toList()[indexNum]]["1"]
                                                                            : ref.watch(enrankingTaleProviderModel.notifier).tales[ref.watch(enrankingTaleProviderModel.notifier).tales.keys.toList()[indexNum]]["1"],
                                                                        title: Localizations.localeOf(context).toString() ==
                                                                                "ko"
                                                                            ? ref.watch(rankingTaleProviderModel.notifier).tales[ref.watch(rankingTaleProviderModel.notifier).tales.keys.toList()[indexNum]]["title"]
                                                                            : ref.watch(enrankingTaleProviderModel.notifier).tales[ref.watch(enrankingTaleProviderModel.notifier).tales.keys.toList()[indexNum]]["title"],
                                                                        taleData:
                                                                            taleData,
                                                                        userId: Localizations.localeOf(context).toString() ==
                                                                                "ko"
                                                                            ? ref.watch(rankingTaleProviderModel.notifier).tales[ref.watch(rankingTaleProviderModel.notifier).tales.keys.toList()[indexNum]]["user_id"]
                                                                            : ref.watch(enrankingTaleProviderModel.notifier).tales[ref.watch(enrankingTaleProviderModel.notifier).tales.keys.toList()[indexNum]]["user_id"],
                                                                        timeStamp: Localizations.localeOf(context).toString() ==
                                                                                "ko"
                                                                            ? ref.watch(rankingTaleProviderModel.notifier).tales.keys.toList()[indexNum]
                                                                            : ref.watch(enrankingTaleProviderModel.notifier).tales.keys.toList()[indexNum],
                                                                      ),
                                                                    ),
                                                                  );
                                                                }
                                                              },
                                                              child: Container(
                                                                width: MediaQuery.of(
                                                                                context)
                                                                            .size
                                                                            .width >
                                                                        600
                                                                    ? MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        14 /
                                                                        36
                                                                    : MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        150 /
                                                                        360,
                                                                height: MediaQuery.of(
                                                                                context)
                                                                            .size
                                                                            .width >
                                                                        600
                                                                    ? MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        16 /
                                                                        36
                                                                    : MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        180 /
                                                                        360,
                                                                decoration: BoxDecoration(
                                                                    image: DecorationImage(
                                                                        image: Image.asset(homebooks[int.parse(Localizations.localeOf(context).toString() == "ko"
                                                                                ? ref.watch(rankingTaleProviderModel.notifier).tales[ref.watch(rankingTaleProviderModel.notifier).tales.keys.toList()[indexNum]]["num"]
                                                                                : ref.watch(enrankingTaleProviderModel.notifier).tales[ref.watch(enrankingTaleProviderModel.notifier).tales.keys.toList()[indexNum]]["num"])])
                                                                            .image)),
                                                                child: Padding(
                                                                  padding: EdgeInsets.only(
                                                                      left: MediaQuery.of(context).size.width >
                                                                              600
                                                                          ? 40
                                                                          : MediaQuery.of(context).size.width *
                                                                              32 /
                                                                              360,
                                                                      top: MediaQuery.of(context).size.width >
                                                                              600
                                                                          ? 20
                                                                          : MediaQuery.of(context).size.width *
                                                                              14 /
                                                                              360,
                                                                      right: MediaQuery.of(context)
                                                                              .size
                                                                              .width *
                                                                          14 /
                                                                          360),
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Container(
                                                                        width: MediaQuery.of(context).size.width >
                                                                                600
                                                                            ? MediaQuery.of(context).size.width *
                                                                                100 /
                                                                                360
                                                                            : MediaQuery.of(context).size.width *
                                                                                100 /
                                                                                360,
                                                                        height: MediaQuery.of(context).size.width >
                                                                                600
                                                                            ? MediaQuery.of(context).size.width *
                                                                                100 /
                                                                                360
                                                                            : MediaQuery.of(context).size.width *
                                                                                100 /
                                                                                360,
                                                                        clipBehavior:
                                                                            Clip.antiAlias,
                                                                        decoration: BoxDecoration(
                                                                            border:
                                                                                Border.all(width: 3, color: Colors.white),
                                                                            borderRadius: BorderRadius.circular(10)),
                                                                        child:
                                                                            Container(
                                                                          clipBehavior:
                                                                              Clip.antiAlias,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(10),
                                                                          ),
                                                                          child:
                                                                              CachedNetworkImage(
                                                                            width: MediaQuery.of(context).size.width > 600
                                                                                ? MediaQuery.of(context).size.width * 100 / 360
                                                                                : MediaQuery.of(context).size.width * 100 / 360,
                                                                            height: MediaQuery.of(context).size.width > 600
                                                                                ? MediaQuery.of(context).size.width * 100 / 360
                                                                                : MediaQuery.of(context).size.width * 100 / 360,
                                                                            imageUrl: Localizations.localeOf(context).toString() == "ko"
                                                                                ? ref.watch(rankingTaleProviderModel.notifier).tales[ref.watch(rankingTaleProviderModel.notifier).tales.keys.toList()[indexNum]]["1"]
                                                                                : ref.watch(enrankingTaleProviderModel.notifier).tales[ref.watch(enrankingTaleProviderModel.notifier).tales.keys.toList()[indexNum]]["1"],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            8,
                                                                      ),
                                                                      Text(
                                                                        Localizations.localeOf(context).toString() ==
                                                                                "ko"
                                                                            ? ref.watch(rankingTaleProviderModel.notifier).tales[ref.watch(rankingTaleProviderModel.notifier).tales.keys.toList()[indexNum]]["title"]
                                                                            : ref.watch(enrankingTaleProviderModel.notifier).tales[ref.watch(enrankingTaleProviderModel.notifier).tales.keys.toList()[indexNum]]["title"],
                                                                        style: TextStyle(
                                                                            fontSize: MediaQuery.of(context).size.width > 600
                                                                                ? 20
                                                                                : 14,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color: Colors.white,
                                                                            fontFamily: "TmoneyRoundWind"),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 15,
                                                            ),
                                                            Text(
                                                              Localizations.localeOf(
                                                                              context)
                                                                          .toString() ==
                                                                      "ko"
                                                                  ? "${indexNum + 1} 위"
                                                                  : "Top ${indexNum + 1}",
                                                              style: const TextStyle(
                                                                  color: Color(
                                                                      0xff468aff),
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontFamily:
                                                                      "TmoneyRoundWind"),
                                                            ),
                                                            const SizedBox(
                                                              height: 12,
                                                            ),
                                                            Container(
                                                              width: 75,
                                                              height: 30,
                                                              decoration: BoxDecoration(
                                                                  color: const Color(
                                                                      0xffEDF3FF),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              15)),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Image.asset(
                                                                    "assets/heart.png",
                                                                    width: 18,
                                                                    height: 16,
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 4,
                                                                  ),
                                                                  Text(
                                                                    Localizations.localeOf(context).toString() ==
                                                                            "ko"
                                                                        ? ref.watch(rankingTaleProviderModel.notifier).tales[ref.watch(rankingTaleProviderModel.notifier).tales.keys.toList()[indexNum]]
                                                                            [
                                                                            "like_num"]
                                                                        : ref.watch(enrankingTaleProviderModel.notifier).tales[ref
                                                                            .watch(enrankingTaleProviderModel.notifier)
                                                                            .tales
                                                                            .keys
                                                                            .toList()[indexNum]]["like_num"],
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontFamily:
                                                                            "TmoneyRoundWind"),
                                                                  )
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ],
                                                    );
                                                  }),
                                            )),
                                // SizedBox(
                                //   height:
                                //       MediaQuery.of(context).size.width > 600
                                //           ? MediaQuery.of(context).size.width *
                                //               16 /
                                //               36
                                //           : MediaQuery.of(context).size.width *
                                //               23 /
                                //               36,
                                //   child: ListView.separated(
                                //     itemCount: Localizations.localeOf(context)
                                //                 .toString() ==
                                //             "ko"
                                //         ? ref
                                //             .watch(rankingTaleProviderModel
                                //                 .notifier)
                                //             .tales
                                //             .length
                                //         : ref
                                //             .watch(enrankingTaleProviderModel
                                //                 .notifier)
                                //             .tales
                                //             .length,
                                //     primary: false,
                                //     scrollDirection: Axis.horizontal,
                                //     itemBuilder:
                                //         (BuildContext context, indexNum) {
                                //       return GestureDetector(
                                //         onTap: () async {
                                //           final SharedPreferences prefs =
                                //               await SharedPreferences
                                //                   .getInstance();

                                //           setState(() {
                                //             isLoading = true;
                                //           });
                                //           if (!ref
                                //               .watch(playbackConfigProvider)
                                //               .muted) {
                                //             AudioPlayer().play(AssetSource(
                                //                 'button_click.wav'));
                                //           }

                                //           try {
                                //             final String? value =
                                //                 prefs.getString('jwt');
                                //             final userID = Localizations.localeOf(context)
                                //                         .toString() ==
                                //                     "ko"
                                //                 ? ref.watch(rankingTaleProviderModel.notifier).tales[ref
                                //                         .watch(
                                //                             rankingTaleProviderModel
                                //                                 .notifier)
                                //                         .tales
                                //                         .keys
                                //                         .toList()[indexNum]]
                                //                     ["user_id"]
                                //                 : ref.watch(enrankingTaleProviderModel.notifier).tales[ref
                                //                     .watch(
                                //                         enrankingTaleProviderModel
                                //                             .notifier)
                                //                     .tales
                                //                     .keys
                                //                     .toList()[indexNum]]["user_id"];

                                //             var headersList = {
                                //               'Authorization': "Bearer $value",
                                //               'Content-Type': 'application/json'
                                //             };
                                //             var url = Uri.parse(getTaleDetail);
                                //             final data =
                                //                 Localizations.localeOf(context)
                                //                             .toString() ==
                                //                         "ko"
                                //                     ? {
                                //                         "user_id": userID,
                                //                         "time_stamp": ref
                                //                             .watch(
                                //                                 rankingTaleProviderModel
                                //                                     .notifier)
                                //                             .tales
                                //                             .keys
                                //                             .toList()[indexNum],
                                //                       }
                                //                     : {
                                //                         "user_id": userID,
                                //                         "time_stamp": ref
                                //                             .watch(
                                //                                 enrankingTaleProviderModel
                                //                                     .notifier)
                                //                             .tales
                                //                             .keys
                                //                             .toList()[indexNum],
                                //                         "ver": "global"
                                //                       };

                                //             var body = data;

                                //             var req = http.Request('POST', url);
                                //             req.headers.addAll(headersList);
                                //             req.body = json.encode(body);

                                //             var res = await req.send();
                                //             final resBody = await res.stream
                                //                 .bytesToString();
                                //             if (res.statusCode >= 200 &&
                                //                 res.statusCode < 300) {
                                //               setState(() {
                                //                 taleData = jsonDecode(resBody);
                                //                 isLoading = false;
                                //               });
                                //             } else {}
                                //             Navigator.of(context).push(
                                //               MaterialPageRoute(
                                //                 builder: (context) =>
                                //                     TaleDetail(
                                //                   thumbnail: Localizations.localeOf(
                                //                                   context)
                                //                               .toString() ==
                                //                           "ko"
                                //                       ? ref.watch(rankingTaleProviderModel.notifier).tales[ref
                                //                               .watch(rankingTaleProviderModel
                                //                                   .notifier)
                                //                               .tales
                                //                               .keys
                                //                               .toList()[indexNum]]
                                //                           ["1"]
                                //                       : ref.watch(enrankingTaleProviderModel.notifier).tales[ref
                                //                           .watch(enrankingTaleProviderModel
                                //                               .notifier)
                                //                           .tales
                                //                           .keys
                                //                           .toList()[indexNum]]["1"],
                                //                   title: Localizations.localeOf(context)
                                //                               .toString() ==
                                //                           "ko"
                                //                       ? ref.watch(rankingTaleProviderModel.notifier).tales[ref
                                //                               .watch(
                                //                                   rankingTaleProviderModel
                                //                                       .notifier)
                                //                               .tales
                                //                               .keys
                                //                               .toList()[indexNum]]
                                //                           ["title"]
                                //                       : ref.watch(enrankingTaleProviderModel.notifier).tales[ref
                                //                           .watch(
                                //                               enrankingTaleProviderModel
                                //                                   .notifier)
                                //                           .tales
                                //                           .keys
                                //                           .toList()[indexNum]]["title"],
                                //                   taleData: taleData,
                                //                   userId: Localizations.localeOf(context)
                                //                               .toString() ==
                                //                           "ko"
                                //                       ? ref.watch(rankingTaleProviderModel.notifier).tales[ref
                                //                               .watch(
                                //                                   rankingTaleProviderModel
                                //                                       .notifier)
                                //                               .tales
                                //                               .keys
                                //                               .toList()[indexNum]]
                                //                           ["user_id"]
                                //                       : ref.watch(enrankingTaleProviderModel.notifier).tales[ref
                                //                               .watch(
                                //                                   enrankingTaleProviderModel
                                //                                       .notifier)
                                //                               .tales
                                //                               .keys
                                //                               .toList()[indexNum]]
                                //                           ["user_id"],
                                //                   timeStamp: Localizations
                                //                                   .localeOf(
                                //                                       context)
                                //                               .toString() ==
                                //                           "ko"
                                //                       ? ref
                                //                           .watch(
                                //                               rankingTaleProviderModel
                                //                                   .notifier)
                                //                           .tales
                                //                           .keys
                                //                           .toList()[indexNum]
                                //                       : ref
                                //                           .watch(
                                //                               enrankingTaleProviderModel
                                //                                   .notifier)
                                //                           .tales
                                //                           .keys
                                //                           .toList()[indexNum],
                                //                 ),
                                //               ),
                                //             );
                                //           } catch (e) {
                                //             final value = await FirebaseAuth
                                //                 .instance.currentUser!
                                //                 .getIdToken();
                                //             await prefs.setString(
                                //                 'jwt', value!);
                                //             final userID = Localizations.localeOf(context)
                                //                         .toString() ==
                                //                     "ko"
                                //                 ? ref.watch(rankingTaleProviderModel.notifier).tales[ref
                                //                         .watch(
                                //                             rankingTaleProviderModel
                                //                                 .notifier)
                                //                         .tales
                                //                         .keys
                                //                         .toList()[indexNum]]
                                //                     ["user_id"]
                                //                 : ref.watch(enrankingTaleProviderModel.notifier).tales[ref
                                //                     .watch(
                                //                         enrankingTaleProviderModel
                                //                             .notifier)
                                //                     .tales
                                //                     .keys
                                //                     .toList()[indexNum]]["user_id"];

                                //             var headersList = {
                                //               'Authorization': "Bearer $value",
                                //               'Content-Type': 'application/json'
                                //             };
                                //             var url = Uri.parse(getTaleDetail);
                                //             final data =
                                //                 Localizations.localeOf(context)
                                //                             .toString() ==
                                //                         "ko"
                                //                     ? {
                                //                         "user_id": userID,
                                //                         "time_stamp": ref
                                //                             .watch(
                                //                                 rankingTaleProviderModel
                                //                                     .notifier)
                                //                             .tales
                                //                             .keys
                                //                             .toList()[indexNum],
                                //                       }
                                //                     : {
                                //                         "user_id": userID,
                                //                         "time_stamp": ref
                                //                             .watch(
                                //                                 enrankingTaleProviderModel
                                //                                     .notifier)
                                //                             .tales
                                //                             .keys
                                //                             .toList()[indexNum],
                                //                         "ver": "global"
                                //                       };

                                //             var body = data;

                                //             var req = http.Request('POST', url);
                                //             req.headers.addAll(headersList);
                                //             req.body = json.encode(body);

                                //             var res = await req.send();
                                //             final resBody = await res.stream
                                //                 .bytesToString();

                                //             if (res.statusCode >= 200 &&
                                //                 res.statusCode < 300) {
                                //               setState(() {
                                //                 taleData = jsonDecode(resBody);
                                //                 isLoading = false;
                                //               });
                                //             } else {}

                                //             Navigator.of(context).push(
                                //               MaterialPageRoute(
                                //                 builder: (context) =>
                                //                     TaleDetail(
                                //                   thumbnail: Localizations.localeOf(
                                //                                   context)
                                //                               .toString() ==
                                //                           "ko"
                                //                       ? ref.watch(rankingTaleProviderModel.notifier).tales[ref
                                //                               .watch(rankingTaleProviderModel
                                //                                   .notifier)
                                //                               .tales
                                //                               .keys
                                //                               .toList()[indexNum]]
                                //                           ["1"]
                                //                       : ref.watch(enrankingTaleProviderModel.notifier).tales[ref
                                //                           .watch(enrankingTaleProviderModel
                                //                               .notifier)
                                //                           .tales
                                //                           .keys
                                //                           .toList()[indexNum]]["1"],
                                //                   title: Localizations.localeOf(context)
                                //                               .toString() ==
                                //                           "ko"
                                //                       ? ref.watch(rankingTaleProviderModel.notifier).tales[ref
                                //                               .watch(
                                //                                   rankingTaleProviderModel
                                //                                       .notifier)
                                //                               .tales
                                //                               .keys
                                //                               .toList()[indexNum]]
                                //                           ["title"]
                                //                       : ref.watch(enrankingTaleProviderModel.notifier).tales[ref
                                //                           .watch(
                                //                               enrankingTaleProviderModel
                                //                                   .notifier)
                                //                           .tales
                                //                           .keys
                                //                           .toList()[indexNum]]["title"],
                                //                   taleData: taleData,
                                //                   userId: Localizations.localeOf(context)
                                //                               .toString() ==
                                //                           "ko"
                                //                       ? ref.watch(rankingTaleProviderModel.notifier).tales[ref
                                //                               .watch(
                                //                                   rankingTaleProviderModel
                                //                                       .notifier)
                                //                               .tales
                                //                               .keys
                                //                               .toList()[indexNum]]
                                //                           ["user_id"]
                                //                       : ref.watch(enrankingTaleProviderModel.notifier).tales[ref
                                //                               .watch(
                                //                                   enrankingTaleProviderModel
                                //                                       .notifier)
                                //                               .tales
                                //                               .keys
                                //                               .toList()[indexNum]]
                                //                           ["user_id"],
                                //                   timeStamp: Localizations
                                //                                   .localeOf(
                                //                                       context)
                                //                               .toString() ==
                                //                           "ko"
                                //                       ? ref
                                //                           .watch(
                                //                               rankingTaleProviderModel
                                //                                   .notifier)
                                //                           .tales
                                //                           .keys
                                //                           .toList()[indexNum]
                                //                       : ref
                                //                           .watch(
                                //                               enrankingTaleProviderModel
                                //                                   .notifier)
                                //                           .tales
                                //                           .keys
                                //                           .toList()[indexNum],
                                //                 ),
                                //               ),
                                //             );
                                //           }
                                //         },
                                //         child: Padding(
                                //           padding: const EdgeInsets.symmetric(
                                //               horizontal: 24),
                                //           child: Container(
                                //             width: MediaQuery.of(context)
                                //                         .size
                                //                         .width >
                                //                     600
                                //                 ? MediaQuery.of(context)
                                //                         .size
                                //                         .width *
                                //                     14 /
                                //                     36
                                //                 : MediaQuery.of(context)
                                //                         .size
                                //                         .width *
                                //                     1 /
                                //                     2,
                                //             height: MediaQuery.of(context)
                                //                         .size
                                //                         .width >
                                //                     600
                                //                 ? MediaQuery.of(context)
                                //                         .size
                                //                         .width *
                                //                     16 /
                                //                     36
                                //                 : MediaQuery.of(context)
                                //                         .size
                                //                         .width *
                                //                     23 /
                                //                     36,
                                //             decoration: BoxDecoration(
                                //                 image: DecorationImage(
                                //                     image: Image.asset(books[int.parse(Localizations.localeOf(context)
                                //                                     .toString() ==
                                //                                 "ko"
                                //                             ? ref.watch(rankingTaleProviderModel.notifier).tales[
                                //                                     ref.watch(rankingTaleProviderModel.notifier).tales.keys.toList()[indexNum]]
                                //                                 ["num"]
                                //                             : ref.watch(enrankingTaleProviderModel.notifier).tales[ref
                                //                                 .watch(enrankingTaleProviderModel.notifier)
                                //                                 .tales
                                //                                 .keys
                                //                                 .toList()[indexNum]]["num"])])
                                //                         .image)),
                                //             child: Padding(
                                //               padding: EdgeInsets.only(
                                //                   left: MediaQuery.of(context)
                                //                               .size
                                //                               .width >
                                //                           600
                                //                       ? 40
                                //                       : MediaQuery.of(context)
                                //                               .size
                                //                               .width *
                                //                           26 /
                                //                           360,
                                //                   top: MediaQuery.of(context)
                                //                               .size
                                //                               .width >
                                //                           600
                                //                       ? 20
                                //                       : MediaQuery.of(context)
                                //                               .size
                                //                               .width *
                                //                           14 /
                                //                           360,
                                //                   right: MediaQuery.of(context)
                                //                           .size
                                //                           .width *
                                //                       14 /
                                //                       360),
                                //               child: Column(
                                //                 crossAxisAlignment:
                                //                     CrossAxisAlignment.center,
                                //                 children: [
                                //                   Container(
                                //                     width: MediaQuery.of(
                                //                                     context)
                                //                                 .size
                                //                                 .width >
                                //                             600
                                //                         ? MediaQuery.of(context)
                                //                                 .size
                                //                                 .width *
                                //                             100 /
                                //                             360
                                //                         : MediaQuery.of(context)
                                //                                 .size
                                //                                 .width *
                                //                             140 /
                                //                             360,
                                //                     height: MediaQuery.of(
                                //                                     context)
                                //                                 .size
                                //                                 .width >
                                //                             600
                                //                         ? MediaQuery.of(context)
                                //                                 .size
                                //                                 .width *
                                //                             100 /
                                //                             360
                                //                         : MediaQuery.of(context)
                                //                                 .size
                                //                                 .width *
                                //                             140 /
                                //                             360,
                                //                     clipBehavior:
                                //                         Clip.antiAlias,
                                //                     decoration: BoxDecoration(
                                //                         border: Border.all(
                                //                             width: 3,
                                //                             color:
                                //                                 Colors.white),
                                //                         borderRadius:
                                //                             BorderRadius
                                //                                 .circular(10)),
                                //                     child: Container(
                                //                       clipBehavior:
                                //                           Clip.antiAlias,
                                //                       decoration: BoxDecoration(
                                //                         borderRadius:
                                //                             BorderRadius
                                //                                 .circular(10),
                                //                       ),
                                //                       child: CachedNetworkImage(
                                //                         width: MediaQuery.of(
                                //                                         context)
                                //                                     .size
                                //                                     .width >
                                //                                 600
                                //                             ? MediaQuery.of(
                                //                                         context)
                                //                                     .size
                                //                                     .width *
                                //                                 100 /
                                //                                 360
                                //                             : MediaQuery.of(
                                //                                         context)
                                //                                     .size
                                //                                     .width *
                                //                                 140 /
                                //                                 360,
                                //                         height: MediaQuery.of(
                                //                                         context)
                                //                                     .size
                                //                                     .width >
                                //                                 600
                                //                             ? MediaQuery.of(
                                //                                         context)
                                //                                     .size
                                //                                     .width *
                                //                                 100 /
                                //                                 360
                                //                             : MediaQuery.of(
                                //                                         context)
                                //                                     .size
                                //                                     .width *
                                //                                 140 /
                                //                                 360,
                                //                         imageUrl: Localizations.localeOf(
                                //                                         context)
                                //                                     .toString() ==
                                //                                 "ko"
                                //                             ? ref.watch(rankingTaleProviderModel.notifier).tales[ref
                                //                                     .watch(rankingTaleProviderModel
                                //                                         .notifier)
                                //                                     .tales
                                //                                     .keys
                                //                                     .toList()[
                                //                                 indexNum]]["1"]
                                //                             : ref.watch(enrankingTaleProviderModel.notifier).tales[ref
                                //                                 .watch(enrankingTaleProviderModel.notifier)
                                //                                 .tales
                                //                                 .keys
                                //                                 .toList()[indexNum]]["1"],
                                //                       ),
                                //                     ),
                                //                   ),
                                //                   const SizedBox(
                                //                     height: 8,
                                //                   ),
                                //                   Text(
                                //                     Localizations.localeOf(context)
                                //                                 .toString() ==
                                //                             "ko"
                                //                         ? ref
                                //                             .watch(
                                //                                 rankingTaleProviderModel
                                //                                     .notifier)
                                //                             .tales[ref
                                //                                 .watch(
                                //                                     rankingTaleProviderModel
                                //                                         .notifier)
                                //                                 .tales
                                //                                 .keys
                                //                                 .toList()[
                                //                             indexNum]]["title"]
                                //                         : ref.watch(enrankingTaleProviderModel.notifier).tales[ref
                                //                             .watch(enrankingTaleProviderModel.notifier)
                                //                             .tales
                                //                             .keys
                                //                             .toList()[indexNum]]["title"],
                                //                     style: TextStyle(
                                //                         fontSize: MediaQuery.of(
                                //                                         context)
                                //                                     .size
                                //                                     .width >
                                //                                 600
                                //                             ? 20
                                //                             : 14,
                                //                         fontWeight:
                                //                             FontWeight.bold,
                                //                         color: Colors.white),
                                //                   )
                                //                 ],
                                //               ),
                                //             ),
                                //           ),
                                //         ),
                                //       );
                                //     },
                                //     separatorBuilder:
                                //         (BuildContext context, index) {
                                //       return const SizedBox(
                                //         width: 1,
                                //       );
                                //     },
                                //   ),
                                // ),
                                const SizedBox(
                                  height: 50,
                                ),
                                isiOS
                                    ? Container()
                                    : Localizations.localeOf(context)
                                                .toString() ==
                                            "ko"
                                        ? Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 24),
                                            child:
                                                Localizations.localeOf(context)
                                                            .toString() ==
                                                        "ko"
                                                    ? GestureDetector(
                                                        onTap: () async {
                                                          if (!ref
                                                              .watch(
                                                                  playbackConfigProvider)
                                                              .muted) {
                                                            AudioPlayer().play(
                                                                AssetSource(
                                                                    'button_click.wav'));
                                                          }
                                                          const url =
                                                              'https://kobook.kids';
                                                          if (await canLaunchUrl(
                                                              Uri.parse(url))) {
                                                            await launchUrl(
                                                                Uri.parse(url));
                                                          } else {
                                                            throw 'Could not launch $url';
                                                          }
                                                        },
                                                        child: Container(
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          height: 66,
                                                          decoration: BoxDecoration(
                                                              color: const Color(
                                                                  0xffEBF4FF),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        18,
                                                                    vertical:
                                                                        11),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                const Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      "아이들을 위한 AI 동화 만들기",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              12,
                                                                          color:
                                                                              Color(0xff78AAFE)),
                                                                    ),
                                                                    Text(
                                                                      "꼬북이 궁금하신가요?",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color:
                                                                              Color(0xff468AFF)),
                                                                    )
                                                                  ],
                                                                ),
                                                                Image.asset(
                                                                  "assets/appicon.png",
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      1 /
                                                                      9,
                                                                  height: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      1 /
                                                                      9,
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : Container(),
                                          )
                                        : Container(),
                              ]),
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
                ));
  }
}
