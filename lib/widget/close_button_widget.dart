import 'package:belteiis_kids/core/helper/audio_handler.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CloseButtonWidget extends StatelessWidget {
  final VoidCallback? onPressed;

  const CloseButtonWidget({Key? key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final audioController = Get.find<AudioController>();
    return GestureDetector(
      onTap: () {
        audioController.buttonClick();
        if (onPressed != null) {
          onPressed!();
        } else {
          Navigator.of(context).pop();
        }
      },
      child: Container(
        width: 44,
        height: 44,
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 159, 15, 4),
          shape: BoxShape.circle,
          border: Border.fromBorderSide(
            BorderSide(
              color: Colors.white, // Border color
              width: 2.0, // Border thickness
            ),
          ),
        ),
        child: Center(
          child: Image.asset(
            'assets/image/bottom_close.png',
            width: 40,
            height: 40,
          ),
        ),
      ),
    );
  }
}