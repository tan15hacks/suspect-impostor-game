import 'dart:math';

enum GameMode {
  classic,
  twoSimilarWords,
  questionInterrogation,
  emojiClues,
  speedRound,
  anonymousClues,
  multipleImpostors,
  oneSentenceStory,
}

enum AdvancedRole {
  civilian,
  impostor,
  mimic,
  doubleAgent,
  mrBlank,
  saboteur,
  trickster,
}

enum VoteConfidence { slightlySuspicious, verySuspicious, certain }

enum TieBreakerType { extraClue, shortAnswer, tenSecondDefense, secondVote }

class RoleConfiguration {
  const RoleConfiguration({
    required this.playerCount,
    required this.impostorCount,
    required this.gameMode,
    required this.enabledRoles,
  });

  final int playerCount;
  final int impostorCount;
  final GameMode gameMode;
  final Set<AdvancedRole> enabledRoles;
}

class AdvancedAssignment {
  const AdvancedAssignment({
    required this.rolesByPlayerId,
    required this.impostorSideIds,
  });

  final Map<String, AdvancedRole> rolesByPlayerId;
  final Set<String> impostorSideIds;
}

class ConfidenceScore {
  const ConfidenceScore({required this.correctPoints, required this.wrongPenalty});

  final int correctPoints;
  final int wrongPenalty;
}

class AdvancedRules {
  const AdvancedRules._();

  static String? validateConfiguration(RoleConfiguration configuration) {
    if (configuration.playerCount < 3 || configuration.playerCount > 12) {
      return 'Player count must be between 3 and 12.';
    }
    if (configuration.impostorCount < 1) {
      return 'At least one impostor-side player is required.';
    }
    final maximumFairImpostors = configuration.gameMode == GameMode.multipleImpostors
        ? max(1, (configuration.playerCount - 1) ~/ 3)
        : 1;
    if (configuration.impostorCount > maximumFairImpostors) {
      return 'This impostor count is not balanced for the selected player count.';
    }
    if (configuration.gameMode == GameMode.twoSimilarWords &&
        configuration.enabledRoles.contains(AdvancedRole.mimic)) {
      return 'Mimic is not compatible with Two Similar Words mode.';
    }
    if (configuration.gameMode == GameMode.emojiClues &&
        configuration.enabledRoles.contains(AdvancedRole.mimic)) {
      return 'Mimic is disabled in Emoji Clues because seeing the first clue is too strong.';
    }
    if (configuration.enabledRoles.contains(AdvancedRole.saboteur) &&
        configuration.gameMode != GameMode.twoSimilarWords) {
      return 'Saboteur requires Two Similar Words mode.';
    }
    if (configuration.enabledRoles.contains(AdvancedRole.doubleAgent) &&
        configuration.playerCount < 6) {
      return 'Double Agent requires at least 6 players.';
    }
    if (configuration.enabledRoles.contains(AdvancedRole.trickster) &&
        configuration.playerCount < 5) {
      return 'Trickster requires at least 5 players.';
    }
    return null;
  }

  static AdvancedAssignment assignRoles({
    required List<String> playerIds,
    required RoleConfiguration configuration,
    Random? random,
  }) {
    final error = validateConfiguration(configuration);
    if (error != null) {
      throw ArgumentError(error);
    }
    if (playerIds.length != configuration.playerCount) {
      throw ArgumentError('Player IDs do not match the configured player count.');
    }
    final uniqueIds = playerIds.toSet();
    if (uniqueIds.length != playerIds.length) {
      throw ArgumentError('Player IDs must be unique.');
    }

    final rng = random ?? Random.secure();
    final shuffled = [...playerIds]..shuffle(rng);
    final roles = <String, AdvancedRole>{};
    final impostorSide = <String>{};
    var cursor = 0;

    void assignOne(AdvancedRole role, {required bool impostorAligned}) {
      if (cursor >= shuffled.length) {
        return;
      }
      final id = shuffled[cursor++];
      roles[id] = role;
      if (impostorAligned) {
        impostorSide.add(id);
      }
    }

    final enabled = configuration.enabledRoles;
    if (enabled.contains(AdvancedRole.doubleAgent)) {
      assignOne(AdvancedRole.doubleAgent, impostorAligned: true);
    }
    if (enabled.contains(AdvancedRole.saboteur)) {
      assignOne(AdvancedRole.saboteur, impostorAligned: true);
    }
    if (enabled.contains(AdvancedRole.mimic)) {
      assignOne(AdvancedRole.mimic, impostorAligned: true);
    }
    if (enabled.contains(AdvancedRole.mrBlank)) {
      assignOne(AdvancedRole.mrBlank, impostorAligned: true);
    }

    while (impostorSide.length < configuration.impostorCount) {
      assignOne(AdvancedRole.impostor, impostorAligned: true);
    }

    if (enabled.contains(AdvancedRole.trickster) && cursor < shuffled.length) {
      assignOne(AdvancedRole.trickster, impostorAligned: false);
    }

    while (cursor < shuffled.length) {
      assignOne(AdvancedRole.civilian, impostorAligned: false);
    }

    return AdvancedAssignment(
      rolesByPlayerId: Map.unmodifiable(roles),
      impostorSideIds: Set.unmodifiable(impostorSide),
    );
  }

  static ConfidenceScore confidenceScore(VoteConfidence confidence) {
    switch (confidence) {
      case VoteConfidence.slightlySuspicious:
        return const ConfidenceScore(correctPoints: 1, wrongPenalty: 0);
      case VoteConfidence.verySuspicious:
        return const ConfidenceScore(correctPoints: 2, wrongPenalty: 1);
      case VoteConfidence.certain:
        return const ConfidenceScore(correctPoints: 3, wrongPenalty: 2);
    }
  }

  static bool isEmojiOnly(String clue) {
    final trimmed = clue.trim();
    if (trimmed.isEmpty) {
      return false;
    }
    final withoutWhitespace = trimmed.replaceAll(RegExp(r'\s+'), '');
    final ordinaryText = RegExp(r'[A-Za-z0-9]').hasMatch(withoutWhitespace);
    return !ordinaryText;
  }

  static int maximumImpostorsFor(int playerCount) {
    if (playerCount < 3) {
      return 0;
    }
    return max(1, (playerCount - 1) ~/ 3);
  }

  static bool hasCivilianTeamWon({
    required Set<String> survivingPlayerIds,
    required Set<String> impostorSideIds,
  }) {
    return survivingPlayerIds.intersection(impostorSideIds).isEmpty;
  }

  static bool hasImpostorTeamWon({
    required Set<String> survivingPlayerIds,
    required Set<String> impostorSideIds,
  }) {
    final survivingImpostors = survivingPlayerIds.intersection(impostorSideIds).length;
    final survivingOthers = survivingPlayerIds.length - survivingImpostors;
    return survivingImpostors > 0 && survivingImpostors >= survivingOthers;
  }
}
