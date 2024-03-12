import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:crepas/character/models/character_view_model.dart';
import 'package:dio/dio.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:kakao_flutter_sdk_share/kakao_flutter_sdk_share.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;

class CharacterCompleteScreen extends ConsumerStatefulWidget {
  final String imageUrl;
  final String name;
  final String timestamp;
  const CharacterCompleteScreen(
      {super.key,
      required this.imageUrl,
      required this.name,
      required this.timestamp});

  @override
  CharacterCompleteScreenState createState() => CharacterCompleteScreenState();
}

class CharacterCompleteScreenState
    extends ConsumerState<CharacterCompleteScreen> {
  final FeedTemplate defaultFeed = FeedTemplate(
    content: Content(
      title: '내캐릭터 만들기',
      description: '#나만의 #캐릭터 #만들기 #꼬북 #으로 #오세요',
      imageUrl: Uri.parse(""),
      link: Link(
          webUrl: Uri.parse('https://developers.kakao.com'),
          mobileWebUrl: Uri.parse('https://developers.kakao.com')),
    ),
    buttons: [
      Button(
        title: '웹으로 보기',
        link: Link(
          webUrl: Uri.parse('https: //developers.kakao.com'),
          mobileWebUrl: Uri.parse('https: //developers.kakao.com'),
        ),
      ),
      Button(
        title: '앱으로보기',
        link: Link(
          androidExecutionParams: {'key1': 'value1', 'key2': 'value2'},
          iosExecutionParams: {'key1': 'value1', 'key2': 'value2'},
        ),
      ),
    ],
  );

  _save() async {
    var response = await Dio().get(widget.imageUrl,
        options: Options(responseType: ResponseType.bytes));
    final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(response.data),
        quality: 60,
        name: "hello");
    print(result);
  }

  _shareKakao() async {
    int templateId = 96111;
    bool isKakaoTalkSharingAvailable =
        await ShareClient.instance.isKakaoTalkSharingAvailable();
    if (isKakaoTalkSharingAvailable) {
      try {
        Uri uri = await ShareClient.instance.shareCustom(
            templateId: templateId, templateArgs: {"THU": widget.imageUrl});
        await ShareClient.instance.launchKakaoTalk(uri);
      } catch (error) {}
    } else {
      try {
        Uri shareUrl = await WebSharerClient.instance
            .makeDefaultUrl(template: defaultFeed);
        await launchBrowserTab(shareUrl, popupOpen: true);
      } catch (error) {}
    }
  }

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    super.initState();
  }

  bool get isiOS =>
      foundation.defaultTargetPlatform == foundation.TargetPlatform.iOS;

  alertSave() async {
    return await showDialog(
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
                        ? "저장이 완료되었어요!"
                        : "Saving is complete!",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(
                  height: 20,
                ),
                Text(
                    Localizations.localeOf(context).toString() == "ko"
                        ? "갤러리에서 확인해보세요"
                        : "Check it out in the gallery!",
                    style: const TextStyle(
                        fontSize: 16, color: Color(0xff8B8B8B))),
                const SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
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
                                ? "확인"
                                : "Okay",
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

  alertDelete() async {
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
                      ? "삭제한 캐릭터는 "
                      : "Deleted characters",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                    Localizations.localeOf(context).toString() == "ko"
                        ? "복구되지 않아요"
                        : "are not recovered",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(
                  height: 20,
                ),
                Text(
                    Localizations.localeOf(context).toString() == "ko"
                        ? "정말 삭제하시겠어요?"
                        : "Are you sure delete it?",
                    style: const TextStyle(
                        fontSize: 18,
                        color: Colors.red,
                        fontWeight: FontWeight.bold)),
                const SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        FirebaseAnalytics.instance
                            .logEvent(name: "DeleteCharacter");
                        ref
                            .read(characterProviderModel.notifier)
                            .removeCharacter(widget.timestamp);
                        Navigator.pop(context, true);
                        context.pushReplacement("/character");
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: 124,
                        height: 48,
                        child: Text(
                            Localizations.localeOf(context).toString() == "ko"
                                ? "삭제할래요"
                                : "Delete",
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
                                ? "괜찮아요"
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        toolbarHeight: 40,
        title: Text(
          widget.name,
          style:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: TextButton(
                onPressed: () {
                  alertDelete();
                },
                child: Text(
                  Localizations.localeOf(context).toString() == "ko"
                      ? "삭제"
                      : "Delete",
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff468AFF)),
                )),
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 40,
              ),
              CachedNetworkImage(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 5 / 8,
                imageUrl: widget.imageUrl,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                fit: BoxFit.cover,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 50 / 800,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      FirebaseAnalytics.instance
                          .logEvent(name: "SaveCharacterImage");
                      _save();
                      alertSave();
                    },
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: const Color(0xff468AFF)),
                        width: 79,
                        height: 32,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.file_download_outlined,
                              color: Colors.white,
                            ),
                            Text(
                              Localizations.localeOf(context).toString() == "ko"
                                  ? "저장"
                                  : "Save",
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            )
                          ],
                        )),
                  ),
                  GestureDetector(
                    onTap: () async {
                      FirebaseAnalytics.instance
                          .logEvent(name: "ShareCharacter");
                      if (Localizations.localeOf(context).toString() == "ko") {
                        _shareKakao();
                      } else {
                        final box = context.findRenderObject() as RenderBox?;

                        final http.Response responseData =
                            await http.get(Uri.parse(widget.imageUrl));
                        var uint8list = responseData.bodyBytes;
                        var buffer = uint8list.buffer;
                        ByteData byteData = ByteData.view(buffer);
                        var tempDir = await getTemporaryDirectory();
                        File file = await File('${tempDir.path}/img.jpg')
                            .writeAsBytes(buffer.asUint8List(
                                byteData.offsetInBytes,
                                byteData.lengthInBytes));
                        XFile files = XFile(file.path);

                        Share.shareXFiles([files],
                            subject: "My Character : ${widget.name}!!",
                            text: "Go To Make My child's Character",
                            sharePositionOrigin:
                                box!.localToGlobal(Offset.zero) & box.size);
                      }
                    },
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: const Color(0xff468AFF)),
                        width: 79,
                        height: 32,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.share,
                              color: Colors.white,
                            ),
                            Text(
                              Localizations.localeOf(context).toString() == "ko"
                                  ? "공유"
                                  : "Share",
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            )
                          ],
                        )),
                  ),
                ],
              )
              // GestureDetector(
              //   onTap: () {
              //     _save();
              //     alertSave();
              //   },
              //   child:
              //       const CGTextButton(buttonText: "저장하기", isCentered: true),
              // ),
              // GestureDetector(
              //   onTap: () {
              //     _shareKakao();
              //   },
              //   child:
              //       const CGTextButton(buttonText: "공유하기", isCentered: true),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
