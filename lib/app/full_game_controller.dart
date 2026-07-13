import 'package:flutter/foundation.dart';

import '../domain/custom_pack.dart';

class FullGameController extends ChangeNotifier {
  String displayName = 'Guest Detective';
  String language = 'English';
  int coins = 0;
  bool familySafe = true;
  bool reducedMotion = false;
  bool highContrast = false;
  bool haptics = true;
  bool timerSounds = true;
  bool confirmBeforeLeaving = true;
  double textScale = 1.0;

  final List<CustomWordPack> _customPacks = [];
  final Set<String> _unlockedAchievements = {};

  List<CustomWordPack> get customPacks => List.unmodifiable(_customPacks);
  Set<String> get unlockedAchievements => Set.unmodifiable(_unlockedAchievements);

  void updateDisplayName(String value) {
    final cleaned = value.trim();
    if (cleaned.isEmpty || cleaned == displayName) {
      return;
    }
    displayName = cleaned;
    notifyListeners();
  }

  void updateLanguage(String value) {
    if (value == language) {
      return;
    }
    language = value;
    notifyListeners();
  }

  void updateFamilySafe(bool value) {
    familySafe = value;
    notifyListeners();
  }

  void updateReducedMotion(bool value) {
    reducedMotion = value;
    notifyListeners();
  }

  void updateHighContrast(bool value) {
    highContrast = value;
    notifyListeners();
  }

  void updateHaptics(bool value) {
    haptics = value;
    notifyListeners();
  }

  void updateTimerSounds(bool value) {
    timerSounds = value;
    notifyListeners();
  }

  void updateConfirmBeforeLeaving(bool value) {
    confirmBeforeLeaving = value;
    notifyListeners();
  }

  void updateTextScale(double value) {
    textScale = value.clamp(0.9, 1.35).toDouble();
    notifyListeners();
  }

  void savePack(CustomWordPack pack) {
    final index = _customPacks.indexWhere((item) => item.id == pack.id);
    if (index == -1) {
      _customPacks.add(pack);
    } else {
      _customPacks[index] = pack;
    }
    notifyListeners();
  }

  void deletePack(String id) {
    _customPacks.removeWhere((pack) => pack.id == id);
    notifyListeners();
  }

  void duplicatePack(String id) {
    final source = _customPacks.firstWhere((pack) => pack.id == id);
    final copyId = '${source.id}-copy-${DateTime.now().millisecondsSinceEpoch}';
    final copy = CustomWordPack(
      id: copyId,
      name: '${source.name} Copy',
      language: source.language,
      familySafe: source.familySafe,
      colorValue: source.colorValue,
      iconCodePoint: source.iconCodePoint,
      words: [
        for (var index = 0; index < source.words.length; index++)
          CustomWordEntry(
            id: '$copyId-word-$index',
            word: source.words[index].word,
            alternateWord: source.words[index].alternateWord,
            enabled: source.words[index].enabled,
          ),
      ],
      enabled: source.enabled,
    );
    _customPacks.add(copy);
    notifyListeners();
  }

  void setAchievementUnlocked(String id, bool unlocked) {
    if (unlocked) {
      _unlockedAchievements.add(id);
    } else {
      _unlockedAchievements.remove(id);
    }
    notifyListeners();
  }
}
