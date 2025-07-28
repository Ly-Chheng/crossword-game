import 'package:animated_button/animated_button.dart';
import 'package:belteiis_kids/core/helper/audio_handler.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final audioController = Get.put(AudioController());

Widget dialogButton({
  required String imagePath,
  VoidCallback? onPressed,
}) {
  return Padding(
    padding: EdgeInsets.symmetric(
        horizontal: (Get.context?.isPhone ?? true) ? 12 : 25),
    child: GestureDetector(
      onTap: () {
        audioController.buttonClick();
        if (onPressed != null) {
          onPressed();
        } else {
          Get.offAllNamed('/LevelScreen');
        }
      },
      child: Container(
        height: (Get.context?.isPhone ?? true) ? Get.height * 0.12 : 60,
        width: (Get.context?.isPhone ?? true) ? Get.height * 0.12 : 60,
        decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.15),
                blurRadius: 1,
                spreadRadius: 0,
                offset: Offset(
                  2,
                  2,
                ),
              ),
            ]),
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
        ),
      ),
    ),
  );
}

Widget buildDialogButton({
  required String label,
  required Color color,
  required VoidCallback onPressed,
}) {
  return Padding(
    padding: EdgeInsets.all(8.0),
    child: SizedBox(
      child: AnimatedButton(
        onPressed: () {
          onPressed();
          audioController.buttonClick();
        },
        color: color,
        enabled: true,
        shadowDegree: ShadowDegree.dark,
        borderRadius: 25,
        duration: 200,
        height: (Get.context?.isPhone ?? true) ? 40 : 60,
        width: (Get.context?.isPhone ?? true) ? 50 : 80,
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: (Get.context?.isPhone ?? true) ? 14 : 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'PatrickHandSC',
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.5),
                offset: const Offset(2, 2),
                blurRadius: 5,
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ),
    ),
  );
}
