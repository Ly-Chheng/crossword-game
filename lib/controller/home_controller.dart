import 'dart:developer';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends GetxController {
  final RxString imagePath = "".obs;

  List<Map<String, dynamic>> animals = [
    {
      "id": 1,
      "title": "PANDA",
      "image": "assets/image/beltei_panda.png",
    },
    {
      "id": 2,
      "title": "BEAR",
      "image": "assets/image/beltei_bear.png",
    },
    {
      "id": 3,
      "title": "ELEPHANT",
      "image": "assets/image/beltei_elephant.png",
    },
    {
      "id": 4,
      "title": "RABBIT",
      "image": "assets/image/beltei_rabbit.png",
    },
  ];

  @override
  void onInit() async {
    super.onInit();
    await _loadCharacters();
    imagePath.value = animals.first['image'];
  }

  Future<void> _loadCharacters() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      for (var animal in animals) {
        final id = animal['id'] as int;
        final character = prefs.getString('character_$id');
        if (character != null) {
          animal['character'] = character;
          log("Loaded character for ID $id: $character");
        }
      }
      update();
    } catch (e) {
      log("Error loading characters: $e");
    }
  }

  void updateAnimalImageById(int id, String newPath) {
    final index = animals.indexWhere((e) => e["id"] == id);
    if (index != -1) {
      animals[index]["image"] = newPath;
      update();
    }
  }

  Future<void> storeCharacter(int id, String character) async {
    try {
      final index = animals.indexWhere((e) => e["id"] == id);
      if (index != -1) {
        animals[index]["character"] = character;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('character_$id', character);
        log("Stored character for ID $id: $character");
        update();
      } else {
        log("Animal with ID $id not found");
      }
    } catch (e) {
      log("Error storing character: $e");
    }
  }
}