import 'dart:developer';
import 'package:belteiis_kids/core/constant/logger.dart';
import 'package:belteiis_kids/core/helper/audio_handler.dart';
import 'package:belteiis_kids/core/helper/terms_storage.dart';
import 'package:belteiis_kids/view/term/term_condition.dart';
import 'package:belteiis_kids/widget/zoom_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  final audioController = Get.put(AudioController());
  bool termsAccepted = false; // Track if terms have been accepted
  bool isLoadingTerms = true; // Track loading state

  @override
  void initState() {
    super.initState();
    _playWelcomeSound();
    _checkTermsStatus();
  }

  /// Check if terms have been previously accepted
  Future<void> _checkTermsStatus() async {
    try {
      final hasAccepted = await TermsStorage.hasAcceptedTerms();
      setState(() {
        termsAccepted = hasAccepted;
        isLoadingTerms = false;
      });

      // Show terms dialog if not accepted
      if (!hasAccepted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showTermsDialog();
        });
      }
    } catch (e) {
      Logger.info("Error checking terms status: $e");
      setState(() {
        isLoadingTerms = false;
      });
      // Show terms dialog on error to be safe
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showTermsDialog();
      });
    }
  }

  Future<void> _playWelcomeSound() async {
    try {
      await audioController.startSound(
        'assets/audio/music_start.mp3',
        loop: true,
        volume: 0.8,
      );
    } catch (e) {
      Logger.info("Error playing welcome sound: $e");
    }
  }

  void _showTermsDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (context) => TermConditionDialog(
        name: "BELTEI Kids App",
        description:
            "To continue playing, you need to confirm that you agree to our Terms of Use and have read our Privacy Policy.",
        onAccept: () async {
          // Store terms acceptance
          await TermsStorage.storeTermsAcceptance();

          log("Store terms successful");

          setState(() {
            termsAccepted = true;
          });
          audioController.buttonClick();
        },
      ),
    );
  }

  void _handlePlayButtonTap() {
    if (isLoadingTerms) {
      // Still loading, don't proceed
      return;
    }

    if (!termsAccepted) {
      // Show terms dialog again if not accepted
      _showTermsDialog();
      return;
    }

    log("Play button tapped");
    audioController.buttonClick();
    Get.toNamed('/LevelScreen');
  }

  @override
  Widget build(BuildContext context) {
    // Get device dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final aspectRatio = screenWidth / screenHeight;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/image/bg_subgames.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Overlay to dim content if terms not accepted or still loading
          if (!termsAccepted || isLoadingTerms)
            Container(
              color: Colors.black.withOpacity(0.3),
            ),
          // Loading indicator while checking terms
          if (isLoadingTerms)
            const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          // Center content
          if (!isLoadingTerms)
            Center(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final maxWidth = constraints.maxWidth;
                  final maxHeight = constraints.maxHeight;
                  final welcomeImageWidth =
                      maxWidth * (aspectRatio > 2 ? 0.28 : 0.37);
                  final playButtonWidth =
                      maxWidth * (aspectRatio > 2 ? 0.07 : 0.09);
                  final textSize = maxWidth * (aspectRatio > 2 ? 0.03 : 0.037);

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Welcome image
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: maxWidth * 0.1,
                          vertical: maxHeight * 0.02,
                        ),
                        child: Image.asset(
                          "assets/image/logo.png",
                          width: welcomeImageWidth,
                        ),
                      ),
                      SizedBox(height: maxHeight * 0.02),
                      // Play button
                      GestureDetector(
                        onTap: _handlePlayButtonTap,
                        child: AnimatedPlayButton(
                          image: "assets/image/play.png",
                          width: playButtonWidth,
                        ),
                      ),
                      SizedBox(height: maxHeight * 0.08),
                      // School name
                      SizedBox(
                        width: maxWidth * 0.7,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            "BELTEI INTERNATIONAL SCHOOL",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: textSize,
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
                    ],
                  );
                },
              ),
            ),
          // Version text
          if (!isLoadingTerms)
            Positioned(
              bottom: screenHeight * 0.02,
              right: screenWidth * 0.02,
              child: Text(
                "Version 1.0",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: "PatrickHandSC",
                  fontSize: screenWidth * (aspectRatio > 2 ? 0.015 : 0.02),
                ),
              ),
            ),
          // Character animations
          if (!isLoadingTerms)
            Positioned(
              left: screenWidth * (aspectRatio > 2 ? 0.05 : 0.03),
              top: screenHeight * (aspectRatio > 2 ? 0.45 : 0.5),
              child: SizedBox(
                width: screenWidth * (aspectRatio > 2 ? 0.25 : 0.3),
                child: AspectRatio(
                  aspectRatio: 1.2,
                  child: Stack(
                    children: [
                      Image.asset(
                        "assets/image/beltei_rabbit.png",
                        fit: BoxFit.contain,
                      ),
                      Positioned(
                        left: 0,
                        bottom: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset(
                              "assets/image/rabit.gif",
                              width:
                                  screenWidth * (aspectRatio > 2 ? 0.12 : 0.14),
                            ),
                            Image.asset(
                              "assets/image/bear.gif",
                              width:
                                  screenWidth * (aspectRatio > 2 ? 0.12 : 0.13),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
