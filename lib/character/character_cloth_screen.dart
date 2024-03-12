import 'package:audioplayers/audioplayers.dart';
import 'package:crepas/character/character_style_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../profile/setting_view_model.dart';

class ChoiceClothScreen extends ConsumerStatefulWidget {
  final int age;
  final String gender;
  final sendImage;

  const ChoiceClothScreen(
      {super.key, required this.age, required this.gender, this.sendImage});

  @override
  ChoiceClothScreenState createState() => ChoiceClothScreenState();
}

class ChoiceClothScreenState extends ConsumerState<ChoiceClothScreen> {
  final List<String> princessAssets = [
    "assets/clothes/princess1.png",
    "assets/clothes/princess.png",
    "assets/clothes/dress.png",
    "assets/clothes/princess3.png",
    "assets/clothes/princess4.png",
    "assets/clothes/princess5.png",
    "assets/clothes/princess6.png",
  ];
  final List<String> princeAssets = [
    "assets/clothes/prince.png",
    "assets/clothes/nobility.png",
  ];
  final List<String> fantasyAssets = [
    "assets/clothes/wizard.png",
    "assets/clothes/armor.png",
  ];
  final List<String> dailyAssets = [
    "assets/clothes/daily1.png",
    "assets/clothes/suit.png",
    "assets/clothes/daily2.png",
    "assets/clothes/daily3.png",
    "assets/clothes/daily4.png",
  ];

  final princessClothesName = [
    "크리스탈 드레스",
    "루비 드레스",
    "발레리나 드레스",
    "프리지아 드레스",
    "스노우 드레스",
    "꼬마공주 드레스",
    "백설공주 드레스"
  ];
  final princessClothesNameEn = [
    "Crystal Dress",
    "Ruby Dress",
    "Ballerina Dress",
    "Phrygian Dress",
    "Snow Dress",
    "Litte Princess Dress",
    "SnowWhite Dress"
  ];
  final princessColor = [
    0xFFE9F3FC,
    0xFFFDF2F9,
    0xffF9E9E5,
    0xffFFF5CD,
    0xFFE6F1F5,
    0xFFFFF0EC,
    0xFFFFF5D0
  ];
  final princessTextColor = [
    0xFF0075DD,
    0xFFFA64A2,
    0xFFF87B4E,
    0xFFFF9C08,
    0xFF1C9EE9,
    0xFFFD594A,
    0xFFF09F00
  ];
  final fantasyColor = [0xffF6FBDA, 0xffEFFEFF];
  final fantasyTextColor = [0xff657B62, 0xff47A4D1];
  final princeColor = [0xffF7ECFF, 0xffEAFEF7];
  final princeTextColor = [0xffAD47FF, 0xff44AAC8];
  final dailyColor = [
    0xFFEEFAFF,
    0xFFE2FAEC,
    0xFFFFF3F4,
    0xFFF2F9FC,
    0xFFECECEC
  ];
  final dailyTextColor = [
    0xFF46AAD3,
    0xFF36926C,
    0xFFEA6173,
    0xFF349FCD,
    0xFF585858
  ];
  final princeClothesName = ["다정한 왕자", "자상한 왕자"];
  final princeClothesNameEn = ["Affectionate Prince", "Charming Prince"];
  final fantasyClothesName = ["신비로운 마법사", "용감한 기사"];
  final fantasyClothesNameEn = ["Wizard", "Knight"];
  final dailyClothesName = [
    "귀여운 멜빵바지",
    "멋쟁이 정장",
    "핑크 리본 원피스",
    "세심한 도련님",
    "단정한 도련님"
  ];
  final dailyClothesNameEn = [
    "Suspenders Pants",
    "Suits",
    "One Piece",
    "Young Master",
    "Cute Master"
  ];
  final clothesNameEn = [
    "Wizard",
    "Knight",
    "Noble",
    "Princess",
    "Prince",
    "Bride"
  ];
  final clothInfo = [
    "princess1",
    "princess",
    "bride",
    "princess3",
    "princess4",
    "princess5",
    "princess6",
    "prince",
    "noble",
    "wizard",
    "knight",
    "daily1",
    "gentleman",
    "daily2",
    "daily3",
    "daily4"
  ];

  _onNextStyle() {
    if (!ref.watch(playbackConfigProvider).muted) {
      AudioPlayer().play(AssetSource('button_click.wav'));
    }
    final cloth = clothInfo[selectedNum];
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CharacterStyleScreen(
          age: widget.age,
          gender: widget.gender,
          sendImage: widget.sendImage,
          cloth: cloth,
        ),
      ),
    );
  }

  bool get isiOS =>
      foundation.defaultTargetPlatform == foundation.TargetPlatform.iOS;

  int selectedNum = -1;
  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 24, top: 16),
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
                              Localizations.localeOf(context).toString() == "ko"
                                  ? "캐릭터에게"
                                  : "Pick an outfit",
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width > 600
                                        ? 32
                                        : 20,
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.02,
                                fontFamily: "TmoneyRoundWind",
                              ),
                            ),
                            Text(
                              Localizations.localeOf(context).toString() == "ko"
                                  ? "무슨 옷을 입힐까요?"
                                  : "for your character to wear",
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width > 600
                                        ? 32
                                        : 20,
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.02,
                                fontFamily: "TmoneyRoundWind",
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 27,
                    ),
                    Text(
                      Localizations.localeOf(context).toString() == "ko"
                          ? "공주"
                          : "Princess",
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                      height: 200,
                      child: ListView.separated(
                        clipBehavior: Clip.none,
                        itemBuilder: (BuildContext context, indexNum) {
                          return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedNum = indexNum;
                                });
                              },
                              child: indexNum == 6
                                  ? Row(
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              150 /
                                              360,
                                          height: 200,
                                          decoration: BoxDecoration(
                                              color: Color(
                                                  princessColor[indexNum]),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: selectedNum == indexNum
                                                  ? Border.all(
                                                      color: const Color(
                                                          0xff468aff),
                                                      width: 1.5)
                                                  : const Border(),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: const Color(0xffADB8BC)
                                                      .withOpacity(0.7),
                                                  blurRadius: 6,
                                                )
                                              ]),
                                          child: Column(
                                            children: [
                                              const SizedBox(
                                                height: 8,
                                              ),
                                              Image.asset(
                                                princessAssets[indexNum],
                                                width: 150,
                                                height: 150,
                                              ),
                                              const SizedBox(
                                                height: 8,
                                              ),
                                              Text(
                                                Localizations.localeOf(context)
                                                            .toString() ==
                                                        "ko"
                                                    ? princessClothesName[
                                                        indexNum]
                                                    : princessClothesNameEn[
                                                        indexNum],
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(
                                                        princessTextColor[
                                                            indexNum])),
                                              )
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 24,
                                        )
                                      ],
                                    )
                                  : Container(
                                      width: MediaQuery.of(context).size.width *
                                          150 /
                                          360,
                                      height: 200,
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(0xffADB8BC)
                                                .withOpacity(0.7),
                                            blurRadius: 6,
                                          )
                                        ],
                                        color: Color(princessColor[indexNum]),
                                        borderRadius: BorderRadius.circular(10),
                                        border: indexNum == selectedNum
                                            ? Border.all(
                                                color: const Color(0xff468aff),
                                                width: 1.5)
                                            : const Border(),
                                      ),
                                      child: Column(
                                        children: [
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Image.asset(
                                            princessAssets[indexNum],
                                            width: 150,
                                            height: 150,
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Text(
                                            Localizations.localeOf(context)
                                                        .toString() ==
                                                    "ko"
                                                ? princessClothesName[indexNum]
                                                : princessClothesNameEn[
                                                    indexNum],
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Color(princessTextColor[
                                                    indexNum])),
                                          )
                                        ],
                                      ),
                                    ));
                        },
                        separatorBuilder: (BuildContext context, index) {
                          return const SizedBox(
                            width: 12,
                          );
                        },
                        itemCount: 7,
                        scrollDirection: Axis.horizontal,
                      ),
                    ),
                    const SizedBox(
                      height: 48,
                    ),
                    Text(
                      Localizations.localeOf(context).toString() == "ko"
                          ? "왕자"
                          : "Prince",
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.width * 200 / 360,
                      child: ListView.separated(
                        clipBehavior: Clip.none,
                        itemBuilder: (BuildContext context, indexNum) {
                          return GestureDetector(
                              onTap: () {
                                if (indexNum == 2) {
                                  setState(() {
                                    selectedNum = -1;
                                  });
                                } else {
                                  setState(() {
                                    selectedNum = indexNum + 7;
                                  });
                                }
                              },
                              child: indexNum == 2
                                  ? Row(
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              150 /
                                              360,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              200 /
                                              360,
                                          decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  color: const Color(0xffADB8BC)
                                                      .withOpacity(0.7),
                                                  blurRadius: 6,
                                                )
                                              ],
                                              color: const Color(0xFFF4F9FF),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Column(
                                            children: [
                                              const SizedBox(
                                                height: 84,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 40),
                                                child: Text(
                                                  Localizations.localeOf(
                                                                  context)
                                                              .toString() ==
                                                          "ko"
                                                      ? "새로운 왕자 옷 준비중..."
                                                      : "Preparing a new prince's outfit...",
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Color(0xffBAC9DB),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      height: 1.6),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 24,
                                        )
                                      ],
                                    )
                                  : Container(
                                      width: MediaQuery.of(context).size.width *
                                          150 /
                                          360,
                                      height:
                                          MediaQuery.of(context).size.width *
                                              200 /
                                              360,
                                      decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color(0xffADB8BC)
                                                  .withOpacity(0.7),
                                              blurRadius: 6,
                                            )
                                          ],
                                          color: Color(princeColor[indexNum]),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: indexNum == selectedNum - 7
                                              ? Border.all(
                                                  color:
                                                      const Color(0xff468aff),
                                                  width: 1.5)
                                              : const Border()),
                                      child: Column(
                                        children: [
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Image.asset(
                                            princeAssets[indexNum],
                                            width: 150,
                                            height: 150,
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Text(
                                            Localizations.localeOf(context)
                                                        .toString() ==
                                                    "ko"
                                                ? princeClothesName[indexNum]
                                                : princeClothesNameEn[indexNum],
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Color(
                                                    princeTextColor[indexNum])),
                                          )
                                        ],
                                      ),
                                    ));
                        },
                        separatorBuilder: (BuildContext context, index) {
                          return const SizedBox(
                            width: 12,
                          );
                        },
                        itemCount: 3,
                        scrollDirection: Axis.horizontal,
                      ),
                    ),
                    const SizedBox(
                      height: 48,
                    ),
                    Text(
                      Localizations.localeOf(context).toString() == "ko"
                          ? "판타지"
                          : "Fantasy",
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.width * 200 / 360,
                      child: ListView.separated(
                        clipBehavior: Clip.none,
                        itemBuilder: (BuildContext context, indexNum) {
                          return GestureDetector(
                              onTap: () {
                                if (indexNum == 2) {
                                  setState(() {
                                    selectedNum = -1;
                                  });
                                } else {
                                  setState(() {
                                    selectedNum = indexNum + 9;
                                  });
                                }
                              },
                              child: indexNum == 2
                                  ? Row(
                                      children: [
                                        Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                150 /
                                                360,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                200 /
                                                360,
                                            decoration: BoxDecoration(
                                                color: const Color(0xFFF4F9FF),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color:
                                                        const Color(0xffADB8BC)
                                                            .withOpacity(0.7),
                                                    blurRadius: 6,
                                                  )
                                                ]),
                                            child: Column(
                                              children: [
                                                const SizedBox(
                                                  height: 84,
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 40),
                                                  child: Text(
                                                    Localizations.localeOf(
                                                                    context)
                                                                .toString() ==
                                                            "ko"
                                                        ? "새로운 판타지 옷 준비중..."
                                                        : "Preparing new fantasy clothes...",
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        color:
                                                            Color(0xffBAC9DB),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        height: 1.6),
                                                  ),
                                                )
                                              ],
                                            )),
                                        const SizedBox(
                                          width: 24,
                                        )
                                      ],
                                    )
                                  : Container(
                                      width: MediaQuery.of(context).size.width *
                                          150 /
                                          360,
                                      height:
                                          MediaQuery.of(context).size.width *
                                              200 /
                                              360,
                                      decoration: BoxDecoration(
                                          color: Color(fantasyColor[indexNum]),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: indexNum == selectedNum - 9
                                              ? Border.all(
                                                  color:
                                                      const Color(0xff468aff),
                                                  width: 1.5)
                                              : const Border(),
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color(0xffADB8BC)
                                                  .withOpacity(0.7),
                                              blurRadius: 6,
                                            )
                                          ]),
                                      child: Column(
                                        children: [
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Image.asset(
                                            fantasyAssets[indexNum],
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                150 /
                                                360,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                150 /
                                                360,
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Text(
                                            Localizations.localeOf(context)
                                                        .toString() ==
                                                    "ko"
                                                ? fantasyClothesName[indexNum]
                                                : fantasyClothesNameEn[
                                                    indexNum],
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Color(fantasyTextColor[
                                                    indexNum])),
                                          )
                                        ],
                                      ),
                                    ));
                        },
                        separatorBuilder: (BuildContext context, index) {
                          return const SizedBox(
                            width: 12,
                          );
                        },
                        itemCount: 3,
                        scrollDirection: Axis.horizontal,
                      ),
                    ),
                    const SizedBox(
                      height: 48,
                    ),
                    Text(
                      Localizations.localeOf(context).toString() == "ko"
                          ? "일상복"
                          : "Daily",
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.width * 200 / 360,
                      child: ListView.separated(
                        clipBehavior: Clip.none,
                        itemBuilder: (BuildContext context, indexNum) {
                          return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedNum = indexNum + 11;
                                });
                              },
                              child: indexNum == 4
                                  ? Row(
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              150 /
                                              360,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              200 /
                                              360,
                                          decoration: BoxDecoration(
                                              color:
                                                  Color(dailyColor[indexNum]),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: const Color(0xffADB8BC)
                                                      .withOpacity(0.7),
                                                  blurRadius: 6,
                                                ),
                                              ],
                                              border:
                                                  indexNum == selectedNum - 11
                                                      ? Border.all(
                                                          color: const Color(
                                                              0xff468aff),
                                                          width: 1.5)
                                                      : const Border()),
                                          child: Column(
                                            children: [
                                              const SizedBox(
                                                height: 8,
                                              ),
                                              Image.asset(
                                                dailyAssets[indexNum],
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    150 /
                                                    360,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    150 /
                                                    360,
                                              ),
                                              const SizedBox(
                                                height: 8,
                                              ),
                                              Text(
                                                Localizations.localeOf(context)
                                                            .toString() ==
                                                        "ko"
                                                    ? dailyClothesName[indexNum]
                                                    : dailyClothesNameEn[
                                                        indexNum],
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(dailyTextColor[
                                                        indexNum])),
                                              )
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 24,
                                        )
                                      ],
                                    )
                                  : Container(
                                      width: MediaQuery.of(context).size.width *
                                          150 /
                                          360,
                                      height:
                                          MediaQuery.of(context).size.width *
                                              200 /
                                              360,
                                      decoration: BoxDecoration(
                                          color: Color(dailyColor[indexNum]),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: indexNum == selectedNum - 11
                                              ? Border.all(
                                                  color:
                                                      const Color(0xff468aff),
                                                  width: 1.5)
                                              : const Border(),
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color(0xffADB8BC)
                                                  .withOpacity(0.7),
                                              blurRadius: 6,
                                            )
                                          ]),
                                      child: Column(
                                        children: [
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Image.asset(
                                            dailyAssets[indexNum],
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                150 /
                                                360,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                150 /
                                                360,
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Text(
                                            Localizations.localeOf(context)
                                                        .toString() ==
                                                    "ko"
                                                ? dailyClothesName[indexNum]
                                                : dailyClothesNameEn[indexNum],
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Color(
                                                    dailyTextColor[indexNum])),
                                          )
                                        ],
                                      ),
                                    ));
                        },
                        separatorBuilder: (BuildContext context, index) {
                          return const SizedBox(
                            width: 12,
                          );
                        },
                        itemCount: 5,
                        scrollDirection: Axis.horizontal,
                      ),
                    ),
                    const SizedBox(
                      height: 64,
                    )
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: isiOS ? 32 : 28,
            left: 24,
            child: GestureDetector(
              onTap: () {
                _onNextStyle();
              },
              child: Container(
                width: MediaQuery.of(context).size.width - 48,
                height: 50,
                decoration: BoxDecoration(
                    color: selectedNum >= 0
                        ? const Color(0xff468aff)
                        : const Color(0xffc9d8e9),
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: Text(
                    Localizations.localeOf(context).toString() == "ko"
                        ? "선택 완료"
                        : "Choice Complete",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: "TmoneyRoundWind"),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
