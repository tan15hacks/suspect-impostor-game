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

  void _selectMode(GameMode mode) {
    setState(() {
      _mode = mode;
      _preview = null;
      _validationMessage = null;
      if (mode != GameMode.twoSimilarWords) {
        _roles.remove(AdvancedRole.saboteur);
      }
      final maximum = AdvancedRules.maximumImpostorsFor(_playerCount);
      _impostorCount = _impostorCount.clamp(1, maximum);
    });
  }

  @override
  Widget build(BuildContext context) {
    final maxImpostors = AdvancedRules.maximumImpostorsFor(_playerCount);
    final missionCount = compatibleMissions(
      playerCount: _playerCount,
      impostorAligned: true,
    ).length;
    final chaosCount = compatibleChaosCards(
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
              return _ModeCard(
                mode: mode,
                selected: mode == _mode,
                onTap: () => _selectMode(mode),
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
                        _impostorCount = _impostorCount.clamp(1, maximum);
                        _preview = null;
                        _validationMessage = null;
                      });
                    },
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Impostor-side players: $_impostorCount',
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                  if (maxImpostors == 1)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        'This player count supports one balanced impostor-side player.',
                        style: TextStyle(color: Colors.white64),
                      ),
                    )
                  else
                    Slider(
                      min: 1,
                      max: maxImpostors.toDouble(),
                      divisions: maxImpostors - 1,
                      value: _impostorCount.toDouble(),
                      label: '$_impostorCount',
                      onChanged: (value) {
                        setState(() {
                          _impostorCount = value.round();
                          _preview = null;
                          _validationMessage = null;
                        });
                      },
                    ),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      Chip(label: Text('$missionCount compatible missions')),
                      Chip(label: Text('$chaosCount compatible chaos cards')),
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
            'Civilian and Classic Impostor are always included. Optional roles are validated against the selected mode and player count.',
            style: TextStyle(color: Colors.white64, height: 1.4),
          ),
          const SizedBox(height: 10),
          for (final role in AdvancedRole.values.where(
            (role) => role != AdvancedRole.civilian && role != AdvancedRole.impostor,
          ))
            SwitchListTile(
              value: _roles.contains(role),
              title: Text(_roleName(role)),
              subtitle: Text(_roleDescription(role)),
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
                color: _preview == null &&
                        _validationMessage != 'Balanced configuration ready.'
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
                      'Actual matches reveal these privately one player at a time.',
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
                        trailing: Text(_roleName(entry.value)),
                      ),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 18),
          if (_mode == GameMode.classic &&
              _roles.isEmpty &&
              _impostorCount == 1)
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
                    Icon(Icons.info_outline_rounded, color: Color(0xFFFFC857)),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'This configuration is fully validated and can generate balanced private roles. The advanced clue, ability, voting, and role-specific scoring screens are being wired in the next gameplay phase; Classic remains the current complete playable loop.',
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

class _ModeCard extends StatelessWidget {
  const _ModeCard({
    required this.mode,
    required this.selected,
    required this.onTap,
  });

  final GameMode mode;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
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
            Icon(_modeIcon(mode), size: 34, color: const Color(0xFFFFC857)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _modeName(mode),
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    _modeDescription(mode),
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
  }
}

String _modeName(GameMode mode) {
  switch (mode) {
    case GameMode.classic:
      return 'Classic Impostor';
    case GameMode.twoSimilarWords:
      return 'Two Similar Words';
    case GameMode.questionInterrogation:
      return 'Question Interrogation';
    case GameMode.emojiClues:
      return 'Emoji Clues';
    case GameMode.speedRound:
      return 'Speed Round';
    case GameMode.anonymousClues:
      return 'Anonymous Clues';
    case GameMode.multipleImpostors:
      return 'Multiple Impostors';
    case GameMode.oneSentenceStory:
      return 'One-Sentence Story';
  }
}

String _modeDescription(GameMode mode) {
  switch (mode) {
    case GameMode.classic:
      return 'Civilians share one word while impostors bluff without seeing it.';
    case GameMode.twoSimilarWords:
      return 'An undercover player receives a curated related alternate word.';
    case GameMode.questionInterrogation:
      return 'Players answer indirect questions instead of ordinary clues.';
    case GameMode.emojiClues:
      return 'Every clue is limited to emoji.';
    case GameMode.speedRound:
      return 'Short clue timers punish hesitation.';
    case GameMode.anonymousClues:
      return 'Clue owners stay hidden until the reveal.';
    case GameMode.multipleImpostors:
      return 'Balanced teams support more than one impostor-side player.';
    case GameMode.oneSentenceStory:
      return 'Each player adds a sentence that subtly references the word.';
  }
}

IconData _modeIcon(GameMode mode) {
  switch (mode) {
    case GameMode.classic:
      return Icons.visibility_off_rounded;
    case GameMode.twoSimilarWords:
      return Icons.compare_arrows_rounded;
    case GameMode.questionInterrogation:
      return Icons.quiz_rounded;
    case GameMode.emojiClues:
      return Icons.emoji_emotions_rounded;
    case GameMode.speedRound:
      return Icons.timer_rounded;
    case GameMode.anonymousClues:
      return Icons.privacy_tip_rounded;
    case GameMode.multipleImpostors:
      return Icons.groups_rounded;
    case GameMode.oneSentenceStory:
      return Icons.auto_stories_rounded;
  }
}

String _roleName(AdvancedRole role) {
  switch (role) {
    case AdvancedRole.civilian:
      return 'Civilian';
    case AdvancedRole.impostor:
      return 'Classic Impostor';
    case AdvancedRole.mimic:
      return 'Mimic';
    case AdvancedRole.doubleAgent:
      return 'Double Agent';
    case AdvancedRole.mrBlank:
      return 'Mr. Blank';
    case AdvancedRole.saboteur:
      return 'Saboteur';
    case AdvancedRole.trickster:
      return 'Trickster';
  }
}

String _roleDescription(AdvancedRole role) {
  switch (role) {
    case AdvancedRole.civilian:
      return 'Knows the word and helps eliminate every impostor.';
    case AdvancedRole.impostor:
      return 'Receives no word and wins by survival or a final guess.';
    case AdvancedRole.mimic:
      return 'May see the first submitted clue before giving their own.';
    case AdvancedRole.doubleAgent:
      return 'Knows the word but secretly belongs to the impostor side.';
    case AdvancedRole.mrBlank:
      return 'Receives no word and may win individually with a correct guess.';
    case AdvancedRole.saboteur:
      return 'Receives a related alternate word in Two Similar Words mode.';
    case AdvancedRole.trickster:
      return 'Wins by receiving enough votes without being eliminated.';
  }
}
