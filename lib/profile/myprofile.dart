import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crepas/apiPaths.dart';
import 'package:crepas/profile/setting_view_model.dart';
import 'package:crepas/profile/voice_setting.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../auth_repo.dart';

class MyProfileScreen extends ConsumerStatefulWidget {
  const MyProfileScreen({super.key});

  @override
  MyProfileScreenState createState() => MyProfileScreenState();
}

class MyProfileScreenState extends ConsumerState<MyProfileScreen> {
  _deleteGoogleUser() async {
    // await user?.reauthenticateWithCredential(credential);

    final value = await FirebaseAuth.instance.currentUser!.getIdToken();
    var headersList = {
      'Authorization': "Bearer $value",
    };
    var url = Uri.parse(removeUserUrl);

    var req = http.Request('GET', url);
    req.headers.addAll(headersList);

    var res = await req.send();
    var resBody = await res.stream.bytesToString();

    if (res.statusCode >= 200 && res.statusCode < 300) {
      print(resBody);
    } else {
      print(res.reasonPhrase);
    }

    CollectionReference users = FirebaseFirestore.instance.collection("users");
    User user = FirebaseAuth.instance.currentUser!;
    users.doc(user.uid).delete();
    user.delete();
    context.pop();
    context.go("/login");
  }

  _onLogout() async {
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
                Localizations.localeOf(context).toString() == "ko"
                    ? const Text(
                        "정말 로그아웃 하시나요?",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      )
                    : const Text(
                        "Are you sure log out?",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        ref.read(authRepo).signOut();
                        context.go("/");
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: 124,
                        height: 48,
                        child:
                            Localizations.localeOf(context).toString() == "ko"
                                ? const Text("로그아웃",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold))
                                : const Text("LogOut",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context, false);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width * 1 / 3,
                        height: 48,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color(0xff468AFF)),
                        child:
                            Localizations.localeOf(context).toString() == "ko"
                                ? const Text("취소",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white))
                                : const Text("Cancel",
                                    style: TextStyle(
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

  _onQuit() async {
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
                Localizations.localeOf(context).toString() == "ko"
                    ? const Text(
                        "정말 탈퇴하시겠어요?",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      )
                    : const Text(
                        "Are you sure you leave?",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                const SizedBox(
                  height: 12,
                ),
                Localizations.localeOf(context).toString() == "ko"
                    ? const Text(
                        "캐릭터와 동화책이 모두 삭제되고 복구할 수 없어요",
                        style: TextStyle(fontSize: 12),
                      )
                    : const Text(
                        "All information will be deleted.",
                        style: TextStyle(fontSize: 16),
                      ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _deleteGoogleUser();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: 124,
                        height: 48,
                        child:
                            Localizations.localeOf(context).toString() == "ko"
                                ? const Text("탈퇴할게요",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold))
                                : const Text("I'm leaving",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context, false);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width * 1 / 3,
                        height: 48,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color(0xff468AFF)),
                        child:
                            Localizations.localeOf(context).toString() == "ko"
                                ? const Text("생각해볼게요",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white))
                                : const Text("No",
                                    style: TextStyle(
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

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        start();
      }
    });

    super.initState();
  }

  bool noti = false;
  start() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    noti = prefs.getBool("noti") ?? false;
  }

  bool get isiOS =>
      foundation.defaultTargetPlatform == foundation.TargetPlatform.iOS;
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: ListView(
            children: [
              SwitchListTile.adaptive(
                value: ref.watch(playbackConfigProvider).muted,
                onChanged: (value) =>
                    ref.read(playbackConfigProvider.notifier).setMuted(value),
                title: Localizations.localeOf(context).toString() == "ko"
                    ? const Text("효과음 음소거")
                    : const Text("Mute sound"),
                subtitle: Localizations.localeOf(context).toString() == "ko"
                    ? const Text("설정 시 효과음이 나오지 않아요")
                    : const Text(""),
              ),
              Localizations.localeOf(context).toString() == "ko"
                  ? ListTile(
                      title: Localizations.localeOf(context).toString() == "ko"
                          ? const Text("동화 재생 음성 설정")
                          : const Text("Voice Setting"),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const VoiceSettingScreen(
                              comeSource: 'setting',
                            ),
                          ),
                        );
                      },
                    )
                  : Container(),
              ListTile(
                title: Localizations.localeOf(context).toString() == "ko"
                    ? const Text("이용약관")
                    : const Text("Terms of Use"),
                onTap: () async {
                  if (!ref.watch(playbackConfigProvider).muted) {
                    AudioPlayer().play(AssetSource('button_click.wav'));
                  }
                  const url =
                      'https://hwan9.notion.site/5f9b865645e049829048a4ebbe164289?pvs=4';
                  if (await canLaunchUrl(Uri.parse(url))) {
                    await launchUrl(Uri.parse(url));
                  } else {
                    throw 'Could not launch $url';
                  }
                },
              ),
              ListTile(
                title: Localizations.localeOf(context).toString() == "ko"
                    ? const Text(
                        "개인정보처리방침",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    : const Text("Privacy Policy"),
                onTap: () async {
                  if (!ref.watch(playbackConfigProvider).muted) {
                    AudioPlayer().play(AssetSource('button_click.wav'));
                  }
                  const url =
                      'https://hwan9.notion.site/a1d368f29b1b4aac934a229f0e6f6227?pvs=4';
                  if (await canLaunchUrl(Uri.parse(url))) {
                    await launchUrl(Uri.parse(url));
                  } else {
                    throw 'Could not launch $url';
                  }
                },
              ),
              Localizations.localeOf(context).toString() == "ko"
                  ? ListTile(
                      title: const Text("1:1 문의 하기"),
                      onTap: () async {
                        if (!ref.watch(playbackConfigProvider).muted) {
                          AudioPlayer().play(AssetSource('button_click.wav'));
                        }
                        const url = 'http://pf.kakao.com/_xlsudG/chat';
                        if (await canLaunchUrl(Uri.parse(url))) {
                          await launchUrl(Uri.parse(url),
                              mode: LaunchMode.externalApplication);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                    )
                  : const Text(""),
              AboutListTile(
                applicationName:
                    Localizations.localeOf(context).toString() == "ko"
                        ? "꼬북"
                        : "Kobook",
                applicationVersion: "2.2.0",
              ),
              ListTile(
                title: Localizations.localeOf(context).toString() == "ko"
                    ? const Text("로그아웃")
                    : const Text("Log Out"),
                textColor: Colors.grey,
                onTap: () {
                  _onLogout();
                },
              ),
              ListTile(
                title: Localizations.localeOf(context).toString() == "ko"
                    ? const Text("회원탈퇴")
                    : const Text("Sign Out"),
                textColor: Colors.grey,
                onTap: () {
                  _onQuit();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
