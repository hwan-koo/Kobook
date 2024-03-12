import 'package:flutter/material.dart';

class CharacterProgress2 extends StatelessWidget {
  const CharacterProgress2({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 85,
      height: 15,
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50), color: Colors.grey),
          ),
          const SizedBox(
            width: 6,
          ),
          Container(
            alignment: Alignment.center,
            width: 15,
            height: 15,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50), color: Colors.blue),
            child: const Text(
              "2",
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          const SizedBox(
            width: 6,
          ),
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50), color: Colors.grey),
          ),
          const SizedBox(
            width: 6,
          ),
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50), color: Colors.grey),
          ),
          const SizedBox(
            width: 6,
          ),
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50), color: Colors.grey),
          ),
          const SizedBox(
            width: 6,
          ),
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50), color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
