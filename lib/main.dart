import 'package:belteiis_kids/controller/time_controller.dart';
import 'package:belteiis_kids/core/constant/logger.dart';
import 'package:belteiis_kids/core/helper/audio_handler.dart';
import 'package:belteiis_kids/routes.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();
  Get.put(TimerController());
  Get.put(AudioController()); // Initialize AudioController
  Get.put(AppController());
  runApp(MyApp.instance);
}

class MyApp extends StatefulWidget {
  const MyApp._internal();
  
  static const MyApp _instance = MyApp._internal();
  static MyApp get instance => _instance;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final AppController _appController = Get.find<AppController>();
  final AudioController _audioController = Get.find<AudioController>(); // Add AudioController

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.detached:
        _appController.clearSharedPreferences();
        _audioController.pauseAllSounds(); // Pause all audio when app is detached
        Logger.info("App detached - SharedPreferences cleared and audio paused");
        break;
      case AppLifecycleState.paused:
        _audioController.pauseAllSounds(); // Pause all audio when app goes to background
        Logger.info("App paused - Audio paused");
        break;
      case AppLifecycleState.resumed:
        _audioController.resumeAllSounds(); // Resume all audio when app comes back to foreground
        Logger.info("App resumed - Audio resumed");
        break;
      case AppLifecycleState.inactive:
        _audioController.pauseAllSounds(); // Pause audio when app becomes inactive
        Logger.info("App inactive - Audio paused");
        break;
      case AppLifecycleState.hidden:
        _audioController.pauseAllSounds(); // Pause audio when app is hidden
        Logger.info("App hidden - Audio paused");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white,
      ),
    );
    Logger.info("RUN GAME APP");
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/SplashScreen',
      getPages: appRoute,
    );
  }
}

class AppController extends GetxController {
  final AudioController _audioController = Get.find<AudioController>(); // Add AudioController reference

  @override
  void onClose() {
    _audioController.pauseAllSounds(); // Pause audio when controller is disposed
    clearSharedPreferences();
    super.onClose();
  }

  Future<void> clearSharedPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      Logger.info("SharedPreferences cleared successfully");
    } catch (e) {
      Logger.error("Error clearing SharedPreferences: $e");
    }
  }

  Future<void> clearGameData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Clear level stars
      for (int i = 0; i < 10; i++) {
        await prefs.remove('level_${i}_stars');
      }

      // Clear other game-specific data
      final gameKeys = [
        'user_settings',
        'game_progress',
        'total_score',
      ];

      for (String key in gameKeys) {
        await prefs.remove(key);
      }

      Logger.info("Game data cleared successfully");
    } catch (e) {
      Logger.error("Error clearing game data: $e");
    }
  }

  // Additional method to handle audio when clearing game data
  Future<void> resetGameWithAudio() async {
    await _audioController.stopSound(); // Stop current audio
    await clearGameData();
    Logger.info("Game reset with audio stopped");
  }
}