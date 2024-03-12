import 'dart:convert';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:crepas/apiPaths.dart';
import 'package:crepas/character/camera_screen.dart';
import 'package:crepas/character/character_cloth_screen.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../profile/setting_view_model.dart';
import 'components/textbutton.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:http/http.dart' as http;

class PhotoSelectionScreen extends ConsumerStatefulWidget {
  final int age;
  final String gender;
  const PhotoSelectionScreen(
      {super.key, required this.age, required this.gender});

  @override
  PhotoSelectionScreenState createState() => PhotoSelectionScreenState();
}

class PhotoSelectionScreenState extends ConsumerState<PhotoSelectionScreen> {
  _onChoicephoto() {
    if (!ref.watch(playbackConfigProvider).muted) {
      AudioPlayer().play(AssetSource('button_click.wav'));
    }
    _showBottomSheet();
  }

  XFile? _pickedFile;

  // _getCameraImage() async {
  //   final pickedFile = await ImagePicker()
  //       .pickImage(source: ImageSource.camera, imageQuality: 50);
  //   if (pickedFile != null) {
  //     setState(() {
  //       _pickedFile = pickedFile;
  //     });
  //   } else {
  //     if (kDebugMode) {
  //       print('이미지 선택안함');
  //     }
  //   }
  // }

  _getPhotoLibraryImage() async {
    if (!ref.watch(playbackConfigProvider).muted) {
      AudioPlayer().play(AssetSource('button_click.wav'));
    }
    final pickedFile = await ImagePicker().pickImage(
      // maxHeight: 800,
      // maxWidth: 600,
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _pickedFile = pickedFile;
      });
      context.pop();
    } else {
      if (kDebugMode) {
        print('이미지 선택안함');
      }
    }
  }

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _onHelp();
    });
  }

  bool isLoading = false;

  Future<bool> _sendImageCheck() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final String? value = prefs.getString('jwt');
      var headersList = {
        'Authorization': "Bearer $value",
        'Content-Type': 'application/json'
      };
      String postUrl = imageCheckURL;

      var file = _pickedFile!;

      var body = await file.readAsBytes();

      String encodedImage = base64Encode(body);
      Map<String, String> payload = {
        "image": encodedImage,
      };
      String jsonPayload = jsonEncode(payload);

      http.Response response = await http.post(Uri.parse(postUrl),
          body: jsonPayload, headers: headersList);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return true;
      } else {
        setState(() {
          isLoading = false;
        });
        return false;
      }
    } catch (e) {
      final value = await FirebaseAuth.instance.currentUser!.getIdToken();
      await prefs.setString('jwt', value!);

      var headersList = {
        'Authorization': "Bearer $value",
        'Content-Type': 'application/json'
      };
      String postUrl = imageCheckURL;

      var file = _pickedFile!;

      var body = await file.readAsBytes();

      String encodedImage = base64Encode(body);
      Map<String, String> payload = {
        "image": encodedImage,
      };
      String jsonPayload = jsonEncode(payload);

      http.Response response = await http.post(Uri.parse(postUrl),
          body: jsonPayload, headers: headersList);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return true;
      } else {
        setState(() {
          isLoading = false;
        });
        return false;
      }
    }
  }

  _onHelp() async {
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  Localizations.localeOf(context).toString() == "ko"
                      ? '어떤 사진을 올려야 할까요?'
                      : "Which photos should you post?",
                  style: TextStyle(
                      fontSize:
                          MediaQuery.of(context).size.width > 600 ? 18 : 12,
                      color: const Color(0xff468AFF),
                      fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context, false);
                  },
                  child: const Icon(
                    Icons.close,
                    color: Color(0xffC1C1C1),
                    size: 25,
                  ),
                )
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Image.asset(
                      "assets/help1.png",
                      width: MediaQuery.of(context).size.width * 7 / 36,
                      height: MediaQuery.of(context).size.width * 7 / 36,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Image.asset(
                      "assets/help2.png",
                      width: MediaQuery.of(context).size.width * 7 / 36,
                      height: MediaQuery.of(context).size.width * 7 / 36,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Image.asset(
                      "assets/help3.png",
                      width: MediaQuery.of(context).size.width * 7 / 36,
                      height: MediaQuery.of(context).size.width * 7 / 36,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 24,
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          width:
                              MediaQuery.of(context).size.width > 600 ? 24 : 16,
                          height:
                              MediaQuery.of(context).size.width > 600 ? 24 : 16,
                          decoration: BoxDecoration(
                              color: const Color(0xff468AFF),
                              borderRadius: BorderRadius.circular(100)),
                          child: Text(
                            "1",
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width > 600
                                        ? 16
                                        : 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                        SizedBox(
                          width:
                              MediaQuery.of(context).size.width > 600 ? 10 : 5,
                        ),
                        Text(
                          Localizations.localeOf(context).toString() == "ko"
                              ? "부모님과 같이 찍은 사진이 아닌"
                              : "Upload a photo of your child alone",
                          style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width > 600
                                  ? 16
                                  : 13),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          width:
                              MediaQuery.of(context).size.width > 600 ? 24 : 16,
                          height:
                              MediaQuery.of(context).size.width > 600 ? 24 : 16,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(100)),
                          child: Text(
                            "1",
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width > 600
                                        ? 16
                                        : 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                        SizedBox(
                          width:
                              MediaQuery.of(context).size.width > 600 ? 10 : 5,
                        ),
                        Text(
                          Localizations.localeOf(context).toString() == "ko"
                              ? "아이 혼자 나온 사진을 올려 주세요"
                              : "not with your parents",
                          style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width > 600
                                  ? 16
                                  : 13),
                        )
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          width:
                              MediaQuery.of(context).size.width > 600 ? 24 : 16,
                          height:
                              MediaQuery.of(context).size.width > 600 ? 24 : 16,
                          decoration: BoxDecoration(
                              color: const Color(0xff468AFF),
                              borderRadius: BorderRadius.circular(100)),
                          child: Text(
                            "2",
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width > 600
                                        ? 16
                                        : 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                        SizedBox(
                          width:
                              MediaQuery.of(context).size.width > 600 ? 10 : 5,
                        ),
                        Text(
                          Localizations.localeOf(context).toString() == "ko"
                              ? "유치원이나 학교처럼 복잡한 배경에서"
                              : "Photos with complex backgrounds",
                          style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width > 600
                                  ? 16
                                  : 13),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          width:
                              MediaQuery.of(context).size.width > 600 ? 24 : 16,
                          height:
                              MediaQuery.of(context).size.width > 600 ? 24 : 16,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(100)),
                          child: Text(
                            "1",
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width > 600
                                        ? 16
                                        : 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                        SizedBox(
                          width:
                              MediaQuery.of(context).size.width > 600 ? 10 : 5,
                        ),
                        Text(
                          Localizations.localeOf(context).toString() == "ko"
                              ? "찍힌 사진은 얼굴을 인식하기 어려워요"
                              : "make it difficult to recognize faces.",
                          style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width > 600
                                  ? 16
                                  : 13),
                        )
                      ],
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }

  _onAlert() async {
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            insetPadding: const EdgeInsets.all(10),
            backgroundColor: Colors.white,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  Localizations.localeOf(context).toString() == "ko"
                      ? '다른 사진을 올려주세요'
                      : "Upload another photo!",
                  style: const TextStyle(
                      fontSize: 20,
                      color: Colors.red,
                      fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context, false);
                  },
                  child: const Icon(
                    Icons.close,
                    color: Color(0xffC1C1C1),
                    size: 25,
                  ),
                )
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Image.asset(
                      "assets/help1.png",
                      width: MediaQuery.of(context).size.width * 7 / 36,
                      height: MediaQuery.of(context).size.width * 7 / 36,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Image.asset(
                      "assets/help2.png",
                      width: MediaQuery.of(context).size.width * 7 / 36,
                      height: MediaQuery.of(context).size.width * 7 / 36,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Image.asset(
                      "assets/help3.png",
                      width: MediaQuery.of(context).size.width * 7 / 36,
                      height: MediaQuery.of(context).size.width * 7 / 36,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 24,
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                              color: const Color(0xff468AFF),
                              borderRadius: BorderRadius.circular(100)),
                          child: const Text(
                            "1",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          Localizations.localeOf(context).toString() == "ko"
                              ? "부모님과 같이 찍은 사진이 아닌"
                              : "Upload a photo of your child alone",
                          style: const TextStyle(fontSize: 13),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(100)),
                          child: const Text(
                            "1",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          Localizations.localeOf(context).toString() == "ko"
                              ? "아이 혼자 나온 사진을 올려 주세요"
                              : "not with your parents",
                          style: const TextStyle(fontSize: 13),
                        )
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                              color: const Color(0xff468AFF),
                              borderRadius: BorderRadius.circular(100)),
                          child: const Text(
                            "2",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          Localizations.localeOf(context).toString() == "ko"
                              ? "유치원이나 학교처럼 복잡한 배경에서"
                              : "Photos with complex backgrounds",
                          style: const TextStyle(fontSize: 13),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(100)),
                          child: const Text(
                            "1",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          Localizations.localeOf(context).toString() == "ko"
                              ? "찍힌 사진은 얼굴을 인식하기 어려워요"
                              : "make it difficult to recognize faces.",
                          style: const TextStyle(fontSize: 13),
                        )
                      ],
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }

  void _onNextPage() async {
    if (!ref.watch(playbackConfigProvider).muted) {
      AudioPlayer().play(AssetSource('button_click.wav'));
    }
    setState(() {
      isLoading = true;
    });
    if (await _sendImageCheck()) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ChoiceClothScreen(
            age: widget.age,
            gender: widget.gender,
            sendImage: _pickedFile,
          ),
        ),
      );
      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
        _pickedFile = null;
      });
      FirebaseAnalytics.instance.logEvent(name: "PhotoInvalid");
      _onAlert();
    }
  }

  bool get isiOS =>
      foundation.defaultTargetPlatform == foundation.TargetPlatform.iOS;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
                                ? "아이가 잘 보이는"
                                : "Upload ",
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.02,
                                fontFamily: "TmoneyRoundWind"),
                          ),
                          Text(
                            Localizations.localeOf(context).toString() == "ko"
                                ? "사진을 올려 주세요"
                                : "photo of your child",
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.02,
                                fontFamily: "TmoneyRoundWind"),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  Text(
                    Localizations.localeOf(context).toString() == "ko"
                        ? "사진은 캐릭터를 만드는 목적 외에"
                        : "Photos are never used for anything",
                    style:
                        const TextStyle(fontSize: 12, color: Color(0xff8B8B8B)),
                  ),
                  Text(
                    Localizations.localeOf(context).toString() == "ko"
                        ? "절대 사용되지 않아요."
                        : "other than character creation.",
                    style:
                        const TextStyle(fontSize: 12, color: Color(0xff8B8B8B)),
                  ),
                  const SizedBox(height: 37),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (!ref.watch(playbackConfigProvider).muted) {
                            AudioPlayer().play(AssetSource('button_click.wav'));
                          }
                          _onHelp();
                        },
                        child: Container(
                          width: 89,
                          height: 32,
                          decoration: BoxDecoration(
                              color: const Color(0xff468AFF),
                              borderRadius: BorderRadius.circular(40)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.info_outline,
                                size: 16,
                                color: Colors.white,
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Text(
                                Localizations.localeOf(context).toString() ==
                                        "ko"
                                    ? "도움말"
                                    : "Help",
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  if (_pickedFile == null)
                    Image.asset(
                      "assets/nomirror.png",
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width * 0.7,
                    )
                  else
                    Stack(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.width > 600
                                  ? 60
                                  : 30,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.45,
                              height: MediaQuery.of(context).size.width * 0.55,
                              decoration: ShapeDecoration(
                                shape: const OvalBorder(),
                                image: DecorationImage(
                                    image: FileImage(File(_pickedFile!.path)),
                                    fit: BoxFit.fill),
                              ),
                            ),
                          ],
                        ),
                        Image.asset(
                          "assets/mirrorin.png",
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.width * 0.7,
                        ),
                      ],
                    ),
                  const SizedBox(
                    height: 23,
                  ),
                  if (_pickedFile != null)
                    Row(
                      children: [
                        GestureDetector(
                          onTap: _onChoicephoto,
                          child: Container(
                              width:
                                  MediaQuery.of(context).size.width * 150 / 360,
                              height: 66,
                              decoration: ShapeDecoration(
                                color: Colors.white,
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
                                          ? "다시 올리기"
                                          : "Repost",
                                      style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width >
                                                  600
                                              ? 20
                                              : 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              )),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        GestureDetector(
                          onTap: _onNextPage,
                          child: Container(
                              width:
                                  MediaQuery.of(context).size.width * 150 / 360,
                              height: 66,
                              decoration: ShapeDecoration(
                                color: Colors.blue,
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
                                          ? "다음"
                                          : "Next",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width >
                                                  600
                                              ? 20
                                              : 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              )),
                        ),
                      ],
                    )
                  else
                    GestureDetector(
                      onTap: _onChoicephoto,
                      child: CGTextButton(
                        buttonText:
                            Localizations.localeOf(context).toString() == "ko"
                                ? "사진 올리기"
                                : "Upload a photo",
                        isCentered: true,
                      ),
                    ),
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            Localizations.localeOf(context).toString() == "ko"
                                ? "얼굴이 맞는지 검증하고 있어요!"
                                : "validating a photo..",
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
                    ),
                  ],
                )
              : Container()
        ],
      ),
    );
  }

  _showBottomSheet() {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () async {
                if (!ref.watch(playbackConfigProvider).muted) {
                  AudioPlayer().play(AssetSource('button_click.wav'));
                }
                final reuslt = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CameraScreen(),
                    ));
                setState(() {
                  _pickedFile = reuslt;
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  alignment: Alignment.centerLeft,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  height: 60,
                  child: Text(
                    Localizations.localeOf(context).toString() == "ko"
                        ? "사진찍기"
                        : "Take a Photo",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: _getPhotoLibraryImage,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  alignment: Alignment.centerLeft,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  height: 60,
                  child: Text(
                    Localizations.localeOf(context).toString() == "ko"
                        ? "앨범에서 불러오기 "
                        : "Import from an album",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }
}
