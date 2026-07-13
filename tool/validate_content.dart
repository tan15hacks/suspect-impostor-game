import 'dart:io';

import 'package:suspect_impostor_game/data/achievements.dart';
import 'package:suspect_impostor_game/data/curated_party_content.dart';

void main() {
  final errors = <String>[];
  final warnings = <String>[];

  _validateUniqueIds(
    label: 'secret mission',
    ids: secretMissions.map((item) => item.id),
    errors: errors,
  );
  _validateUniqueIds(
    label: 'chaos card',
    ids: chaosCards.map((item) => item.id),
    errors: errors,
  );
  _validateUniqueIds(
    label: 'achievement',
    ids: achievements.map((item) => item.id),
    errors: errors,
  );

  if (secretMissions.length < 60) {
    errors.add('Expected at least 60 secret missions; found ${secretMissions.length}.');
  }
  if (chaosCards.length < 40) {
    errors.add('Expected at least 40 chaos cards; found ${chaosCards.length}.');
  }
  if (achievements.length < 40) {
    errors.add('Expected at least 40 achievements; found ${achievements.length}.');
  }

  final missionText = <String>{};
  for (final mission in secretMissions) {
    final normalized = _normalize(mission.text);
    if (!missionText.add(normalized)) {
      errors.add('Repeated secret mission text: ${mission.text}');
    }
    if (mission.minimumPlayers < 3 || mission.minimumPlayers > 12) {
      errors.add('Mission ${mission.id} has an invalid minimum player count.');
    }
    if (mission.text.length > 180) {
      warnings.add('Mission ${mission.id} may be too long for a reveal card.');
    }
  }

  final chaosDescriptions = <String>{};
  for (final card in chaosCards) {
    final normalized = _normalize(card.description);
    if (!chaosDescriptions.add(normalized)) {
      errors.add('Repeated chaos-card description: ${card.description}');
    }
    if (card.compatibleModes.isEmpty) {
      errors.add('Chaos card ${card.id} has no compatible mode.');
    }
    if (card.minimumPlayers < 3 || card.minimumPlayers > 12) {
      errors.add('Chaos card ${card.id} has an invalid minimum player count.');
    }
    if (card.resolution.trim().isEmpty) {
      errors.add('Chaos card ${card.id} has no resolution rule.');
    }
  }

  final achievementMetrics = <String>{};
  for (final achievement in achievements) {
    achievementMetrics.add(achievement.metric);
    if (achievement.requirement <= 0) {
      errors.add('Achievement ${achievement.id} has an invalid requirement.');
    }
    if (achievement.coinReward < 0) {
      errors.add('Achievement ${achievement.id} has a negative coin reward.');
    }
  }

  stdout.writeln('Suspect! content validation');
  stdout.writeln('Secret missions: ${secretMissions.length}');
  stdout.writeln('Chaos cards: ${chaosCards.length}');
  stdout.writeln('Achievements: ${achievements.length}');
  stdout.writeln('Tracked achievement metrics: ${achievementMetrics.length}');
  stdout.writeln('Warnings: ${warnings.length}');
  for (final warning in warnings) {
    stdout.writeln('WARNING: $warning');
  }
  stdout.writeln('Critical errors: ${errors.length}');
  for (final error in errors) {
    stderr.writeln('ERROR: $error');
  }

  if (errors.isNotEmpty) {
    exitCode = 1;
  }
}

void _validateUniqueIds({
  required String label,
  required Iterable<String> ids,
  required List<String> errors,
}) {
  final seen = <String>{};
  for (final id in ids) {
    if (id.trim().isEmpty) {
      errors.add('A $label has an empty identifier.');
    } else if (!seen.add(id)) {
      errors.add('Duplicate $label identifier: $id');
    }
  }
}

String _normalize(String value) {
  return value
      .trim()
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9\s]'), '')
      .replaceAll(RegExp(r'\s+'), ' ');
}
