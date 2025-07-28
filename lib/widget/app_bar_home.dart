import 'dart:developer';
import 'dart:io';
import 'package:belteiis_kids/controller/home_controller.dart';
import 'package:belteiis_kids/core/helper/audio_handler.dart';
import 'package:belteiis_kids/core/helper/background_helper.dart';
import 'package:belteiis_kids/widget/charator_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PlayerInfoBox extends StatelessWidget {
  const PlayerInfoBox({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => HomeController());
    final HomeController homeController = Get.put(HomeController());

    return Padding(
      padding: EdgeInsets.only(
          left: Platform.isIOS ? 20 : 10, top: Platform.isIOS ? 10 : 5),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: (Get.context?.isPhone ?? true) ? 120 : 180,
            alignment: Alignment.topRight,
            decoration: BoxDecoration(
              border: Border.all(
                width: (Get.context?.isPhone ?? true) ? 2 : 3,
                color: const Color.fromARGB(255, 108, 4, 168),
              ),
              color: Color.fromARGB(255, 174, 50, 246),
              borderRadius: BorderRadius.circular(13),
            ),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Obx(() {
              final currentAnimal = homeController.animals.firstWhere(
                (animal) => animal['image'] == homeController.imagePath.value,
                orElse: () => {'title': 'BEAR'},
              );
              return Text(
                currentAnimal['title'],
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: (Get.context?.isPhone ?? true) ? 14 : 18,
                  fontFamily: "PatrickHandSC",
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              );
            }),
          ),

          // Player image (reactive with Obx)
          Positioned(
            top: 0,
            left: 0,
            child: CharacterStack(),
          ),
        ],
      ),
    );
  }
}

// Custom widget for the character stack
class CharacterStack extends StatelessWidget {
  const CharacterStack({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.put(HomeController());
    final audioController = Get.find<AudioController>();

    return SizedBox(
      height: (Get.context?.isPhone ?? true) ? 50 : 70,
      width: (Get.context?.isPhone ?? true) ? 50 : 70,
      child: GestureDetector(
        onTap: () {
          audioController.buttonClick();
          String? selectedImagePath = homeController.imagePath.value;

          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return StatefulBuilder(
                builder: (context, setState) {
                  return Dialog(
                    child: SizedBox(
                      width: (Get.context?.isPhone ?? true)
                          ? MediaQuery.of(context).size.width * 0.5
                          : MediaQuery.of(context).size.width * 0.5,
                      height: (Get.context?.isPhone ?? true)
                          ? MediaQuery.of(context).size.height * 0.7
                          : MediaQuery.of(context).size.height * 0.5,
                      child: Stack(
                        fit: StackFit.expand,
                        alignment: AlignmentDirectional.topCenter,
                        children: [
                          BackgroundImage.buildBackgroundImage(
                            const AssetImage(
                                "assets/image/bg_setting_dialog.png"),
                          ),
                          Positioned(
                            top: 10,
                            child: Text(
                              'PLEASE SELECT CHARACTERS',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: "PatrickHandSC",
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    (Get.context?.isPhone ?? true) ? 20 : 30,
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
                          ),
                          Positioned(
                            top: 8,
                            right: 3,
                            child: Align(
                              alignment: Alignment.topRight,
                              child: SafeArea(
                                child: GestureDetector(
                                  onTap: () {
                                    audioController.buttonClick();
                                    Navigator.of(context).pop();
                                  },
                                  child: Image.asset(
                                    "assets/image/close.png",
                                    width: (Get.context?.isPhone ?? true)
                                        ? 35
                                        : 50,
                                    height: (Get.context?.isPhone ?? true)
                                        ? 35
                                        : 50,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SafeArea(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: (Get.context?.isPhone ?? true)
                                        ? MediaQuery.of(context).size.width *
                                            0.030
                                        : MediaQuery.of(context).size.width *
                                            0.035,
                                  ),
                                  child: Center(
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ...homeController.animals
                                              .map((animal) {
                                            final String image =
                                                animal['image'];
                                            final String title =
                                                animal['title'];
                                            return Row(
                                              children: [
                                                AnimalCard(
                                                  title: title,
                                                  foregroundImageAsset: image,
                                                  isShowborder:
                                                      selectedImagePath ==
                                                          image,
                                                  ontap: () {
                                                    audioController
                                                        .buttonClick();
                                                    log("Selected animal: $title");
                                                    setState(() {
                                                      selectedImagePath = image;
                                                    });
                                                  },
                                                ),
                                              ],
                                            );
                                          }).toList(),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () async {
                                    audioController.buttonClick();
                                    if (selectedImagePath != null) {
                                      final selectedAnimal = homeController
                                          .animals
                                          .firstWhere((animal) =>
                                              animal['image'] ==
                                              selectedImagePath);
                                      homeController.imagePath.value =
                                          selectedImagePath!;
                                      await homeController.storeCharacter(
                                        selectedAnimal['id'],
                                        selectedAnimal['title'],
                                      );
                                      log("✅ Character stored: ${selectedAnimal['title']} for ID: ${selectedAnimal['id']}");
                                    } else {
                                      log("⚠️ No animal selected");
                                    }
                                    Navigator.of(context).pop();
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      image: const DecorationImage(
                                        image: AssetImage(
                                            'assets/image/buttom_2.png'),
                                        fit: BoxFit.fill,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: (Get.context?.isPhone ?? true)
                                          ? MediaQuery.of(context).size.width *
                                              0.015
                                          : MediaQuery.of(context).size.width *
                                              0.015,
                                      vertical: (Get.context?.isPhone ?? true)
                                          ? MediaQuery.of(context).size.width *
                                              0.015
                                          : MediaQuery.of(context).size.width *
                                              0.009,
                                    ),
                                    child: Text(
                                      'CONFIRM',
                                      style: TextStyle(
                                        fontFamily: "PatrickHandSC",
                                        fontWeight: FontWeight.bold,
                                        fontSize: (Get.context?.isPhone ?? true)
                                            ? 13
                                            : 18,
                                        color: Colors.white,
                                        shadows: [
                                          Shadow(
                                            color:
                                                Colors.black.withOpacity(0.5),
                                            offset: const Offset(2, 2),
                                            blurRadius: 5,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
        child: Obx(() {
          return Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/image/bg_setting.png'),
                fit: BoxFit.fill,
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  homeController.imagePath.value.isNotEmpty
                      ? homeController.imagePath.value
                      : "assets/image/icons_charater.png",
                  width: (Get.context?.isPhone ?? true) ? 40 : 55,
                  height: (Get.context?.isPhone ?? true) ? 40 : 55,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class SettingsButton extends StatefulWidget {
  const SettingsButton({super.key});

  @override
  State<SettingsButton> createState() => _SettingsButtonState();
}

class _SettingsButtonState extends State<SettingsButton> {
  bool isMusicOn = true; // Initial state for music ON/OFF
  bool isSoundOn = true; // Initial state for sound ON/OFF
  final audioController = Get.find<AudioController>();

  @override
  void initState() {
    super.initState();
    // Initialize states from AudioController
    isMusicOn = !audioController.isBackgroundMusicDisabled;
    isSoundOn = !audioController.isSoundEffectsDisabled;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: context.isPhone ? 10 : 15,
        right: context.isPhone
            ? Platform.isIOS
                ? 20
                : 10
            : 15,
      ),
      child: GestureDetector(
        onTap: () {
          audioController.buttonClick();
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return StatefulBuilder(
                builder: (context, setDialogState) {
                  return Dialog(
                    insetPadding: EdgeInsets.zero,
                    child: SizedBox(
                      width: (Get.context?.isPhone ?? true)
                          ? MediaQuery.of(context).size.width * 0.5
                          : MediaQuery.of(context).size.width * 0.5,
                      height: (Get.context?.isPhone ?? true)
                          ? MediaQuery.of(context).size.height * 0.7
                          : MediaQuery.of(context).size.height * 0.5,
                      child: Stack(
                        fit: StackFit.expand,
                        alignment: AlignmentDirectional.topCenter,
                        children: [
                          Image.asset(
                            "assets/image/bg_setting_dialog.png",
                            fit: BoxFit.fill,
                          ),
                          Positioned(
                            top: 10,
                            child: Text(
                              'SETTINGS',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: "PatrickHandSC",
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    (Get.context?.isPhone ?? true) ? 20 : 30,
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
                          ),
                          Positioned(
                            top: 8,
                            right: 3,
                            child: Align(
                              alignment: Alignment.topRight,
                              child: SafeArea(
                                child: GestureDetector(
                                  onTap: () {
                                    audioController.buttonClick();
                                    Navigator.of(context).pop();
                                  },
                                  child: Image.asset(
                                    "assets/image/close.png",
                                    width: (Get.context?.isPhone ?? true)
                                        ? 35
                                        : 50,
                                    height: (Get.context?.isPhone ?? true)
                                        ? 35
                                        : 50,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SafeArea(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Sound',
                                        style: TextStyle(
                                          fontSize:
                                              (Get.context?.isPhone ?? true)
                                                  ? 16
                                                  : 26,
                                          color: Colors.white,
                                          fontFamily: "PatrickHandSC",
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.center,
                                        child: Container(
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: Color(0XFFF4E9DE),
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            border: Border.all(
                                              width: 3,
                                              color: Color.fromARGB(
                                                  255, 215, 192, 168),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              // SOUND OFF BUTTON
                                              SizedBox(
                                                width: 45,
                                                child: TextButton(
                                                  onPressed: () async {
                                                    audioController
                                                        .buttonClick();
                                                    // Disable sound effects
                                                    await audioController
                                                        .disableSoundEffects();
                                                    setDialogState(() {
                                                      isSoundOn = false;
                                                    });

                                                    log("SOUND: OFF");
                                                  },
                                                  style: TextButton.styleFrom(
                                                    backgroundColor: !isSoundOn
                                                        ? Colors.green
                                                        : Colors.transparent,
                                                  ),
                                                  child: Text(
                                                    "OFF",
                                                    style: TextStyle(
                                                        fontFamily:
                                                            "PatrickHandSC",
                                                        fontSize: (Get.context
                                                                    ?.isPhone ??
                                                                true)
                                                            ? 13
                                                            : 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: isSoundOn
                                                            ? Colors.black
                                                            : Colors.white),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 45,
                                                child: TextButton(
                                                  onPressed: () async {
                                                    audioController
                                                        .buttonClick();
                                                    // Enable sound effects
                                                    await audioController
                                                        .enableSoundEffects();

                                                    setDialogState(() {
                                                      isSoundOn = true;
                                                    });

                                                    // Play a test sound effect
                                                    await audioController
                                                        .soundEffect(
                                                            "assets/audio/button_click.mp3");

                                                    log("SOUND: ON");
                                                  },
                                                  style: TextButton.styleFrom(
                                                    backgroundColor: isSoundOn
                                                        ? Colors.green
                                                        : Colors.transparent,
                                                  ),
                                                  child: Text(
                                                    "ON",
                                                    style: TextStyle(
                                                        fontSize: (Get.context
                                                                    ?.isPhone ??
                                                                true)
                                                            ? 13
                                                            : 15,
                                                        fontFamily:
                                                            "PatrickHandSC",
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: isSoundOn
                                                            ? Colors.white
                                                            : Colors.black),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 15),
                                  // MUSIC ROW
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Background Music',
                                        style: TextStyle(
                                          fontSize:
                                              (Get.context?.isPhone ?? true)
                                                  ? 16
                                                  : 26,
                                          color: Colors.white,
                                          fontFamily: "PatrickHandSC",
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.center,
                                        child: Container(
                                          height: 40,
                                          decoration: BoxDecoration(
                                              color: Color(0XFFF4E9DE),
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              border: Border.all(
                                                width: 3,
                                                color: Color.fromARGB(
                                                    255, 215, 192, 168),
                                              )),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              // MUSIC OFF BUTTON
                                              SizedBox(
                                                width: 45,
                                                child: TextButton(
                                                  onPressed: () async {
                                                    audioController
                                                        .buttonClick();
                                                    // Disable background music
                                                    await audioController
                                                        .pauseAllSoundsBackground();

                                                    setDialogState(() {
                                                      isMusicOn = false;
                                                    });

                                                    log("MUSIC: OFF");
                                                  },
                                                  style: TextButton.styleFrom(
                                                    backgroundColor: !isMusicOn
                                                        ? Colors.green
                                                        : Colors.transparent,
                                                  ),
                                                  child: Text(
                                                    "OFF",
                                                    style: TextStyle(
                                                        fontSize: (Get.context
                                                                    ?.isPhone ??
                                                                true)
                                                            ? 13
                                                            : 15,
                                                        fontFamily:
                                                            "PatrickHandSC",
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: isMusicOn
                                                            ? Colors.black
                                                            : Colors.white),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 45,
                                                child: TextButton(
                                                  onPressed: () async {
                                                    audioController
                                                        .buttonClick();
                                                    // Enable background music

                                                    setDialogState(() {
                                                      isMusicOn = true;
                                                    });

                                                    await audioController
                                                        .resumeAllSoundsBackground();

                                                    log("MUSIC: ON");
                                                  },
                                                  style: TextButton.styleFrom(
                                                    backgroundColor: isMusicOn
                                                        ? Colors.green
                                                        : Colors.transparent,
                                                  ),
                                                  child: Text(
                                                    "ON",
                                                    style: TextStyle(
                                                        fontSize: (Get.context
                                                                    ?.isPhone ??
                                                                true)
                                                            ? 13
                                                            : 15,
                                                        fontFamily:
                                                            "PatrickHandSC",
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: isMusicOn
                                                            ? Colors.white
                                                            : Colors.black),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
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
                  );
                },
              );
            },
          );
        },
        child: Container(
          height: (Get.context?.isPhone ?? true) ? 40 : 45,
          width: (Get.context?.isPhone ?? true) ? 40 : 45,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/image/Square.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: Icon(
            Icons.settings,
            size: (Get.context?.isPhone ?? true) ? 25 : 35,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

// Main CustomRowWidget
class CustomRowWidget extends StatelessWidget {
  const CustomRowWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: PlayerInfoBox(),
        ),
        // CharacterStack(),
        const SizedBox(width: 10),
        SettingsButton(),
      ],
    );
  }
}
