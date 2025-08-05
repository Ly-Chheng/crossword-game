import 'dart:io';

import 'package:belteiis_kids/controller/crossword_controller.dart';
import 'package:belteiis_kids/core/helper/background_helper.dart';
import 'package:belteiis_kids/widget/game_app_bar.dart';
import 'package:belteiis_kids/widget/complete_dialog.dart';
import 'package:flutter/material.dart';
import 'package:crossword/crossword.dart';
import 'package:get/get.dart';

class CrossWord extends StatelessWidget {
  const CrossWord({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return GetBuilder<CrossWordController>(
      init: CrossWordController(),
      initState: (_) {
        Get.find<CrossWordController>().timerController.startCountdown();
      },
      builder: (controller) {
        return Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BackgroundImage.buildContainerBackground(
              imagePath: "assets/image/bg_subgames.png",
            ),
            child: Column(
              children: [
                Obx(
                  () => GameAppBar(
                    score: controller.totalScore.value,
                    currentLevel: controller.currentLevelIndex.value + 1,
                    formattedTime: controller.timerController.formattedTime,
                    onBack: () {
                      controller.timerController.pauseTimer();
                      MissionCompletedDialog.showExit(
                        context: context,
                        onRestart: () {
                          controller.timerController.startCountdown();
                        },
                      );
                    },
                    onReset: () {
                      controller.loadLevel();
                    },
                    onPause: () {},
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Crossword container with auto height
                        IntrinsicHeight(
                          child: IntrinsicWidth(
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                vertical: context.isPhone
                                    ? screenWidth * 0.02
                                    : screenWidth * 0.03,
                                horizontal: context.isPhone
                                    ? Platform.isIOS
                                        ? screenWidth * 0.05
                                        : screenWidth * 0.02
                                    : screenWidth * 0.03,
                              ),
                              padding: EdgeInsets.all(
                                (Get.context?.isPhone ?? true)
                                    ? screenWidth * 0.02
                                    : screenWidth * 0.03,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xffFFFFFF),
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: const Color.fromARGB(255, 41, 96, 246),
                                  width: (Get.context?.isPhone ?? true)
                                      ? screenWidth * 0.003
                                      : screenWidth * 0.004,
                                ),
                              ),
                              child: IgnorePointer(
                                ignoring: controller.isLevelComplete.value,
                                child: Crossword(
                                  key: controller.crosswordState,
                                  allowOverlap: true,
                                  letters: controller.letters,
                                  spacing: Offset(
                                      screenWidth * 0.04, screenWidth * 0.04),
                                  onLineUpdate: controller.handleLineUpdate,
                                  addIncorrectWord: false,
                                  textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: (Get.context?.isPhone ?? true)
                                        ? 15
                                        : 30.0,
                                    fontFamily: "PatrickHandSC",
                                  ),
                                  lineDecoration: LineDecoration(
                                    lineGradientColors:
                                        controller.getWordColors(),
                                    strokeWidth: screenWidth * 0.04,
                                    lineTextStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: (Get.context?.isPhone ?? true)
                                          ? 15
                                          : 30.0,
                                      fontFamily: "PatrickHandSC",
                                    ),
                                  ),
                                  hints: controller.hints
                                      .map((hint) => hint["word"] ?? "")
                                      .toList(),
                                ),
                              ),
                            ),
                          ),
                        ),
                        // SizedBox(
                        //   width: (Get.context?.isPhone ?? true)
                        //       ? screenWidth * 0.03
                        //       : screenWidth * 0.02,
                        // ),
                        // Hints container
                        Expanded(
                          child: Obx(() {
                            final hints = controller.hints;
                            int crossAxisCount =
                                hints.length >= 4 ? 4 : hints.length;
                            double spacing =
                                (Get.context?.isPhone ?? true) ? 2 : 4;
                            double cellSize = screenWidth * 0.09;
                            double totalWidth = (cellSize * crossAxisCount) +
                                (spacing * (crossAxisCount - 1));

                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Top green header
                                Container(
                                  width: totalWidth,
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                    ),
                                    color: Colors.green,
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    vertical: (Get.context?.isPhone ?? true)
                                        ? screenHeight * 0.012
                                        : screenHeight * 0.01,
                                  ),
                                  child: Center(
                                    child: Text(
                                      controller.currentLevelType,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: (Get.context?.isPhone ?? true)
                                            ? 13
                                            : 25.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontFamily: "PatrickHandSC",
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: context.isTablet ? 5 : 0),

                                // Grid of hints
                                SizedBox(
                                  width: totalWidth,
                                  height: screenHeight * 0.5,
                                  child: GridView.builder(
                                    padding: EdgeInsets.zero,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: crossAxisCount,
                                      crossAxisSpacing: spacing,
                                      mainAxisSpacing: spacing,
                                      childAspectRatio: 1.0,
                                    ),
                                    itemCount: hints.length,
                                    itemBuilder: (context, index) {
                                      final hint = hints[index];
                                      final String hintWord =
                                          hint["word"] ?? "";
                                      final bool isFound = controller.foundWords
                                          .contains(hintWord);

                                      return Opacity(
                                        opacity: isFound ? 0.7 : 1,
                                        child: Padding(
                                          padding: EdgeInsets.all(
                                            (Get.context?.isPhone ?? true)
                                                ? 2.0
                                                : 4.0,
                                          ),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: isFound
                                                  ? const Color.fromARGB(
                                                      255, 52, 64, 73)
                                                  : const Color(0XFFFFFFFF),
                                              border: Border.all(
                                                color: isFound
                                                    ? Colors.green
                                                    : const Color.fromARGB(
                                                        255, 41, 96, 246),
                                                width: (Get.context?.isPhone ??
                                                        true)
                                                    ? screenWidth * 0.003
                                                    : screenWidth * 0.002,
                                              ),
                                            ),
                                            child: Center(
                                              child: controller
                                                              .currentLevelIndex
                                                              .value %
                                                          10 <
                                                      5
                                                  ? Padding(
                                                      padding: EdgeInsets.all(
                                                        (Get.context?.isPhone ??
                                                                true)
                                                            ? screenWidth *
                                                                0.008
                                                            : screenWidth *
                                                                0.006,
                                                      ),
                                                      child: Image.asset(
                                                        hint["image"] ??
                                                            "assets/image/world.png",
                                                        fit: BoxFit.contain,
                                                        errorBuilder: (context,
                                                            error, stackTrace) {
                                                          return Image.asset(
                                                            "assets/image/default.png",
                                                            fit: BoxFit.contain,
                                                          );
                                                        },
                                                      ),
                                                    )
                                                  : Text(
                                                      hintWord,
                                                      style: TextStyle(
                                                        color: isFound
                                                            ? Colors.white
                                                            : Colors.black,
                                                        fontSize: (Get.context
                                                                    ?.isPhone ??
                                                                true)
                                                            ? 13
                                                            : 20.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily:
                                                            "PatrickHandSC",
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
