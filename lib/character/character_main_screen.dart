import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crepas/character/character_generate_screen.dart';
import 'package:crepas/character/charater_complete.dart';
import 'package:crepas/character/components/textbutton.dart';
import 'package:crepas/character/models/character_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/foundation.dart' as foundation;

import '../profile/setting_view_model.dart';

class CharacterMainScreen extends ConsumerStatefulWidget {
  const CharacterMainScreen({super.key});

  @override
  CharacterMainScreenState createState() => CharacterMainScreenState();
}

Map<String, dynamic> characters = {"": ""};
List<String> timestamps = [];
bool isFirst = false;
final cardColor = {
  "wizard": 0xFFF6FBDA,
  "knight": 0xFFEFFEFF,
  "noble": 0xFFEAFEF7,
  "gentleman": 0xFF82C89E,
  "princess": 0xFFFDF2F9,
  "prince": 0xFFF7ECFF,
  "bride": 0xFFF9E9E5,
  "princess1": 0xFFE9F3FC,
  "princess3": 0xFFFFF5CD,
  "princess4": 0xFFE6F1F5,
  "princess5": 0xFFFFF0EC,
  "princess6": 0xFFFFF5D0,
  "daily1": 0xFFEEFAFF,
  "daily2": 0xFFFFF3F4,
  "daily3": 0xFFF2F9FC,
  "daily4": 0xFfECECEC
};
final cardTextColor = {
  "wizard": 0xFF657B62,
  "knight": 0xFF47A4D1,
  "noble": 0xFF44AAC8,
  "gentleman": 0xFF36926C,
  "princess": 0xFFF688A2,
  "prince": 0xFFFA64A2,
  "bride": 0xFFF87B4E,
  "princess1": 0xFF0075DD,
  "princess3": 0xFFFF9C08,
  "princess4": 0xFF1C9EE9,
  "princess5": 0xFFFD594A,
  "princess6": 0xFFF09F00,
  "daily1": 0xFF46AAD3,
  "daily2": 0xFFEA6173,
  "daily3": 0xFF349FCD,
  "daily4": 0xFf585858
};

class CharacterMainScreenState extends ConsumerState<CharacterMainScreen> {
  var isLoading = false;
  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    super.initState();
  }

  // static Future refreshRequest() async {
  //   final rtoken = await storage.read(key: 'refresh_token');
  //   var headersList = {
  //     'Authorization':
  //         'Basic Njlna2pmYmo0NWN0OHFnNHZvYWM2ajd1NWs6bjNvZjRjcWUxcWVlODZoMjhiZGxnajluMGE4M3Bxb280N3RucmRob2FrYjQ5M2NuNGIz',
  //     'Content-Type': 'application/x-www-form-urlencoded'
  //   };
  //   var url = Uri.parse(
  //       'https://kobook-api.auth.ap-northeast-2.amazoncognito.com/oauth2/token');

  //   Map<String, String> body = {
  //     'client_id': '69gkjfbj45ct8qg4voac6j7u5k',
  //     'redirect_uri': 'myapp://',
  //     'grant_type': 'refresh_token',
  //     'refresh_token': rtoken!
  //   };

  //   var req = http.Request('POST', url);
  //   req.headers.addAll(headersList);
  //   req.bodyFields = body;

  //   var res = await req.send();
  //   final resBody = await res.stream.bytesToString();
  //   final tokenData = json.decode(resBody);

  //   await storage.write(key: 'id_token', value: tokenData['id_token']);
  //   await storage.write(key: 'access_token', value: tokenData['access_token']);
  //   // await storage.write(
  //   //     key: 'refresh_token', value: tokenData['refresh_token']);

  //   if (res.statusCode >= 200 && res.statusCode < 300) {
  //     print(resBody);
  //   } else {
  //     print(res.reasonPhrase);
  //   }
  // }

  void _onCharacterGenerate() {
    if (!ref.watch(playbackConfigProvider).muted) {
      AudioPlayer().play(AssetSource('button_click.wav'));
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const CharacterGenerateScreen(),
      ),
    );
  }

  // _getCharacter() async {
  //   final value = await storage.read(key: 'id_token');
  //   var headersList = {'Authorization': value!};
  //   var url = Uri.parse(
  //       'https://w4eqnnp9k2.execute-api.ap-northeast-2.amazonaws.com/v1/character/image');

  //   var req = http.Request('GET', url);
  //   req.headers.addAll(headersList);

  //   var res = await req.send();
  //   final resBody = await res.stream.bytesToString();
  //   Map<String, dynamic> character = jsonDecode(resBody);

  //   setState(() {
  //     characters = character;
  //     timestamps = characters.keys.toList();
  //     isLoading = false;
  //     if (character.isNotEmpty) {
  //       isFirst = false;
  //     }
  //   });
  //   print(characters[timestamps[0]]["img_url"]);
  //   if (res.statusCode >= 200 && res.statusCode < 300) {
  //     print(resBody);
  //   } else {
  //     print(res.reasonPhrase);
  //   }
  // }

  bool get isiOS =>
      foundation.defaultTargetPlatform == foundation.TargetPlatform.iOS;
  @override
  Widget build(BuildContext context) {
    return ref.watch(characterProviderModel).when(
          loading: () => Center(
            child: SpinKitSpinningCircle(
              itemBuilder: (context, index) {
                return Center(
                  child: Image.asset(
                    "assets/turtle.png",
                  ),
                );
              },
            ),
          ),
          error: (error, stackTrace) => Center(
            child: Text("$error 잠시 후 다시 시도해주세요"),
          ),
          data: (characters) => SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: ref
                      .watch(characterProviderModel.notifier)
                      .character
                      .isEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Localizations.localeOf(context).toString() == "ko"
                              ? "동화 속 주인공이 될"
                              : "To be the hero",
                          style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width > 600
                                  ? 32
                                  : 24,
                              fontWeight: FontWeight.bold,
                              fontFamily: "TmoneyRoundWind"),
                        ),
                        Text(
                          Localizations.localeOf(context).toString() == "ko"
                              ? "우리 아이 캐릭터"
                              : "Of a fairy tale",
                          style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width > 600
                                  ? 32
                                  : 24,
                              fontWeight: FontWeight.bold,
                              fontFamily: "TmoneyRoundWind"),
                        ),
                        SizedBox(
                          height:
                              MediaQuery.of(context).size.width > 600 ? 40 : 24,
                        ),
                        Image.asset(
                          Localizations.localeOf(context).toString() == "ko"
                              ? "assets/instruction.png"
                              : "assets/characterInstructionEn.png",
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.55,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                        ),
                        GestureDetector(
                          onTap: () {
                            if (!ref.watch(playbackConfigProvider).muted) {
                              AudioPlayer()
                                  .play(AssetSource('button_click.wav'));
                            }
                            _onCharacterGenerate();
                          },
                          child: CGTextButton(
                            buttonText:
                                Localizations.localeOf(context).toString() ==
                                        "ko"
                                    ? "캐릭터 만들기"
                                    : "Go to Create Character",
                            isCentered: true,
                          ),
                        ),
                      ],
                    )
                  : isLoading
                      ? Center(
                          child: SpinKitSpinningCircle(
                            itemBuilder: (context, index) {
                              return Center(
                                child: Image.asset("assets/turtle.png"),
                              );
                            },
                          ),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.width > 600
                                  ? 120
                                  : 80,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        Localizations.localeOf(context)
                                                    .toString() ==
                                                "ko"
                                            ? "우리 아이"
                                            : "Create My",
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width >
                                                    600
                                                ? 32
                                                : 20,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "TmoneyRoundWind"),
                                      ),
                                      Text(
                                        Localizations.localeOf(context)
                                                    .toString() ==
                                                "ko"
                                            ? "캐릭터 만들기"
                                            : "child's character",
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width >
                                                    600
                                                ? 32
                                                : 20,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "TmoneyRoundWind"),
                                      ),
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: _onCharacterGenerate,
                                    child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            color: const Color(0xff468AFF)),
                                        width:
                                            MediaQuery.of(context).size.width >
                                                    600
                                                ? 200
                                                : 120,
                                        height:
                                            MediaQuery.of(context).size.width >
                                                    600
                                                ? 60
                                                : 32,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            const Icon(
                                              Icons.add_rounded,
                                              color: Colors.white,
                                            ),
                                            Text(
                                              Localizations.localeOf(context)
                                                          .toString() ==
                                                      "ko"
                                                  ? "새로 만들기"
                                                  : "New Character",
                                              style: TextStyle(
                                                  fontSize: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width >
                                                          600
                                                      ? 20
                                                      : Localizations.localeOf(
                                                                      context)
                                                                  .toString() ==
                                                              "ko"
                                                          ? 14
                                                          : 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            )
                                          ],
                                        )),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Expanded(
                              child: RefreshIndicator(
                                onRefresh: () async {
                                  await ref
                                      .watch(characterProviderModel.notifier)
                                      .fetchCharacter();
                                },
                                child: GridView.builder(
                                    shrinkWrap: true,
                                    itemCount: characters.length,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount:
                                                MediaQuery.of(context)
                                                            .size
                                                            .width >
                                                        600
                                                    ? 3
                                                    : 2,
                                            childAspectRatio: 140 / 218,
                                            mainAxisSpacing: 30,
                                            crossAxisSpacing: 30),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return GestureDetector(
                                        onTap: () {
                                          if (!ref
                                              .watch(playbackConfigProvider)
                                              .muted) {
                                            AudioPlayer().play(AssetSource(
                                                'button_click.wav'));
                                          }
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  CharacterCompleteScreen(
                                                name: characters[
                                                    characters.keys.toList()[
                                                        characters.length -
                                                            index -
                                                            1]]["name"],
                                                imageUrl: characters[
                                                    characters.keys.toList()[
                                                        characters.length -
                                                            index -
                                                            1]]["img_url"],
                                                timestamp:
                                                    characters.keys.toList()[
                                                        characters.length -
                                                            index -
                                                            1],
                                              ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(14),
                                            color: Color(cardColor[characters[
                                                characters.keys.toList()[
                                                    characters.length -
                                                        index -
                                                        1]]["cloth"]]!),
                                          ),
                                          child: Column(
                                            children: [
                                              Container(
                                                clipBehavior: Clip.antiAlias,
                                                width: MediaQuery.of(context)
                                                            .size
                                                            .width >
                                                        600
                                                    ? MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        80 /
                                                        360
                                                    : MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        128 /
                                                        360,
                                                height: MediaQuery.of(context)
                                                            .size
                                                            .width >
                                                        600
                                                    ? MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        130 /
                                                        360
                                                    : MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        178 /
                                                        360,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            14)),
                                                child: CachedNetworkImage(
                                                  imageUrl: characters[
                                                      characters.keys.toList()[
                                                          characters.length -
                                                              index -
                                                              1]]["img_url"],
                                                  width: MediaQuery.of(context)
                                                              .size
                                                              .width >
                                                          600
                                                      ? MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          80 /
                                                          360
                                                      : MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          128 /
                                                          360,
                                                  height: MediaQuery.of(context)
                                                              .size
                                                              .width >
                                                          600
                                                      ? MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          130 /
                                                          360
                                                      : MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          178 /
                                                          360,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                            .size
                                                            .width >
                                                        600
                                                    ? 10
                                                    : 6,
                                              ),
                                              Text(
                                                characters[
                                                    characters.keys.toList()[
                                                        characters.length -
                                                            index -
                                                            1]]["name"],
                                                style: TextStyle(
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                    .size
                                                                    .width >
                                                                600
                                                            ? 24
                                                            : 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(cardTextColor[
                                                        characters[characters
                                                            .keys
                                                            .toList()[characters
                                                                .length -
                                                            index -
                                                            1]]["cloth"]]!)),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                            )
                          ],
                        ),
            ),
          ),
        );
  }
}
