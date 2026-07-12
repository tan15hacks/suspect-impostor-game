import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:suspect_impostor_game/game_engine.dart';

void main() {
  group('player validation', () {
    test('requires at least three unique names', () {
      expect(GameEngine.validatePlayerNames(['A', 'B']), isNotNull);
      expect(GameEngine.validatePlayerNames(['A', 'B', 'a']), isNotNull);
      expect(GameEngine.validatePlayerNames(['A', 'B', 'C']), isNull);
    });
  });

  group('classic role assignment', () {
    test('assigns exactly one impostor', () {
      const players = [
        PartyPlayer(id: 'a', name: 'A'),
        PartyPlayer(id: 'b', name: 'B'),
        PartyPlayer(id: 'c', name: 'C'),
        PartyPlayer(id: 'd', name: 'D'),
      ];
      final assignment = GameEngine.assignClassicRoles(
        players: players,
        secretWord: 'Jeepney',
        random: Random(8),
      );
      expect(
        assignment.players
            .where((player) => player.role == PlayerRole.impostor)
            .length,
        1,
      );
      expect(
        assignment.players
            .where((player) => player.role == PlayerRole.civilian)
            .length,
        3,
      );
    });
  });

  group('voting', () {
    test('finds a single leader', () {
      final result = GameEngine.countVotes({
        'a': 'c',
        'b': 'c',
        'c': 'a',
      });
      expect(result.isTie, isFalse);
      expect(result.leaders, ['c']);
      expect(result.counts['c'], 2);
    });

    test('reports ties without losing candidates', () {
      final result = GameEngine.countVotes({
        'a': 'b',
        'b': 'a',
        'c': 'a',
        'd': 'b',
      });
      expect(result.isTie, isTrue);
      expect(result.leaders, ['a', 'b']);
    });
  });

  group('secret word guessing', () {
    test('normalizes capitalization, spaces, and punctuation', () {
      expect(GameEngine.isCorrectGuess('  Halo-Halo! ', 'halo-halo'), isTrue);
      expect(GameEngine.isCorrectGuess('Halo halo', 'halo-halo'), isFalse);
    });
  });

  group('scoring', () {
    test('awards civilian victory and correct-vote points', () {
      const players = [
        PartyPlayer(id: 'a', name: 'A', role: PlayerRole.civilian),
        PartyPlayer(id: 'b', name: 'B', role: PlayerRole.civilian),
        PartyPlayer(id: 'c', name: 'C', role: PlayerRole.impostor),
      ];
      final score = GameEngine.scoreClassicRound(
        players: players,
        winner: WinnerSide.civilians,
        impostorId: 'c',
        votes: const {'a': 'c', 'b': 'c', 'c': 'a'},
        eliminatedId: 'c',
        impostorGuessedWord: false,
      );
      expect(score.updatedPlayers.first.score, 4);
      expect(score.updatedPlayers[1].score, 4);
      expect(score.updatedPlayers[2].score, 0);
    });
  });
}
