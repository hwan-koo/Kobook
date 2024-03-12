import 'package:audioplayers/audioplayers.dart';
import 'package:bookfx/bookfx.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class ViewerScreen extends StatefulWidget {
  final List<String> images;
  final String title;
  const ViewerScreen({super.key, required this.images, required this.title});

  @override
  State<ViewerScreen> createState() => _ViewerScreenState();
}

class _ViewerScreenState extends State<ViewerScreen> {
  BookController bookController = BookController();
  bool get isiOS =>
      foundation.defaultTargetPlatform == foundation.TargetPlatform.iOS;

  @override
  void initState() {
    // 가로 화면 고정
    isiOS
        ? SystemChrome.setPreferredOrientations(
            [DeviceOrientation.landscapeRight])
        : SystemChrome.setPreferredOrientations(
            [DeviceOrientation.landscapeLeft]);
    super.initState();
  }

  @override
  void dispose() {
    // 세로 화면 고정
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  _alertEnd() async {
    return await showDialog(
        barrierDismissible: true,
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
                  FontAwesomeIcons.check,
                  color: Color(0xff468AFF),
                  size: 50,
                )
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "동화를 모두 읽었어요 🎉",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        Navigator.pop(context, true);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: 124,
                        height: 48,
                        child: const Text("취소",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context, true);
                        context.pushReplacement("/home");
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: 124,
                        height: 48,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color(0xff468AFF)),
                        child: const Text("다른 동화 보기",
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

  int isEnd = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: BookFx(
          lastCallBack: (index) {
            AudioPlayer().play(AssetSource('turnpage.mp3'));
          },
          nextCallBack: (index) {
            AudioPlayer().play(AssetSource('turnpage.mp3'));

            if (index == widget.images.length) {
              setState(() {
                isEnd += 1;
              });
            }
            if (isEnd >= 3) {
              _alertEnd();
            }
          },
          size: Size(
            MediaQuery.of(context).size.height,
            MediaQuery.of(context).size.width,
          ),
          pageCount: 8,
          currentPage: (index) {
            return CachedNetworkImage(
              imageUrl: widget.images[index],
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              fit: BoxFit.cover,
            );
          },
          nextPage: (index) {
            return CachedNetworkImage(
              imageUrl: widget.images[index],
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              fit: BoxFit.cover,
            );
          },
          controller: bookController),
    );
  }
}
