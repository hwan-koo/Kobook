import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:crepas/apiPaths.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MakingTale extends ConsumerStatefulWidget {
  const MakingTale({
    super.key,
  });

  @override
  MakingTaleState createState() => MakingTaleState();
}

class MakingTaleState extends ConsumerState<MakingTale> {
  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod();
    });
  }

  int waitingTime = 10;
  String status = "1";
  bool isLoading = true;
  _asyncMethod() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final String? value = prefs.getString('jwt');
      var headersList = {
        'Authorization': "Bearer $value",
      };
      var url = Uri.parse(makingStatusUrl);

      var req = http.Request('GET', url);
      req.headers.addAll(headersList);

      var res = await req.send();
      var resBody = await res.stream.bytesToString();
      final String? bookWaiting = prefs.getString('book_waiting');
      if (res.statusCode >= 200 && res.statusCode < 300) {
        setState(() {
          isLoading = false;
          status = jsonDecode(resBody)['status'];
          waitingTime = 5 * int.parse(bookWaiting!);
        });
      } else {}
    } catch (e) {
      final value = await FirebaseAuth.instance.currentUser!.getIdToken();
      await prefs.setString('jwt', value!);

      var headersList = {
        'Authorization': "Bearer $value",
      };
      var url = Uri.parse(makingStatusUrl);

      var req = http.Request('GET', url);
      req.headers.addAll(headersList);

      var res = await req.send();
      var resBody = await res.stream.bytesToString();
      final String? bookWaiting = prefs.getString('book_waiting');
      if (res.statusCode >= 200 && res.statusCode < 300) {
        setState(() {
          isLoading = false;
          status = jsonDecode(resBody)['status'];
          waitingTime = 5 * int.parse(bookWaiting!);
        });
      } else {}
    }
  }

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
                            AudioPlayer().play(AssetSource('button_click.wav'));
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
                              Localizations.localeOf(context).toString() == "ko"
                                  ? "동화를 열심히 만들고 있어요"
                                  : "Working on a fairy tale",
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width > 600
                                          ? 32
                                          : 24,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: -0.02),
                            ),
                            Text(
                              Localizations.localeOf(context).toString() == "ko"
                                  ? "잠시만 기다려 주세요"
                                  : "Please wait a moment",
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width > 600
                                          ? 32
                                          : 24,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: -0.02),
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1,
                                          color: const Color(0xffd9dfe4)),
                                      borderRadius: BorderRadius.circular(50),
                                      color: status == "1"
                                          ? const Color(0xffB4D4FE)
                                          : const Color(0xff468AFF)),
                                  child: status == "1"
                                      ? const FaIcon(
                                          FontAwesomeIcons.ellipsis,
                                          color: Colors.white,
                                          size: 16,
                                        )
                                      : const FaIcon(
                                          FontAwesomeIcons.check,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  Localizations.localeOf(context).toString() ==
                                          "ko"
                                      ? "스토리를 만들고 있어요"
                                      : "creating a story",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: status == "1"
                                          ? const Color(0xff468aff)
                                          : Colors.black),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1,
                                          color: const Color(0xffd9dfe4)),
                                      borderRadius: BorderRadius.circular(50),
                                      color: status == "2"
                                          ? const Color(0xffB4D4FE)
                                          : status == "1"
                                              ? Colors.white
                                              : const Color(0xff468AFF)),
                                  child: status == "2"
                                      ? const FaIcon(
                                          FontAwesomeIcons.ellipsis,
                                          color: Colors.white,
                                          size: 16,
                                        )
                                      : status == "1"
                                          ? Container()
                                          : const FaIcon(
                                              FontAwesomeIcons.check,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  Localizations.localeOf(context).toString() ==
                                          "ko"
                                      ? "동화의 그림을 그리고 있어요"
                                      : "drawing a picture of a fairy tale",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: status == "2"
                                          ? const Color(0xff468aff)
                                          : status == "3"
                                              ? Colors.black
                                              : status == "4"
                                                  ? Colors.black
                                                  : const Color(0xffC1C1C1)),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1,
                                        color: const Color(0xffd9dfe4)),
                                    borderRadius: BorderRadius.circular(50),
                                    color: status == "3"
                                        ? const Color(0xffB4D4FE)
                                        : status == "4"
                                            ? const Color(0xff468AFF)
                                            : Colors.white,
                                  ),
                                  child: status == "3"
                                      ? const FaIcon(FontAwesomeIcons.ellipsis,
                                          color: Colors.white, size: 16)
                                      : status == "4"
                                          ? const FaIcon(FontAwesomeIcons.check,
                                              color: Colors.white, size: 16)
                                          : Container(),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  Localizations.localeOf(context).toString() ==
                                          "ko"
                                      ? "꼼꼼하게 완성하고 있어요"
                                      : "Perfecting the details",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: status == "3"
                                          ? const Color(0xff468aff)
                                          : status == "4"
                                              ? Colors.black
                                              : const Color(0xffC1C1C1)),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: status == "4"
                                        ? const Color(0xff468aff)
                                        : Colors.white,
                                    border: Border.all(
                                        width: 1,
                                        color: const Color(0xffd9dfe4)),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: status == "4"
                                      ? const FaIcon(FontAwesomeIcons.check,
                                          color: Colors.white, size: 16)
                                      : Container(),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  Localizations.localeOf(context).toString() ==
                                          "ko"
                                      ? "동화 생성 완료!"
                                      : "Fairy tale creation complete!",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: status == "4"
                                          ? const Color(0xff468aff)
                                          : const Color(0xffC1C1C1)),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  Localizations.localeOf(context).toString() ==
                                          "ko"
                                      ? "동화를 만드는데 $waitingTime"
                                      : "It takes $waitingTime minutes ",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(Localizations.localeOf(context)
                                            .toString() ==
                                        "ko"
                                    ? "분 소요 돼요"
                                    : " to create a fairy tale"),
                                const SizedBox(
                                  width: 10,
                                ),
                                // const FaIcon(FontAwesomeIcons.rotateRight)
                              ],
                            )
                          ],
                        ),
                      ],
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
