import 'dart:developer';
import 'package:belteiis_kids/controller/crossword_controller.dart';
import 'package:belteiis_kids/controller/home_controller.dart';
import 'package:belteiis_kids/core/helper/audio_handler.dart';
import 'package:belteiis_kids/core/helper/background_helper.dart';
import 'package:belteiis_kids/core/helper/dialog_helper_image.dart';
import 'package:belteiis_kids/widget/app_bar_home.dart';
import 'package:belteiis_kids/core/data/cross_word_api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LevelScreen extends StatefulWidget {
  const LevelScreen({super.key});

  @override
  State<LevelScreen> createState() => _LevelScreenState();
}

class _LevelScreenState extends State<LevelScreen> with WidgetsBindingObserver {
  final audioController = Get.put(AudioController());
  late final HomeController homeController;
  CrossWordController? crossWordController; // Make it nullable for lazy loading
  List<int> levelStars = List.filled(10, 0); // Store stars for 10 levels per page
  int currentPage = 0; // Track current page of levels
  int levelsPerPage = 10; // Number of levels per page
  bool canGoNext = false; // Track if next page is available
  int totalLevels = 0; // Track total number of levels available

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Get.lazyPut(() => HomeController());
    homeController = Get.find<HomeController>();

    // Register CrossWordController with lazy loading - it will be created only when first accessed
    Get.lazyPut(() => CrossWordController());

    // Calculate total levels available
    totalLevels = levels[0]["data"].length;

    _loadStars();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadStars();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (ModalRoute.of(context)?.isCurrent == true) {
      _loadStars();
    }
  }

  // Get crossword controller (will be created on first access due to lazyPut)
  CrossWordController _getCrossWordController() {
    if (crossWordController == null) {
      crossWordController = Get.find<CrossWordController>();
      log("CrossWordController accessed for first time");
    }
    return crossWordController!;
  }

  Future<void> _loadStars() async {
    final prefs = await SharedPreferences.getInstance();

    if (mounted) {
      setState(() {
        for (int index = 0; index < levelStars.length; index++) {
          int levelIndex = currentPage * levelsPerPage + index;
          levelStars[index] = prefs.getInt('level_${levelIndex}_stars') ?? 0;
        }
        // Check if all levels in current page are completed (at least 1 star)
        canGoNext = levelStars.every((stars) => stars >= 1);
      });
    }

    log("=== LEVEL DEBUG INFO ===");
    log("Current Page: $currentPage");
    log("Total Levels: $totalLevels");
    log("Loaded stars: $levelStars");
    for (int i = 0; i < levelStars.length; i++) {
      int globalLevelIndex = currentPage * levelsPerPage + i;
      if (globalLevelIndex < totalLevels) {
        log("Level ${globalLevelIndex + 1}: ${levelStars[i]} stars, unlocked: ${await _isLevelUnlocked(i)}");
      }
    }
    log("Can go to next page: $canGoNext");
    log("Has next page: ${_hasNextPage()}");
    log("================##============");
  }

  Future<void> refreshStars() async {
    await _loadStars();
  }

  // Check if there's a next page available
  bool _hasNextPage() {
    return (currentPage + 1) * levelsPerPage < totalLevels;
  }

  // Check if there's a previous page available
  bool _hasPreviousPage() {
    return currentPage > 0;
  }

  Future<bool> _isLevelUnlocked(int levelIndex) async {
    // First level is always unlocked
    if (levelIndex == 0 && currentPage == 0) return true;

    // For first level of subsequent pages, check if last level of previous page is completed
    if (levelIndex == 0 && currentPage > 0) {
      final prefs = await SharedPreferences.getInstance();
      int previousPageLastLevel =
          (currentPage - 1) * levelsPerPage + (levelsPerPage - 1);
      int previousLevelStars =
          prefs.getInt('level_${previousPageLastLevel}_stars') ?? 0;
      return previousLevelStars >= 1;
    }

    // For other levels in the same page, check if previous level is completed
    if (levelIndex > 0) {
      return levelStars[levelIndex - 1] >= 1;
    }

    return false;
  }

  void _goToNextPage() {
    if (_hasNextPage()) {
      setState(() {
        currentPage++;
        levelStars = List.filled(levelsPerPage, 0);
      });
      _loadStars();
      audioController.buttonClick();
    } else {
      // No more levels to show
      audioController.buttonClick();
    }
  }

  void _goToPreviousPage() {
    if (_hasPreviousPage()) {
      setState(() {
        currentPage--;
        levelStars = List.filled(levelsPerPage, 0);
      });
      _loadStars();
      audioController.buttonClick();
    } else {
      // Already at first page
      audioController.buttonClick();
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            decoration: BackgroundImage.buildContainerBackground(
              imagePath: "assets/image/bg_subgames.png",
            ),
            child: Column(
              children: [
                CustomRowWidget(),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: Get.height * 0.02,
                      left: context.isPhone
                          ? Get.height * 0.03
                          : Get.height * 0.02,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            top: Get.height * 0.1,
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Obx(
                              () => Image.asset(
                                homeController.imagePath.value.isNotEmpty
                                    ? homeController.imagePath.value
                                    : "assets/image/pand.png",
                                width: context.isPhone
                                    ? Get.height * 0.45
                                    : Get.height * 0.38,
                                height: Get.height * 0.45,
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: _buildLayout(
                            screenWidth * 0.105,
                            screenHeight * 0.6,
                            screenWidth * 0.02,
                            (Get.context?.isPhone ?? true),
                            !(Get.context?.isPhone ?? true),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLayout(double cardWidth, double cardHeight, double spacing,
      bool isSmallScreen, bool isMediumScreen) {
    return SingleChildScrollView(
      scrollDirection:
          isSmallScreen || isMediumScreen ? Axis.vertical : Axis.horizontal,
      child: Center(
        child: Row(
          children: [
            IconButton(
              icon: Opacity(
                opacity: _hasPreviousPage() ? 1.0 : 0.1,
                child: Image.asset(
                  'assets/image/arrow_back_home.png',
                  width: (Get.context?.isPhone ?? true) ? 20 : 30,
                  height: (Get.context?.isPhone ?? true) ? 20 : 30,
                ),
              ),
              onPressed: _goToPreviousPage,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:
                      _buildLevelRow(0, 5, cardWidth, cardHeight, spacing),
                ),
                SizedBox(height: spacing),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:
                      _buildLevelRow(5, 10, cardWidth, cardHeight, spacing),
                ),
                SizedBox(height: spacing),
                // Add page indicator
                // _buildPageIndicator(),
              ],
            ),
            IconButton(
              icon: Opacity(
                opacity: _hasNextPage() ? 1.0 : 0.1,
                child: Image.asset(
                  'assets/image/arrow_next_home.png',
                  width: (Get.context?.isPhone ?? true) ? 20 : 30,
                  height: (Get.context?.isPhone ?? true) ? 20 : 30,
                ),
              ),
              onPressed: _goToNextPage,
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildLevelRow(int startIndex, int endIndex, double cardWidth,
      double cardHeight, double spacing) {
    return List.generate(endIndex - startIndex, (index) {
      final levelIndex = startIndex + index;
      final globalLevelIndex = currentPage * levelsPerPage + levelIndex;

      // Check if this level exists
      if (globalLevelIndex >= totalLevels) {
        return SizedBox(
            width: cardWidth,
            height: cardHeight); // Empty space for non-existent levels
      }

      final levelData = levels[0]["data"][globalLevelIndex];

      return FutureBuilder<bool>(
        future: _isLevelUnlocked(levelIndex),
        builder: (context, snapshot) {
          final isUnlocked = snapshot.data ?? false;
          final imageAsset = isUnlocked
              ? levelData["result"][0]["image"]
              : "assets/image/lock.png";

          return Row(
            children: [
              _buildGameCard(
                imageAsset: imageAsset,
                gameTitle: "${globalLevelIndex + 1}",
                stars: levelStars[levelIndex],
                isLocked: !isUnlocked,
                onTap: !isUnlocked
                    ? () {
                        audioController.buttonClick();
                        DialogHelperImage.showLevelLockedDialog(
                            context, globalLevelIndex);
                      }
                    : () async {
                        // ONLY NOW initialize and load crossword controller when user actually wants to play
                        try {
                          final controller = _getCrossWordController();

                          // Set the selected level
                          controller.currentLevelIndex.value = globalLevelIndex;
                          controller.currentLevel.value = globalLevelIndex;

                          // Load level data only when user taps to play
                          controller.loadLevel();

                          log("Level $globalLevelIndex loaded for gameplay");

                          // Navigate to crossword game
                          await Get.toNamed('/crossword');

                          // Refresh stars after returning
                          await refreshStars();
                        } catch (e) {
                          log("Error initializing crossword game: $e");
                          // Show error dialog to user
                          Get.snackbar(
                            'Error',
                            'Failed to load level. Please try again.',
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        }
                      },
                width: cardWidth,
                height: cardHeight,
              ),
              if (index < endIndex - startIndex - 1) SizedBox(width: spacing),
            ],
          );
        },
      );
    });
  }

  Widget _buildGameCard({
    required String imageAsset,
    required String gameTitle,
    required int stars,
    required bool isLocked,
    required VoidCallback onTap,
    required double width,
    required double height,
  }) {
    return Column(
      children: [
        GameCard(
          imageAsset: imageAsset,
          gameTitle: gameTitle,
          stars: stars,
          isLocked: isLocked,
          onTap: onTap,
          width: width,
          height: height,
        ),
      ],
    );
  }
}

class GameCard extends StatelessWidget {
  final String imageAsset;
  final String gameTitle;
  final int stars;
  final bool isLocked;
  final double width;
  final double height;
  final VoidCallback? onTap;

  const GameCard({
    super.key,
    required this.imageAsset,
    required this.gameTitle,
    required this.stars,
    required this.isLocked,
    required this.width,
    required this.height,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isPhone = Get.context?.isPhone ?? true;
    final borderRadius = isPhone ? 15.0 : 25.0;
    final padding = MediaQuery.of(context).size.width * (isPhone ? 0.02 : 0.02);
    final lockIconSize = width * (isPhone ? 0.6 : 0.4);

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: width,
            width: width,
            decoration: BoxDecoration(
              image: const DecorationImage(
                image: AssetImage('assets/image/card_level_1.png'),
                fit: BoxFit.fill,
              ),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: Padding(
              padding: EdgeInsets.all(padding),
              child: Column(
                children: [
                  _buildLevelSection(),
                  _buildStarSection(context),
                ],
              ),
            ),
          ),
          if (isLocked)
            Container(
              height: width,
              width: width,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              child: Center(
                child: Image.asset(
                  'assets/image/lock.png',
                  width: lockIconSize,
                  height: lockIconSize,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLevelSection() {
    final paddingValue = width < 50 ? 4.0 : (width < 100 ? 3.0 : 1.0);

    return Expanded(
      flex: 5,
      child: Padding(
        padding: EdgeInsets.all(paddingValue),
        child: Text(
          gameTitle,
          // style: ManagerFontStyles.headerStyleBold,
          style: TextStyle(
            color: Colors.white,
            fontFamily: "PatrickHandSC",
            fontSize: (Get.context?.isPhone ?? true) ? 18 : 25.0,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
        ),
      ),
    );
  }

  Widget _buildStarSection(BuildContext context) {
    double starSize = context.isPhone ? 15 : Get.height * 0.025;

    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(3, (index) {
          return Image.asset(
            index < stars
                ? 'assets/image/level_star.png'
                : 'assets/image/level_star_empty.png',
            width: starSize,
            height: starSize,
          );
        }),
      ),
    );
  }
}
