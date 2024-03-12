import 'package:audioplayers/audioplayers.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:crepas/tale/small_theme_choice.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MiddleThemeChoice extends StatefulWidget {
  final String bigTheme;
  final String character_datetime;
  final String character_name;
  final String character_type;
  const MiddleThemeChoice(
      {super.key,
      required this.bigTheme,
      required this.character_datetime,
      required this.character_name,
      required this.character_type});

  @override
  State<MiddleThemeChoice> createState() => _MiddleThemeChoiceState();
}

CarouselController carouselController = CarouselController();

bool get isiOS =>
    foundation.defaultTargetPlatform == foundation.TargetPlatform.iOS;
final images = {
  "직업을 체험해봐요!": jobImage,
  "Try out jobs!": jobImage,
  "Take adventure!": adventureImage,
  "Protect nature": envImage,
  "용감한 모험을 떠나요!": adventureImage,
  "자연과 환경보호": envImage
};
final adventureImage = [
  "assets/taleTheme/animals.png",
  "assets/taleTheme/magic.png",
  "assets/taleTheme/treasure.png"
];
final jobImage = [
  "assets/taleTheme/doctor.png",
  "assets/taleTheme/teacher.png",
  "assets/taleTheme/firefighter.png"
];
final envImage = [
  "assets/taleTheme/preserve.png",
  "assets/taleTheme/nature.png",
];
final toptitle1 = {
  "직업을 체험해봐요!": "어떤 직업을",
  "용감한 모험을 떠나요!": "어떤 모험을",
  "자연과 환경보호": "관심 있는 주제를"
};
final toptitle1En = {
  "Try out jobs!": "Which job",
  "Take adventure!": "What adventures",
  "Protect nature": "Choose the topic"
};
final toptitle2En = {
  "Try out jobs!": "would you like to try out?",
  "Take adventure!": " will you take?",
  "Protect nature": "you're interested in"
};

final toptitle2 = {
  "직업을 체험해봐요!": "체험하시겠어요?",
  "용감한 모험을 떠나요!": "떠나시겠어요?",
  "자연과 환경보호": "선택해주세요!"
};

final adventureTitle = ["동물 친구들과 모험을 떠날래요", "신비한 마법 세계로 떠날래요", "보물 찾기를 해볼래요"];
final jobTitleEn = [
  "Became a doctor",
  "Became a teacher",
  "Became a firefighter"
];
final environmentTitle = ["환경보호 방법에 대해 알아봐요", "자연의 중요성을 알아봐요"];
final adventureTitleEn = [
  "Go on an adventure with animal friends",
  "Go to a mysterious magical world",
  "Go on a treasure hunt"
];
final jobTitle = ["의사가 되었어요", "선생님이 되었어요", "소방관이 되었어요"];
final environmentTitleEn = [
  "Learn how to protect the environment",
  "Learn about the importance of nature"
];

final subTitle = {
  "직업을 체험해봐요!": jobTitle,
  "용감한 모험을 떠나요!": adventureTitle,
  "자연과 환경보호": environmentTitle
};
final subTitleEn = {
  "Try out jobs!": jobTitleEn,
  "Take adventure!": adventureTitleEn,
  "Protect nature": environmentTitleEn,
};
int _currentIndex = 0;

class _MiddleThemeChoiceState extends State<MiddleThemeChoice> {
  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                        width:
                            MediaQuery.of(context).size.width > 600 ? 200 : 120,
                        height:
                            MediaQuery.of(context).size.width > 600 ? 64 : 32,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              Localizations.localeOf(context).toString() == "ko"
                                  ? "동화 만들기"
                                  : "Make Tale",
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width > 600
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
                      AudioPlayer().play(AssetSource('button_click.wav'));
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.white),
                        width:
                            MediaQuery.of(context).size.width > 600 ? 200 : 120,
                        height:
                            MediaQuery.of(context).size.width > 600 ? 64 : 32,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              Localizations.localeOf(context).toString() == "ko"
                                  ? "동화 읽기"
                                  : "Read Books",
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width > 600
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
                            ? toptitle1[widget.bigTheme]!
                            : toptitle1En[widget.bigTheme]!,
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width > 600
                                ? 30
                                : 24,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.02),
                      ),
                      Text(
                        Localizations.localeOf(context).toString() == "ko"
                            ? toptitle2[widget.bigTheme]!
                            : toptitle2En[widget.bigTheme]!,
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width > 600
                                ? 30
                                : 24,
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
                      itemCount: images[widget.bigTheme]!.length,
                      itemBuilder: (BuildContext context, index, realIndex) =>
                          Container(
                            width: MediaQuery.of(context).size.width > 600
                                ? MediaQuery.of(context).size.width * 24 / 36
                                : MediaQuery.of(context).size.width * 32 / 36,
                            height: MediaQuery.of(context).size.width > 600
                                ? MediaQuery.of(context).size.width * 24 / 36
                                : MediaQuery.of(context).size.width * 32 / 36,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: const Color(0xffeceded), width: 1),
                                borderRadius: BorderRadius.circular(20)),
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20)),
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  child: Image.asset(
                                    images[widget.bigTheme]![index],
                                    width: MediaQuery.of(context).size.width >
                                            600
                                        ? MediaQuery.of(context).size.width *
                                            24 /
                                            36
                                        : MediaQuery.of(context).size.width *
                                            30 /
                                            36,
                                    height: MediaQuery.of(context).size.width >
                                            600
                                        ? MediaQuery.of(context).size.width *
                                            24 /
                                            36
                                        : MediaQuery.of(context).size.width *
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
                                        ? subTitle[widget.bigTheme]![index]
                                        : subTitleEn[widget.bigTheme]![index],
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width >
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
                            height: MediaQuery.of(context).size.width * 30 / 36,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  width: MediaQuery.of(context).size.width > 600
                                      ? 60
                                      : 40,
                                  height:
                                      MediaQuery.of(context).size.width > 600
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
                                      borderRadius: BorderRadius.circular(50)),
                                  child:
                                      const FaIcon(FontAwesomeIcons.angleLeft),
                                ),
                              ],
                            ),
                          ),
                        ),
                  _currentIndex == images[widget.bigTheme]!.length - 1
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
                            height: MediaQuery.of(context).size.width * 30 / 36,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  width: MediaQuery.of(context).size.width > 600
                                      ? 60
                                      : 40,
                                  height:
                                      MediaQuery.of(context).size.width > 600
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
                                      borderRadius: BorderRadius.circular(50)),
                                  child:
                                      const FaIcon(FontAwesomeIcons.angleRight),
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
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => SmallThemeChoice(
                              bigTheme: widget.bigTheme,
                              character_datetime: widget.character_datetime,
                              character_name: widget.character_name,
                              character_type: widget.character_type,
                              middleTheme: Localizations.localeOf(context)
                                          .toString() ==
                                      "ko"
                                  ? subTitle[widget.bigTheme]![_currentIndex]
                                  : subTitleEn[widget.bigTheme]![_currentIndex],
                            )),
                  );
                },
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width > 600 ? 90 : 66,
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
                            Localizations.localeOf(context).toString() == "ko"
                                ? "다음"
                                : "Next",
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
            ],
          ),
        ),
      ),
    );
  }
}
