import 'package:belteiis_kids/core/helper/audio_handler.dart';
import 'package:belteiis_kids/controller/time_controller.dart';
import 'package:belteiis_kids/widget/complete_dialog.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:crossword/crossword.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/data/cross_word_api.dart';
import 'dart:developer';

class CrossWordController extends GetxController {
  GlobalKey<CrosswordState> crosswordState = GlobalKey<CrosswordState>();

  var currentWord = ''.obs;
  var foundWords = <String>[].obs;
  var hintIndex = 0.obs;
  var currentLevelIndex = 0.obs;
  var currentLevel = 0.obs;
  var star = 0.obs;
  var isLevelComplete = false.obs;
  var totalScore = 0.obs;
  var timeUpHandled = false.obs;
  var isDialogShowing = false.obs;
  final audioController = Get.put(AudioController());

  late TimerController timerController;
  late List<List<String>> letters;
  late List<Map<String, String>> hints;
  final Map<String, Color> wordColors = {};

  @override
  void onInit() {
    super.onInit();
    log("=== CrossWordController.onInit() START ===");
    _playWelcomeSound();
    Get.delete<TimerController>(force: true);
    timerController = Get.put(
      TimerController(
        onTimeout: () => onTimeOut(Get.overlayContext),
        showMissionAlert: () => onMissing(),
      ),
    );
    replay();
    timerController.resetTimer();
    timerController.startCountdown();
  }

  @override
  void onClose() {
    log("Playing background music on controller close");
    audioController.startSound(
      'assets/audio/music_start.mp3',
      loop: true,
    );
  }

  List<List<Color>> getWordColors() {
    return hints.map((hint) {
      final word = hint["word"] ?? "";
      return [wordColors[word] ?? Colors.blue];
    }).toList();
  }

  void assignWordColors() {
    // Expanded list of distinct colors to minimize repetition
    final List<Color> availableColors = [
      Colors.green,
      Colors.blue,
      Colors.purple,
      Colors.orange,
      Colors.teal,
      Colors.yellow,
      Colors.cyan,
      Colors.pink,
      Colors.amber,
      Colors.indigo,
      Colors.lime,
      Colors.deepPurple,
      Colors.lightBlue,
      Colors.deepOrange,
      Colors.yellowAccent,
      Colors.brown,
      Colors.indigoAccent,
      Colors.tealAccent
    ];

    wordColors.clear(); // Clear any existing color assignments

    // Shuffle colors to ensure random assignment
    final shuffledColors = List<Color>.from(availableColors)..shuffle();

    // Assign unique colors to each hint word
    for (int i = 0; i < hints.length; i++) {
      final word = hints[i]["word"] ?? "";
      if (word.isNotEmpty) {
        // Use modulo to cycle through colors if hints exceed available colors
        wordColors[word] = shuffledColors[i % shuffledColors.length];
      }
    }

    // Log assigned colors for debugging
    wordColors.forEach((word, color) {
      log("Assigned color to '$word': $color");
    });
  }

  // Future<void> _saveStars(int levelIndex, int stars) async {
  //   log("=== _saveStars() START ===");
  //   log("Saving stars - Level: $levelIndex, Stars: $stars");

  //   try {
  //     final prefs = await SharedPreferences.getInstance();
  //     await prefs.setInt('level_${levelIndex}_stars', stars);
  //     log("Successfully saved $stars stars for level $levelIndex");
  //   } catch (e) {
  //     log("ERROR saving stars: $e");
  //   }

  //   log("=== _saveStars() COMPLETE ===");
  // }

  Future<void> _saveStars(int levelIndex, int stars) async {
  log("=== _saveStars() START ===");
  log("Saving stars - Level: $levelIndex, Stars: $stars");

  try {
    final prefs = await SharedPreferences.getInstance();
    final currentStars = prefs.getInt('level_${levelIndex}_stars') ?? 0;
    // Only save if the new star count is higher than the existing one
    if (stars > currentStars) {
      await prefs.setInt('level_${levelIndex}_stars', stars);
      log("Successfully saved $stars stars for level $levelIndex (previous: $currentStars)");
    } else {
      log("Skipped saving $stars stars for level $levelIndex (current: $currentStars is higher or equal)");
    }
  } catch (e) {
    log("ERROR saving stars: $e");
  }

  log("=== _saveStars() COMPLETE ===");
}

  Future<int> getStars(int levelIndex) async {
    log("=== getStars() START ===");
    log("Retrieving stars for level: $levelIndex");

    try {
      final prefs = await SharedPreferences.getInstance();
      final stars = prefs.getInt('level_${levelIndex}_stars') ?? 0;
      log("Retrieved $stars stars for level $levelIndex");
      return stars;
    } catch (e) {
      log("ERROR retrieving stars: $e");
      return 0;
    }
  }

void checkStarByAbsoluteTime() {
  final levelData = levels[0]["data"][currentLevelIndex.value];
  final int allocatedTimeSeconds = levelData["time"] ?? 20;
  
  log("Level data: $levelData | Allocated: ${allocatedTimeSeconds}s | Found: ${foundWords.length}/${hints.length}");

  // Check if level is completed
  if (foundWords.length != hints.length) {
    star.value = 0; // No stars if level is not completed
    log("Level not completed: foundWords=${foundWords.length}, hints=${hints.length}, stars=0");
    return;
  }

  // Validate allocated time
  if (allocatedTimeSeconds <= 0) {
    star.value = 0; // No stars if allocated time is invalid
    log("RESULT: Invalid allocated time (${allocatedTimeSeconds}s) - 0 stars awarded");
    return;
  }

  // Your star calculation logic
  var remainingTime = timerController.seconds.value; // Get remaining time
  var result1 = allocatedTimeSeconds / 3; // 1/3 of time (33%)
  var result2 = allocatedTimeSeconds - result1 ; // 1/2 of time (50%)
  var result3 = allocatedTimeSeconds - result2;     // full time (100%)
  
  if (remainingTime >= result2) {      // Still have > 50% time left
    star.value = 3;
    log("RESULT: 3 stars awarded - ${remainingTime}s remaining (≥${result2}s threshold - 50% time left)");
  } else if (remainingTime >= result1) { // Still have > 33% time left  
    star.value = 2;
    log("RESULT: 2 stars awarded - ${remainingTime}s remaining (≥${result1}s threshold - 33% time left)");
  } else if (remainingTime > 0) {       // Any time remaining
    star.value = 1;
    log("RESULT: 1 star awarded - ${remainingTime}s remaining (>0s threshold - completed in time)");
  } else {
    star.value = 0; // No time remaining
    log("RESULT: 0 stars awarded - No time remaining");
  }
  
  log("Star rating: ${star.value} stars (remaining: ${remainingTime}s/${allocatedTimeSeconds}s, thresholds: 3⭐≥${result2}s, 2⭐≥${result1}s, 1⭐>0s)");
}


  void onMissing() {
    if (timerController.missingTime.value % 10 == 0) {
      revealHint();
    }
  }

  Future<void> _playWelcomeSound() async {
    try {
      await audioController.startSound(
        'assets/audio/bg_music_13.mp3',
        loop: true,
        volume: 0.2,
      );
    } catch (e) {
      log("Error playing welcome sound: $e");
    }
  }

  void replay() {
    totalScore.value = 0;
    currentLevelIndex.value = 0;
    currentLevel.value = 0;
    timeUpHandled.value = false;
    isDialogShowing.value = false;
    loadLevel();
    timerController.startCountdown();
  }

  void replayCurrentLevel() {
    currentWord.value = '';
    foundWords.clear();
    hintIndex.value = 0;
    isLevelComplete.value = false;
    star.value = 0;
    timeUpHandled.value = false;
    isDialogShowing.value = false;

    timerController.missingTime.value = 0;

    loadLevel();
    timerController.startCountdown();
  }

  String get currentLevelType {
    final levelData = levels[0]["data"][currentLevelIndex.value];
    return levelData["type"]?.toString() ?? "Puzzle";
  }

  void loadLevel() {
    log("Loading level index: ${currentLevelIndex.value}");
    final levelData = levels[0]["data"][currentLevelIndex.value];
    log("Level data retrieved: $levelData");
    letters = List<List<String>>.from(levelData["word"]);
    hints = List<Map<String, String>>.from(levelData["result"]);
    timerController.seconds.value = levelData["time"]; // Set level-specific time
    log("Letters: $letters, Hints: $hints");
    assignWordColors();
    for (var hint in hints) {
      log("Hint word: ${hint['word']}, sound: ${hint['sound']}");
    }
    crosswordState = GlobalKey<CrosswordState>(debugLabel: UniqueKey().toString());
    currentWord.value = "";
    foundWords.clear();
    hintIndex.value = 0;
    isLevelComplete.value = false;
    timerController.missingTime.value = 0;
    update();
  }

  Future<void> handleLineUpdate( String word, List<String> words, bool isLineDrawn) async {
    bool isValidPrefix =  hints.any((hint) => (hint["word"] ?? "").startsWith(word));
    log("Handling line update: word=$word, isValidPrefix=$isValidPrefix, isLineDrawn=$isLineDrawn");
    if (!isValidPrefix) {
      currentWord.value = "";
    } else {
      currentWord.value = isLineDrawn ? word : currentWord.value;
      if (isLineDrawn &&
          hints.any((hint) => hint["word"] == word) &&
          !foundWords.contains(word)) {
        foundWords.add(word);
        final matchedHint = hints.firstWhere(
          (hint) => hint["word"] == word,
          orElse: () => <String, String>{},
        );
        final soundPath = matchedHint["sound"];
        log("Matched hint: $matchedHint, soundPath: $soundPath");
        if (soundPath != null && soundPath.isNotEmpty) {
          log("Playing sound for '$word': $soundPath");
          await audioController.soundEffect(soundPath);
        } else {
          log("No sound found for word: $word");
          await audioController.soundEffect("assets/audio/null_sound001.mp3");
        }
      }
    }

    if (foundWords.length == hints.length && !isLevelComplete.value) {
      log("Level completed: foundWords=$foundWords, hints=$hints");
      isLevelComplete.value = true;
      timerController.pauseTimer();
      checkStarByAbsoluteTime(); // Calculate stars before showing dialog
      await _saveStars(currentLevelIndex.value, star.value); // Save stars immediately

      // Check if player failed (0 stars) after completing all words
      if (star.value == 0) {
        log("Level completed but failed due to time - showing level failed dialog: $star");
        if (Get.context != null && !isDialogShowing.value) {
          isDialogShowing.value = true;
          Future.delayed(const Duration(seconds: 1), () {
            if (Get.context != null) {
              MissionCompletedDialog.showLevelFailed(
                context: Get.context!,
                starCount: star.value,
                title: "Level Failed!",
                description: "Sorry You Failed",
                level: "${currentLevel.value + 1}",
                retry: () {
                  isDialogShowing.value = false;
                  replayCurrentLevel();
                },
              );
            }
          });
        }
      } else {
        // Show success dialog
        if (Get.context != null && !isDialogShowing.value) {
          isDialogShowing.value = true;
          Future.delayed(const Duration(seconds: 1), () {
            if (Get.context != null) {
              MissionCompletedDialog.nextLevelPopUp(
                context: Get.context!,
                level: currentLevel.value + 1,
                expiredTime: timerController.formattedTime,         
                starCount: star.value,
                onReplay: () {
                  isDialogShowing.value = false;
                  replayCurrentLevel();
                  timerController.startCountdown();
                },
                nextLevel: () {
                  isDialogShowing.value = false;
                  Get.back();
                  nextLevel();
                },
                toHomePage: () {
                  Get.offAllNamed('/LevelScreen');
                  timerController.startCountdown();
                },
              );
            } else {
              log("Error: Get.context is null when trying to show nextLevelPopUp");
            }
          });
        } else {
          log("Error: Get.context is null or dialog already showing, skipping nextLevelPopUp");
        }
      }
    }
    update();
  }

  void nextLevel() {
    int totalLevels = (levels[0]["data"] as List).length;
    log("Current level: ${currentLevelIndex.value}, Total levels: $totalLevels");

    if (star.value == 0) {
      log("No stars earned, prompting retry for level ${currentLevel.value + 1}");
      timerController.pauseTimer();
      if (Get.context != null && !isDialogShowing.value) {
        isDialogShowing.value = true;
        MissionCompletedDialog.showLevelFailed(
          context: Get.context!,
          starCount: star.value,
          title: "Level Failed",
          description: "Sorry you Failed",
          level: "${currentLevel.value}",
          onReplay: () {
            replayCurrentLevel();
            // timerController.resetTimer();
            timerController.startCountdown();
            isDialogShowing.value = false;
          },
        );
      } else {
        log("Error: Get.context is null or dialog already showing, skipping showGameOver");
      }
      return;
    }

    if (currentLevelIndex.value + 1 >= totalLevels) {
      log("GAME COMPLETE - Reached final level");
      timerController.pauseTimer();
      totalScore.value += 10;
      if (Get.context != null && !isDialogShowing.value) {
        isDialogShowing.value = true;
        MissionCompletedDialog.showCompletedDialog(
          context: Get.context!,
          level: currentLevel.value + 1,
          expiredTime: timerController.formattedCountupTime,
          score: "${totalScore.value}",
          onReplay: () {
            replay();
            isDialogShowing.value = false;
          },
        );
      } else {
        log("Error: Get.context is null or dialog already showing, skipping showCompletedDialog");
      }
    } else {
      totalScore.value += 10;
      currentLevelIndex.value++;
      currentLevel.value++;
      crosswordState = GlobalKey<CrosswordState>();
      loadLevel();
      // timerController.resetTimer();
      timerController.startCountdown();
    }
    update();
    log("UI update triggered");
  }

  Offset? findHintPosition(String hintWord) {
    log("Searching for hint word: '$hintWord' (length: ${hintWord.length})");

    for (int i = 0; i < letters.length; i++) {
      for (int j = 0; j < letters[i].length; j++) {
        if (j + hintWord.length <= letters[i].length &&
            letters[i].sublist(j, j + hintWord.length).join() == hintWord) {
          log("Found horizontal hint at ($j, $i)");
          return Offset(j.toDouble(), i.toDouble());
        }
        if (i + hintWord.length <= letters.length) {
          String verticalWord = "";
          for (int k = 0; k < hintWord.length; k++) {
            verticalWord += letters[i + k][j];
          }
          if (verticalWord == hintWord) {
            log("Found vertical hint at ($j, $i)");
            return Offset(j.toDouble(), i.toDouble());
          }
        }
      }
    }
    log("Hint '$hintWord' not found in grid");
    return null;
  }

  void revealHint() {
    if (isLevelComplete.value) {
      log("Level already completed, skipping hint animation");
      timerController.missingTime.value = 0;
      return;
    }

    if (hints.isEmpty || hintIndex.value >= hints.length) {
      log("No hints available or index out of bounds: hintIndex=${hintIndex.value}, hints.length=${hints.length}");
      return;
    }

    int initialIndex = hintIndex.value;
    bool foundUnfoundHint = false;
    String hintWord = "";
    Offset? position;

    for (int i = 0; i < hints.length; i++) {
      hintWord = hints[hintIndex.value]["word"] ?? "";
      log("Checking hint: $hintWord at index: ${hintIndex.value}");

      if (hintWord.isEmpty) {
        log("Hint word is empty at index: ${hintIndex.value}");
        hintIndex.value = (hintIndex.value + 1) % hints.length;
        continue;
      }

      if (!foundWords.contains(hintWord)) {
        foundUnfoundHint = true;
        position = findHintPosition(hintWord);
        break;
      }

      hintIndex.value = (hintIndex.value + 1) % hints.length;
      if (hintIndex.value == initialIndex) {
        break;
      }
    }

    if (!foundUnfoundHint) {
      log("All hints are already found or no valid hints available");
      return;
    }

    if (position != null) {
      if (crosswordState.currentState != null) {
        crosswordState.currentState?.animate(offset: position);
        hintIndex.value = (hintIndex.value + 1) % hints.length;
      } else {
        log("Error: crosswordState.currentState is null");
      }
    } else {
      log("Hint '$hintWord' not found in grid, moving to next hint");
      hintIndex.value = (hintIndex.value + 1) % hints.length;
    }

    update();
  }

  void onTimeOut(BuildContext? context) {
    log("onTimeOut called, timeUpHandled: ${timeUpHandled.value}, isDialogShowing: ${isDialogShowing.value}");

    if (timeUpHandled.value || isDialogShowing.value || Get.context == null) {
      log("Time out already handled or dialog showing, skipping");
      return;
    }

    timeUpHandled.value = true;
    isDialogShowing.value = true;

    // Set stars to 0 when time runs out
    star.value = 0;

    // Save the failed attempt
    _saveStars(currentLevelIndex.value, star.value);
    timerController.pauseTimer();

    // Show timeout dialog which should be treated as level failed
    MissionCompletedDialog.showLevelFailed(
      context: Get.context!,
      starCount: star.value,
      title: "Time's Up!",
      description: "Time ran out! Try again.",
      level: "${currentLevel.value + 1}",
      retry: () {
        isDialogShowing.value = false;
        replayCurrentLevel();
      },
    );
  }
}



