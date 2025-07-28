
import 'package:belteiis_kids/widget/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DialogHelperImage {
  static void showLevelLockedDialog(BuildContext context, int levelIndex) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: _AnimatedLockImageDialog(levelIndex: levelIndex),
        ),
      ),
      barrierDismissible: false,
    );
  }
}

class _AnimatedLockImageDialog extends StatefulWidget {
  final int levelIndex;

  const _AnimatedLockImageDialog({required this.levelIndex});

  @override
  __AnimatedLockImageDialogState createState() =>
      __AnimatedLockImageDialogState();
}

class __AnimatedLockImageDialogState extends State<_AnimatedLockImageDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _imageController;
  late Animation<double> _imageAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _imageController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Initialize drop-from-top animation
    _imageAnimation = Tween<double>(
      begin: -100.0, // Start above the dialog
      end: 0.0, // End at original position
    ).animate(CurvedAnimation(
      parent: _imageController,
      curve: Curves.bounceOut,
    ));

    // Start the animation
    _imageController.forward();
  }

  @override
  void dispose() {
    _imageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background image
        Positioned.fill(
          child: Image.asset(
            "assets/image/bg_setting_dialog.png",
            fit: BoxFit.fill,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: (Get.context?.isPhone ?? true) ? 5 : 10,),
            Text(
              "Level Locked",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: "PatrickHandSC",
                fontWeight: FontWeight.bold,
                fontSize:  (Get.context?.isPhone ?? true) ? 15 :30,
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.5),
                    offset: const Offset(2, 2),
                    blurRadius: 5,
                  ),
                ],
              ),
            ),
            SizedBox(height: (Get.context?.isPhone ?? true) ? 10 : 20,),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 100, vertical: 30),
              child: Column(
                children: [
                  AnimatedBuilder(
                    animation: _imageAnimation,
                    builder: (context, child) {
                      // Clamp the translation value
                      double translation =
                          _imageAnimation.value.clamp(-100.0, 0.0);
                      return Transform.translate(
                        offset: Offset(0, translation),
                        child: Image.asset(
                          "assets/image/lock_level.png",
                            width: (Get.context?.isPhone ?? true) ? 70 : 100,
                            height: (Get.context?.isPhone ?? true) ? 70 : 100,
                        ),
                      );
                    },
                  ),
                  SizedBox(height: (Get.context?.isPhone ?? true) ? 5 : 10,),
                  Text(
                    "Complete Level ${widget.levelIndex} to unlock this level!",
                    textAlign: TextAlign.center,
                    style:  TextStyle(
                      color: Colors.white,
                      fontSize:  (Get.context?.isPhone ?? true) ? 13 :18,
                      fontFamily: "PatrickHandSC",
                    ),
                  ),
                  SizedBox(height: (Get.context?.isPhone ?? true) ? 10 : 20,),
                  buildDialogButton(
                    label: 'OK',
                    color: Colors.red,
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}