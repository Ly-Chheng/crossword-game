import 'package:belteiis_kids/core/helper/background_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
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
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
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

    // In initState, add this with other animations
    _progressColorAnimation = ColorTween(
      begin: Color(0XFFFFFFFF),
      end: const Color(0xFFFDA90E),
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut,
    ));

    _startAnimation();
  }

  void _startAnimation() async {
    // Start logo animation
    await _logoController.forward();
    
    // Start text animation with slight delay
    await Future.delayed(const Duration(milliseconds: 200));
    await _textController.forward();
    
    // Start progress animation
    _progressController.forward();
    
    // Wait for 2 seconds then fade out
    await Future.delayed(const Duration(seconds: 2));
    await _fadeController.forward();
    
    // Navigate to main screen
    _navigateToHome();
  }

  void _navigateToHome() {
    Get.offNamed('/start');
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
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2E),
      body: AnimatedBuilder(
        animation: _fadeAnimation,
        builder: (context, child) {
          // Clamp the opacity value to ensure it stays within valid range
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
                      // Animated Logo
                      AnimatedBuilder(
                        animation: _logoAnimation,
                        builder: (context, child) {
                          // Clamp the scale value as well
                          double scale = _logoAnimation.value.clamp(0.0, 1.0);
                          

                          return Transform.scale(
                            scale: scale,
                            child: SizedBox(
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: Image.asset(
                                  "assets/image/logo_beltei.png",
                                  height: (Get.context?.isPhone ?? true)
                                      ? screenWidth * 0.1
                                      : screenWidth * 0.2,
                                ),
                              ),

                              ),
                          );
                        },
                      ),
                      SizedBox(height: (Get.context?.isPhone ?? true) ? 40.0 : 50.0,),

                      // Animated App Name
                      AnimatedBuilder(
                        animation: _textAnimation,
                        builder: (context, child) {
                          // Clamp the text animation value
                          double textValue = _textAnimation.value.clamp(0.0, 1.0);
                          
                          return Transform.translate(
                            offset: Offset(0, 50 * (1 - textValue)),
                            child: Opacity(
                              opacity: textValue,
                              child: Column(
                                children: [
                                  Text(
                                    'BELTEI KIDS',
                                    style: TextStyle(
                                      fontSize: (Get.context?.isPhone ?? true) ? 15.0 : 30.0,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                      letterSpacing: 4,
                                      fontFamily: "PatrickHandSC",
                                      shadows: [
                                        Shadow(
                                          color: Colors.black.withOpacity(0.5),
                                          offset: const Offset(3, 3),
                                          blurRadius: 8,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      
                      const SizedBox(height: 10),
                      
                      // Custom Progress Indicator
                      AnimatedBuilder(
                        animation: _textAnimation,
                        builder: (context, child) {
                          // Clamp the text animation value for loading indicator
                          double textValue = _textAnimation.value.clamp(0.0, 1.0);
                          
                          return Opacity(
                            opacity: textValue,
                            child: Column(
                              children: [
                                Container(
                                    width: (Get.context?.isPhone ?? true)
                                        ? screenWidth * 0.15
                                        : screenWidth * 0.15,
                                    height: (Get.context?.isPhone ?? true) ? 15 : 20,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(width: 3, color: Colors.blueGrey),
                                    ),
                                    child: AnimatedBuilder(
                                      animation: _progressAnimation,
                                      builder: (context, child) {
                                        return Container(
                                          width: ((Get.context?.isPhone ?? true)
                                              ? screenWidth * 0.15
                                              : screenWidth * 0.15) * _progressAnimation.value,
                                          height: double.infinity,
                                          decoration: BoxDecoration(
                                            color: _progressColorAnimation.value,
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                        );
                                      },
                                    ),
                                  ),

                                SizedBox(height: (Get.context?.isPhone ?? true) ? 10.0 : 16.0,),
                                AnimatedBuilder(
                                  animation: _progressAnimation,
                                  builder: (context, child) {
                                    int percentage = (_progressAnimation.value * 100).round();
                                    return Text(
                                      'LOADING... $percentage%',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: (Get.context?.isPhone ?? true) ? 13 : 20.0,
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
    );
  }
}