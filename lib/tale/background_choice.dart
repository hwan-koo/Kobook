import 'package:carousel_slider/carousel_slider.dart';
import 'package:crepas/tale/user_story.dart';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BackgroundChoice extends StatefulWidget {
  final String character_name;
  final String character_type;
  final String character_datetime;
  const BackgroundChoice({
    super.key,
    required this.character_name,
    required this.character_type,
    required this.character_datetime,
  });

  @override
  State<BackgroundChoice> createState() => _BackgroundChoiceState();
}

class _BackgroundChoiceState extends State<BackgroundChoice> {
  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    super.initState();
  }

  CarouselController carouselController = CarouselController();

  final backgroundImage = [
    "assets/talebackground/amusementpark.png",
    "assets/talebackground/school.png",
    "assets/talebackground/beach.png",
    "assets/talebackground/mountain.png",
    "assets/talebackground/playground.png",
    "assets/talebackground/house.png"
  ];
  final backgroundText = ["놀이공원", "학교", "바다", "산", "놀이터", "집"];
  final backgroundTextEn = [
    "Amusement Park",
    "School",
    "Sea",
    "Mountain",
    "Playground",
    "Home"
  ];

  bool get isiOS =>
      foundation.defaultTargetPlatform == foundation.TargetPlatform.iOS;
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(Localizations.localeOf(context).toString() == "ko"
            ? "배경이 될 장소는 어디인가요?"
            : "Where will the background be?"),
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          CarouselSlider.builder(
              carouselController: carouselController,
              itemCount: backgroundImage.length,
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
                          backgroundImage[index],
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
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    Text(
                      Localizations.localeOf(context).toString() == "ko"
                          ? backgroundText[_currentIndex]
                          : backgroundTextEn[_currentIndex],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize:
                            MediaQuery.of(context).size.width > 600 ? 32 : 26,
                        letterSpacing: 5,
                        fontFamily: "TmoneyRoundWind",
                        fontWeight: FontWeight.bold,
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth =
                              Localizations.localeOf(context).toString() == "ko"
                                  ? 10
                                  : 8
                          ..color = Colors.white,
                      ),
                    ),
                    Text(
                      Localizations.localeOf(context).toString() == "ko"
                          ? backgroundText[_currentIndex]
                          : backgroundTextEn[_currentIndex],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize:
                            MediaQuery.of(context).size.width > 600 ? 32 : 26,
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
          _currentIndex == backgroundImage.length - 1
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
                            builder: (context) => UserStory(
                                character_datetime: widget.character_datetime,
                                character_name: widget.character_name,
                                character_type: widget.character_type,
                                background: Localizations.localeOf(context)
                                            .toString() ==
                                        "ko"
                                    ? backgroundText[_currentIndex]
                                    : backgroundTextEn[_currentIndex])),
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
