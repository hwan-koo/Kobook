import 'package:flutter/material.dart';

class CharacterInstruction extends StatelessWidget {
  const CharacterInstruction({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 312,
      height: 371,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 10,
            offset: Offset(0, 4),
            spreadRadius: 0,
          )
        ],
      ),
      child: const Stack(
        children: [
          Positioned(
            left: 41,
            top: 184,
            child: Text(
              '부모님과 같이 찍은 사진이 아닌          아이 혼자 나온 사진을 올려 주세요',
              style: TextStyle(
                color: Color(0xFF8B8B8B),
                fontSize: 12,
                fontFamily: 'Tmoney RoundWind',
                fontWeight: FontWeight.w400,
                height: 20,
                letterSpacing: -0.12,
              ),
            ),
          ),
          Positioned(
            left: 41,
            top: 331,
            child: Text(
              '옷은 계속해서 추가될 예정이에요',
              style: TextStyle(
                color: Color(0xFF8B8B8B),
                fontSize: 12,
                fontFamily: 'Tmoney RoundWind',
                fontWeight: FontWeight.w400,
                height: 20,
                letterSpacing: -0.12,
              ),
            ),
          ),
          Positioned(
            left: 41,
            top: 232,
            child: Text(
              '유치원이나 학교처럼 복잡한 배경에서          찍힌 사진은 얼굴을 인식하기 어려워요',
              style: TextStyle(
                color: Color(0xFF8B8B8B),
                fontSize: 12,
                fontFamily: 'Tmoney RoundWind',
                fontWeight: FontWeight.w400,
                height: 20,
                letterSpacing: -0.12,
              ),
            ),
          ),
          Positioned(
            left: 41,
            top: 88,
            child: Text(
              '캐릭터를 만들기 위해\n나이와 성별 정보가 필요해요',
              style: TextStyle(
                color: Color(0xFF8B8B8B),
                fontSize: 12,
                fontFamily: 'Tmoney RoundWind',
                fontWeight: FontWeight.w400,
                height: 20,
                letterSpacing: -0.12,
              ),
            ),
          ),
          Positioned(
            left: 41,
            top: 152,
            child: Text(
              '아이 사진을 올려 주세요',
              style: TextStyle(
                color: Color(0xFF333333),
                fontSize: 14,
                fontFamily: 'Tmoney RoundWind',
                fontWeight: FontWeight.w400,
                height: 24,
                letterSpacing: -0.14,
              ),
            ),
          ),
          Positioned(
            left: 41,
            top: 296,
            child: SizedBox(
              width: 242,
              height: 27,
              child: Text(
                '캐릭터의 옷과 그림체를 골라 주세요',
                style: TextStyle(
                  color: Color(0xFF333333),
                  fontSize: 14,
                  fontFamily: 'Tmoney RoundWind',
                  fontWeight: FontWeight.w400,
                  height: 24,
                  letterSpacing: -0.14,
                ),
              ),
            ),
          ),
          Positioned(
            left: 41,
            top: 56,
            child: Text(
              '아이에 대해 알려 주세요',
              style: TextStyle(
                color: Color(0xFF333333),
                fontSize: 14,
                fontFamily: 'Tmoney RoundWind',
                fontWeight: FontWeight.w400,
                height: 24,
                letterSpacing: -0.14,
              ),
            ),
          ),
          Positioned(
            left: 20,
            top: 20,
            child: Text(
              '어떻게 만들 수 있나요?',
              style: TextStyle(
                color: Color(0xFF468AFF),
                fontSize: 12,
                fontFamily: 'Tmoney RoundWind',
                fontWeight: FontWeight.w800,
                height: 20,
                letterSpacing: -0.06,
              ),
            ),
          ),
          Positioned(
            left: 20,
            top: 61,
            child: SizedBox(
              width: 15,
              height: 15,
              child: Stack(children: []),
            ),
          ),
          Positioned(
            left: 20,
            top: 157,
            child: SizedBox(
              width: 15,
              height: 15,
              child: Stack(children: []),
            ),
          ),
          Positioned(
            left: 20,
            top: 300,
            child: SizedBox(
              width: 15,
              height: 15,
              child: Stack(children: []),
            ),
          ),
        ],
      ),
    );
  }
}
