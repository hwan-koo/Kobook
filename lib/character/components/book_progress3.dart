import 'package:flutter/material.dart';

class BookProgress3 extends StatelessWidget {
  const BookProgress3({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 85,
      height: 15,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width > 600 ? 16 : 8,
            height: MediaQuery.of(context).size.width > 600 ? 16 : 8,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: const Color(0xffD9DFE4)),
          ),
          const SizedBox(
            width: 6,
          ),
          Container(
            width: MediaQuery.of(context).size.width > 600 ? 16 : 8,
            height: MediaQuery.of(context).size.width > 600 ? 16 : 8,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: const Color(0xffD9DFE4)),
          ),
          const SizedBox(
            width: 6,
          ),
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width > 600 ? 16 : 8,
            height: MediaQuery.of(context).size.width > 600 ? 16 : 8,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: const Color(0xff468aff)),
          ),
          const SizedBox(
            width: 6,
          ),
          Container(
            width: MediaQuery.of(context).size.width > 600 ? 16 : 8,
            height: MediaQuery.of(context).size.width > 600 ? 16 : 8,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: const Color(0xffD9DFE4)),
          ),
        ],
      ),
    );
  }
}
