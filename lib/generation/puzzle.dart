import 'package:crepas/constants/gaps.dart';
import 'package:crepas/generation/story_generation.dart';
import 'package:flutter/material.dart';

class PuzzleScreen extends StatefulWidget {
  const PuzzleScreen({super.key});

  @override
  State<PuzzleScreen> createState() => _PuzzleScreenState();
}

class _PuzzleScreenState extends State<PuzzleScreen> {
  void _onStoryTap() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const StoryGenerationScreen(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.1,
          vertical: MediaQuery.of(context).size.height * 0.05),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "동화만들기",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink),
            ),
            Gaps.v16,
            const Text(
              "아이들의 이야기를 만들어주세요",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            Gaps.v28,
            Row(
              children: [
                Container(
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(color: Colors.lightBlue),
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: MediaQuery.of(context).size.height * 0.2,
                  child: const Text(
                    "캐릭터 설정",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
                GestureDetector(
                  onTap: _onStoryTap,
                  child: Container(
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(color: Colors.lightGreen),
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.height * 0.2,
                    child: const Text(
                      "스토리 설정",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(color: Colors.purple),
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: MediaQuery.of(context).size.height * 0.2,
                  child: const Text(
                    "테마 설정",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}
