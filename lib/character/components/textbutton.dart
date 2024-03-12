import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CGTextButton extends StatelessWidget {
  final String buttonText;
  final bool isCentered;

  const CGTextButton({
    super.key,
    required this.buttonText,
    required this.isCentered,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width > 600 ? 90 : 66,
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
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 21),
          child: Row(
            mainAxisAlignment: isCentered
                ? MainAxisAlignment.center
                : MainAxisAlignment.spaceBetween,
            children: [
              Text(
                buttonText,
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width > 600 ? 22 : 16,
                    fontWeight: FontWeight.bold),
              ),
              isCentered
                  ? Container()
                  : const FaIcon(
                      FontAwesomeIcons.angleRight,
                      color: Color(0xffCDCDCD),
                    )
            ],
          ),
        ));
  }
}
