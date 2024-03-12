import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crepas/users/user_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart' as foundation;

class FirebaseRepository {
  String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}

String sha256ofString(String input) {
  final bytes = utf8.encode(input);
  final digest = sha256.convert(bytes);
  return digest.toString();
}

// class AppleRepository {
//   final _fireAuthInstance = FirebaseAuth.instance;

//   Future<UserCredential> signInWithApple() async {
//     final rawNonce = generateNonce();
//     final nonce = sha256ofString(rawNonce);

//     //앱에서 애플 로그인 창을 호출하고, apple계정의 credential을 가져온다.
//     final appleCredential = await SignInWithApple.getAppleIDCredential(
//       scopes: [
//         AppleIDAuthorizationScopes.email,
//         AppleIDAuthorizationScopes.fullName,
//       ],
//       nonce: nonce,
//     );

//     //그 credential을 넣어서 OAuth를 생성
//     final oauthCredential = OAuthProvider("apple.com").credential(
//       idToken: appleCredential.identityToken,
//       rawNonce: rawNonce,
//     );

//     //OAuth를 넣어서 firebase유저 생성
//     return await _fireAuthInstance.signInWithCredential(oauthCredential);
//   }
// }

bool get isiOS =>
    foundation.defaultTargetPlatform == foundation.TargetPlatform.iOS;

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

final FirebaseFirestore _db = FirebaseFirestore.instance;

class LoginScreenState extends ConsumerState<LoginScreen> {
  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    super.initState();
  }

  Future<UserCredential> signInWithApple() async {
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    //앱에서 애플 로그인 창을 호출하고, apple계정의 credential을 가져온다.
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    //그 credential을 넣어서 OAuth를 생성
    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );

    final userCredential =
        await FirebaseAuth.instance.signInWithCredential(oauthCredential);
    final users = ref.read(userProvider.notifier);

    await users.createAccount(userCredential);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final value = await FirebaseAuth.instance.currentUser!.getIdToken();
    print("유저 토큰값 변경 $value");
    await prefs.setString('jwt', value!);
    await prefs.setBool('refreshRequirement', true);

    //OAuth를 넣어서 firebase유저 생성
    return userCredential;
  }

  var token = "";
  dynamic signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      return null;
    } else {}

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setBool('refreshRequirement', true);
    print("로그인 성공, 새로고침 값 저장");
    final userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    final user = userCredential.user!;
    final users = ref.read(userProvider.notifier);
    _db.collection("users").doc(user.uid).set({"token": ""}).onError(
        (e, _) => print("Error writing document: $e"));

    await users.createAccount(userCredential);
    final value = await FirebaseAuth.instance.currentUser!.getIdToken();
    await prefs.setString('jwt', value!);

    // await getRequest(await user.getIdToken());
    // await postRequest(await user.getIdToken());

    // Once signed in, return the UserCredential

    return await FirebaseAuth.instance.signInWithCredential(credential);

    // Trigger the authentication flow
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff468AFF),
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width * 1 / 2,
                height: MediaQuery.of(context).size.width * 1 / 2,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: Image.asset(
                  "assets/logo.png",
                ).image)),
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.width * 1 / 3,
                    ),
                    Text(
                        Localizations.localeOf(context).toString() == "ko"
                            ? "내 아이가 주인공인 동화"
                            : "A Story about my child",
                        style:
                            const TextStyle(color: Colors.white, fontSize: 14)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 150,
          ),
          isiOS
              ? Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await signInWithGoogle();
                        // if (mounted) {
                        //   await ref
                        //       .watch(taleProviderModel.notifier)
                        //       .fetchTale();
                        // }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Image.asset(
                                    "assets/google.png",
                                    width: 24,
                                    height: 24,
                                  ),
                                ),
                                Text(
                                  Localizations.localeOf(context).toString() ==
                                          "ko"
                                      ? "구글 계정으로 로그인하기"
                                      : "Continue with Google",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () async {
                        await signInWithApple();
                        // if (mounted) {
                        //   await ref
                        //       .watch(taleProviderModel.notifier)
                        //       .fetchTale();
                        // }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Image.asset(
                                    "assets/apple.png",
                                    width: 24,
                                    height: 24,
                                  ),
                                ),
                                Text(
                                  Localizations.localeOf(context).toString() ==
                                          "ko"
                                      ? "애플 계정으로 로그인하기"
                                      : "Continue with Apple",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await signInWithGoogle();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Image.asset(
                                    "assets/google.png",
                                    width: 24,
                                    height: 24,
                                  ),
                                ),
                                Text(
                                  Localizations.localeOf(context).toString() ==
                                          "ko"
                                      ? "구글 계정으로 로그인하기"
                                      : "Continue with Google",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ],
      )),
    );
  }
}
