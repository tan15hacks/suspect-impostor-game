import 'package:flutter/material.dart';

import '../../core/widgets/game_scaffold.dart';

class TutorialPage extends StatefulWidget {
  const TutorialPage({super.key});

  @override
  State<TutorialPage> createState() => _TutorialPageState();
}

class _TutorialPageState extends State<TutorialPage> {
  final PageController _pageController = PageController();
  int _index = 0;

  static const _steps = <({IconData icon, String title, String body, Color color})>[
    (
      icon: Icons.lock_rounded,
      title: '1. Receive a private role',
      body: 'Most players are civilians and see the same secret word. Impostor-side players receive different information and must keep it private.',
      color: Color(0xFF6D5DFB),
    ),
    (
      icon: Icons.lightbulb_rounded,
      title: '2. Give a subtle clue',
      body: 'Say something connected to the word without making it obvious. The impostor listens carefully and tries to sound believable.',
      color: Color(0xFFF59E0B),
    ),
    (
      icon: Icons.forum_rounded,
      title: '3. Discuss suspicious behavior',
      body: 'Compare clues, ask respectful questions, complete secret missions, and explain anything that made the group suspicious.',
      color: Color(0xFF14B8A6),
    ),
    (
      icon: Icons.how_to_vote_rounded,
      title: '4. Vote privately',
      body: 'Each player selects a suspect. Confidence can increase rewards for correct votes and penalties for confidently incorrect votes.',
      color: Color(0xFFEC4899),
    ),
    (
      icon: Icons.balance_rounded,
      title: '5. Resolve ties and defense',
      body: 'Tied suspects may give another clue or short defense before a second vote. The round always has a deterministic recovery path.',
      color: Color(0xFF3B82F6),
    ),
    (
      icon: Icons.theater_comedy_rounded,
      title: '6. Reveal and score',
      body: 'If the group eliminates an impostor, that player may get one final secret-word guess. The game then reveals roles, awards points, and continues the session.',
      color: Color(0xFFFF6B6B),
    ),
    (
      icon: Icons.bolt_rounded,
      title: '7. Advanced party rules',
      body: 'Optional missions, chaos cards, similar-word pairs, emoji clues, stories, special roles, and multiple impostors change the strategy while preserving fair balance rules.',
      color: Color(0xFFA855F7),
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _next() {
    if (_index >= _steps.length - 1) {
      Navigator.of(context).pop();
      return;
    }
    _pageController.nextPage(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GameScaffold(
      title: 'How to Play',
      subtitle: 'Complete round walkthrough',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 430,
            child: PageView.builder(
              controller: _pageController,
              itemCount: _steps.length,
              onPageChanged: (index) => setState(() => _index = index),
              itemBuilder: (context, index) {
                final step = _steps[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(28),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 112,
                            height: 112,
                            decoration: BoxDecoration(
                              color: step.color.withOpacity(0.18),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: step.color.withOpacity(0.65),
                                width: 3,
                              ),
                            ),
                            child: Icon(step.icon, size: 56, color: step.color),
                          ),
                          const SizedBox(height: 28),
                          Text(
                            step.title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            step.body,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var index = 0; index < _steps.length; index++)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: index == _index ? 28 : 9,
                  height: 9,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: index == _index
                        ? const Color(0xFFFFC857)
                        : Colors.white24,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _index == 0
                      ? null
                      : () => _pageController.previousPage(
                            duration: const Duration(milliseconds: 260),
                            curve: Curves.easeOutCubic,
                          ),
                  child: const Text('Back'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton.icon(
                  onPressed: _next,
                  icon: Icon(
                    _index == _steps.length - 1
                        ? Icons.check_rounded
                        : Icons.arrow_forward_rounded,
                  ),
                  label: Text(
                    _index == _steps.length - 1 ? 'Finish tutorial' : 'Next',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
