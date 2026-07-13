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

  void _resetOutput() {
    _preview = null;
    _validationMessage = null;
  }

  void _setMode(GameMode mode) {
    setState(() {
      _mode = mode;
      if (mode != GameMode.twoSimilarWords) {
        _roles.remove(AdvancedRole.saboteur);
      }
      _impostorCount = _impostorCount
          .clamp(1, AdvancedRules.maximumImpostorsFor(_playerCount))
          .toInt();
      _resetOutput();
    });
  }

  void _validate() {
    final error = AdvancedRules.validateConfiguration(_configuration);
    setState(() {
      _validationMessage = error ?? 'Balanced configuration ready.';
      if (error != null) {
        _preview = null;
      }
    });
  }

  void _generatePreview() {
    final error = AdvancedRules.validateConfiguration(_configuration);
    if (error != null) {
      setState(() {
        _validationMessage = error;
        _preview = null;
      });
      return;
    }
    final playerIds = List.generate(
      _playerCount,
      (index) => 'Player ${index + 1}',
    );
    setState(() {
      _validationMessage = 'Balanced role preview generated.';
      _preview = AdvancedRules.assignRoles(
        playerIds: playerIds,
        configuration: _configuration,
        random: Random(DateTime.now().microsecondsSinceEpoch),
      );
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
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Choose a game mode',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<GameMode>(
                    value: _mode,
                    decoration: const InputDecoration(
                      labelText: 'Game mode',
                      prefixIcon: Icon(Icons.sports_esports_rounded),
                    ),
                    items: GameMode.values
                        .map(
                          (mode) => DropdownMenuItem(
                            value: mode,
                            child: Text(_modeName(mode)),
                          ),
                        )
                        .toList(growable: false),
                    onChanged: (mode) {
                      if (mode != null) {
                        _setMode(mode);
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _modeDescription(_mode),
                    style: const TextStyle(color: Colors.white64, height: 1.4),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
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
                        _impostorCount = _impostorCount
                            .clamp(
                              1,
                              AdvancedRules.maximumImpostorsFor(_playerCount),
                            )
                            .toInt();
                        _resetOutput();
                      });
                    },
                  ),
                  Text(
                    'Impostor-side players: $_impostorCount',
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                  if (maxImpostors == 1)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        'This party size supports one balanced impostor-side player.',
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
                          _resetOutput();
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
          const SizedBox(height: 18),
          const Text(
            'Optional advanced roles',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 6),
          const Text(
            'Civilian and Classic Impostor are included automatically.',
            style: TextStyle(color: Colors.white64),
          ),
          const SizedBox(height: 8),
          for (final role in AdvancedRole.values.where(
            (role) => role != AdvancedRole.civilian &&
                role != AdvancedRole.impostor,
          ))
            SwitchListTile(
              value: _roles.contains(role),
              title: Text(_roleName(role)),
              subtitle: Text(_roleDescription(role)),
              onChanged: (enabled) {
                setState(() {
                  if (enabled) {
                    _roles.add(role);
                  } else {
                    _roles.remove(role);
                  }
                  _resetOutput();
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
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Private role preview',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 8),
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
          const SizedBox(height: 16),
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
                child: Text(
                  'This setup can validate and generate balanced advanced roles now. The advanced clue, ability, voting, and role-specific scoring screens are the next gameplay integration step; Classic remains the complete playable loop in this build.',
                  style: TextStyle(height: 1.45),
                ),
              ),
            ),
        ],
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
      return 'Players answer indirect questions instead of giving ordinary clues.';
    case GameMode.emojiClues:
      return 'Each clue must contain emoji without ordinary text.';
    case GameMode.speedRound:
      return 'Short clue deadlines punish hesitation.';
    case GameMode.anonymousClues:
      return 'Clue owners remain hidden until voting or round completion.';
    case GameMode.multipleImpostors:
      return 'Balanced player counts support more than one impostor-side role.';
    case GameMode.oneSentenceStory:
      return 'Every player adds one sentence that subtly references the word.';
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
      return 'May see the first submitted clue before giving a clue.';
    case AdvancedRole.doubleAgent:
      return 'Knows the real word but belongs to the impostor side.';
    case AdvancedRole.mrBlank:
      return 'Receives no word and may win with a correct final guess.';
    case AdvancedRole.saboteur:
      return 'Receives a related alternate word in Two Similar Words mode.';
    case AdvancedRole.trickster:
      return 'Wins by receiving enough votes without being eliminated.';
  }
}
