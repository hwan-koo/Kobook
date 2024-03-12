import 'package:crepas/constants/gaps.dart';
import 'package:crepas/constants/sizes.dart';
import 'package:crepas/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({super.key});

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  void _onStart(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: TabBarView(
            children: [
              Stack(
                children: [
                  Image.asset(
                    "lib/onboarding/photos/aaa.png",
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 40,
                        ),
                        const TabPageSelector(
                          color: Colors.white,
                          selectedColor: Color(0xff468AFF),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Text(
                          Localizations.localeOf(context).toString() == "ko"
                              ? "우리 아이가 주인공인"
                              : "Create a fairy tale with my child",
                          style: const TextStyle(
                              fontSize: Sizes.size20,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          Localizations.localeOf(context).toString() == "ko"
                              ? "동화를 만들어요"
                              : "as the main character",
                          style: const TextStyle(
                              fontSize: Sizes.size20,
                              fontWeight: FontWeight.bold),
                        ),
                        Gaps.v20,
                        Text(
                          Localizations.localeOf(context).toString() == "ko"
                              ? "우리 아이가 주인공이 되어, 마법같은 이야기가 펼쳐져요"
                              : "A magical story with my child as the main character",
                          style: TextStyle(
                              fontSize:
                                  Localizations.localeOf(context).toString() ==
                                          "ko"
                                      ? Sizes.size12
                                      : 14),
                        ),
                        Text(
                          Localizations.localeOf(context).toString() == "ko"
                              ? "모험을 떠나 상상력을 마음껏 펼쳐봐요!"
                              : "Go on an adventure and let your imagination run wild!",
                          style: TextStyle(
                              fontSize:
                                  Localizations.localeOf(context).toString() ==
                                          "ko"
                                      ? Sizes.size12
                                      : 14),
                        ),
                        Gaps.v60,
                      ],
                    ),
                  ),
                  Positioned(
                      left: 30,
                      bottom: 40,
                      child: GestureDetector(
                        onTap: () {
                          _onStart(context);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: 70,
                          height: 36,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50)),
                          child: const Text(
                            "Skip",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ))
                ],
              ),
              Stack(
                children: [
                  Image.asset(
                    "lib/onboarding/photos/bbb.png",
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 40,
                        ),
                        const TabPageSelector(
                          color: Colors.white,
                          selectedColor: Color(0xff468AFF),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Text(
                          Localizations.localeOf(context).toString() == "ko"
                              ? "아이 맞춤형"
                              : "Personalized hyperrealistic",
                          style: const TextStyle(
                              fontSize: Sizes.size20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        Text(
                          Localizations.localeOf(context).toString() == "ko"
                              ? "하이퍼리얼리즘 동화"
                              : "fairy tales for kids",
                          style: const TextStyle(
                              fontSize: Sizes.size20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        Gaps.v20,
                        Text(
                          Localizations.localeOf(context).toString() == "ko"
                              ? "AI 기술로 내 아이만을 위한 이야기가 만들어져요"
                              : "AI creates a story just for your child",
                          style: TextStyle(
                              fontSize:
                                  Localizations.localeOf(context).toString() ==
                                          "ko"
                                      ? Sizes.size12
                                      : 14,
                              color: Colors.white),
                        ),
                        Text(
                          Localizations.localeOf(context).toString() == "ko"
                              ? "수십 가지 다양한 이야기의 동화를 만들어보세요!"
                              : "Create dozens of different fairy tales!",
                          style: TextStyle(
                              fontSize:
                                  Localizations.localeOf(context).toString() ==
                                          "ko"
                                      ? Sizes.size12
                                      : 14,
                              color: Colors.white),
                        ),
                        Gaps.v60,
                      ],
                    ),
                  ),
                  Positioned(
                      left: 30,
                      bottom: 40,
                      child: GestureDetector(
                        onTap: () {
                          _onStart(context);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: 70,
                          height: 36,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50)),
                          child: const Text(
                            "Skip",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ))
                ],
              ),
              Stack(
                children: [
                  Image.asset(
                    "lib/onboarding/photos/ccc.png",
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 40,
                        ),
                        const TabPageSelector(
                          color: Colors.white,
                          selectedColor: Color(0xff468AFF),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Text(
                          Localizations.localeOf(context).toString() == "ko"
                              ? "아이들에게"
                              : "Bringing joy",
                          style: const TextStyle(
                              fontSize: Sizes.size20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        Text(
                          Localizations.localeOf(context).toString() == "ko"
                              ? "즐거움을 전달합니다"
                              : "to Our kids",
                          style: const TextStyle(
                              fontSize: Sizes.size20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        Gaps.v20,
                        Text(
                          Localizations.localeOf(context).toString() == "ko"
                              ? "부모님과 아이들을 위한 단 하나뿐인 이야기가 만들어져요"
                              : "Create a one-of-a-kind story for parents and kids",
                          style: TextStyle(
                              fontSize:
                                  Localizations.localeOf(context).toString() ==
                                          "ko"
                                      ? Sizes.size12
                                      : 14,
                              color: Colors.white),
                        ),
                        Text(
                          Localizations.localeOf(context).toString() == "ko"
                              ? "태어나서 처음 만나는 동화책을 더 특별하게 간직해요!"
                              : "Make your favorite children's book even more special!",
                          style: TextStyle(
                              fontSize:
                                  Localizations.localeOf(context).toString() ==
                                          "ko"
                                      ? Sizes.size12
                                      : 14,
                              color: Colors.white),
                        ),
                        Gaps.v60,
                      ],
                    ),
                  ),
                  Positioned(
                      left: 24,
                      right: 24,
                      bottom: 40,
                      child: GestureDetector(
                        onTap: () {
                          _onStart(context);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            Localizations.localeOf(context).toString() == "ko"
                                ? "시작하기"
                                : "Get Started",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
