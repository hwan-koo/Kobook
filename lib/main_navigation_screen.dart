import 'package:crepas/character/character_main_screen.dart';
import 'package:crepas/home/book_timeline_screen.dart';
import 'package:crepas/mybook/mybookmain.dart';
import 'package:crepas/profile/setting_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:audioplayers/audioplayers.dart';

class MainNavigation extends ConsumerStatefulWidget {
  static const String routeName = "mainNavigation";

  final String tab;
  const MainNavigation({super.key, required this.tab});

  @override
  MainNavigationState createState() => MainNavigationState();
}

class MainNavigationState extends ConsumerState<MainNavigation> {
  final List<String> _tabs = ["character", "home", "mybook"];
  late int _selectedIndex = _tabs.indexOf(widget.tab);

  void _onTap(int index) {
    context.go("/${_tabs[index]}");
    if (!ref.watch(playbackConfigProvider).muted) {
      AudioPlayer().play(AssetSource('button_click.wav'));
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(children: [
          Offstage(
            offstage: _selectedIndex != 1,
            child: const BookTimelineScreen(),
          ),
          Offstage(
            offstage: _selectedIndex != 2,
            child: const MyBookMainScreen(),
          ),
          Offstage(
            offstage: _selectedIndex != 0,
            child: const CharacterMainScreen(),
          ),
        ]),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          selectedFontSize: MediaQuery.of(context).size.width > 600 ? 22 : 10,
          unselectedFontSize: MediaQuery.of(context).size.width > 600 ? 22 : 10,
          showUnselectedLabels: true,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black,
          onTap: _onTap,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Image.asset(
                  "assets/gnb4_unselected.png",
                  width: MediaQuery.of(context).size.width > 600 ? 50 : 36,
                  height: MediaQuery.of(context).size.width > 600 ? 50 : 36,
                ),
                activeIcon: Image.asset(
                  "assets/gnb4_selected.png",
                  width: MediaQuery.of(context).size.width > 600 ? 50 : 36,
                  height: MediaQuery.of(context).size.width > 600 ? 50 : 36,
                ),
                label: Localizations.localeOf(context).toString() == "ko"
                    ? "내 캐릭터"
                    : "Characters"),
            BottomNavigationBarItem(
                icon: Image.asset(
                  "assets/gnb1_unselected.png",
                  width: MediaQuery.of(context).size.width > 600 ? 50 : 36,
                  height: MediaQuery.of(context).size.width > 600 ? 50 : 36,
                ),
                activeIcon: Image.asset(
                  "assets/gnb1_selected.png",
                  width: MediaQuery.of(context).size.width > 600 ? 50 : 36,
                  height: MediaQuery.of(context).size.width > 600 ? 50 : 36,
                ),
                label: Localizations.localeOf(context).toString() == "ko"
                    ? "홈"
                    : "Home"),
            BottomNavigationBarItem(
                icon: Image.asset(
                  "assets/gnb3_unselected.png",
                  width: MediaQuery.of(context).size.width > 600 ? 50 : 36,
                  height: MediaQuery.of(context).size.width > 600 ? 50 : 36,
                ),
                activeIcon: Image.asset(
                  "assets/gnb3_selected.png",
                  width: MediaQuery.of(context).size.width > 600 ? 50 : 36,
                  height: MediaQuery.of(context).size.width > 600 ? 50 : 36,
                ),
                label: Localizations.localeOf(context).toString() == "ko"
                    ? "내 책장"
                    : "My Book"),
          ],
        ));
  }
}
