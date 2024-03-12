import 'package:crepas/constants/gaps.dart';
import 'package:crepas/generation/charater_generation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class StoryGenerationScreen extends StatefulWidget {
  const StoryGenerationScreen({super.key});
  @override
  State<StoryGenerationScreen> createState() => _StoryGenerationScreenState();
}

class _StoryGenerationScreenState extends State<StoryGenerationScreen> {
  String story = "";

  bool _clicked1 = false;
  void _onStoryClick1() {
    setState(() {
      _clicked1 = !_clicked1;
      _clicked2 = false;
      _clicked3 = false;
    });
  }

  bool _clicked2 = false;
  void _onStoryClick2() {
    setState(() {
      _clicked2 = !_clicked2;
      _clicked1 = false;
      _clicked3 = false;
    });
  }

  bool _clicked3 = false;
  void _onStoryClick3() {
    setState(() {
      _clicked3 = !_clicked3;
      _clicked1 = false;
      _clicked2 = false;
    });
  }

  bool _small_choiced_1_1 = false;
  bool _small_choiced_1_2 = false;
  bool _small_choiced_1_3 = false;
  bool _small_choiced_1_4 = false;

  void _onSmallclick1_1() {
    setState(() {
      _small_choiced_1_2 = false;
      _small_choiced_1_3 = false;
      _small_choiced_1_4 = false;
      _small_choiced_1_1 = !_small_choiced_1_1;
    });
  }

  void _onSmallclick1_2() {
    setState(() {
      _small_choiced_1_1 = false;
      _small_choiced_1_3 = false;
      _small_choiced_1_4 = false;
      _small_choiced_1_2 = !_small_choiced_1_2;
    });
  }

  void _onSmallclick1_3() {
    setState(() {
      _small_choiced_1_2 = false;
      _small_choiced_1_1 = false;
      _small_choiced_1_4 = false;
      _small_choiced_1_3 = !_small_choiced_1_3;
    });
  }

  void _onSmallclick1_4() {
    setState(() {
      _small_choiced_1_2 = false;
      _small_choiced_1_3 = false;
      _small_choiced_1_1 = false;
      _small_choiced_1_4 = !_small_choiced_1_4;
    });
  }

  void _onStory() {
    if (_small_choiced_1_1) {
      setState(() {
        story = "소방관 직업을 체험해요";
      });
    }
    if (_small_choiced_1_2) {
      setState(() {
        story = "소방관 직업을 체험해요";
      });
    }
    if (_small_choiced_1_3) {
      setState(() {
        story = "축구선수 직업을 체험해요";
      });
    }
    if (_small_choiced_1_4) {
      setState(() {
        story = "경찰 직업을 체험해요";
      });
    }
  }

  void _onCompleteStory() async {
    _onStory();
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => CharacterChoiceScreen(
        story: story,
      ),
    ));
  }

  final List<String> images = [
    "assets/b.png",
    "assets/a.png",
    "assets/b.png",
    "assets/a.png"
  ];
  final List<String> tags = [""];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
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
                "스토리 선택",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              Gaps.v28,
              const Text(
                "어떤 이야기를 원하시나요?",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Gaps.v20,
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: _onStoryClick1,
                      child: Container(
                        decoration: BoxDecoration(
                            border: _clicked1
                                ? Border.all(color: Colors.pink, width: 3)
                                : Border.all(color: Colors.black)),
                        child: Column(
                          children: [
                            Image.asset(
                              "assets/b.png",
                              width: MediaQuery.of(context).size.width * 0.4,
                              height: MediaQuery.of(context).size.width * 0.4,
                            ),
                            const Text("직업 체험")
                          ],
                        ),
                      ),
                    ),
                    Card(
                      child: Column(
                        children: [
                          Image.asset(
                            "assets/b.png",
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: MediaQuery.of(context).size.width * 0.4,
                          ),
                          const Text("test1")
                        ],
                      ),
                    ),
                    Gaps.h10,
                    GestureDetector(
                      onTap: _onStoryClick2,
                      child: Container(
                        decoration: BoxDecoration(
                            border: _clicked2
                                ? Border.all(color: Colors.pink, width: 3)
                                : Border.all(color: Colors.black)),
                        child: Column(
                          children: [
                            Image.asset(
                              "assets/b.png",
                              width: MediaQuery.of(context).size.width * 0.4,
                              height: MediaQuery.of(context).size.width * 0.4,
                            ),
                            const Text("즐거운 모험")
                          ],
                        ),
                      ),
                    ),
                    Gaps.h10,
                    GestureDetector(
                      onTap: _onStoryClick3,
                      child: Container(
                        decoration: BoxDecoration(
                            border: _clicked3
                                ? Border.all(color: Colors.pink, width: 3)
                                : Border.all(color: Colors.black)),
                        child: Column(
                          children: [
                            Image.asset(
                              "assets/b.png",
                              width: MediaQuery.of(context).size.width * 0.4,
                              height: MediaQuery.of(context).size.width * 0.4,
                            ),
                            const Text("환경보호와 자연")
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  _clicked1
                      ? Column(
                          children: [
                            const Text("직업을 골라보세요!"),
                            GestureDetector(
                              onTap: _onSmallclick1_1,
                              child: Card(
                                  color: _small_choiced_1_1
                                      ? Colors.pink
                                      : Colors.white,
                                  child: const ListTile(
                                    leading: FaIcon(
                                        FontAwesomeIcons.personChalkboard),
                                    title: Text('선생님'),
                                  )),
                            ),
                            GestureDetector(
                              onTap: _onSmallclick1_2,
                              child: Card(
                                  color: _small_choiced_1_2
                                      ? Colors.pink
                                      : Colors.white,
                                  child: const ListTile(
                                    leading: FaIcon(
                                        FontAwesomeIcons.personChalkboard),
                                    title: Text('소방관'),
                                  )),
                            ),
                            GestureDetector(
                              onTap: _onSmallclick1_3,
                              child: Card(
                                  color: _small_choiced_1_3
                                      ? Colors.pink
                                      : Colors.white,
                                  child: const ListTile(
                                    leading: FaIcon(
                                        FontAwesomeIcons.personChalkboard),
                                    title: Text('축구선수'),
                                  )),
                            ),
                            GestureDetector(
                              onTap: _onSmallclick1_4,
                              child: Card(
                                  color: _small_choiced_1_4
                                      ? Colors.pink
                                      : Colors.white,
                                  child: const ListTile(
                                    leading: FaIcon(
                                        FontAwesomeIcons.personChalkboard),
                                    title: Text('경찰'),
                                  )),
                            ),
                          ],
                        )
                      : Container(),
                  _small_choiced_1_1 |
                          _small_choiced_1_2 |
                          _small_choiced_1_3 |
                          _small_choiced_1_4
                      ? TextButton(
                          onPressed: _onCompleteStory,
                          child: const Text("다음으로"))
                      : Container()
                ],
              ),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: Column(
                        children: [
                          Image.asset(
                            images[index],
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: MediaQuery.of(context).size.width * 0.4,
                          ),
                          Text("$index")
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
