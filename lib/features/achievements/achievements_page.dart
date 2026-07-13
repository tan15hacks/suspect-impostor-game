import 'package:flutter/material.dart';

import '../../app/full_game_app.dart';
import '../../core/widgets/game_scaffold.dart';
import '../../data/achievements.dart';

class AchievementsPage extends StatefulWidget {
  const AchievementsPage({super.key});

  @override
  State<AchievementsPage> createState() => _AchievementsPageState();
}

class _AchievementsPageState extends State<AchievementsPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _showHidden = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = FullGameScope.of(context);
    final query = _searchController.text.trim().toLowerCase();
    final filtered = achievements.where((achievement) {
      if (!_showHidden && achievement.hidden &&
          !controller.unlockedAchievements.contains(achievement.id)) {
        return false;
      }
      return query.isEmpty ||
          achievement.name.toLowerCase().contains(query) ||
          achievement.description.toLowerCase().contains(query) ||
          achievement.metric.toLowerCase().contains(query);
    }).toList(growable: false);

    return GameScaffold(
      title: 'Achievements',
      subtitle: '${controller.unlockedAchievements.length} of ${achievements.length} unlocked',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: Color(0xFFF59E0B),
                        foregroundColor: Color(0xFF17111F),
                        child: Icon(Icons.emoji_events_rounded),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '${controller.unlockedAchievements.length}/${achievements.length} unlocked',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                        ),
                      ),
                      Text('${controller.coins} coins'),
                    ],
                  ),
                  const SizedBox(height: 14),
                  LinearProgressIndicator(
                    value: achievements.isEmpty
                        ? 0
                        : controller.unlockedAchievements.length / achievements.length,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Achievements are defined against real gameplay metrics. The current Classic preview does not yet write persistent progress, so this screen honestly shows only recorded unlocks from the full-game controller.',
                    style: TextStyle(color: Colors.white64, height: 1.4),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _searchController,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(
              labelText: 'Search achievements',
              prefixIcon: Icon(Icons.search_rounded),
            ),
          ),
          SwitchListTile(
            value: _showHidden,
            title: const Text('Show locked hidden achievements'),
            subtitle: const Text('Hidden names remain concealed until they are earned.'),
            onChanged: (value) => setState(() => _showHidden = value),
          ),
          const SizedBox(height: 8),
          if (filtered.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: Text('No achievements match this search.')),
              ),
            )
          else
            for (final achievement in filtered) ...[
              _AchievementCard(
                achievement: achievement,
                unlocked: controller.unlockedAchievements.contains(achievement.id),
              ),
              const SizedBox(height: 10),
            ],
        ],
      ),
    );
  }
}

class _AchievementCard extends StatelessWidget {
  const _AchievementCard({required this.achievement, required this.unlocked});

  final AchievementDefinition achievement;
  final bool unlocked;

  @override
  Widget build(BuildContext context) {
    final concealed = achievement.hidden && !unlocked;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: unlocked
                  ? const Color(0xFFF59E0B)
                  : Colors.white.withOpacity(0.08),
              foregroundColor: unlocked ? const Color(0xFF17111F) : Colors.white54,
              child: Icon(
                concealed
                    ? Icons.help_outline_rounded
                    : unlocked
                        ? Icons.emoji_events_rounded
                        : Icons.lock_outline_rounded,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    concealed ? 'Hidden Achievement' : achievement.name,
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    concealed
                        ? 'Complete its secret requirement to reveal this achievement.'
                        : achievement.description,
                    style: const TextStyle(color: Colors.white64, height: 1.35),
                  ),
                  if (!concealed) ...[
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        Chip(label: Text('Goal: ${achievement.requirement}')),
                        Chip(label: Text('${achievement.coinReward} coins')),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
