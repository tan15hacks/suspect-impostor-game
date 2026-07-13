import 'package:flutter/material.dart';

import '../../app/full_game_app.dart';
import '../../core/widgets/game_scaffold.dart';
import '../../data/achievements.dart';
import '../../data/curated_party_content.dart';
import '../../main.dart' show PartyGamePage;
import '../achievements/achievements_page.dart';
import '../content/content_library_page.dart';
import '../custom_packs/custom_packs_page.dart';
import '../modes/mode_setup_page.dart';
import '../settings/settings_page.dart';
import '../tutorial/tutorial_page.dart';

class FullHomePage extends StatelessWidget {
  const FullHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = FullGameScope.of(context);
    return GameScaffold(
      title: 'SUSPECT!',
      subtitle: 'Impostor Party',
      showBackButton: false,
      actions: [
        IconButton(
          tooltip: 'Settings',
          onPressed: () => _open(context, const SettingsPage()),
          icon: const Icon(Icons.settings_rounded),
        ),
      ],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6D5DFB), Color(0xFF9B4DCA)],
              ),
              borderRadius: BorderRadius.circular(28),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x446D5DFB),
                  blurRadius: 30,
                  offset: Offset(0, 14),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 28,
                      backgroundColor: Color(0xFFFFC857),
                      foregroundColor: Color(0xFF17111F),
                      child: Icon(Icons.visibility_rounded, size: 30),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.displayName,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Text(
                            '${controller.coins} coins • ${controller.customPacks.length} custom packs',
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                const Text(
                  'Find the liar before the liar finds the word.',
                  style: TextStyle(
                    fontSize: 28,
                    height: 1.08,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Play the complete offline Classic loop now, then configure advanced modes, roles, missions, chaos cards, and custom content.',
                  style: TextStyle(color: Colors.white70, height: 1.45),
                ),
                const SizedBox(height: 18),
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFFFC857),
                    foregroundColor: const Color(0xFF17111F),
                  ),
                  onPressed: () => _open(context, const PartyGamePage()),
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: const Text('Play Offline Classic'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              const CountPill(label: 'missions', value: '${secretMissions.length}'),
              const CountPill(label: 'chaos cards', value: '${chaosCards.length}'),
              const CountPill(label: 'achievements', value: '${achievements.length}'),
              CountPill(label: 'custom packs', value: '${controller.customPacks.length}'),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Build your party',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 12),
          ActionCard(
            icon: Icons.tune_rounded,
            title: 'Advanced Match Setup',
            subtitle: 'Configure all eight modes, seven roles, player balance, missions, and chaos cards.',
            onTap: () => _open(context, const ModeSetupPage()),
            accent: const Color(0xFFFFC857),
          ),
          const SizedBox(height: 12),
          ActionCard(
            icon: Icons.inventory_2_rounded,
            title: 'Custom Word Packs',
            subtitle: 'Create, validate, duplicate, delete, import, and export your own packs.',
            onTap: () => _open(context, const CustomPacksPage()),
            accent: const Color(0xFF14B8A6),
          ),
          const SizedBox(height: 12),
          ActionCard(
            icon: Icons.auto_awesome_rounded,
            title: 'Party Content Library',
            subtitle: 'Search the curated secret missions and compatible chaos cards.',
            onTap: () => _open(context, const ContentLibraryPage()),
            accent: const Color(0xFFEC4899),
          ),
          const SizedBox(height: 12),
          ActionCard(
            icon: Icons.emoji_events_rounded,
            title: 'Achievements',
            subtitle: 'Browse all tracked goals, hidden achievements, requirements, and coin rewards.',
            onTap: () => _open(context, const AchievementsPage()),
            accent: const Color(0xFFF59E0B),
          ),
          const SizedBox(height: 12),
          ActionCard(
            icon: Icons.school_rounded,
            title: 'How to Play',
            subtitle: 'Learn the clue, discussion, voting, defense, and impostor-guess flow.',
            onTap: () => _open(context, const TutorialPage()),
            accent: const Color(0xFF3B82F6),
          ),
          const SizedBox(height: 12),
          ActionCard(
            icon: Icons.settings_accessibility_rounded,
            title: 'Settings & Accessibility',
            subtitle: 'Adjust family safety, reduced motion, contrast, text size, haptics, and timer sounds.',
            onTap: () => _open(context, const SettingsPage()),
            accent: const Color(0xFFA855F7),
          ),
        ],
      ),
    );
  }

  void _open(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => page));
  }
}
