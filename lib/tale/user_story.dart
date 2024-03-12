import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import 'models/tale_view_model.dart';

class UserStory extends ConsumerStatefulWidget {
  final String character_datetime;
  final String character_name;
  final String character_type;
  final String background;
  const UserStory({
    super.key,
    required this.character_datetime,
    required this.character_name,
    required this.character_type,
    required this.background,
  });

  @override
  UserStoryState createState() => UserStoryState();
}

class UserStoryState extends ConsumerState<UserStory> {
  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    super.initState();
  }

  bool isInitial = true;
  bool isExample = false;
  bool isLoading = false;
  final _textController = TextEditingController();
  String story = "";
  bool get isiOS =>
      foundation.defaultTargetPlatform == foundation.TargetPlatform.iOS;
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
      body: Stack(
        children: [
          SafeArea(
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                              AudioPlayer()
                                  .play(AssetSource('button_click.wav'));
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
                                Localizations.localeOf(context).toString() ==
                                        "ko"
                                    ? "${widget.background}에서"
                                    : "What Do I",
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
                                    ? "무엇을 하나요?"
                                    : "In \"${widget.background}\"",
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width > 600
                                            ? 32
                                            : 24,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: -0.02),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 60,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.width > 600
                            ? MediaQuery.of(context).size.width * 20 / 36
                            : MediaQuery.of(context).size.width * 30 / 36,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                width: 1, color: const Color(0xff468AFF)),
                            color: const Color(0xffF9FBFF)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  MediaQuery.of(context).size.width > 600
                                      ? Text(
                                          Localizations.localeOf(context)
                                                      .toString() ==
                                                  "ko"
                                              ? "${widget.background}에서 \"${widget.character_name}\" 은(는)"
                                              : "${widget.character_name} is in ${widget.background}",
                                          style: const TextStyle(fontSize: 24),
                                        )
                                      : Text(
                                          Localizations.localeOf(context)
                                                      .toString() ==
                                                  "ko"
                                              ? "${widget.background}에서 \"${widget.character_name}\" 은(는)"
                                              : "${widget.character_name} is in ${widget.background}",
                                        ),
                                  IconButton(
                                      iconSize: 16,
                                      onPressed: () {
                                        _textController.clear();
                                        setState(() {
                                          story = "";
                                        });
                                      },
                                      icon: _textController.text.isNotEmpty
                                          ? const FaIcon(
                                              FontAwesomeIcons.solidCircleXmark)
                                          : const FaIcon(FontAwesomeIcons.pen))
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.width > 600
                                    ? MediaQuery.of(context).size.width *
                                        10 /
                                        36
                                    : MediaQuery.of(context).size.width *
                                        22 /
                                        36,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        width: 1,
                                        color: const Color(0xffECEDED)),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: TextField(
                                    style: TextStyle(
                                        color: const Color(0xff468AFF),
                                        fontSize:
                                            MediaQuery.of(context).size.width >
                                                    600
                                                ? 22
                                                : 14),
                                    cursorHeight: 15,
                                    maxLength: 300,
                                    maxLines: 7,
                                    controller: _textController,
                                    onChanged: (text) {
                                      setState(() {
                                        story = text;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      hintStyle:
                                          MediaQuery.of(context).size.width >
                                                  600
                                              ? const TextStyle(fontSize: 22)
                                              : const TextStyle(),
                                      border: InputBorder.none,
                                      hintText: Localizations.localeOf(context)
                                                  .toString() ==
                                              "ko"
                                          ? "예) 친구와 놀아요"
                                          : "ex) Playing with friends",
                                      constraints: const BoxConstraints(
                                          maxHeight: 80, maxWidth: 160),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      GestureDetector(
                        onTap: () async {
                          FirebaseAnalytics.instance
                              .logEvent(name: "TaleUserInput");
                          if (_textController.text.isNotEmpty) {
                            AudioPlayer().play(AssetSource('button_click.wav'));
                            setState(() {
                              isLoading = true;
                            });

                            final data =
                                Localizations.localeOf(context).toString() ==
                                        "ko"
                                    ? {
                                        "mode": "1",
                                        "theme": story,
                                        "background": widget.background,
                                        "character_datetime":
                                            widget.character_datetime,
                                        "character_type": widget.character_type,
                                        "name": widget.character_name
                                      }
                                    : {
                                        "mode": "1",
                                        "theme": story,
                                        "background": widget.background,
                                        "character_datetime":
                                            widget.character_datetime,
                                        "character_type": widget.character_type,
                                        "name": widget.character_name,
                                        "ver": "global"
                                      };

                            await ref
                                .watch(taleProviderModel.notifier)
                                .generateTale(data);
                            Navigator.pop(context, true);
                            context.pushReplacement("/mybook");
                          }
                        },
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.width > 600
                                ? 90
                                : 66,
                            decoration: ShapeDecoration(
                              color: _textController.text.isNotEmpty
                                  ? const Color(0xff468AFF)
                                  : const Color(0xffDFDFDF),
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
                                    Localizations.localeOf(context)
                                                .toString() ==
                                            "ko"
                                        ? "완료"
                                        : "Complete",
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width >
                                                    600
                                                ? 22
                                                : 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            )),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          isInitial
              ? Stack(
                  children: [
                    const Opacity(
                      opacity: 0.8,
                      child:
                          ModalBarrier(dismissible: false, color: Colors.black),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            Localizations.localeOf(context).toString() == "ko"
                                ? "꼬북 꿀팁 🍯"
                                : "👦🏻 Story Writing Tips 👧🏻",
                            style: const TextStyle(color: Color(0xffFFD646)),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            Localizations.localeOf(context).toString() == "ko"
                                ? "간단한 문장 몇 줄도 좋지만"
                                : "A few simple sentences are great, but",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: Localizations.localeOf(context)
                                            .toString() ==
                                        "ko"
                                    ? 20
                                    : 16,
                                fontWeight: FontWeight.w500),
                          ),
                          Text(
                              Localizations.localeOf(context).toString() == "ko"
                                  ? "내용을 자세하게 적을수록"
                                  : "The more details you include",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: Localizations.localeOf(context)
                                              .toString() ==
                                          "ko"
                                      ? 20
                                      : 16,
                                  fontWeight: FontWeight.w500)),
                          Text(
                              Localizations.localeOf(context).toString() == "ko"
                                  ? "더 멋진 동화를 만들 수 있어요!"
                                  : "the better your fairy tale will be!",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: Localizations.localeOf(context)
                                              .toString() ==
                                          "ko"
                                      ? 20
                                      : 16,
                                  fontWeight: FontWeight.w500)),
                          const SizedBox(
                            height: 30,
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isInitial = false;
                                isExample = true;
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: 120,
                              height: 50,
                              decoration: BoxDecoration(
                                  color: const Color(0xffFFD646),
                                  borderRadius: BorderRadius.circular(40)),
                              child: Text(
                                  Localizations.localeOf(context).toString() ==
                                          "ko"
                                      ? "예시 보기"
                                      : "See an example"),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isInitial = false;
                              });
                            },
                            child: Text(
                              Localizations.localeOf(context).toString() == "ko"
                                  ? "닫기"
                                  : "Close",
                              style: const TextStyle(color: Colors.white),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                )
              : Container(),
          isExample
              ? Stack(
                  children: [
                    const Opacity(
                      opacity: 0.8,
                      child:
                          ModalBarrier(dismissible: false, color: Colors.black),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            Localizations.localeOf(context).toString() == "ko"
                                ? "꼬북 꿀팁 🍯"
                                : "👦🏻 Story Writing Tips 👧🏻",
                            style: const TextStyle(color: Color(0xffFFD646)),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            Localizations.localeOf(context).toString() == "ko"
                                ? "\"서아는 시금치를 먹지 않아요."
                                : "\"Sofia doesn't eat spinach,",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                          Text(
                              Localizations.localeOf(context).toString() == "ko"
                                  ? "하지만 맛있는 시금치 요리를 먹은 뒤로"
                                  : " but after eating a delicious spinach dish,",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500)),
                          Text(
                              Localizations.localeOf(context).toString() == "ko"
                                  ? "시금치가 좋아졌어요.\""
                                  : " she loves it.\"",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500)),
                          const SizedBox(
                            height: 30,
                          ),
                          Container(
                              alignment: Alignment.center,
                              width: 268,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  Localizations.localeOf(context).toString() ==
                                          "ko"
                                      ? "옛날 어느 작은 마을에 서아라는 귀여운 아이가 살고 있었습니다. 하지만 서아에겐 작은 비밀이 있었어요. 바로 시금치를 좋아하지 않는 것이었습니다.(중략)\n\n 서아는 눈을 질끈 감고 시금치를 먹어 보았어요. 그런데 이게 웬걸, 시금치는 신선하고 맛있었어요. 서아는 이제 엄마의 시금치 요리를 매일 먹고 싶어할 정도로 시금치를 좋아하게 되었답니다."
                                      : "Once upon a time, in a small town, there lived a cute little girl named Seoah. But Seoah had a little secret: she didn't like spinach.(interruption)\n\n Seoah squeezed her eyes shut and tried some spinach, and lo and behold, it was fresh and delicious. Seoah now loved spinach so much that she wanted to eat her mom's spinach dishes every day.",
                                  style: const TextStyle(fontSize: 12),
                                ),
                              )),
                          const SizedBox(
                            height: 30,
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isExample = false;
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: 120,
                              height: 50,
                              decoration: BoxDecoration(
                                  color: const Color(0xffFFD646),
                                  borderRadius: BorderRadius.circular(40)),
                              child: Text(
                                  Localizations.localeOf(context).toString() ==
                                          "ko"
                                      ? "만들러 가기"
                                      : "Go To Make"),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                )
              : Container(),
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
