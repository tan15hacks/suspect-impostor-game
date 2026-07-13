import 'package:flutter/material.dart';

import '../../core/widgets/game_scaffold.dart';
import '../../data/curated_party_content.dart';
import '../../domain/advanced_rules.dart';

class ContentLibraryPage extends StatefulWidget {
  const ContentLibraryPage({super.key});

  @override
  State<ContentLibraryPage> createState() => _ContentLibraryPageState();
}

class _ContentLibraryPageState extends State<ContentLibraryPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  GameMode? _modeFilter;
  bool? _impostorAlignedFilter;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  bool _matches(String value) {
    final query = _searchController.text.trim().toLowerCase();
    return query.isEmpty || value.toLowerCase().contains(query);
  }

  @override
  Widget build(BuildContext context) {
    final showingMissions = _tabController.index == 0;
    final missions = secretMissions.where((mission) {
      final alignmentMatches = _impostorAlignedFilter == null ||
          mission.impostorAligned == _impostorAlignedFilter;
      return alignmentMatches &&
          _matches('${mission.text} ${mission.verification} ${mission.id}');
    }).toList(growable: false);
    final cards = chaosCards.where((card) {
      final modeMatches = _modeFilter == null || card.compatibleModes.contains(_modeFilter);
      return modeMatches &&
          _matches('${card.name} ${card.description} ${card.resolution} ${card.id}');
    }).toList(growable: false);

    return GameScaffold(
      title: 'Party Content Library',
      subtitle: 'Curated missions and compatible chaos rules',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: 'Secret Missions (${secretMissions.length})'),
              Tab(text: 'Chaos Cards (${chaosCards.length})'),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _searchController,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              labelText: 'Search ${showingMissions ? 'missions' : 'chaos cards'}',
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: _searchController.text.isEmpty
                  ? null
                  : IconButton(
                      tooltip: 'Clear search',
                      onPressed: () {
                        _searchController.clear();
                        setState(() {});
                      },
                      icon: const Icon(Icons.clear_rounded),
                    ),
            ),
          ),
          const SizedBox(height: 12),
          if (showingMissions)
            SegmentedButton<bool?>(
              segments: const [
                ButtonSegment(value: null, label: Text('All')),
                ButtonSegment(value: true, label: Text('Impostor side')),
                ButtonSegment(value: false, label: Text('Civilian')),
              ],
              selected: {_impostorAlignedFilter},
              onSelectionChanged: (selection) {
                setState(() => _impostorAlignedFilter = selection.first);
              },
            )
          else
            DropdownButtonFormField<GameMode?>(
              value: _modeFilter,
              decoration: const InputDecoration(
                labelText: 'Compatible mode',
                prefixIcon: Icon(Icons.tune_rounded),
              ),
              items: [
                const DropdownMenuItem<GameMode?>(
                  value: null,
                  child: Text('All modes'),
                ),
                ...GameMode.values.map(
                  (mode) => DropdownMenuItem<GameMode?>(
                    value: mode,
                    child: Text(_modeName(mode)),
                  ),
                ),
              ],
              onChanged: (value) => setState(() => _modeFilter = value),
            ),
          const SizedBox(height: 18),
          if (showingMissions)
            if (missions.isEmpty)
              const _EmptyResults(message: 'No secret missions match these filters.')
            else
              for (final mission in missions) ...[
                Card(
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: CircleAvatar(
                      backgroundColor: mission.impostorAligned
                          ? const Color(0xFFB91C1C)
                          : const Color(0xFF6D5DFB),
                      child: Icon(
                        mission.impostorAligned
                            ? Icons.theater_comedy_rounded
                            : Icons.shield_rounded,
                      ),
                    ),
                    title: Text(
                      mission.text,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'Minimum ${mission.minimumPlayers} players • ${mission.verification}',
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ]
          else if (cards.isEmpty)
            const _EmptyResults(message: 'No chaos cards match these filters.')
          else
            for (final card in cards) ...[
              Card(
                child: ExpansionTile(
                  tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
                  leading: CircleAvatar(
                    backgroundColor: card.isPrivate
                        ? const Color(0xFF7C3AED)
                        : const Color(0xFFF59E0B),
                    child: Icon(
                      card.isPrivate ? Icons.lock_rounded : Icons.bolt_rounded,
                    ),
                  ),
                  title: Text(
                    card.name,
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                  subtitle: Text(card.description),
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          Chip(label: Text('Min ${card.minimumPlayers} players')),
                          Chip(label: Text(card.isPrivate ? 'Private effect' : 'Public effect')),
                          Chip(label: Text(card.duration)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Resolution: ${card.resolution}',
                        style: const TextStyle(height: 1.45),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Compatible: ${card.compatibleModes.map(_modeName).join(', ')}',
                        style: const TextStyle(color: Colors.white60),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
        ],
      ),
    );
  }

  static String _modeName(GameMode mode) {
    switch (mode) {
      case GameMode.classic:
        return 'Classic';
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
}

class _EmptyResults extends StatelessWidget {
  const _EmptyResults({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF172033),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Icon(Icons.search_off_rounded, size: 48, color: Colors.white54),
          const SizedBox(height: 8),
          Text(message, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
