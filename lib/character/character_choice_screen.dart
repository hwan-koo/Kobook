import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:crepas/character/models/character_view_model.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../profile/setting_view_model.dart';

class CharacterChoiceFinalScreen extends ConsumerStatefulWidget {
  final List<Image> image;
  final String name;
  const CharacterChoiceFinalScreen(
      {super.key, required this.image, required this.name});

  @override
  CharacterChoiceScreenState createState() => CharacterChoiceScreenState();
}

class CharacterChoiceScreenState
    extends ConsumerState<CharacterChoiceFinalScreen> {
  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    super.initState();
  }

  var imageUrl = "";
  Future apiRequest() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final String? value = prefs.getString('jwt');
      var headersList = {
        'Authorization': "Bearer $value",
        'Content-Type': 'application/json'
      };
      var url = Uri.parse(
          'https://kifdc7pg1k.execute-api.ap-northeast-2.amazonaws.com/dev/character/image/upscale');

      var body = {"index": selectedImage + 1, "name": widget.name};

      var req = http.Request('POST', url);
      req.headers.addAll(headersList);
      req.body = json.encode(body);

      var res = await req.send();
      final resBody = await res.stream.bytesToString();

      if (res.statusCode >= 200 && res.statusCode < 300) {
        setState(() {
          imageUrl = jsonDecode(resBody)['img_url'];
        });
      } else {}
    } catch (e) {
      final value = await FirebaseAuth.instance.currentUser!.getIdToken();
      await prefs.setString('jwt', value!);

      var headersList = {
        'Authorization': "Bearer $value",
        'Content-Type': 'application/json'
      };
      var url = Uri.parse(
          'https://kifdc7pg1k.execute-api.ap-northeast-2.amazonaws.com/dev/character/image/upscale');

      var body = {"index": selectedImage + 1, "name": widget.name};

      var req = http.Request('POST', url);
      req.headers.addAll(headersList);
      req.body = json.encode(body);

      var res = await req.send();
      final resBody = await res.stream.bytesToString();

      if (res.statusCode >= 200 && res.statusCode < 300) {
        print(resBody);
        setState(() {
          imageUrl = jsonDecode(resBody)['img_url'];
        });
      } else {
        print(res.reasonPhrase);
      }
    }
  }

  Future<bool> _onBackKey() async {
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
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  Localizations.localeOf(context).toString() == "ko"
                      ? "캐릭터를 만들고 있어요"
                      : "Now Creating a character..",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                    Localizations.localeOf(context).toString() == "ko"
                        ? "정말 그만하시겠어요?"
                        : "Are you sure stop?",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(
                  height: 20,
                ),
                Text(
                    Localizations.localeOf(context).toString() == "ko"
                        ? "입력한 캐릭터 정보는 저장되지 않아요"
                        : "The character information entered is not saved",
                    style: const TextStyle(
                        fontSize: 12, color: Color(0xff8B8B8B))),
                const SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context, true);
                        context.pushReplacement("/home");
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: 124,
                        height: 48,
                        child: Text(
                            Localizations.localeOf(context).toString() == "ko"
                                ? "그만할래요"
                                : "Stop Making",
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context, false);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: 124,
                        height: 48,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color(0xff468AFF)),
                        child: Text(
                            Localizations.localeOf(context).toString() == "ko"
                                ? "계속할래요"
                                : "Cancel",
                            style: const TextStyle(
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

  bool get isiOS =>
      foundation.defaultTargetPlatform == foundation.TargetPlatform.iOS;
  int selectedImage = -1;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return _onBackKey();
      },
      child: Scaffold(
        appBar: isiOS
            ? AppBar(
                backgroundColor:
                    isLoading ? Colors.black.withOpacity(0.5) : Colors.white,
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
            SingleChildScrollView(
              child: SafeArea(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Localizations.localeOf(context).toString() == "ko"
                            ? "가장 마음에 드는"
                            : "Choose your",
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        Localizations.localeOf(context).toString() == "ko"
                            ? "캐릭터를 선택해주세요"
                            : "favorite character",
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width > 600
                                ? MediaQuery.of(context).size.width * 0.7
                                : MediaQuery.of(context).size.width * 0.85,
                            height: MediaQuery.of(context).size.width > 600
                                ? MediaQuery.of(context).size.height * 0.6
                                : MediaQuery.of(context).size.height * 0.55,
                            child: GridView.builder(
                                itemCount: 4,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        mainAxisSpacing: 10,
                                        crossAxisSpacing: 10,
                                        childAspectRatio: 148 / 204),
                                itemBuilder: (BuildContext context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedImage = index;
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 6,
                                            color: selectedImage == index
                                                ? Colors.blue
                                                : Colors.white),
                                      ),
                                      child: Image(
                                        image: widget.image[index].image,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      GestureDetector(
                        onTap: () async {
                          FirebaseAnalytics.instance
                              .logEvent(name: "ChoiceCharacter");
                          if (!ref.watch(playbackConfigProvider).muted) {
                            AudioPlayer().play(AssetSource('button_click.wav'));
                          }

                          // ignore: use_build_context_synchronously

                          if (selectedImage != -1) {
                            setState(() {
                              isLoading = true;
                            });
                            await ref
                                .read(characterProviderModel.notifier)
                                .generateCharacter(selectedImage, widget.name);
                            Navigator.of(context)
                                .popUntil((route) => route.isFirst);
                            if (!ref.watch(playbackConfigProvider).muted) {
                              AudioPlayer().play(AssetSource('complete.mp3'));
                            }
                          }
                        },
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 66,
                            decoration: ShapeDecoration(
                              color: (selectedImage == -1)
                                  ? const Color(0xffDFDFDF)
                                  : const Color(0xff468AFF),
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
                                        ? "선택 완료"
                                        : "Complete the selection",
                                    style: TextStyle(
                                        fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width >
                                                600
                                            ? 20
                                            : Localizations.localeOf(context)
                                                        .toString() ==
                                                    "ko"
                                                ? 16
                                                : 18,
                                        fontWeight: FontWeight.bold,
                                        color: selectedImage == -1
                                            ? const Color(0xffC1C1C1)
                                            : Colors.white),
                                  ),
                                ],
                              ),
                            )),
                      ),
                    ],
                  ),
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
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              Localizations.localeOf(context).toString() == "ko"
                                  ? "사진을 불러오고 있어요, 잠시만 기다려주세요"
                                  : "Loading photos, please wait",
                              style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            SpinKitSpinningCircle(
                              itemBuilder: (context, index) {
                                return Center(
                                  child: Image.asset("assets/turtle.png"),
                                );
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
