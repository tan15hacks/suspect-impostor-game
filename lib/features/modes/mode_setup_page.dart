import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/widgets/game_scaffold.dart';
import '../../data/curated_party_content.dart';
import '../../domain/advanced_rules.dart';
import '../../main.dart' show PartyGamePage;

class ModeSetupPage extends StatefulWidget {
  const ModeSetupPage({super.key});

  @override
  State<ModeSetupPage> createState() => _ModeSetupPageState();
}

class _ModeSetupPageState extends State<ModeSetupPage> {
  GameMode _mode = GameMode.classic;
  int _playerCount = 5;
  int _impostorCount = 1;
  final Set<AdvancedRole> _roles = {};
  AdvancedAssignment? _preview;
  String? _validationMessage;

  static const _modeInfo = <GameMode, ({String name, String description, IconData icon})>{
    GameMode.classic: (
      name: 'Classic Impostor',
      description: 'Civilians share one word while impostors bluff without seeing it.',
      icon: Icons.visibility_off_rounded,
    ),
    GameMode.twoSimilarWords: (
      name: 'Two Similar Words',
      description: 'Most players see the main word while an undercover player sees a curated alternate.',
      icon: Icons.compare_arrows_rounded,
    ),
    GameMode.questionInterrogation: (
      name: 'Question Interrogation',
      description: 'Players answer indirect category questions instead of giving ordinary clues.',
      icon: Icons.quiz_rounded,
    ),
    GameMode.emojiClues: (
      name: 'Emoji Clues',
      description: 'Clues are limited to emoji, forcing creative interpretation.',
      icon: Icons.emoji_emotions_rounded,
    ),
    GameMode.speedRound: (
      name: 'Speed Round',
      description: 'Short clue timers punish hesitation and create fast suspicion.',
      icon: Icons.timer_rounded,
    ),
    GameMode.anonymousClues: (
      name: 'Anonymous Clues',
      description: 'Clue owners stay hidden until voting or round completion.',
      icon: Icons.privacy_tip_rounded,
    ),
    GameMode.multipleImpostors: (
      name: 'Multiple Impostors',
      description: 'Balanced teams support more than one impostor-side player.',
      icon: Icons.groups_rounded,
    ),
    GameMode.oneSentenceStory: (
      name: 'One-Sentence Story',
      description: 'Each player adds one sentence that subtly references the secret word.',
      icon: Icons.auto_stories_rounded,
    ),
  };

  static const _roleInfo = <AdvancedRole, ({String name, String description})>{
    AdvancedRole.civilian: (
      name: 'Civilian',
      description: 'Knows the word and helps eliminate every impostor.',
    ),
    AdvancedRole.impostor: (
      name: 'Classic Impostor',
      description: 'Receives no word and wins through survival or a final guess.',
    ),
    AdvancedRole.mimic: (
      name: 'Mimic',
      description: 'Receives no word but may see the first submitted clue.',
    ),
    AdvancedRole.doubleAgent: (
      name: 'Double Agent',
      description: 'Knows the real word but secretly belongs to the impostor side.',
    ),
    AdvancedRole.mrBlank: (
      name: 'Mr. Blank',
      description: 'Receives no word and can win individually with a correct final guess.',
    ),
    AdvancedRole.saboteur: (
      name: 'Saboteur',
      description: 'Receives a related alternate word and blends between both meanings.',
    ),
    AdvancedRole.trickster: (
      name: 'Trickster',
      description: 'Wins individually by attracting enough votes without being eliminated.',
    ),
  };

  RoleConfiguration get _configuration => RoleConfiguration(
        playerCount: _playerCount,
        impostorCount: _impostorCount,
        gameMode: _mode,
        enabledRoles: _roles,
      );

  void _validate() {
    final message = AdvancedRules.validateConfiguration(_configuration);
    setState(() {
      _validationMessage = message ?? 'Balanced configuration ready.';
      if (message != null) {
        _preview = null;
      }
    });
  }

  void _generatePreview() {
    final message = AdvancedRules.validateConfiguration(_configuration);
    if (message != null) {
      setState(() {
        _validationMessage = message;
        _preview = null;
      });
      return;
    }
    final ids = List.generate(_playerCount, (index) => 'Player ${index + 1}');
    setState(() {
      _validationMessage = 'Balanced role preview generated.';
      _preview = AdvancedRules.assignRoles(
        playerIds: ids,
        configuration: _configuration,
        random: Random(DateTime.now().microsecondsSinceEpoch),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final compatibleMissionCount = compatibleMissions(
      playerCount: _playerCount,
      impostorAligned: true,
    ).length;
    final compatibleChaosCount = compatibleChaosCards(
      playerCount: _playerCount,
      mode: _mode,
    ).length;

    return GameScaffold(
      title: 'Advanced Match Setup',
      subtitle: 'Modes, roles, balance, missions, and chaos',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Choose a game mode',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: GameMode.values.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.sizeOf(context).width > 720 ? 2 : 1,
              mainAxisExtent: 116,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemBuilder: (context, index) {
              final mode = GameMode.values[index];
              final info = _modeInfo[mode]!;
              final selected = _mode == mode;
              return InkWell(
                borderRadius: BorderRadius.circular(22),
                onTap: () {
                  setState(() {
                    _mode = mode;
                    _preview = null;
                    _validationMessage = null;
                    final maximum = AdvancedRules.maximumImpostorsFor(_playerCount);
                    if (_impostorCount > maximum) {
                      _impostorCount = maximum;
                    }
                    if (mode != GameMode.twoSimilarWords) {
                      _roles.remove(AdvancedRole.saboteur);
                    }
                  });
                },
                child: Ink(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: selected
                        ? const Color(0xFF6D5DFB).withOpacity(0.22)
                        : const Color(0xFF172033),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: selected
                          ? const Color(0xFF9B8CFF)
                          : Colors.white.withOpacity(0.08),
                      width: selected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(info.icon, size: 34, color: const Color(0xFFFFC857)),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              info.name,
                              style: const TextStyle(fontWeight: FontWeight.w900),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              info.description,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.white64, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Players: $_playerCount',
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                  Slider(
                    min: 3,
                    max: 12,
                    divisions: 9,
                    value: _playerCount.toDouble(),
                    label: '$_playerCount',
                    onChanged: (value) {
                      setState(() {
                        _playerCount = value.round();
                        final maximum = AdvancedRules.maximumImpostorsFor(_playerCount);
                        if (_impostorCount > maximum) {
                          _impostorCount = maximum;
                        }
                        _preview = null;
                      });
                    },
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Impostor-side players: $_impostorCount',
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                  Slider(
                    min: 1,
                    max: AdvancedRules.maximumImpostorsFor(_playerCount).toDouble(),
                    divisions: max(1, AdvancedRules.maximumImpostorsFor(_playerCount) - 1),
                    value: _impostorCount.toDouble(),
                    label: '$_impostorCount',
                    onChanged: (value) {
                      setState(() {
                        _impostorCount = value.round();
                        _preview = null;
                      });
                    },
                  ),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      Chip(label: Text('$compatibleMissionCount compatible missions')),
                      Chip(label: Text('$compatibleChaosCount compatible chaos cards')),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Advanced roles',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          const Text(
            'Civilian and Classic Impostor are always part of the base assignment. Enable optional roles below.',
            style: TextStyle(color: Colors.white64, height: 1.4),
          ),
          const SizedBox(height: 10),
          for (final role in AdvancedRole.values.where(
            (role) => role != AdvancedRole.civilian && role != AdvancedRole.impostor,
          ))
            SwitchListTile(
              value: _roles.contains(role),
              title: Text(_roleInfo[role]!.name),
              subtitle: Text(_roleInfo[role]!.description),
              onChanged: (value) {
                setState(() {
                  if (value) {
                    _roles.add(role);
                  } else {
                    _roles.remove(role);
                  }
                  _preview = null;
                  _validationMessage = null;
                });
              },
            ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _validate,
                  icon: const Icon(Icons.fact_check_rounded),
                  label: const Text('Validate setup'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton.icon(
                  onPressed: _generatePreview,
                  icon: const Icon(Icons.casino_rounded),
                  label: const Text('Generate roles'),
                ),
              ),
            ],
          ),
          if (_validationMessage != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: (_preview == null && _validationMessage != 'Balanced configuration ready.')
                    ? const Color(0xFFB91C1C).withOpacity(0.18)
                    : const Color(0xFF14B8A6).withOpacity(0.16),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(_validationMessage!),
            ),
          ],
          if (_preview != null) ...[
            const SizedBox(height: 18),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Private role preview',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'This preview proves the assignment and balance rules. Actual matches reveal these privately one player at a time.',
                      style: TextStyle(color: Colors.white64),
                    ),
                    const SizedBox(height: 12),
                    for (final entry in _preview!.rolesByPlayerId.entries)
                      ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(
                          _preview!.impostorSideIds.contains(entry.key)
                              ? Icons.theater_comedy_rounded
                              : Icons.shield_rounded,
                        ),
                        title: Text(entry.key),
                        trailing: Text(_roleInfo[entry.value]!.name),
                      ),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 18),
          if (_mode == GameMode.classic && _roles.isEmpty && _impostorCount == 1)
            FilledButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(builder: (_) => const PartyGamePage()),
                );
              },
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text('Start this Classic match'),
            )
          else
            const Card(
              child: Padding(
                padding: EdgeInsets.all(18),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.construction_rounded, color: Color(0xFFFFC857)),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'The advanced configuration, balancing, missions, and chaos selection are active in this build. Their complete clue, voting, and scoring screens are the next gameplay wiring step; the current playable session remains Classic mode.',
                        style: TextStyle(height: 1.45),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
