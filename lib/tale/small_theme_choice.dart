import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import '../profile/setting_view_model.dart';
import 'models/tale_view_model.dart';

class SmallThemeChoice extends ConsumerStatefulWidget {
  final String bigTheme;
  final String middleTheme;
  final String character_datetime;
  final String character_name;
  final String character_type;
  const SmallThemeChoice(
      {super.key,
      required this.middleTheme,
      required this.character_datetime,
      required this.bigTheme,
      required this.character_name,
      required this.character_type});

  @override
  SmallThemeChoiceState createState() => SmallThemeChoiceState();
}

bool get isiOS =>
    foundation.defaultTargetPlatform == foundation.TargetPlatform.iOS;
final images = {
  "의사가 되었어요": doctorImage,
  "선생님이 되었어요": teacherImage,
  "소방관이 되었어요": fireImage,
  "동물 친구들과 모험을 떠날래요": animalsImage,
  "신비한 마법 세계로 떠날래요": magicImage,
  "보물 찾기를 해볼래요": treasureImage,
  "환경보호 방법에 대해 알아봐요": preserveImage,
  "자연의 중요성을 알아봐요": natureImage,
  "Became a doctor": doctorImage,
  "Became a teacher": teacherImage,
  "Became a firefighter": fireImage,
  "Go on an adventure with animal friends": animalsImage,
  "Go to a mysterious magical world": magicImage,
  "Go on a treasure hunt": treasureImage,
  "Learn how to protect the environment": preserveImage,
  "Learn about the importance of nature": natureImage,
};
final doctorImage = [
  "assets/taleTheme/dog1.png",
  "assets/taleTheme/cat1.png",
  "assets/taleTheme/bear1.png"
];
final teacherImage = [
  "assets/taleTheme/korean.png",
  "assets/taleTheme/math.png",
  "assets/taleTheme/english.png"
];
final fireImage = [
  "assets/taleTheme/heartfulFire.png",
  "assets/taleTheme/braveFire.png",
  "assets/taleTheme/smartFire.png"
];
final animalsImage = [
  "assets/taleTheme/cat2.png",
  "assets/taleTheme/dog2.png",
  "assets/taleTheme/rabbit2.png"
];
final magicImage = [
  "assets/taleTheme/magiccastle.png",
  "assets/taleTheme/magicforest.png",
  "assets/taleTheme/seakingdom.png"
];
final treasureImage = ["assets/taleTheme/toy.png", "assets/taleTheme/food.png"];
final preserveImage = [
  "assets/taleTheme/recycling.png",
  "assets/taleTheme/nofood.png"
];
final natureImage = [
  "assets/taleTheme/treeimportant.png",
  "assets/taleTheme/animalimportant.png"
];

final toptitle1 = {
  "의사가 되었어요": "누구를 ",
  "선생님이 되었어요": "어떤 선생님이",
  "소방관이 되었어요": "어떤 소방관이",
  "동물 친구들과 모험을 떠날래요": "누구와 함께",
  "신비한 마법 세계로 떠날래요": "어떤 곳으로",
  "보물 찾기를 해볼래요": "어떤 보물을",
  "환경보호 방법에 대해 알아봐요": "우리 지구를",
  "자연의 중요성을 알아봐요": "생태계의",
};
final toptitle1En = {
  "Became a doctor": "Who do you?",
  "Became a teacher": "What kind of teacher",
  "Became a firefighter": "What kind of firefighter",
  "Go on an adventure with animal friends": "Who do you",
  "Go to a mysterious magical world": "Where do you ",
  "Go on a treasure hunt": "What treasures",
  "Learn how to protect the environment": "Taking our planet",
  "Learn about the importance of nature": "Learn",
};

final toptitle2 = {
  "의사가 되었어요": "도와주고 싶나요?",
  "선생님이 되었어요": "되고 싶나요?",
  "소방관이 되었어요": "되고 싶나요?",
  "동물 친구들과 모험을 떠날래요": "떠나고 싶나요?",
  "신비한 마법 세계로 떠날래요": "가보고 싶나요?",
  "보물 찾기를 해볼래요": "찾고 싶나요?",
  "환경보호 방법에 대해 알아봐요": "우리 손으로 지켜요",
  "자연의 중요성을 알아봐요": "중요성을 알아봐요",
};
final toptitle2En = {
  "Became a doctor": "want to help",
  "Became a teacher": "do you want to be?",
  "Became a firefighter": "do you want to be?",
  "Go on an adventure with animal friends": "want to leave with?",
  "Go to a mysterious magical world": "want to go?",
  "Go on a treasure hunt": "do you want to find?",
  "Learn how to protect the environment": "into our own hands",
  "Learn about the importance of nature": "the importance of ecosystems"
};

final doctor = ["강아지", "고양이", "곰"];
final teacher = ["국어", "수학", "영어"];
final firefighter = ["마음씨 따뜻한 소방관", "용감한 소방관", "똑똑한 소방관"];
final animalfriends = ["고양이", "강아지", "토끼"];
final magicworld = ["마법의 성", "마법의 숲", "바다 왕국"];
final treasure = ["장난감", "맛있는 음식"];
final preserve = ["분리수거를 잘해요", "음식을 남기지 않아요"];
final nature = ["식물과 나무의 중요성을 알아봐요", "동물의 중요성을 알아봐요"];
final doctorEn = ["Puppy", "Cat", "Bear"];
final teacherEn = ["Korean", "Math", "English"];
final firefighterEn = [
  "Heartful firefighter",
  "Brave firefighter",
  "Smart firefighter"
];
final animalfriendsEn = ["Cat", "Puppy", "Rabbit"];
final magicworldEn = ["Magic Castle", "Magic Forest", "Sea Kingdom"];
final treasureEn = ["Toys", "Delicious Food"];
final preserveEn = ["Recycle well", "Don't leave food behind"];
final natureEn = [
  "Learn the importance of plants",
  "Learn about the importance of animals"
];

final subTitle = {
  "의사가 되었어요": doctor,
  "선생님이 되었어요": teacher,
  "소방관이 되었어요": firefighter,
  "동물 친구들과 모험을 떠날래요": animalfriends,
  "신비한 마법 세계로 떠날래요": magicworld,
  "보물 찾기를 해볼래요": treasure,
  "환경보호 방법에 대해 알아봐요": preserve,
  "자연의 중요성을 알아봐요": nature,
};
final subTitleEn = {
  "Became a doctor": doctorEn,
  "Became a teacher": teacherEn,
  "Became a firefighter": firefighterEn,
  "Go on an adventure with animal friends": animalfriendsEn,
  "Go to a mysterious magical world": magicworldEn,
  "Go on a treasure hunt": treasureEn,
  "Learn how to protect the environment": preserveEn,
  "Learn about the importance of nature": natureEn,
};
int _currentIndex = 0;

class SmallThemeChoiceState extends ConsumerState<SmallThemeChoice> {
  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    super.initState();
  }

  Future apiRequest(data) async {
    final value = await FirebaseAuth.instance.currentUser!.getIdToken();

    var headersList = {
      'Authorization': "Bearer $value",
      'Content-Type': 'application/json'
    };
    var url = Uri.parse(
        'https://kifdc7pg1k.execute-api.ap-northeast-2.amazonaws.com/dev/book/make');

    var body = data;

    var req = http.Request('POST', url);
    req.headers.addAll(headersList);
    req.body = json.encode(body);

    var res = await req.send();
    final resBody = await res.stream.bytesToString();
    // final presignedUrl = jsonDecode(resBody)['presigned_url'];
    // await _sendImage(presignedUrl);
    if (res.statusCode >= 200 && res.statusCode < 300) {
      print(resBody);
    } else {
      print(res.reasonPhrase);
    }
  }

  var isLoading = false;
  CarouselController carouselController = CarouselController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: isiOS
      //     ? AppBar(
      //         backgroundColor:
      //             isLoading ? Colors.black.withOpacity(0.5) : Colors.white,
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
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
                            width: MediaQuery.of(context).size.width > 600
                                ? 200
                                : 120,
                            height: MediaQuery.of(context).size.width > 600
                                ? 64
                                : 32,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  Localizations.localeOf(context).toString() ==
                                          "ko"
                                      ? "동화 만들기"
                                      : "Make Tale",
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width >
                                                  600
                                              ? 24
                                              : Localizations.localeOf(context)
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
                          if (!ref.watch(playbackConfigProvider).muted) {
                            AudioPlayer().play(AssetSource('button_click.wav'));
                          }
                          Navigator.of(context)
                              .popUntil((route) => route.isFirst);
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.white),
                            width: MediaQuery.of(context).size.width > 600
                                ? 200
                                : 120,
                            height: MediaQuery.of(context).size.width > 600
                                ? 64
                                : 32,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  Localizations.localeOf(context).toString() ==
                                          "ko"
                                      ? "동화 읽기"
                                      : "Read Books",
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width >
                                                  600
                                              ? 24
                                              : Localizations.localeOf(context)
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
                            Localizations.localeOf(context).toString() == "ko"
                                ? toptitle1[widget.middleTheme]!
                                : toptitle1En[widget.middleTheme]!,
                            style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.02),
                          ),
                          Text(
                            Localizations.localeOf(context).toString() == "ko"
                                ? toptitle2[widget.middleTheme]!
                                : toptitle2En[widget.middleTheme]!,
                            style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.02),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Stack(
                    children: [
                      CarouselSlider.builder(
                          carouselController: carouselController,
                          itemCount: images[widget.middleTheme]!.length,
                          itemBuilder: (BuildContext context, index,
                                  realIndex) =>
                              Container(
                                width: MediaQuery.of(context).size.width > 600
                                    ? MediaQuery.of(context).size.width *
                                        24 /
                                        36
                                    : MediaQuery.of(context).size.width *
                                        32 /
                                        36,
                                height: MediaQuery.of(context).size.width > 600
                                    ? MediaQuery.of(context).size.width *
                                        24 /
                                        36
                                    : MediaQuery.of(context).size.width *
                                        32 /
                                        36,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: const Color(0xffeceded),
                                        width: 1),
                                    borderRadius: BorderRadius.circular(20)),
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      child: Image.asset(
                                        images[widget.middleTheme]![index],
                                        width:
                                            MediaQuery.of(context).size.width >
                                                    600
                                                ? MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    24 /
                                                    36
                                                : MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    30 /
                                                    36,
                                        height:
                                            MediaQuery.of(context).size.width >
                                                    600
                                                ? MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    24 /
                                                    36
                                                : MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    30 /
                                                    36,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Text(
                                        Localizations.localeOf(context)
                                                    .toString() ==
                                                "ko"
                                            ? subTitle[widget.middleTheme]![
                                                index]
                                            : subTitleEn[widget.middleTheme]![
                                                index],
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width >
                                                    600
                                                ? 24
                                                : 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                          options: CarouselOptions(
                            aspectRatio: 24 / 32,
                            viewportFraction: 1,
                            enableInfiniteScroll: false,
                            height: MediaQuery.of(context).size.width > 600
                                ? MediaQuery.of(context).size.width * 28 / 36
                                : MediaQuery.of(context).size.width,
                            onPageChanged: (index, reason) {
                              setState(() {
                                _currentIndex = index;
                              });
                            },
                          )),
                      _currentIndex == 0
                          ? Container()
                          : GestureDetector(
                              onTap: () {
                                carouselController.previousPage();
                              },
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.width * 30 / 36,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      width: MediaQuery.of(context).size.width >
                                              600
                                          ? 60
                                          : 40,
                                      height:
                                          MediaQuery.of(context).size.width >
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
                                          FontAwesomeIcons.angleLeft),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                      _currentIndex == images[widget.middleTheme]!.length - 1
                          ? Container()
                          : GestureDetector(
                              onTap: () {
                                carouselController.nextPage();
                                // setState(() {
                                //   _currentIndex += 1;
                                // });
                              },
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.width * 30 / 36,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      width: MediaQuery.of(context).size.width >
                                              600
                                          ? 60
                                          : 40,
                                      height:
                                          MediaQuery.of(context).size.width >
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
                                          FontAwesomeIcons.angleRight),
                                    ),
                                  ],
                                ),
                              ),
                            )
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.width > 600 ? 40 : 30,
                  ),
                  GestureDetector(
                    onTap: () async {
                      FirebaseAnalytics.instance
                          .logEvent(name: "TaleRecommendation");
                      if (!ref.watch(playbackConfigProvider).muted) {
                        AudioPlayer().play(AssetSource('button_click.wav'));
                      }

                      setState(() {
                        isLoading = true;
                      });

                      final data = Localizations.localeOf(context).toString() ==
                              "ko"
                          ? {
                              "mode": "0",
                              "theme": {
                                "major": widget.bigTheme,
                                "middle": widget.middleTheme,
                                "sub": Localizations.localeOf(context)
                                            .toString() ==
                                        "ko"
                                    ? subTitle[widget.middleTheme]![
                                        _currentIndex]
                                    : subTitleEn[widget.middleTheme]![
                                        _currentIndex]
                              },
                              "background": "0",
                              "character_datetime": widget.character_datetime,
                              "character_type": widget.character_type,
                              "name": widget.character_name
                            }
                          : {
                              "mode": "0",
                              "theme": {
                                "major": widget.bigTheme,
                                "middle": widget.middleTheme,
                                "sub": Localizations.localeOf(context)
                                            .toString() ==
                                        "ko"
                                    ? subTitle[widget.middleTheme]![
                                        _currentIndex]
                                    : subTitleEn[widget.middleTheme]![
                                        _currentIndex]
                              },
                              "background": "0",
                              "character_datetime": widget.character_datetime,
                              "character_type": widget.character_type,
                              "name": widget.character_name,
                              "ver": "global"
                            };
                      await ref
                          .watch(taleProviderModel.notifier)
                          .generateTale(data);
                      Navigator.pop(context, true);
                      context.pushReplacement("/mybook");

                      // alertComplete();
                      if (!ref.watch(playbackConfigProvider).muted) {
                        AudioPlayer().play(AssetSource('complete.mp3'));
                      }
                    },
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        height:
                            MediaQuery.of(context).size.width > 600 ? 90 : 66,
                        decoration: ShapeDecoration(
                          color: const Color(0xff468AFF),
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
                                    ? "완료"
                                    : "Complete",
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width > 600
                                            ? 22
                                            : 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        )),
                  ),
                  // Expanded(
                  //   child: ListView.separated(
                  //       shrinkWrap: true,
                  //       itemBuilder: (BuildContext context, index) {
                  //         return GestureDetector(
                  //           onTap: () async {
                  //             AudioPlayer()
                  //                 .play(AssetSource('button_click.wav'));
                  //             setState(() {
                  //               isLoading = true;
                  //             });
                  //             final data = {
                  //               "major": widget.bigTheme,
                  //               "middle": widget.middleTheme,
                  //               "sub": subTitle[widget.middleTheme]![index],
                  //               "character_datetime": widget.character
                  //             };
                  //             await ref
                  //                 .watch(taleProviderModel.notifier)
                  //                 .generateTale(data);
                  //             Navigator.of(context)
                  //                 .popUntil((route) => route.isFirst);

                  //             alertComplete();
                  //             AudioPlayer().play(AssetSource('complete.mp3'));
                  //           },
                  //           child: Row(
                  //             mainAxisAlignment: MainAxisAlignment.center,
                  //             children: [
                  //               Container(
                  //                 clipBehavior: Clip.antiAlias,
                  //                 width: MediaQuery.of(context).size.width > 600
                  //                     ? 430
                  //                     : MediaQuery.of(context).size.width,
                  //                 height:
                  //                     MediaQuery.of(context).size.width > 600
                  //                         ? 340
                  //                         : MediaQuery.of(context).size.height *
                  //                             0.3,
                  //                 decoration: ShapeDecoration(
                  //                   color: Colors.white,
                  //                   shape: RoundedRectangleBorder(
                  //                     borderRadius: BorderRadius.circular(10),
                  //                   ),
                  //                   shadows: const [
                  //                     BoxShadow(
                  //                       color: Color(0x0C000000),
                  //                       blurRadius: 10,
                  //                       offset: Offset(0, 4),
                  //                       spreadRadius: 0,
                  //                     )
                  //                   ],
                  //                 ),
                  //                 child: Column(
                  //                   crossAxisAlignment:
                  //                       CrossAxisAlignment.start,
                  //                   children: [
                  //                     Image.asset(
                  //                       images[widget.middleTheme]![index],
                  //                       width:
                  //                           MediaQuery.of(context).size.width,
                  //                       height:
                  //                           MediaQuery.of(context).size.height *
                  //                               18 /
                  //                               80,
                  //                       fit: BoxFit.cover,
                  //                     ),
                  //                     const SizedBox(
                  //                       height: 20,
                  //                     ),
                  //                     Padding(
                  //                       padding: const EdgeInsets.symmetric(
                  //                           horizontal: 18),
                  //                       child: Row(
                  //                         mainAxisAlignment:
                  //                             MainAxisAlignment.spaceBetween,
                  //                         children: [
                  //                           Text(
                  //                             subTitle[widget.middleTheme]![
                  //                                 index],
                  //                             style: const TextStyle(
                  //                                 fontSize: 16,
                  //                                 fontWeight: FontWeight.bold),
                  //                           ),
                  //                           const SizedBox(
                  //                             width: 32,
                  //                             child: FaIcon(
                  //                               FontAwesomeIcons.angleRight,
                  //                               color: Color(0xffCDCDCD),
                  //                             ),
                  //                           )
                  //                         ],
                  //                       ),
                  //                     ),
                  //                   ],
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //         );
                  //       },
                  //       separatorBuilder: (BuildContext context, index) =>
                  //           const SizedBox(
                  //             height: 20,
                  //           ),
                  //       itemCount: subTitle[widget.middleTheme]!.length),
                  // )
                ],
              ),
            ),
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
