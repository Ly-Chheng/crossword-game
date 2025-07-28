import 'dart:developer' as developer;
import 'package:belteiis_kids/core/helper/audio_handler.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Replace with your actual audioController
final audioController = Get.find<AudioController>();

class DialogHelper {
  static void showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) {
          bool isMusicOn = !audioController.isBackgroundMusicDisabled;
          bool isSoundOn = !audioController.isSoundEffectsDisabled;

          return Dialog(
           
            backgroundColor: Colors.transparent,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Background image
                  Positioned.fill(
                    child: Image.asset(
                      "assets/image/bg_setting_d.png",
                      fit: BoxFit.cover,width: double.infinity,height: double.infinity,
                    ),
                  ),
                  // Settings content
                  Container(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      // mainAxisSize: MainAxisSize.min,
                      children: [
                      
                        // Sound section
                        _buildToggleRow(
                          icon: 'assets/image/icon_sound.png',
                          label: 'Sound',
                          isOn: isSoundOn,
                          onToggleOff: () async {
                            audioController.buttonClick();
                            await audioController.disableSoundEffects();
                            setState(() => isSoundOn = false);
                            developer.log("SOUND: OFF");
                          },
                          onToggleOn: () async {
                            audioController.buttonClick();
                            await audioController.enableSoundEffects();
                            setState(() => isSoundOn = true);
                            await audioController.soundEffect("assets/audio/button_click.mp3");
                            developer.log("SOUND: ON");
                          },
                        ),
                        const SizedBox(height: 20),
                        // Music section
                        _buildToggleRow(
                          icon: 'assets/image/music.png',
                          label: 'Music',
                          isOn: isMusicOn,
                          onToggleOff: () async {
                            audioController.buttonClick();
                            await audioController.pauseAllSoundsBackground();
                            setState(() => isMusicOn = false);
                            developer.log("MUSIC: OFF");
                          },
                          onToggleOn: () async {
                            audioController.buttonClick();
                            await audioController.resumeAllSoundsBackground();
                            setState(() => isMusicOn = true);
                            developer.log("MUSIC: ON");
                          },
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: CloseButton(
                      color: Colors.white,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  static Widget _buildToggleRow({
    required String icon,
    required String label,
    required bool isOn,
    required VoidCallback onToggleOff,
    required VoidCallback onToggleOn,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Image.asset(icon, width: 40, height: 40),
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(
                fontSize: 24,
                color: Color(0XFF6C3499),
                fontFamily: "PatrickHandSC",
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/image/btn_music_2.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Row(
              children: [
                GestureDetector(
                  onTap: onToggleOff,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                    decoration: BoxDecoration(
                      color: !isOn ? Colors.green : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "OFF",
                      style: TextStyle(
                        fontFamily: "PatrickHandSC",
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isOn ? Colors.black : Colors.white,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: onToggleOn,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                    decoration: BoxDecoration(
                      color: isOn ? Colors.green : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "ON",
                      style: TextStyle(
                        fontFamily: "PatrickHandSC",
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isOn ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
