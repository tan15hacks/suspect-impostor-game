class AchievementDefinition {
  const AchievementDefinition({
    required this.id,
    required this.name,
    required this.description,
    required this.metric,
    required this.requirement,
    required this.coinReward,
    this.hidden = false,
  });

  final String id;
  final String name;
  final String description;
  final String metric;
  final int requirement;
  final int coinReward;
  final bool hidden;
}

const achievements = <AchievementDefinition>[
  AchievementDefinition(id: 'first_game', name: 'First Suspicion', description: 'Finish your first game.', metric: 'gamesPlayed', requirement: 1, coinReward: 25),
  AchievementDefinition(id: 'first_win', name: 'Case Closed', description: 'Win your first round.', metric: 'roundWins', requirement: 1, coinReward: 30),
  AchievementDefinition(id: 'impostor_survivor', name: 'Perfect Bluff', description: 'Survive a round as an impostor.', metric: 'impostorSurvivals', requirement: 1, coinReward: 40),
  AchievementDefinition(id: 'no_votes', name: 'Invisible Suspect', description: 'Win as an impostor without receiving a vote.', metric: 'zeroVoteImpostorWins', requirement: 1, coinReward: 60),
  AchievementDefinition(id: 'five_correct_votes', name: 'Human Lie Detector', description: 'Correctly identify five impostors.', metric: 'correctVotes', requirement: 5, coinReward: 50),
  AchievementDefinition(id: 'twenty_correct_votes', name: 'Senior Detective', description: 'Cast twenty correct votes.', metric: 'correctVotes', requirement: 20, coinReward: 100),
  AchievementDefinition(id: 'falsely_accused_three', name: 'Wrongfully Suspected', description: 'Be falsely accused three times.', metric: 'falseAccusationsReceived', requirement: 3, coinReward: 40),
  AchievementDefinition(id: 'missions_ten', name: 'Secret Operative', description: 'Complete ten secret missions.', metric: 'missionsCompleted', requirement: 10, coinReward: 80),
  AchievementDefinition(id: 'missions_fifty', name: 'Mission Specialist', description: 'Complete fifty secret missions.', metric: 'missionsCompleted', requirement: 50, coinReward: 180),
  AchievementDefinition(id: 'cause_tie', name: 'Deadlock', description: 'Cause a tied first vote.', metric: 'tiesCaused', requirement: 1, coinReward: 35),
  AchievementDefinition(id: 'mr_blank_win', name: 'Blank but Brilliant', description: 'Win as Mr. Blank.', metric: 'mrBlankWins', requirement: 1, coinReward: 70),
  AchievementDefinition(id: 'saboteur_win', name: 'Double Meaning', description: 'Win as the Saboteur.', metric: 'saboteurWins', requirement: 1, coinReward: 70),
  AchievementDefinition(id: 'mimic_win', name: 'Quick Study', description: 'Win as the Mimic.', metric: 'mimicWins', requirement: 1, coinReward: 70),
  AchievementDefinition(id: 'double_agent_win', name: 'Inside Job', description: 'Win as the Double Agent.', metric: 'doubleAgentWins', requirement: 1, coinReward: 75),
  AchievementDefinition(id: 'trickster_win', name: 'Exactly as Planned', description: 'Complete the Trickster win condition.', metric: 'tricksterWins', requirement: 1, coinReward: 90, hidden: true),
  AchievementDefinition(id: 'all_free_categories', name: 'Category Tourist', description: 'Play every free category.', metric: 'freeCategoriesPlayed', requirement: 8, coinReward: 80),
  AchievementDefinition(id: 'create_pack', name: 'Pack Creator', description: 'Create a valid custom word pack.', metric: 'customPacksCreated', requirement: 1, coinReward: 40),
  AchievementDefinition(id: 'create_three_packs', name: 'Content Curator', description: 'Create three valid custom word packs.', metric: 'customPacksCreated', requirement: 3, coinReward: 90),
  AchievementDefinition(id: 'ten_round_session', name: 'Party Marathon', description: 'Finish a ten-round session.', metric: 'tenRoundSessions', requirement: 1, coinReward: 100),
  AchievementDefinition(id: 'eight_players', name: 'Full House', description: 'Play with eight or more players.', metric: 'largePartySessions', requirement: 1, coinReward: 60),
  AchievementDefinition(id: 'three_streak', name: 'On a Roll', description: 'Win three rounds consecutively.', metric: 'bestWinStreak', requirement: 3, coinReward: 60),
  AchievementDefinition(id: 'five_streak', name: 'Unstoppable', description: 'Win five rounds consecutively.', metric: 'bestWinStreak', requirement: 5, coinReward: 120),
  AchievementDefinition(id: 'correct_certain', name: 'Absolutely Certain', description: 'Cast a correct “Certain” confidence vote.', metric: 'correctCertainVotes', requirement: 1, coinReward: 35),
  AchievementDefinition(id: 'wrong_certain_five', name: 'Confidently Incorrect', description: 'Cast five incorrect “Certain” votes.', metric: 'wrongCertainVotes', requirement: 5, coinReward: 30, hidden: true),
  AchievementDefinition(id: 'secret_guess', name: 'Last-Second Theft', description: 'Guess the secret word after elimination.', metric: 'successfulImpostorGuesses', requirement: 1, coinReward: 60),
  AchievementDefinition(id: 'secret_guess_five', name: 'Mind Reader', description: 'Guess five secret words after elimination.', metric: 'successfulImpostorGuesses', requirement: 5, coinReward: 140),
  AchievementDefinition(id: 'anonymous_win', name: 'Hidden Hand', description: 'Win an Anonymous Clues round.', metric: 'anonymousClueWins', requirement: 1, coinReward: 45),
  AchievementDefinition(id: 'emoji_win', name: 'Emoji Detective', description: 'Win an Emoji Clues round.', metric: 'emojiWins', requirement: 1, coinReward: 45),
  AchievementDefinition(id: 'story_win', name: 'Suspicious Storyteller', description: 'Win a One-Sentence Story round.', metric: 'storyWins', requirement: 1, coinReward: 45),
  AchievementDefinition(id: 'speed_win', name: 'Fast Thinker', description: 'Win a Speed Round.', metric: 'speedWins', requirement: 1, coinReward: 45),
  AchievementDefinition(id: 'question_win', name: 'Interrogator', description: 'Win a Question Interrogation round.', metric: 'questionWins', requirement: 1, coinReward: 45),
  AchievementDefinition(id: 'chaos_ten', name: 'Chaos Regular', description: 'Complete ten rounds with chaos cards.', metric: 'chaosRoundsPlayed', requirement: 10, coinReward: 70),
  AchievementDefinition(id: 'chaos_fifty', name: 'Chaos Magnet', description: 'Complete fifty rounds with chaos cards.', metric: 'chaosRoundsPlayed', requirement: 50, coinReward: 160),
  AchievementDefinition(id: 'civilian_ten', name: 'Trusted Civilian', description: 'Win ten rounds on the civilian side.', metric: 'civilianWins', requirement: 10, coinReward: 100),
  AchievementDefinition(id: 'impostor_ten', name: 'Master Manipulator', description: 'Win ten rounds on the impostor side.', metric: 'impostorWins', requirement: 10, coinReward: 120),
  AchievementDefinition(id: 'games_twenty_five', name: 'Party Regular', description: 'Finish twenty-five games.', metric: 'gamesPlayed', requirement: 25, coinReward: 120),
  AchievementDefinition(id: 'games_one_hundred', name: 'Party Legend', description: 'Finish one hundred games.', metric: 'gamesPlayed', requirement: 100, coinReward: 300),
  AchievementDefinition(id: 'no_clue_survival', name: 'Silent Survivor', description: 'Survive after submitting no clue in a Speed Round.', metric: 'noClueSurvivals', requirement: 1, coinReward: 50, hidden: true),
  AchievementDefinition(id: 'every_role', name: 'Role Collector', description: 'Play every advanced role at least once.', metric: 'uniqueRolesPlayed', requirement: 7, coinReward: 180),
  AchievementDefinition(id: 'reconnect', name: 'Back in the Room', description: 'Reconnect successfully to an online match.', metric: 'successfulReconnects', requirement: 1, coinReward: 30),
];

class AchievementProgress {
  const AchievementProgress({required this.unlocked, required this.progress});

  final Set<String> unlocked;
  final Map<String, int> progress;
}

class AchievementEvaluation {
  const AchievementEvaluation({
    required this.newlyUnlocked,
    required this.totalCoinReward,
  });

  final List<AchievementDefinition> newlyUnlocked;
  final int totalCoinReward;
}

AchievementEvaluation evaluateAchievements({
  required Map<String, int> metrics,
  required Set<String> alreadyUnlocked,
}) {
  final unlocked = <AchievementDefinition>[];
  var reward = 0;
  for (final achievement in achievements) {
    if (alreadyUnlocked.contains(achievement.id)) {
      continue;
    }
    final value = metrics[achievement.metric] ?? 0;
    if (value >= achievement.requirement) {
      unlocked.add(achievement);
      reward += achievement.coinReward;
    }
  }
  return AchievementEvaluation(
    newlyUnlocked: List.unmodifiable(unlocked),
    totalCoinReward: reward,
  );
}
