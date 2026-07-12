import 'dart:math';

enum PlayerRole { civilian, impostor }

enum WinnerSide { civilians, impostor }

class PartyPlayer {
  const PartyPlayer({
    required this.id,
    required this.name,
    this.score = 0,
    this.role,
  });

  final String id;
  final String name;
  final int score;
  final PlayerRole? role;

  PartyPlayer copyWith({
    String? id,
    String? name,
    int? score,
    PlayerRole? role,
    bool clearRole = false,
  }) {
    return PartyPlayer(
      id: id ?? this.id,
      name: name ?? this.name,
      score: score ?? this.score,
      role: clearRole ? null : role ?? this.role,
    );
  }
}

class RoundAssignment {
  const RoundAssignment({
    required this.players,
    required this.secretWord,
    required this.impostorId,
  });

  final List<PartyPlayer> players;
  final String secretWord;
  final String impostorId;
}

class VoteResult {
  const VoteResult({
    required this.counts,
    required this.leaders,
  });

  final Map<String, int> counts;
  final List<String> leaders;

  bool get isTie => leaders.length > 1;
}

class RoundScore {
  const RoundScore({
    required this.updatedPlayers,
    required this.breakdown,
  });

  final List<PartyPlayer> updatedPlayers;
  final Map<String, List<String>> breakdown;
}

class GameEngine {
  const GameEngine._();

  static String? validatePlayerNames(List<String> names) {
    final cleaned = names.map((name) => name.trim()).toList(growable: false);
    if (cleaned.length < 3) {
      return 'Add at least 3 players.';
    }
    if (cleaned.length > 12) {
      return 'A party can have at most 12 players.';
    }
    if (cleaned.any((name) => name.isEmpty)) {
      return 'Every player needs a name.';
    }
    if (cleaned.any((name) => name.length > 18)) {
      return 'Player names must be 18 characters or fewer.';
    }
    final normalized = cleaned.map((name) => name.toLowerCase()).toSet();
    if (normalized.length != cleaned.length) {
      return 'Player names must be unique.';
    }
    return null;
  }

  static RoundAssignment assignClassicRoles({
    required List<PartyPlayer> players,
    required String secretWord,
    Random? random,
  }) {
    if (players.length < 3) {
      throw ArgumentError.value(players.length, 'players', 'At least 3 required');
    }
    final rng = random ?? Random.secure();
    final impostorIndex = rng.nextInt(players.length);
    final assigned = <PartyPlayer>[];
    for (var index = 0; index < players.length; index++) {
      assigned.add(
        players[index].copyWith(
          role: index == impostorIndex
              ? PlayerRole.impostor
              : PlayerRole.civilian,
        ),
      );
    }
    return RoundAssignment(
      players: List.unmodifiable(assigned),
      secretWord: secretWord,
      impostorId: assigned[impostorIndex].id,
    );
  }

  static VoteResult countVotes(
    Map<String, String> votes, {
    Set<String>? allowedTargets,
  }) {
    final counts = <String, int>{};
    for (final target in votes.values) {
      if (allowedTargets != null && !allowedTargets.contains(target)) {
        continue;
      }
      counts.update(target, (value) => value + 1, ifAbsent: () => 1);
    }
    if (counts.isEmpty) {
      return const VoteResult(counts: {}, leaders: []);
    }
    final highest = counts.values.reduce(max);
    final leaders = counts.entries
        .where((entry) => entry.value == highest)
        .map((entry) => entry.key)
        .toList(growable: false)
      ..sort();
    return VoteResult(
      counts: Map.unmodifiable(counts),
      leaders: List.unmodifiable(leaders),
    );
  }

  static RoundScore scoreClassicRound({
    required List<PartyPlayer> players,
    required WinnerSide winner,
    required String impostorId,
    required Map<String, String> votes,
    required String eliminatedId,
    required bool impostorGuessedWord,
  }) {
    final breakdown = <String, List<String>>{};
    final updated = <PartyPlayer>[];

    for (final player in players) {
      var earned = 0;
      final details = <String>[];
      final isImpostor = player.id == impostorId;

      if (!isImpostor && winner == WinnerSide.civilians) {
        earned += 3;
        details.add('+3 civilian team victory');
      }
      if (isImpostor && winner == WinnerSide.impostor) {
        earned += 5;
        details.add('+5 impostor victory');
      }
      if (!isImpostor && votes[player.id] == impostorId) {
        earned += 1;
        details.add('+1 correct vote');
      }
      if (isImpostor && eliminatedId != impostorId) {
        earned += 2;
        details.add('+2 survived the vote');
      }
      if (isImpostor && impostorGuessedWord) {
        earned += 3;
        details.add('+3 correct secret-word guess');
      }
      if (details.isEmpty) {
        details.add('+0 this round');
      }

      breakdown[player.id] = List.unmodifiable(details);
      updated.add(player.copyWith(score: player.score + earned));
    }

    return RoundScore(
      updatedPlayers: List.unmodifiable(updated),
      breakdown: Map.unmodifiable(breakdown),
    );
  }

  static String normalizeGuess(String value) {
    return value
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9\s-]'), '')
        .replaceAll(RegExp(r'\s+'), ' ');
  }

  static bool isCorrectGuess(String guess, String secretWord) {
    return normalizeGuess(guess) == normalizeGuess(secretWord);
  }
}
