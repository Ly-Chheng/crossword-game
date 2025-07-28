import 'package:belteiis_kids/widget/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MissionCompletedDialog {
  static Future<void> showCompletedDialog({
    required BuildContext context,
    int? starCount,
    required String score,
    int? level,
    String? remark,
    String? expiredTime,
    VoidCallback? onReplay,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: (Get.context?.isPhone ?? true)
                  ? MediaQuery.of(context).size.width * 0.5
                  : MediaQuery.of(context).size.width * 0.4,
              height: (Get.context?.isPhone ?? true)
                  ? MediaQuery.of(context).size.height * 0.7
                  : MediaQuery.of(context).size.height * 0.5,
              decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFFDEA9F), Color(0XFFF3D988)],
                  ),
                  borderRadius: BorderRadius.circular(
                      (Get.context?.isPhone ?? true) ? 10 : 40),
                  border: Border.all(
                    color: Color.fromARGB(255, 89, 18, 165),
                    width: (Get.context?.isPhone ?? true) ? 3 : 4,
                  )),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Column(
                        children: [
                          SizedBox(
                              height:
                                  (Get.context?.isPhone ?? true) ? 25.0 : 50.0),
                          Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: []),
                          const Spacer(),
                          cutomTextField(
                            imagePath: "assets/image/level.png",
                            text: 'Level : ${level ?? "1"}',
                          ),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              dialogButton(
                                imagePath: "assets/image/home_button.png",
                              ),
                              dialogButton(
                                imagePath: "assets/image/reset_button.png",
                                onPressed: () {
                                  onReplay?.call();
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: -100,
              left: 0,
              right: 0,
              child: Center(
                child: Image.asset(
                  "assets/image/gift.png",
                  width: (Get.context?.isPhone ?? true) ? 110 : 220,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // game over
  static Future<void> showLevelFailed({
    required BuildContext context,
    int? starCount,
    String? title,
    description,
    String? level,
    VoidCallback? onReplay,
    VoidCallback? retry,
  }) {
    const int maxStars = 3;
    final int filledStars = starCount ?? 0;
    return Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular((Get.context?.isPhone ?? true) ? 10 : 40),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomRight,
              colors: [Color(0xFFFDEA9F), Color(0XFFF3D988)],
            ),
            borderRadius: BorderRadius.circular(
             (Get.context?.isPhone ?? true) ? 10 : 40
            ),
            border: Border.all(
              color: Color.fromARGB(255, 89, 18, 165),
              width: (Get.context?.isPhone ?? true) ? 3 : 4,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.fromARGB(255, 92, 4, 170),
                      Color.fromARGB(255, 89, 18, 165),
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(
                          (Get.context?.isPhone ?? true) ? 7 : 35),
                      topRight: Radius.circular(
                          (Get.context?.isPhone ?? true) ? 7 : 35)),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: (Get.context?.isPhone ?? true) ? 120.0 : 120.0,
                    vertical: (Get.context?.isPhone ?? true) ? 15.0 : 20.0,
                  ),
                  child: Text(
                    title ?? "Level Failed",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: (Get.context?.isPhone ?? true) ? 15.0 : 25.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: "PatrickHandSC",
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.5),
                          offset: const Offset(2, 2),
                          blurRadius: 5,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: (Get.context?.isPhone ?? true) ? 5.0 : 15.0,
                ),
                child: Column(
                  children: [
                    Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ...List.generate(maxStars, (index) {
                            double width = index == 1 ? 85 : 60;
                            String starImage = index < filledStars
                                ? "assets/image/yellow_star.png"
                                : "assets/image/grey_star.png";
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal:
                                    (Get.context?.isPhone ?? true) ? 2.0 : 4.0,
                              ),
                              child: Image.asset(
                                starImage,
                                width: width,
                              ),
                            );
                          }),
                        ]),
                    SizedBox(
                      height: (Get.context?.isPhone ?? true) ? 5.0 : 10.0,
                    ),
                    Text(
                      description ?? "Sorry you Failed",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: (Get.context?.isPhone ?? true) ? 13.0 : 20.0,
                        fontFamily: "PatrickHandSC",
                      ),
                    ),
                    SizedBox(
                      height: (Get.context?.isPhone ?? true) ? 10.0 : 20.0,
                    ),
                    buildDialogButton(
                      label: 'Retry',
                      color: Colors.orange,
                      onPressed: () {
                        retry?.call();
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  static Future<void> nextLevelPopUp({
    required BuildContext context,
    int? starCount,
    String? score,
    int? level,
    String? remark,
    String? expiredTime,
    VoidCallback? onReplay,
    VoidCallback? nextLevel,
    VoidCallback? toHomePage,
  }) {
    const int maxStars = 3;
    final int filledStars = starCount ?? 0;

    double screenWidth = MediaQuery.of(context).size.width;
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: (Get.context?.isPhone ?? true)
                  ? MediaQuery.of(context).size.width * 0.5
                  : MediaQuery.of(context).size.width * 0.4,
              height: (Get.context?.isPhone ?? true)
                  ? MediaQuery.of(context).size.height * 0.7
                  : MediaQuery.of(context).size.height * 0.5,
              decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFFDEA9F), Color(0XFFF3D988)],
                  ),
                  borderRadius: BorderRadius.circular(
                      (Get.context?.isPhone ?? true) ? 20 : 40),
                  border: Border.all(
                    color: Color.fromARGB(255, 89, 18, 165),
                    width: (Get.context?.isPhone ?? true) ? 3 : 4,
                  )),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Column(
                        children: [
                          SizedBox(
                            height: (Get.context?.isPhone ?? true)
                                ? Get.height * 0.15
                                : 90.0,
                          ),
                          Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ...List.generate(maxStars, (index) {
                                  // double width = index == 1 ? 80 : 55;
                                  double width = (index == 1 &&
                                          (Get.context?.isPhone ?? true))
                                      ? 55
                                      : 55;
                                  String starImage = index < filledStars
                                      ? "assets/image/yellow_star.png"
                                      : "assets/image/grey_star.png";
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    child: Image.asset(
                                      starImage,
                                      width: width,
                                    ),
                                  );
                                }),
                              ]),
                          const Spacer(),
                          cutomTextField(
                            imagePath: "assets/image/icon_time.png",
                            text: 'Time : $expiredTime',
                          ),
                          cutomTextField(
                            imagePath: "assets/image/level_up.png",
                            text: 'Level : ${level ?? "1"}',
                          ),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // dialogButton(
                              //   imagePath: "assets/image/home_button.png",
                              //   onPressed: toHomePage,
                              // ),
                              dialogButton(
                                imagePath: "assets/image/reset_button.png",
                                onPressed: () {
                                  onReplay?.call();
                                  Navigator.pop(context);
                                },
                              ),
                              dialogButton(
                                imagePath: "assets/image/btn_next_level.png",
                                onPressed: nextLevel,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: (Get.context?.isPhone ?? true) ? -35 : -100,
              left: 0,
              right: 0,
              child: Center(
                child: Image.asset(
                  "assets/image/winner.png",
                  width: (Get.context?.isPhone ?? true)
                      ? screenWidth * 0.15
                      : screenWidth * 0.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void showExit({
    required BuildContext context,
    String? imgDialog,
    int? score,
    VoidCallback? onRestart,
    VoidCallback? onBack,
  }) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular((Get.context?.isPhone ?? true) ? 10 : 40),
        ),
        child: Container(
          width: (Get.context?.isPhone ?? true)
              ? MediaQuery.of(context).size.width * 0.3
              : MediaQuery.of(context).size.width * 0.4,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomRight,
              colors: [Color(0xFFFDEA9F), Color(0XFFF3D988)],
            ),
            borderRadius:
                BorderRadius.circular((Get.context?.isPhone ?? true) ? 10 : 40),
            border: Border.all(
              color: Color.fromARGB(255, 89, 18, 165),
              width: (Get.context?.isPhone ?? true) ? 3 : 4,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.fromARGB(255, 92, 4, 170),
                      Color.fromARGB(255, 89, 18, 165),
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(
                        (Get.context?.isPhone ?? true) ? 7 : 35),
                    topRight: Radius.circular(
                        (Get.context?.isPhone ?? true) ? 7 : 35),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: (Get.context?.isPhone ?? true) ? 10 : 30,
                  ),
                  child: Center(
                    child: Text(
                      'Quit Level?',
                      style: TextStyle(
                        fontSize: (Get.context?.isPhone ?? true) ? 15 : 30,
                        color: Colors.white,
                        fontFamily: "PatrickHandSC",
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.5),
                            offset: const Offset(2, 2),
                            blurRadius: 5,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: (Get.context?.isPhone ?? true) ? 20 : 40,
                ),
                child: Text(
                  'Do you want to exit?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: "PatrickHandSC",
                    fontSize: (Get.context?.isPhone ?? true) ? 13 : 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  bottom: (Get.context?.isPhone ?? true) ? 5 : 30,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildDialogButton(
                      label: 'No',
                      color: Colors.orange,
                      onPressed: () {
                        onRestart?.call();
                        Get.back();
                      },
                    ),
                    buildDialogButton(
                      label: 'Yes',
                      color: Colors.red,
                      onPressed: () {
                        onBack ?? Get.back();
                        Get.back(); // close dialog
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  static Future<void> showTimeout({
    required BuildContext context,
    required int score,
    int? starCount,
    int? level,
    String? expiredTime,
    VoidCallback? onRestart,
  }) {
    const int maxStars = 3;
    final int filledStars = starCount ?? 0;
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: (Get.context?.isPhone ?? true)
                  ? MediaQuery.of(context).size.width * 0.3
                  : MediaQuery.of(context).size.width * 0.5,
              decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFFDEA9F), Color(0XFFF3D988)],
                  ),
                  borderRadius: BorderRadius.circular(
                      (Get.context?.isPhone ?? true) ? 10 : 40),
                  border: Border.all(
                      color: Color.fromARGB(255, 89, 18, 165), width: 5)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: (Get.context?.isPhone ?? true) ? 5 : 10,
                    ),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 89, 18, 165),
                      borderRadius: BorderRadius.vertical(
                          top: Radius.circular(
                              (Get.context?.isPhone ?? true) ? 10 : 40)),
                    ),
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: (Get.context?.isPhone ?? true) ? 5 : 10,
                        ),
                        child: Text('TIME OUT',
                            style: TextStyle(
                              fontSize:
                                  (Get.context?.isPhone ?? true) ? 18 : 20,
                              color: Colors.white,
                              fontFamily: "PatrickHandSC",
                            )),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: (Get.context?.isPhone ?? true) ? 2 : 4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ...List.generate(maxStars, (index) {
                                  double width = index == 1 ? 85 : 60;
                                  String starImage = index < filledStars
                                      ? "assets/image/yellow_star.png"
                                      : "assets/image/grey_star.png";
                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal:
                                            (Get.context?.isPhone ?? true)
                                                ? 2
                                                : 4),
                                    child: Image.asset(
                                      starImage,
                                      width: width,
                                    ),
                                  );
                                }),
                              ]),
                          cutomTextField(
                            imagePath: "assets/image/clock.png",
                            text: 'Time : $expiredTime',
                          ),
                          cutomTextField(
                            imagePath: "assets/image/level_up.png",
                            text: 'Level : ${level ?? "1"}',
                          ),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              dialogButton(
                                imagePath: "assets/image/home_button.png",
                              ),
                              dialogButton(
                                imagePath: "assets/image/reset_button.png",
                                onPressed: () {
                                  onRestart?.call();
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: -60,
              left: 0,
              right: 0,
              child: Center(
                child: Image.asset(
                  "assets/image/time_out.png",
                  width: (Get.context?.isPhone ?? true) ? 50 : 100,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget cutomTextField({
  required String imagePath,
  required String text,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: SizedBox(
      width: (Get.context?.isPhone ?? true) ? 150 : 250,
      height: (Get.context?.isPhone ?? true) ? Get.height * 0.1 : 50,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: (Get.context?.isPhone ?? true) ? 150 : 300,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(60, 64, 67, 0.3),
                        blurRadius: 2,
                        spreadRadius: 0,
                        offset: Offset(
                          0,
                          1,
                        ),
                      ),
                      BoxShadow(
                        color: Color.fromRGBO(60, 64, 67, 0.15),
                        blurRadius: 6,
                        spreadRadius: 2,
                        offset: Offset(
                          0,
                          2,
                        ),
                      ),
                    ]),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      text,
                      style: TextStyle(
                        color: Color.fromARGB(255, 58, 7, 108),
                        fontFamily: "PatrickHandSC",
                        fontSize: (Get.context?.isPhone ?? true) ? 16 : 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            left: -20,
            top: 0,
            bottom: 0,
            child: Container(
              width: (Get.context?.isPhone ?? true) ? 50 : 60,
              height: (Get.context?.isPhone ?? true) ? 50 : 60,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromARGB(255, 89, 18, 165)),
              padding: EdgeInsets.all(10.0),
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
                width: (Get.context?.isPhone ?? true) ? 40 : 70,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
