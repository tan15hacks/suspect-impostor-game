import '../domain/advanced_rules.dart';

class SecretMission {
  const SecretMission({
    required this.id,
    required this.text,
    required this.minimumPlayers,
    required this.impostorAligned,
    required this.verification,
  });

  final String id;
  final String text;
  final int minimumPlayers;
  final bool impostorAligned;
  final String verification;
}

class ChaosCard {
  const ChaosCard({
    required this.id,
    required this.name,
    required this.description,
    required this.compatibleModes,
    required this.minimumPlayers,
    required this.isPrivate,
    required this.duration,
    required this.resolution,
  });

  final String id;
  final String name;
  final String description;
  final Set<GameMode> compatibleModes;
  final int minimumPlayers;
  final bool isPrivate;
  final String duration;
  final String resolution;
}

const secretMissions = <SecretMission>[
  SecretMission(id: 'mission_repeat_clue', text: 'Make another player repeat your clue during discussion.', minimumPlayers: 4, impostorAligned: true, verification: 'Group confirmation'),
  SecretMission(id: 'mission_change_vote', text: 'Convince at least one player to change their intended vote.', minimumPlayers: 4, impostorAligned: true, verification: 'Group confirmation'),
  SecretMission(id: 'mission_accuse_first', text: 'Accuse the first clue giver before anyone else does.', minimumPlayers: 4, impostorAligned: true, verification: 'Host confirmation'),
  SecretMission(id: 'mission_defend_innocent', text: 'Clearly defend one civilian during discussion.', minimumPlayers: 4, impostorAligned: true, verification: 'Host confirmation'),
  SecretMission(id: 'mission_cause_tie', text: 'Help create a tied first vote.', minimumPlayers: 4, impostorAligned: true, verification: 'Automatic'),
  SecretMission(id: 'mission_avoid_first', text: 'Do not speak first during discussion.', minimumPlayers: 3, impostorAligned: true, verification: 'Self-claim and group confirmation'),
  SecretMission(id: 'mission_use_exactly', text: 'Naturally use the harmless word “exactly” during discussion.', minimumPlayers: 3, impostorAligned: true, verification: 'Group confirmation'),
  SecretMission(id: 'mission_make_laugh', text: 'Make at least one player laugh without insulting anyone.', minimumPlayers: 4, impostorAligned: true, verification: 'Group confirmation'),
  SecretMission(id: 'mission_one_vote', text: 'Receive exactly one vote in the first vote.', minimumPlayers: 4, impostorAligned: true, verification: 'Automatic'),
  SecretMission(id: 'mission_vote_accuser', text: 'Vote for the first player who directly accuses you.', minimumPlayers: 4, impostorAligned: true, verification: 'Host confirmation'),
  SecretMission(id: 'mission_no_accusation', text: 'Survive the round without directly accusing anyone.', minimumPlayers: 3, impostorAligned: true, verification: 'Self-claim and group confirmation'),
  SecretMission(id: 'mission_hear_name', text: 'Get another player to mention your name during discussion.', minimumPlayers: 4, impostorAligned: true, verification: 'Group confirmation'),
  SecretMission(id: 'mission_two_argue', text: 'Get two players to disagree about the same clue.', minimumPlayers: 5, impostorAligned: true, verification: 'Group confirmation'),
  SecretMission(id: 'mission_question_two', text: 'Ask two different players a direct question.', minimumPlayers: 4, impostorAligned: true, verification: 'Host confirmation'),
  SecretMission(id: 'mission_deflect', text: 'Redirect suspicion from yourself to another player once.', minimumPlayers: 4, impostorAligned: true, verification: 'Group confirmation'),
  SecretMission(id: 'mission_shortest_clue', text: 'Give the shortest valid clue of the round.', minimumPlayers: 3, impostorAligned: true, verification: 'Automatic'),
  SecretMission(id: 'mission_last_speaker', text: 'Be the final person to speak before voting begins.', minimumPlayers: 4, impostorAligned: true, verification: 'Host confirmation'),
  SecretMission(id: 'mission_agree_twice', text: 'Agree with two different players during discussion.', minimumPlayers: 4, impostorAligned: true, verification: 'Group confirmation'),
  SecretMission(id: 'mission_say_fair', text: 'Naturally use the word “fair” during discussion.', minimumPlayers: 3, impostorAligned: true, verification: 'Group confirmation'),
  SecretMission(id: 'mission_question_clue', text: 'Politely question one clue without accusing its owner.', minimumPlayers: 3, impostorAligned: true, verification: 'Host confirmation'),
  SecretMission(id: 'mission_support_vote', text: 'Publicly support another player’s suspicion before voting.', minimumPlayers: 4, impostorAligned: true, verification: 'Group confirmation'),
  SecretMission(id: 'mission_switch_suspect', text: 'Name one suspect early, then change to a different suspect later.', minimumPlayers: 4, impostorAligned: true, verification: 'Group confirmation'),
  SecretMission(id: 'mission_neutral_opening', text: 'Open your first statement with a neutral observation instead of an accusation.', minimumPlayers: 3, impostorAligned: true, verification: 'Host confirmation'),
  SecretMission(id: 'mission_echo_phrase', text: 'Reuse a harmless two-word phrase said by another player.', minimumPlayers: 4, impostorAligned: true, verification: 'Group confirmation'),
  SecretMission(id: 'mission_ask_confidence', text: 'Ask another player how confident they are.', minimumPlayers: 4, impostorAligned: true, verification: 'Host confirmation'),
  SecretMission(id: 'mission_defense_question', text: 'Answer an accusation with a question.', minimumPlayers: 4, impostorAligned: true, verification: 'Group confirmation'),
  SecretMission(id: 'mission_no_word_me', text: 'Avoid saying “me” during the entire discussion.', minimumPlayers: 3, impostorAligned: true, verification: 'Self-claim and group confirmation'),
  SecretMission(id: 'mission_thank_player', text: 'Thank another player for explaining their clue.', minimumPlayers: 3, impostorAligned: true, verification: 'Group confirmation'),
  SecretMission(id: 'mission_summary', text: 'Summarize the two most suspicious clues before voting.', minimumPlayers: 4, impostorAligned: true, verification: 'Host confirmation'),
  SecretMission(id: 'mission_calm_down', text: 'Calm down a disagreement without taking either side.', minimumPlayers: 5, impostorAligned: true, verification: 'Group confirmation'),
  SecretMission(id: 'mission_repeat_question', text: 'Get another player to repeat a question to you.', minimumPlayers: 4, impostorAligned: true, verification: 'Group confirmation'),
  SecretMission(id: 'mission_vote_confident', text: 'Submit a “Certain” confidence vote.', minimumPlayers: 3, impostorAligned: true, verification: 'Automatic'),
  SecretMission(id: 'mission_vote_low', text: 'Submit a “Slightly suspicious” confidence vote.', minimumPlayers: 3, impostorAligned: true, verification: 'Automatic'),
  SecretMission(id: 'mission_name_three', text: 'Mention three different players by name during discussion.', minimumPlayers: 5, impostorAligned: true, verification: 'Group confirmation'),
  SecretMission(id: 'mission_no_repeat_clue', text: 'Never repeat your own clue after submitting it.', minimumPlayers: 3, impostorAligned: true, verification: 'Self-claim and group confirmation'),
  SecretMission(id: 'mission_ask_first_clue', text: 'Ask the first clue giver to explain their thinking.', minimumPlayers: 4, impostorAligned: true, verification: 'Host confirmation'),
  SecretMission(id: 'mission_defend_self_once', text: 'Defend yourself in one sentence only.', minimumPlayers: 4, impostorAligned: true, verification: 'Group confirmation'),
  SecretMission(id: 'mission_use_maybe', text: 'Naturally use the word “maybe” during discussion.', minimumPlayers: 3, impostorAligned: true, verification: 'Group confirmation'),
  SecretMission(id: 'mission_clue_comparison', text: 'Compare two other players’ clues without naming the secret word.', minimumPlayers: 4, impostorAligned: true, verification: 'Host confirmation'),
  SecretMission(id: 'mission_be_accused', text: 'Get accused by at least two different players and survive.', minimumPlayers: 5, impostorAligned: true, verification: 'Group confirmation'),
  SecretMission(id: 'mission_speak_twice', text: 'Speak exactly twice during the discussion.', minimumPlayers: 4, impostorAligned: true, verification: 'Self-claim and group confirmation'),
  SecretMission(id: 'mission_ask_vote', text: 'Ask one player who they currently plan to vote for.', minimumPlayers: 4, impostorAligned: true, verification: 'Host confirmation'),
  SecretMission(id: 'mission_praise_clue', text: 'Call one clue clever or smart.', minimumPlayers: 3, impostorAligned: true, verification: 'Group confirmation'),
  SecretMission(id: 'mission_correct_name', text: 'Correctly predict one player’s final vote before voting begins.', minimumPlayers: 4, impostorAligned: true, verification: 'Group confirmation'),
  SecretMission(id: 'mission_no_direct_name', text: 'Avoid directly naming your chosen suspect before voting.', minimumPlayers: 3, impostorAligned: true, verification: 'Self-claim and group confirmation'),
  SecretMission(id: 'mission_explain_clue', text: 'Give a believable explanation for your clue when challenged.', minimumPlayers: 3, impostorAligned: true, verification: 'Group confirmation'),
  SecretMission(id: 'mission_support_minor', text: 'Support the least-discussed player at least once.', minimumPlayers: 4, impostorAligned: true, verification: 'Group confirmation'),
  SecretMission(id: 'mission_question_last', text: 'Ask the last clue giver one question.', minimumPlayers: 4, impostorAligned: true, verification: 'Host confirmation'),
  SecretMission(id: 'mission_say_interesting', text: 'Naturally use the word “interesting” during discussion.', minimumPlayers: 3, impostorAligned: true, verification: 'Group confirmation'),
  SecretMission(id: 'mission_reconsider', text: 'Say that you are reconsidering your suspicion.', minimumPlayers: 3, impostorAligned: true, verification: 'Group confirmation'),
  SecretMission(id: 'mission_civilian_help', text: 'As a civilian, identify one clue that genuinely supports another civilian.', minimumPlayers: 4, impostorAligned: false, verification: 'Host confirmation'),
  SecretMission(id: 'mission_civilian_question', text: 'As a civilian, ask a useful question that helps the group compare clues.', minimumPlayers: 3, impostorAligned: false, verification: 'Group confirmation'),
  SecretMission(id: 'mission_civilian_correct', text: 'As a civilian, cast a correct vote with at least “Very suspicious” confidence.', minimumPlayers: 3, impostorAligned: false, verification: 'Automatic'),
  SecretMission(id: 'mission_civilian_defend', text: 'As a civilian, defend another civilian who is under suspicion.', minimumPlayers: 4, impostorAligned: false, verification: 'Host confirmation'),
  SecretMission(id: 'mission_civilian_summary', text: 'As a civilian, summarize the clue board before voting.', minimumPlayers: 4, impostorAligned: false, verification: 'Host confirmation'),
  SecretMission(id: 'mission_civilian_no_false', text: 'As a civilian, finish discussion without falsely accusing another civilian.', minimumPlayers: 4, impostorAligned: false, verification: 'Host confirmation'),
  SecretMission(id: 'mission_civilian_calm', text: 'As a civilian, help settle a disagreement respectfully.', minimumPlayers: 5, impostorAligned: false, verification: 'Group confirmation'),
  SecretMission(id: 'mission_civilian_clue', text: 'As a civilian, give a clue that at least two players describe as useful.', minimumPlayers: 4, impostorAligned: false, verification: 'Group confirmation'),
  SecretMission(id: 'mission_civilian_vote', text: 'As a civilian, explain your intended vote before submitting it.', minimumPlayers: 3, impostorAligned: false, verification: 'Host confirmation'),
  SecretMission(id: 'mission_civilian_survive', text: 'As a civilian, receive at least one vote and still survive the round.', minimumPlayers: 4, impostorAligned: false, verification: 'Automatic'),
];

const _allModes = <GameMode>{
  GameMode.classic,
  GameMode.twoSimilarWords,
  GameMode.questionInterrogation,
  GameMode.emojiClues,
  GameMode.speedRound,
  GameMode.anonymousClues,
  GameMode.multipleImpostors,
  GameMode.oneSentenceStory,
};

const chaosCards = <ChaosCard>[
  ChaosCard(id: 'chaos_reverse_order', name: 'Reverse Order', description: 'The normal turn order is reversed for this clue round.', compatibleModes: _allModes, minimumPlayers: 3, isPrivate: false, duration: 'Clue round', resolution: 'Reverse the generated turn-order list.'),
  ChaosCard(id: 'chaos_silent_player', name: 'Silent Player', description: 'One random player may not speak during the first half of discussion.', compatibleModes: _allModes, minimumPlayers: 4, isPrivate: false, duration: 'Half of discussion', resolution: 'Host selects a player and the app shows the release time.'),
  ChaosCard(id: 'chaos_double_clue', name: 'Double Clue', description: 'One random player must submit two short clues.', compatibleModes: {GameMode.classic, GameMode.twoSimilarWords, GameMode.speedRound, GameMode.anonymousClues}, minimumPlayers: 4, isPrivate: false, duration: 'One turn', resolution: 'Selected player receives two clue fields.'),
  ChaosCard(id: 'chaos_forbidden_word', name: 'Forbidden Word', description: 'A harmless related word is forbidden during discussion.', compatibleModes: _allModes, minimumPlayers: 3, isPrivate: false, duration: 'Discussion', resolution: 'Host chooses from a safe generated list and confirms violations.'),
  ChaosCard(id: 'chaos_sudden_vote', name: 'Sudden Vote', description: 'Discussion ends early when the card timer reaches zero.', compatibleModes: _allModes, minimumPlayers: 3, isPrivate: false, duration: 'Discussion', resolution: 'Reduce discussion to twenty seconds.'),
  ChaosCard(id: 'chaos_anonymous_clue', name: 'Anonymous Clues', description: 'All clue identities stay hidden until voting is complete.', compatibleModes: {GameMode.classic, GameMode.twoSimilarWords, GameMode.speedRound}, minimumPlayers: 4, isPrivate: false, duration: 'Round', resolution: 'Hide clue-owner labels until reveal.'),
  ChaosCard(id: 'chaos_short_discussion', name: 'Short Discussion', description: 'The group receives only twenty-five seconds to discuss.', compatibleModes: _allModes, minimumPlayers: 3, isPrivate: false, duration: 'Discussion', resolution: 'Set the discussion deadline to twenty-five seconds.'),
  ChaosCard(id: 'chaos_mutual_defense', name: 'Mutual Defense', description: 'Two random suspects must defend each other before defending themselves.', compatibleModes: _allModes, minimumPlayers: 5, isPrivate: false, duration: 'Discussion', resolution: 'Select two players and show the paired instruction.'),
  ChaosCard(id: 'chaos_two_words', name: 'Exactly Two Words', description: 'Every clue must contain exactly two words.', compatibleModes: {GameMode.classic, GameMode.twoSimilarWords, GameMode.speedRound, GameMode.anonymousClues}, minimumPlayers: 3, isPrivate: false, duration: 'Clue round', resolution: 'Reject clue submissions with any other word count.'),
  ChaosCard(id: 'chaos_last_first', name: 'Last Goes First', description: 'The final player in the original order becomes the first clue giver.', compatibleModes: _allModes, minimumPlayers: 3, isPrivate: false, duration: 'Clue round', resolution: 'Rotate turn order so the final player starts.'),
  ChaosCard(id: 'chaos_no_timer_bonus', name: 'No Timer Bonus', description: 'One random player cannot earn any speed bonus this round.', compatibleModes: {GameMode.speedRound}, minimumPlayers: 4, isPrivate: true, duration: 'Round', resolution: 'Mark the selected player in private round data.'),
  ChaosCard(id: 'chaos_extra_question', name: 'One Extra Question', description: 'Every player may ask one additional interrogation question.', compatibleModes: {GameMode.questionInterrogation}, minimumPlayers: 3, isPrivate: false, duration: 'Question round', resolution: 'Increase each player’s question allowance by one.'),
  ChaosCard(id: 'chaos_shuffled_clues', name: 'Shuffled Clues', description: 'The clue board displays submitted clues in random order.', compatibleModes: {GameMode.classic, GameMode.twoSimilarWords, GameMode.speedRound, GameMode.anonymousClues}, minimumPlayers: 4, isPrivate: false, duration: 'Clue board', resolution: 'Shuffle clue-display order without changing ownership.'),
  ChaosCard(id: 'chaos_no_accusations', name: 'No Direct Accusations', description: 'Players must discuss clues without directly accusing anyone.', compatibleModes: _allModes, minimumPlayers: 4, isPrivate: false, duration: 'Discussion', resolution: 'Host confirms violations; voting remains normal.'),
  ChaosCard(id: 'chaos_skip_token', name: 'Skip Token', description: 'One random player may skip their clue turn without penalty.', compatibleModes: {GameMode.classic, GameMode.twoSimilarWords, GameMode.speedRound, GameMode.anonymousClues}, minimumPlayers: 4, isPrivate: true, duration: 'Clue round', resolution: 'Give the selected player one private skip action.'),
  ChaosCard(id: 'chaos_confidence_double', name: 'Double Confidence', description: 'Correct and incorrect confidence bonuses are doubled.', compatibleModes: _allModes, minimumPlayers: 3, isPrivate: false, duration: 'Voting', resolution: 'Multiply confidence score changes by two.'),
  ChaosCard(id: 'chaos_tiebreak_clue', name: 'Tie-Breaker Clue', description: 'Tied suspects must each provide one extra clue before the second vote.', compatibleModes: _allModes, minimumPlayers: 4, isPrivate: false, duration: 'Tie breaker', resolution: 'Collect one extra clue from each tied player.'),
  ChaosCard(id: 'chaos_fake_objective', name: 'Harmless Fake Objective', description: 'One civilian receives a private harmless objective for bonus points.', compatibleModes: _allModes, minimumPlayers: 5, isPrivate: true, duration: 'Round', resolution: 'Assign one civilian-compatible mission privately.'),
  ChaosCard(id: 'chaos_questions_only', name: 'Questions Only', description: 'Players may speak only in question form for the first fifteen seconds.', compatibleModes: _allModes, minimumPlayers: 4, isPrivate: false, duration: 'First fifteen seconds', resolution: 'Display a visible countdown and host-confirm violations.'),
  ChaosCard(id: 'chaos_one_word', name: 'One-Word Clues', description: 'Every standard clue must contain exactly one word.', compatibleModes: {GameMode.classic, GameMode.twoSimilarWords, GameMode.speedRound, GameMode.anonymousClues}, minimumPlayers: 3, isPrivate: false, duration: 'Clue round', resolution: 'Reject clues containing spaces after trimming.'),
  ChaosCard(id: 'chaos_vote_hidden', name: 'Hidden Vote Count', description: 'Vote totals remain hidden until the eliminated player is revealed.', compatibleModes: _allModes, minimumPlayers: 3, isPrivate: false, duration: 'Voting', resolution: 'Suppress interim vote-count UI.'),
  ChaosCard(id: 'chaos_vote_visible', name: 'Open Ballot', description: 'Each submitted vote is revealed immediately to the group.', compatibleModes: _allModes, minimumPlayers: 4, isPrivate: false, duration: 'Voting', resolution: 'Show voter and target after each submission.'),
  ChaosCard(id: 'chaos_fast_clues', name: 'Rapid Fire', description: 'Each clue giver receives only eight seconds.', compatibleModes: {GameMode.classic, GameMode.twoSimilarWords, GameMode.speedRound, GameMode.anonymousClues}, minimumPlayers: 3, isPrivate: false, duration: 'Clue round', resolution: 'Set each clue deadline to eight seconds.'),
  ChaosCard(id: 'chaos_slow_start', name: 'Think First', description: 'Nobody may submit a clue during a ten-second thinking period.', compatibleModes: _allModes, minimumPlayers: 3, isPrivate: false, duration: 'Before clue round', resolution: 'Run a shared ten-second countdown before enabling input.'),
  ChaosCard(id: 'chaos_first_last', name: 'First Becomes Last', description: 'The original first clue giver moves to the end of the order.', compatibleModes: _allModes, minimumPlayers: 3, isPrivate: false, duration: 'Clue round', resolution: 'Move the first turn-order item to the final position.'),
  ChaosCard(id: 'chaos_random_order', name: 'Scrambled Order', description: 'The clue order is freshly randomized.', compatibleModes: _allModes, minimumPlayers: 3, isPrivate: false, duration: 'Clue round', resolution: 'Shuffle the turn-order list once.'),
  ChaosCard(id: 'chaos_no_names', name: 'No Names', description: 'Nobody may say another player’s name during discussion.', compatibleModes: _allModes, minimumPlayers: 4, isPrivate: false, duration: 'Discussion', resolution: 'Host confirms violations; use clue positions instead.'),
  ChaosCard(id: 'chaos_one_defense', name: 'One-Sentence Defense', description: 'Every accused player gets exactly one sentence to defend themselves.', compatibleModes: _allModes, minimumPlayers: 4, isPrivate: false, duration: 'Discussion', resolution: 'Host advances after one completed sentence.'),
  ChaosCard(id: 'chaos_shared_timer', name: 'Shared Clue Clock', description: 'The entire group shares one short clue timer.', compatibleModes: {GameMode.classic, GameMode.twoSimilarWords, GameMode.speedRound, GameMode.anonymousClues}, minimumPlayers: 4, isPrivate: false, duration: 'Clue round', resolution: 'Use one deadline for all remaining clue submissions.'),
  ChaosCard(id: 'chaos_confidence_locked', name: 'Confidence Locked', description: 'Every voter must choose “Certain”.', compatibleModes: _allModes, minimumPlayers: 3, isPrivate: false, duration: 'Voting', resolution: 'Lock the confidence selector to Certain.'),
  ChaosCard(id: 'chaos_confidence_low', name: 'Play It Safe', description: 'Every voter must choose “Slightly suspicious”.', compatibleModes: _allModes, minimumPlayers: 3, isPrivate: false, duration: 'Voting', resolution: 'Lock the confidence selector to Slightly suspicious.'),
  ChaosCard(id: 'chaos_clue_swap', name: 'Clue Swap', description: 'Two random clue positions are swapped on the public board.', compatibleModes: {GameMode.classic, GameMode.twoSimilarWords, GameMode.speedRound, GameMode.anonymousClues}, minimumPlayers: 4, isPrivate: false, duration: 'Clue board', resolution: 'Swap two display positions while preserving private ownership.'),
  ChaosCard(id: 'chaos_story_reverse', name: 'Reverse Story', description: 'The one-sentence story is displayed from last sentence to first.', compatibleModes: {GameMode.oneSentenceStory}, minimumPlayers: 4, isPrivate: false, duration: 'Story reveal', resolution: 'Reverse the submitted sentence list for display.'),
  ChaosCard(id: 'chaos_emoji_limit', name: 'Three Emoji Limit', description: 'Each player may submit at most three emoji.', compatibleModes: {GameMode.emojiClues}, minimumPlayers: 3, isPrivate: false, duration: 'Clue round', resolution: 'Reject submissions containing more than three emoji clusters.'),
  ChaosCard(id: 'chaos_emoji_exact', name: 'Exactly Two Emoji', description: 'Each player must submit exactly two emoji.', compatibleModes: {GameMode.emojiClues}, minimumPlayers: 3, isPrivate: false, duration: 'Clue round', resolution: 'Require exactly two emoji clusters.'),
  ChaosCard(id: 'chaos_question_swap', name: 'Question Swap', description: 'Each player answers the question intended for the next player.', compatibleModes: {GameMode.questionInterrogation}, minimumPlayers: 4, isPrivate: false, duration: 'Question round', resolution: 'Rotate assigned question prompts by one player.'),
  ChaosCard(id: 'chaos_secret_speaker', name: 'Secret First Speaker', description: 'One player privately learns that they must open the discussion.', compatibleModes: _allModes, minimumPlayers: 4, isPrivate: true, duration: 'Discussion opening', resolution: 'Assign one player privately and reveal completion afterward.'),
  ChaosCard(id: 'chaos_half_time', name: 'Half Time', description: 'All configured clue and discussion timers are cut in half.', compatibleModes: _allModes, minimumPlayers: 3, isPrivate: false, duration: 'Round', resolution: 'Multiply applicable timer durations by 0.5, rounded up.'),
  ChaosCard(id: 'chaos_bonus_defense', name: 'Extended Defense', description: 'The eliminated suspect receives thirty seconds for final defense.', compatibleModes: _allModes, minimumPlayers: 4, isPrivate: false, duration: 'Final defense', resolution: 'Set the defense deadline to thirty seconds.'),
  ChaosCard(id: 'chaos_second_chance', name: 'Second Chance Vote', description: 'The group may voluntarily restart voting once before reveal.', compatibleModes: _allModes, minimumPlayers: 4, isPrivate: false, duration: 'Voting', resolution: 'Allow the host one vote-reset action before reveal.'),
];

List<SecretMission> compatibleMissions({
  required int playerCount,
  required bool impostorAligned,
}) {
  return secretMissions
      .where((mission) =>
          mission.minimumPlayers <= playerCount &&
          mission.impostorAligned == impostorAligned)
      .toList(growable: false);
}

List<ChaosCard> compatibleChaosCards({
  required int playerCount,
  required GameMode mode,
}) {
  return chaosCards
      .where((card) =>
          card.minimumPlayers <= playerCount && card.compatibleModes.contains(mode))
      .toList(growable: false);
}
