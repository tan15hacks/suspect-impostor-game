import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:suspect_impostor_game/data/achievements.dart';
import 'package:suspect_impostor_game/data/curated_party_content.dart';
import 'package:suspect_impostor_game/domain/advanced_rules.dart';
import 'package:suspect_impostor_game/domain/custom_pack.dart';

void main() {
  group('advanced role configuration', () {
    test('rejects unfair impostor counts', () {
      const configuration = RoleConfiguration(
        playerCount: 6,
        impostorCount: 3,
        gameMode: GameMode.multipleImpostors,
        enabledRoles: {},
      );
      expect(AdvancedRules.validateConfiguration(configuration), isNotNull);
    });

    test('rejects incompatible role and mode combinations', () {
      const configuration = RoleConfiguration(
        playerCount: 6,
        impostorCount: 1,
        gameMode: GameMode.classic,
        enabledRoles: {AdvancedRole.saboteur},
      );
      expect(AdvancedRules.validateConfiguration(configuration), contains('Saboteur'));
    });

    test('assigns requested aligned roles without duplicate players', () {
      const configuration = RoleConfiguration(
        playerCount: 8,
        impostorCount: 2,
        gameMode: GameMode.multipleImpostors,
        enabledRoles: {AdvancedRole.mimic, AdvancedRole.trickster},
      );
      final assignment = AdvancedRules.assignRoles(
        playerIds: List.generate(8, (index) => 'p$index'),
        configuration: configuration,
        random: Random(4),
      );
      expect(assignment.rolesByPlayerId.length, 8);
      expect(assignment.impostorSideIds.length, 2);
      expect(
        assignment.rolesByPlayerId.values.where((role) => role == AdvancedRole.mimic),
        hasLength(1),
      );
      expect(
        assignment.rolesByPlayerId.values.where((role) => role == AdvancedRole.trickster),
        hasLength(1),
      );
    });
  });

  group('mode rules', () {
    test('validates emoji-only clues', () {
      expect(AdvancedRules.isEmojiOnly('🌧️☔'), isTrue);
      expect(AdvancedRules.isEmojiOnly('rain ☔'), isFalse);
      expect(AdvancedRules.isEmojiOnly('   '), isFalse);
    });

    test('uses transparent confidence scoring', () {
      expect(
        AdvancedRules.confidenceScore(VoteConfidence.certain).correctPoints,
        3,
      );
      expect(
        AdvancedRules.confidenceScore(VoteConfidence.certain).wrongPenalty,
        2,
      );
    });
  });

  group('curated content', () {
    test('ships the required mission and chaos-card totals', () {
      expect(secretMissions.length, greaterThanOrEqualTo(60));
      expect(chaosCards.length, greaterThanOrEqualTo(40));
      expect(achievements.length, greaterThanOrEqualTo(40));
    });

    test('filters incompatible chaos cards', () {
      final cards = compatibleChaosCards(
        playerCount: 3,
        mode: GameMode.emojiClues,
      );
      expect(cards, isNotEmpty);
      expect(cards.every((card) => card.compatibleModes.contains(GameMode.emojiClues)), isTrue);
      expect(cards.any((card) => card.id == 'chaos_double_clue'), isFalse);
    });

    test('achievement evaluation returns only new unlocks', () {
      final evaluation = evaluateAchievements(
        metrics: const {'gamesPlayed': 1, 'roundWins': 1},
        alreadyUnlocked: const {'first_game'},
      );
      expect(evaluation.newlyUnlocked.map((item) => item.id), contains('first_win'));
      expect(evaluation.newlyUnlocked.map((item) => item.id), isNot(contains('first_game')));
    });
  });

  group('custom packs', () {
    test('imports plain text and removes duplicates', () {
      final words = CustomPackValidator.importPlainText('''
Adobo
Sinigang | Nilaga
adobo
# ignored note
Jeepney | Bus
''');
      expect(words, hasLength(3));
      expect(words[1].alternateWord, 'Nilaga');
    });

    test('reports duplicate words and self-pairs', () {
      const pack = CustomWordPack(
        id: 'pack-1',
        name: 'My Pack',
        language: 'fil',
        familySafe: true,
        colorValue: 0xFF6D5DFB,
        iconCodePoint: 0xe40a,
        words: [
          CustomWordEntry(id: '1', word: 'Adobo', alternateWord: 'Adobo'),
          CustomWordEntry(id: '2', word: 'adobo'),
          CustomWordEntry(id: '3', word: 'Sinigang'),
          CustomWordEntry(id: '4', word: 'Jeepney'),
          CustomWordEntry(id: '5', word: 'Taho'),
          CustomWordEntry(id: '6', word: 'Fiesta'),
        ],
      );
      final result = CustomPackValidator.validate(pack);
      expect(result.isValid, isFalse);
      expect(result.issues.map((issue) => issue.code), contains('self_pair'));
      expect(result.issues.map((issue) => issue.code), contains('duplicate_word'));
    });

    test('round-trips JSON export', () {
      const pack = CustomWordPack(
        id: 'pack-1',
        name: 'Party Food',
        language: 'en',
        familySafe: true,
        colorValue: 0xFF6D5DFB,
        iconCodePoint: 0xe40a,
        words: [
          CustomWordEntry(id: '1', word: 'Pizza'),
          CustomWordEntry(id: '2', word: 'Burger'),
          CustomWordEntry(id: '3', word: 'Taco'),
          CustomWordEntry(id: '4', word: 'Pasta'),
          CustomWordEntry(id: '5', word: 'Donut'),
          CustomWordEntry(id: '6', word: 'Popcorn'),
        ],
      );
      final restored = CustomWordPack.fromJsonString(pack.toPrettyJson());
      expect(restored.name, pack.name);
      expect(restored.words.length, pack.words.length);
    });
  });
}
