import 'package:belteiis_kids/view/level_game/level_screen.dart';
import 'package:belteiis_kids/view/splas_screen/loading_screen.dart';
import 'package:belteiis_kids/view/term/privacy_policy.dart';
import 'package:belteiis_kids/view/term/terms_of_use.dart';
import 'package:belteiis_kids/view/puzzle_games/cross_word.dart';
import 'package:belteiis_kids/view/start_screen/start_screen.dart';
import 'package:get/get.dart';
import 'view/splas_screen/splas_screen.dart';

final appRoute = [

  GetPage(name: '/start', page: () => const StartScreen()),
  GetPage(name: '/crossword', page: () => CrossWord()),
  GetPage(name: '/LevelScreen', page: () => LevelScreen()),
  GetPage(name: '/SplashScreen', page: () => SplashScreen()),
  GetPage(name: '/LoadingScreen', page: () => LoadingScreen()),
  GetPage(name: '/PrivacyPolicy', page: () => PrivacyPolicy()),
  GetPage(name: '/TermsOfUse', page: () => TermsOfUse()),

];
