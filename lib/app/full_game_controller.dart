import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/custom_pack.dart';

class FullGameController extends ChangeNotifier {
  FullGameController({SharedPreferencesAsync? preferences})
      : _preferences = preferences ?? SharedPreferencesAsync();

  static const _displayNameKey = 'profile.displayName';
  static const _languageKey = 'settings.language';
  static const _coinsKey = 'profile.coins';
  static const _familySafeKey = 'settings.familySafe';
  static const _reducedMotionKey = 'settings.reducedMotion';
  static const _highContrastKey = 'settings.highContrast';
  static const _hapticsKey = 'settings.haptics';
  static const _timerSoundsKey = 'settings.timerSounds';
  static const _confirmLeavingKey = 'settings.confirmBeforeLeaving';
  static const _textScaleKey = 'settings.textScale';
  static const _customPacksKey = 'content.customPacks';
  static const _achievementsKey = 'profile.unlockedAchievements';

  final SharedPreferencesAsync _preferences;

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
  bool hasLoadedLocalState = false;

  final List<CustomWordPack> _customPacks = [];
  final Set<String> _unlockedAchievements = {};

  List<CustomWordPack> get customPacks => List.unmodifiable(_customPacks);
  Set<String> get unlockedAchievements => Set.unmodifiable(_unlockedAchievements);

  Future<void> loadFromStorage() async {
    displayName = await _preferences.getString(_displayNameKey) ?? displayName;
    language = await _preferences.getString(_languageKey) ?? language;
    coins = await _preferences.getInt(_coinsKey) ?? coins;
    familySafe = await _preferences.getBool(_familySafeKey) ?? familySafe;
    reducedMotion =
        await _preferences.getBool(_reducedMotionKey) ?? reducedMotion;
    highContrast = await _preferences.getBool(_highContrastKey) ?? highContrast;
    haptics = await _preferences.getBool(_hapticsKey) ?? haptics;
    timerSounds = await _preferences.getBool(_timerSoundsKey) ?? timerSounds;
    confirmBeforeLeaving =
        await _preferences.getBool(_confirmLeavingKey) ?? confirmBeforeLeaving;
    textScale = (await _preferences.getDouble(_textScaleKey) ?? textScale)
        .clamp(0.9, 1.35)
        .toDouble();

    _customPacks.clear();
    final encodedPacks =
        await _preferences.getStringList(_customPacksKey) ?? const <String>[];
    for (final encoded in encodedPacks) {
      try {
        final pack = CustomWordPack.fromJsonString(encoded);
        if (CustomPackValidator.validate(pack).isValid) {
          _customPacks.add(pack);
        }
      } on FormatException {
        // Corrupted user content is ignored instead of breaking app startup.
      }
    }

    _unlockedAchievements
      ..clear()
      ..addAll(
        await _preferences.getStringList(_achievementsKey) ?? const <String>[],
      );
    hasLoadedLocalState = true;
    notifyListeners();
  }

  void updateDisplayName(String value) {
    final cleaned = value.trim();
    if (cleaned.isEmpty || cleaned == displayName) {
      return;
    }
    displayName = cleaned;
    notifyListeners();
    unawaited(_preferences.setString(_displayNameKey, displayName));
  }

  void updateLanguage(String value) {
    if (value == language) {
      return;
    }
    language = value;
    notifyListeners();
    unawaited(_preferences.setString(_languageKey, language));
  }

  void updateFamilySafe(bool value) {
    familySafe = value;
    notifyListeners();
    unawaited(_preferences.setBool(_familySafeKey, familySafe));
  }

  void updateReducedMotion(bool value) {
    reducedMotion = value;
    notifyListeners();
    unawaited(_preferences.setBool(_reducedMotionKey, reducedMotion));
  }

  void updateHighContrast(bool value) {
    highContrast = value;
    notifyListeners();
    unawaited(_preferences.setBool(_highContrastKey, highContrast));
  }

  void updateHaptics(bool value) {
    haptics = value;
    notifyListeners();
    unawaited(_preferences.setBool(_hapticsKey, haptics));
  }

  void updateTimerSounds(bool value) {
    timerSounds = value;
    notifyListeners();
    unawaited(_preferences.setBool(_timerSoundsKey, timerSounds));
  }

  void updateConfirmBeforeLeaving(bool value) {
    confirmBeforeLeaving = value;
    notifyListeners();
    unawaited(_preferences.setBool(_confirmLeavingKey, confirmBeforeLeaving));
  }

  void updateTextScale(double value) {
    textScale = value.clamp(0.9, 1.35).toDouble();
    notifyListeners();
    unawaited(_preferences.setDouble(_textScaleKey, textScale));
  }

  void savePack(CustomWordPack pack) {
    final validation = CustomPackValidator.validate(pack);
    if (!validation.isValid) {
      throw ArgumentError('Only valid custom packs can be saved.');
    }
    final index = _customPacks.indexWhere((item) => item.id == pack.id);
    if (index == -1) {
      _customPacks.add(pack);
    } else {
      _customPacks[index] = pack;
    }
    notifyListeners();
    _persistCustomPacks();
  }

  void deletePack(String id) {
    _customPacks.removeWhere((pack) => pack.id == id);
    notifyListeners();
    _persistCustomPacks();
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
    _persistCustomPacks();
  }

  void setAchievementUnlocked(String id, bool unlocked) {
    if (unlocked) {
      _unlockedAchievements.add(id);
    } else {
      _unlockedAchievements.remove(id);
    }
    notifyListeners();
    unawaited(
      _preferences.setStringList(
        _achievementsKey,
        _unlockedAchievements.toList(growable: false),
      ),
    );
  }

  void _persistCustomPacks() {
    unawaited(
      _preferences.setStringList(
        _customPacksKey,
        _customPacks
            .map((pack) => pack.toPrettyJson())
            .toList(growable: false),
      ),
    );
  }
}
