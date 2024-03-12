import 'package:carousel_slider/carousel_slider.dart';
import 'package:crepas/tale/middle_theme_choice.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BigThemeChoice extends StatefulWidget {
  const BigThemeChoice(
      {super.key,
      required this.character_type,
      required this.character_datetime,
      required this.character_name});
  final String character_type;
  final String character_datetime;
  final String character_name;

  @override
  State<BigThemeChoice> createState() => _BigThemeChoiceState();
}

CarouselController carouselController = CarouselController();

bool get isiOS =>
    foundation.defaultTargetPlatform == foundation.TargetPlatform.iOS;

final images = [
  "assets/taleTheme/job.png",
  "assets/taleTheme/adventure.png",
  "assets/taleTheme/environment.png"
];
final title = ["직업을 체험해봐요!", "용감한 모험을 떠나요!", "자연과 환경보호"];
final titleEn = ["Try out jobs!", "Take adventure!", "Protect nature"];
final subTitle = [
  "독립적이고 기술적인 인간이 되어가는 과정을 그리며, 자아정체감을 찾고 자존감을 갖게 되는 과정을 체험해봐요",
  "사랑, 우정, 용감함, 인내심에 대한 이야기 속에서 모험하며 새로운 친구를 만드는 과정을 경험할 수 있어요.",
  "아름다운 자연과 환경에 관심을 가지게 되는 경험을 해볼 수 있어요."
];
final subTitleEn = [
  "Experience the process of becoming an independent, technological human being, finding self-identity, and gaining self-esteem.",
  "Experience adventures and make new friends in a story about love, friendship, bravery, and perseverance.",
  "It's a great way to develop an appreciation for beautiful nature and the environment."
];

class _BigThemeChoiceState extends State<BigThemeChoice> {
  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    super.initState();
  }

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(Localizations.localeOf(context).toString() == "ko"
            ? "주제 선택"
            : "Theme Choice"),
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          CarouselSlider.builder(
              carouselController: carouselController,
              itemCount: images.length,
              itemBuilder: (BuildContext context, index, realIndex) =>
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10)),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: Image.asset(
                          images[index],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
              options: CarouselOptions(
                viewportFraction: 1,
                enableInfiniteScroll: false,
                height: MediaQuery.of(context).size.height,
                enlargeCenterPage: true,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              )),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              const Color(0xff999999),
              const Color(0xff000000).withOpacity(0)
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          ),
          Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.52,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Stack(
                      children: [
                        Text(
                          Localizations.localeOf(context).toString() == "ko"
                              ? title[_currentIndex]
                              : titleEn[_currentIndex],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width > 600
                                ? 32
                                : Localizations.localeOf(context).toString() ==
                                        "ko"
                                    ? 20
                                    : 16,
                            letterSpacing: 5,
                            fontFamily: "TmoneyRoundWind",
                            fontWeight: FontWeight.bold,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth =
                                  Localizations.localeOf(context).toString() ==
                                          "ko"
                                      ? 8
                                      : 5
                              ..color = Colors.white,
                          ),
                        ),
                        Text(
                          Localizations.localeOf(context).toString() == "ko"
                              ? title[_currentIndex]
                              : titleEn[_currentIndex],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width > 600
                                ? 32
                                : Localizations.localeOf(context).toString() ==
                                        "ko"
                                    ? 20
                                    : 16,
                            letterSpacing: 5,
                            fontFamily: "TmoneyRoundWind",
                            fontWeight: FontWeight.bold,
                            color: const Color(0xff468aff),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                  decoration: BoxDecoration(
                      color: const Color(0xff333A44).withOpacity(0.5),
                      border: Border.all(
                          width: 1,
                          color: const Color(0xff333a44).withOpacity(0.5)),
                      borderRadius: BorderRadius.circular(12)),
                  width: Localizations.localeOf(context).toString() == "ko"
                      ? MediaQuery.of(context).size.width * 28 / 39
                      : MediaQuery.of(context).size.width * 30 / 39,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: RichText(
                      text: TextSpan(
                          text:
                              Localizations.localeOf(context).toString() == "ko"
                                  ? subTitle[_currentIndex]
                                  : subTitleEn[_currentIndex],
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: MediaQuery.of(context).size.width > 600
                                  ? 18
                                  : 14,
                              height: 1.6)),
                    ),
                  ))
            ],
          ),
          _currentIndex == 0
              ? Container()
              : GestureDetector(
                  onTap: () {
                    carouselController.previousPage();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            width: 40,
                            height: 40,
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
                            child: const FaIcon(FontAwesomeIcons.angleLeft),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
          _currentIndex == images.length - 1
              ? Container()
              : GestureDetector(
                  onTap: () {
                    carouselController.nextPage();
                    // setState(() {
                    //   _currentIndex += 1;
                    // });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            width: 40,
                            height: 40,
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
                            child: const FaIcon(FontAwesomeIcons.angleRight),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => MiddleThemeChoice(
                                  bigTheme: Localizations.localeOf(context)
                                              .toString() ==
                                          "ko"
                                      ? title[_currentIndex]
                                      : titleEn[_currentIndex],
                                  character_datetime: widget.character_datetime,
                                  character_name: widget.character_name,
                                  character_type: widget.character_type,
                                )),
                      );
                    },
                    child: Container(
                        width: MediaQuery.of(context).size.width * 0.9,
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
          )
        ],
      ),
    );
  }
}
