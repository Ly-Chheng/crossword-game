import 'package:belteiis_kids/controller/time_controller.dart';
import 'package:belteiis_kids/core/constant/font.dart';
import 'package:belteiis_kids/core/helper/audio_handler.dart';
import 'package:belteiis_kids/widget/zoom_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GameAppBar extends StatelessWidget {
  final int score;
  final int currentLevel;
  final Function() onBack;
  final Function() onReset;
  final Function() onPause;
  final String formattedTime;
  final int? heart;
  final bool? showheart;

  const GameAppBar(
      {Key? key,
      required this.score,
      required this.currentLevel,
      required this.onBack,
      required this.onReset,
      required this.onPause,
      required this.formattedTime,
      this.heart,
      this.showheart})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TimerController timerController = Get.find<TimerController>();
    final audioController = Get.put(AudioController());

    return Container(
      padding: EdgeInsets.only(
        top: (Get.context?.isPhone ?? true) ? 10 : 20,
        left: (Get.context?.isPhone ?? true) ? 15 : 20,
        right: (Get.context?.isPhone ?? true) ? 15 : 20,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(
                right: (Get.context?.isPhone ?? true) ? 100 : 200,
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: (Get.context?.isPhone ?? true) ? 15 : 20,
                    ),
                    child: GestureDetector(
                        onTap: () {
                          audioController.buttonClick();
                          onBack();
                        },
                        child: Image.asset(
                          "assets/image/back_icon.png",
                          width: (Get.context?.isPhone ?? true) ? 30 : 65,
                          height: (Get.context?.isPhone ?? true) ? 30 : 65,
                        )),
                  ),
                ],
              ),
            ),
          ),
          // Left side - timer and score together
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(
                left: (Get.context?.isPhone ?? true) ? 100.0 : 120.0,
                top: (Get.context?.isPhone ?? true) ? 15.0 : 20.0,
              ),
              child: Row(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Obx(() => Padding(
                            padding: EdgeInsets.only(
                              left: (Get.context?.isPhone ?? true) ? 5.0 : 25.0,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                  image: const DecorationImage(
                                    image: AssetImage(
                                      'assets/image/bottum_1.png',
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.circular(30),
                                  color: const Color(0xFF7B25D9),
                                  border: Border.all(
                                    width: 2,
                                    color: const Color(0XFFAF48FD),
                                  )),
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left:
                                      (Get.context?.isPhone ?? true) ? 25 : 40,
                                  right:
                                      (Get.context?.isPhone ?? true) ? 15 : 20,
                                  top: (Get.context?.isPhone ?? true) ? 3 : 5,
                                  bottom:
                                      (Get.context?.isPhone ?? true) ? 3 : 5,
                                ),
                                child: Text(
                                  timerController.formattedTime,
                                  style:
                                      ManagerFontStyles.labelStyleBold.copyWith(
                                    color: timerController.isLowTime.value
                                        ? (timerController.seconds % 2 == 0)
                                            ? const Color.fromARGB(
                                                255, 250, 101, 90)
                                            : Colors.white
                                        : Colors.white,
                                    fontSize: (Get.context?.isPhone ?? true)
                                        ? 14
                                        : 26,
                                  ),
                                ),
                              ),
                            ),
                          )),
                      Obx(() => Positioned(
                            bottom: 0,
                            left: 0,
                            child: timerController.isLowTime.value
                                ? AnimatedPlayButton(
                                    image: "assets/image/icon_time.png",
                                    width: (Get.context?.isPhone ?? true)
                                        ? 30
                                        : 60,
                                  )
                                : Image.asset(
                                    "assets/image/icon_time.png",
                                    width: (Get.context?.isPhone ?? true)
                                        ? 30
                                        : 60,
                                  ),
                          )),
                    ],
                  ),
                  SizedBox(
                    width: (Get.context?.isPhone ?? true) ? 20 : 30,
                  ),
                  (showheart ?? false)
                      ? Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/image/bottum_1.png'),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(30),
                              color: Color(0XFF7B25D9),
                              border: Border.all(
                                width: 3,
                                color: Color.fromRGBO(167, 78, 235, 1),
                              )),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal:
                                  (Get.context?.isPhone ?? true) ? 10 : 15,
                              vertical: (Get.context?.isPhone ?? true) ? 6 : 8,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(3, (index) {
                                return Padding(
                                  padding:
                                      EdgeInsets.only(right: index < 2 ? 5 : 0),
                                  child: Image.asset(
                                    index < 3 - (heart ?? 0)
                                        ? "assets/image/red_heart.png"
                                        : "assets/image/grey_heart.png",
                                    width: (Get.context?.isPhone ?? true)
                                        ? 20
                                        : 30,
                                    height: (Get.context?.isPhone ?? true)
                                        ? 20
                                        : 30,
                                  ),
                                );
                              }),
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          ),
          // Center - Level container
          Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding:
                    EdgeInsets.all((Get.context?.isPhone ?? true) ? 2.0 : 3.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("LEVEL",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: (Get.context?.isPhone ?? true) ? 18 : 25.0,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'PatrickHandSC',
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.5),
                              offset: const Offset(2, 2),
                              blurRadius: 5,
                            ),
                          ],
                        )),
                    Text(
                      '$currentLevel',
                      style: TextStyle(
                          fontFamily: 'PatrickHandSC',
                          color: Colors.white,
                          fontSize: (Get.context?.isPhone ?? true) ? 18 : 25),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: (Get.context?.isPhone ?? true) ? 20 : 30,
                  ),
                  GestureDetector(
                    onTap: () {
                      audioController.buttonClick();
                      onReset();
                    },
                    child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Image.asset(
                          "assets/image/replay.png",
                          height: (Get.context?.isPhone ?? true) ? 30 : 60,
                          width: (Get.context?.isPhone ?? true) ? 30 : 60,
                        )),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
