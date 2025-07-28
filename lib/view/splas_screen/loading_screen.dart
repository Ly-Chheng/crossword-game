import 'package:belteiis_kids/core/helper/background_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _fadeController;
  late AnimationController _progressController;

  late Animation<double> _logoAnimation;
  late Animation<double> _textAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _progressAnimation;
  late Animation<Color?> _progressColorAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _textController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _progressController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Initialize animations
    _logoAnimation = Tween<double>(
      begin: -200.0, // Start above the screen
      end: 0.0, // End at original position
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.bounceOut,
    ));

    _textAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeOutBack,
    ));

    _fadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut,
    ));

    _progressColorAnimation = ColorTween(
      begin: const Color(0xFFFFFFFF),
      end: const Color(0xFFFDA90E),
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut,
    ));

    _startAnimation();
  }

  void _startAnimation() async {
    await _logoController.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    await _textController.forward();
    _progressController.forward();
    await Future.delayed(const Duration(seconds: 2));
    await _fadeController.forward();
    _navigateToHome();
  }

  void _navigateToHome() {
    Get.offNamed('/LevelScreen');
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _fadeController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions using GetX
    double screenWidth = Get.width;
    double screenHeight = Get.height;

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2E),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _fadeAnimation,
          builder: (context, child) {
            double opacity = _fadeAnimation.value.clamp(0.0, 1.0);

            return Opacity(
              opacity: opacity,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF1E1E2E),
                      Color(0xFF2A2A3E),
                      Color(0xFF3A3A5E),
                    ],
                  ),
                ),
                child: Container(
                  decoration: BackgroundImage.buildContainerBackground(
                    imagePath: "assets/image/bg_subgames.png",
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Responsive Progress Indicator
                        AnimatedBuilder(
                          animation: _textAnimation,
                          builder: (context, child) {
                            double textValue = _textAnimation.value.clamp(0.0, 1.0);

                            return Opacity(
                              opacity: textValue,
                              child: Column(
                                children: [
                                  // Custom Progress Bar
                                  Container(
                                    width: screenWidth * 0.5, // 50% of screen width
                                    height: screenHeight * 0.02, // 2% of screen height
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                    child: AnimatedBuilder(
                                      animation: _progressAnimation,
                                      builder: (context, child) {
                                        return Container(
                                          width: (screenWidth * 0.5) * _progressAnimation.value,
                                          height: screenHeight * 0.02,
                                          decoration: BoxDecoration(
                                            color: _progressColorAnimation.value,
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.02), // Responsive spacing
                                  AnimatedBuilder(
                                    animation: _progressAnimation,
                                    builder: (context, child) {
                                      int percentage = (_progressAnimation.value * 100).round();
                                      return Text(
                                        // 'LOADING... $percentage%',
                                        'LOADING...',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: screenWidth * 0.05, // Responsive font size
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
                                      );
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}