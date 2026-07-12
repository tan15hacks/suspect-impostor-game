import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import 'game_engine.dart';

void main() {
  runApp(const SuspectPartyApp());
}

class SuspectPartyApp extends StatelessWidget {
  const SuspectPartyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Suspect! Impostor Party',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: const Color(0xFFFFC857),
        scaffoldBackgroundColor: Colors.transparent,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white.withOpacity(0.06),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      home: const PartyGamePage(),
    );
  }
}

enum GameStage {
  setup,
  roleReveal,
  clueRound,
  discussion,
  voting,
  tieBreaker,
  impostorGuess,
  roundResult,
  sessionResult,
}

class PartyGamePage extends StatefulWidget {
  const PartyGamePage({super.key});

  @override
  State<PartyGamePage> createState() => _PartyGamePageState();
}

class _PartyGamePageState extends State<PartyGamePage> {
  static const _wordBank = <String, List<String>>{
    'Filipino Favorites': [
      'Adobo',
      'Sinigang',
      'Jeepney',
      'Barangay',
      'Halo-halo',
      'Karaoke',
      'Fiesta',
      'Tricycle',
      'Taho',
      'Palengke',
      'Boodle Fight',
      'Videoke',
    ],
    'Food': [
      'Pizza',
      'Burger',
      'Spaghetti',
      'Pancake',
      'Ice Cream',
      'Popcorn',
      'Sandwich',
      'Chocolate',
      'French Fries',
      'Doughnut',
      'Fried Rice',
      'Hotdog',
    ],
    'School Life': [
      'Classroom',
      'Notebook',
      'Teacher',
      'Assignment',
      'Library',
      'Uniform',
      'Recess',
      'Exam',
      'Projector',
      'Graduation',
      'Classmate',
      'Backpack',
    ],
    'Technology': [
      'Smartphone',
      'Laptop',
      'Keyboard',
      'Wi-Fi',
      'Charger',
      'Headphones',
      'Password',
      'Webcam',
      'Tablet',
      'Bluetooth',
      'Screenshot',
      'Power Bank',
    ],
    'Places': [
      'Beach',
      'Airport',
      'Hospital',
      'Mall',
      'Playground',
      'Restaurant',
      'Museum',
      'Market',
      'Cinema',
      'Farm',
      'Waterfall',
      'Bus Station',
    ],
    'Games & Hobbies': [
      'Basketball',
      'Guitar',
      'Chess',
      'Painting',
      'Camping',
      'Dancing',
      'Cycling',
      'Fishing',
      'Badminton',
      'Gardening',
      'Photography',
      'Cooking',
    ],
  };

  final _random = Random();
  final _nameControllers = <TextEditingController>[
    TextEditingController(text: 'Player 1'),
    TextEditingController(text: 'Player 2'),
    TextEditingController(text: 'Player 3'),
  ];
  final _clueController = TextEditingController();
  final _guessController = TextEditingController();

  GameStage _stage = GameStage.setup;
  List<PartyPlayer> _players = const [];
  String _category = _wordBank.keys.first;
  int _totalRounds = 3;
  int _roundNumber = 1;
  String _secretWord = '';
  String _impostorId = '';
  int _revealIndex = 0;
  bool _roleVisible = false;
  bool _roleSeen = false;
  int _clueIndex = 0;
  Map<String, String> _clues = {};
  Timer? _discussionTimer;
  int _discussionRemaining = 45;
  int _voterIndex = 0;
  Map<String, String> _votes = {};
  Set<String>? _voteCandidateFilter;
  int _tieCount = 0;
  String? _eliminatedId;
  WinnerSide? _winner;
  bool _impostorGuessedWord = false;
  Map<String, List<String>> _scoreBreakdown = {};
  final _recentWords = <String>[];

  @override
  void dispose() {
    _discussionTimer?.cancel();
    for (final controller in _nameControllers) {
      controller.dispose();
    }
    _clueController.dispose();
    _guessController.dispose();
    super.dispose();
  }

  void _addPlayer() {
    if (_nameControllers.length >= 12) {
      _showMessage('A party can have at most 12 players.');
      return;
    }
    setState(() {
      _nameControllers.add(
        TextEditingController(text: 'Player ${_nameControllers.length + 1}'),
      );
    });
  }

  void _removePlayer(int index) {
    if (_nameControllers.length <= 3) {
      _showMessage('At least 3 players are required.');
      return;
    }
    setState(() {
      final controller = _nameControllers.removeAt(index);
      controller.dispose();
    });
  }

  void _startSession() {
    final names = _nameControllers
        .map((controller) => controller.text.trim())
        .toList(growable: false);
    final error = GameEngine.validatePlayerNames(names);
    if (error != null) {
      _showMessage(error);
      return;
    }
    _players = [
      for (var index = 0; index < names.length; index++)
        PartyPlayer(id: 'player-$index', name: names[index]),
    ];
    _roundNumber = 1;
    _recentWords.clear();
    _startRound();
  }

  void _startRound() {
    _discussionTimer?.cancel();
    final pool = _wordBank[_category]!;
    final available = pool
        .where((word) => !_recentWords.contains(word))
        .toList(growable: false);
    final candidates = available.isEmpty ? pool : available;
    final word = candidates[_random.nextInt(candidates.length)];
    _recentWords.add(word);
    if (_recentWords.length > pool.length - 2) {
      _recentWords.removeAt(0);
    }

    final assignment = GameEngine.assignClassicRoles(
      players: _players,
      secretWord: word,
      random: _random,
    );

    setState(() {
      _players = assignment.players;
      _secretWord = assignment.secretWord;
      _impostorId = assignment.impostorId;
      _stage = GameStage.roleReveal;
      _revealIndex = 0;
      _roleVisible = false;
      _roleSeen = false;
      _clueIndex = 0;
      _clues = {};
      _discussionRemaining = 45;
      _voterIndex = 0;
      _votes = {};
      _voteCandidateFilter = null;
      _tieCount = 0;
      _eliminatedId = null;
      _winner = null;
      _impostorGuessedWord = false;
      _scoreBreakdown = {};
      _clueController.clear();
      _guessController.clear();
    });
  }

  PartyPlayer get _revealingPlayer => _players[_revealIndex];
  PartyPlayer get _cluePlayer => _players[_clueIndex];
  PartyPlayer get _votingPlayer => _players[_voterIndex];

  void _markRoleVisible(bool visible) {
    setState(() {
      _roleVisible = visible;
      if (visible) {
        _roleSeen = true;
      }
    });
  }

  void _continueAfterRole() {
    if (!_roleSeen) {
      _showMessage('Hold the card first to view your role.');
      return;
    }
    setState(() {
      _roleVisible = false;
      _roleSeen = false;
      if (_revealIndex == _players.length - 1) {
        _stage = GameStage.clueRound;
        _clueIndex = 0;
      } else {
        _revealIndex += 1;
      }
    });
  }

  void _submitClue() {
    final clue = _clueController.text.trim();
    if (clue.isEmpty) {
      _showMessage('Enter a clue before continuing.');
      return;
    }
    if (clue.length > 40) {
      _showMessage('Keep clues to 40 characters or fewer.');
      return;
    }
    final isLastClue = _clueIndex == _players.length - 1;
    setState(() {
      _clues[_cluePlayer.id] = clue;
      _clueController.clear();
      if (!isLastClue) {
        _clueIndex += 1;
      }
    });
    if (isLastClue) {
      _startDiscussion();
    }
  }

  void _startDiscussion() {
    _discussionTimer?.cancel();
    setState(() {
      _stage = GameStage.discussion;
      _discussionRemaining = 45;
    });
    _discussionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_discussionRemaining <= 1) {
        timer.cancel();
        setState(() => _discussionRemaining = 0);
      } else {
        setState(() => _discussionRemaining -= 1);
      }
    });
  }

  void _beginVoting() {
    _discussionTimer?.cancel();
    setState(() {
      _stage = GameStage.voting;
      _voterIndex = 0;
      _votes = {};
    });
  }

  void _submitVote(String targetId) {
    final isLastVote = _voterIndex == _players.length - 1;
    setState(() {
      _votes[_votingPlayer.id] = targetId;
      if (!isLastVote) {
        _voterIndex += 1;
      }
    });
    if (isLastVote) {
      _finishVoting();
    }
  }

  void _finishVoting() {
    final result = GameEngine.countVotes(
      _votes,
      allowedTargets: _voteCandidateFilter,
    );
    if (result.leaders.isEmpty) {
      _showMessage('No valid votes were recorded.');
      return;
    }
    if (result.isTie && _tieCount == 0) {
      setState(() {
        _tieCount = 1;
        _voteCandidateFilter = result.leaders.toSet();
        _stage = GameStage.tieBreaker;
      });
      return;
    }

    final eliminatedId = result.isTie
        ? result.leaders[_random.nextInt(result.leaders.length)]
        : result.leaders.single;
    _resolveElimination(eliminatedId);
  }

  void _startTieBreakerVote() {
    setState(() {
      _stage = GameStage.voting;
      _voterIndex = 0;
      _votes = {};
    });
  }

  void _resolveElimination(String playerId) {
    final caughtImpostor = playerId == _impostorId;
    setState(() {
      _eliminatedId = playerId;
      if (caughtImpostor) {
        _stage = GameStage.impostorGuess;
      }
    });
    if (!caughtImpostor) {
      _completeRound(WinnerSide.impostor);
    }
  }

  void _submitImpostorGuess() {
    final guess = _guessController.text.trim();
    if (guess.isEmpty) {
      _showMessage('Enter a guess or choose “I do not know”.');
      return;
    }
    final correct = GameEngine.isCorrectGuess(guess, _secretWord);
    _impostorGuessedWord = correct;
    _completeRound(correct ? WinnerSide.impostor : WinnerSide.civilians);
  }

  void _completeRound(WinnerSide winner) {
    final scoring = GameEngine.scoreClassicRound(
      players: _players,
      winner: winner,
      impostorId: _impostorId,
      votes: _votes,
      eliminatedId: _eliminatedId ?? _impostorId,
      impostorGuessedWord: _impostorGuessedWord,
    );
    setState(() {
      _players = scoring.updatedPlayers;
      _scoreBreakdown = scoring.breakdown;
      _winner = winner;
      _stage = GameStage.roundResult;
    });
  }

  void _continueSession() {
    if (_roundNumber >= _totalRounds) {
      setState(() => _stage = GameStage.sessionResult);
      return;
    }
    _roundNumber += 1;
    _startRound();
  }

  void _returnToSetup() {
    _discussionTimer?.cancel();
    setState(() {
      _stage = GameStage.setup;
      _players = const [];
      _roundNumber = 1;
    });
  }

  String _playerName(String id) {
    return _players.firstWhere((player) => player.id == id).name;
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF111827),
              Color(0xFF241437),
              Color(0xFF101827),
            ],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 30),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 760),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildTopBar(),
                        const SizedBox(height: 18),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 260),
                          child: KeyedSubtree(
                            key: ValueKey(_stage),
                            child: _buildCurrentStage(),
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
      ),
    );
  }

  Widget _buildTopBar() {
    final inGame = _stage != GameStage.setup;
    return Row(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: const Color(0xFFFFC857),
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Icon(Icons.visibility_rounded, color: Color(0xFF17111F)),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'SUSPECT!',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.4,
                  fontSize: 22,
                ),
              ),
              Text(
                'Impostor Party',
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
        if (inGame)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text('Round $_roundNumber/$_totalRounds'),
          ),
      ],
    );
  }

  Widget _buildCurrentStage() {
    switch (_stage) {
      case GameStage.setup:
        return _buildSetup();
      case GameStage.roleReveal:
        return _buildRoleReveal();
      case GameStage.clueRound:
        return _buildClueRound();
      case GameStage.discussion:
        return _buildDiscussion();
      case GameStage.voting:
        return _buildVoting();
      case GameStage.tieBreaker:
        return _buildTieBreaker();
      case GameStage.impostorGuess:
        return _buildImpostorGuess();
      case GameStage.roundResult:
        return _buildRoundResult();
      case GameStage.sessionResult:
        return _buildSessionResult();
    }
  }

  Widget _panel({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFF1C2434).withOpacity(0.92),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
        boxShadow: const [
          BoxShadow(
            blurRadius: 36,
            offset: Offset(0, 18),
            color: Color(0x44000000),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _sectionTitle(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: const TextStyle(fontSize: 16, color: Colors.white70, height: 1.4),
        ),
      ],
    );
  }

  Widget _buildSetup() {
    return _panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _sectionTitle(
            'Find the impostor.',
            'Most players know the secret word. One player must bluff, survive the vote, or steal the win with a final guess.',
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: const [
              _FeaturePill(icon: Icons.people_alt_rounded, label: '3–12 players'),
              _FeaturePill(icon: Icons.wifi_off_rounded, label: 'Works offline'),
              _FeaturePill(icon: Icons.phone_android_rounded, label: 'One device'),
            ],
          ),
          const SizedBox(height: 28),
          DropdownButtonFormField<String>(
            value: _category,
            decoration: const InputDecoration(
              labelText: 'Word category',
              prefixIcon: Icon(Icons.category_rounded),
            ),
            items: _wordBank.keys
                .map(
                  (category) => DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  ),
                )
                .toList(growable: false),
            onChanged: (value) {
              if (value != null) {
                setState(() => _category = value);
              }
            },
          ),
          const SizedBox(height: 14),
          DropdownButtonFormField<int>(
            value: _totalRounds,
            decoration: const InputDecoration(
              labelText: 'Session length',
              prefixIcon: Icon(Icons.flag_rounded),
            ),
            items: const [1, 3, 5, 7]
                .map(
                  (rounds) => DropdownMenuItem(
                    value: rounds,
                    child: Text('$rounds round${rounds == 1 ? '' : 's'}'),
                  ),
                )
                .toList(growable: false),
            onChanged: (value) {
              if (value != null) {
                setState(() => _totalRounds = value);
              }
            },
          ),
          const SizedBox(height: 26),
          const Text(
            'Players',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          for (var index = 0; index < _nameControllers.length; index++) ...[
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: _avatarColor(index),
                  child: Text('${index + 1}'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _nameControllers[index],
                    maxLength: 18,
                    decoration: InputDecoration(
                      labelText: 'Player ${index + 1}',
                      counterText: '',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  tooltip: 'Remove player',
                  onPressed: () => _removePlayer(index),
                  icon: const Icon(Icons.remove_circle_outline_rounded),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
          OutlinedButton.icon(
            onPressed: _addPlayer,
            icon: const Icon(Icons.person_add_alt_1_rounded),
            label: const Text('Add player'),
          ),
          const SizedBox(height: 18),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 18),
            ),
            onPressed: _startSession,
            icon: const Icon(Icons.play_arrow_rounded),
            label: const Text('Start offline party'),
          ),
          const SizedBox(height: 12),
          const Text(
            'Playable web preview • Classic mode • English content',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white54, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleReveal() {
    final player = _revealingPlayer;
    final isImpostor = player.role == PlayerRole.impostor;
    return _panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _sectionTitle(
            'Pass to ${player.name}',
            'Make sure nobody else can see the screen. Press and hold the card to reveal the private role.',
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFFFC857).withOpacity(0.12),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFFFC857).withOpacity(0.35)),
            ),
            child: const Row(
              children: [
                Icon(Icons.shield_outlined, color: Color(0xFFFFC857)),
                SizedBox(width: 10),
                Expanded(
                  child: Text('Private screen: keep the phone close and release to hide.'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          Semantics(
            button: true,
            label: _roleVisible
                ? 'Private role is visible'
                : 'Press and hold to reveal private role',
            child: GestureDetector(
              onTapDown: (_) => _markRoleVisible(true),
              onTapUp: (_) => _markRoleVisible(false),
              onTapCancel: () => _markRoleVisible(false),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                constraints: const BoxConstraints(minHeight: 280),
                padding: const EdgeInsets.all(26),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: _roleVisible
                        ? isImpostor
                            ? const [Color(0xFFB91C1C), Color(0xFF5B1628)]
                            : const [Color(0xFF6D5DFB), Color(0xFF3B2D72)]
                        : const [Color(0xFF2A3448), Color(0xFF171E2B)],
                  ),
                  borderRadius: BorderRadius.circular(26),
                  border: Border.all(
                    color: _roleVisible
                        ? Colors.white.withOpacity(0.24)
                        : Colors.white.withOpacity(0.08),
                  ),
                ),
                child: _roleVisible
                    ? ExcludeSemantics(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              isImpostor
                                  ? Icons.theater_comedy_rounded
                                  : Icons.verified_user_rounded,
                              size: 68,
                            ),
                            const SizedBox(height: 18),
                            Text(
                              isImpostor ? 'YOU ARE THE IMPOSTOR' : 'YOU ARE A CIVILIAN',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 14),
                            if (isImpostor)
                              const Text(
                                'You do not know the word. Listen carefully, give a believable clue, and survive the vote.',
                                textAlign: TextAlign.center,
                                style: TextStyle(height: 1.4),
                              )
                            else ...[
                              const Text('SECRET WORD', style: TextStyle(color: Colors.white70)),
                              const SizedBox(height: 6),
                              Text(
                                _secretWord,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 38,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFFFFE08A),
                                ),
                              ),
                            ],
                          ],
                        ),
                      )
                    : const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.fingerprint_rounded, size: 72, color: Colors.white70),
                          SizedBox(height: 18),
                          Text(
                            'PRESS AND HOLD',
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Release anywhere to hide',
                            style: TextStyle(color: Colors.white60),
                          ),
                        ],
                      ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          FilledButton.icon(
            onPressed: _roleSeen ? _continueAfterRole : null,
            icon: const Icon(Icons.visibility_off_rounded),
            label: Text(
              _revealIndex == _players.length - 1
                  ? 'Hide and begin clue round'
                  : 'Hide and pass to next player',
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '${_revealIndex + 1} of ${_players.length} roles checked',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white54),
          ),
        ],
      ),
    );
  }

  Widget _buildClueRound() {
    final player = _cluePlayer;
    return _panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _sectionTitle(
            '${player.name}, give a clue',
            'Say one subtle clue aloud. Do not say the secret word or make the answer too obvious.',
          ),
          const SizedBox(height: 22),
          LinearProgressIndicator(value: (_clueIndex + 1) / _players.length),
          const SizedBox(height: 22),
          TextField(
            controller: _clueController,
            maxLength: 40,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _submitClue(),
            decoration: const InputDecoration(
              labelText: 'Type the clue for the clue board',
              hintText: 'A short, indirect clue',
              prefixIcon: Icon(Icons.lightbulb_outline_rounded),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: _submitClue,
            icon: const Icon(Icons.check_rounded),
            label: Text(
              _clueIndex == _players.length - 1
                  ? 'Submit and start discussion'
                  : 'Submit and pass the phone',
            ),
          ),
          if (_clues.isNotEmpty) ...[
            const SizedBox(height: 24),
            const Text(
              'Submitted clues',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final entry in _clues.entries)
                  Chip(label: Text('${_playerName(entry.key)}: ${entry.value}')),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDiscussion() {
    return _panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _sectionTitle(
            'Discuss and investigate',
            'Compare clues, defend yourself, and look for someone bluffing. Nobody may reveal the word directly.',
          ),
          const SizedBox(height: 22),
          Center(
            child: Container(
              width: 150,
              height: 150,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _discussionRemaining <= 10
                    ? const Color(0xFFB91C1C).withOpacity(0.28)
                    : const Color(0xFF6D5DFB).withOpacity(0.25),
                border: Border.all(
                  width: 5,
                  color: _discussionRemaining <= 10
                      ? const Color(0xFFFF6B6B)
                      : const Color(0xFF9B8CFF),
                ),
              ),
              child: Text(
                '$_discussionRemaining',
                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w900),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Clue board',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          for (final player in _players)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                backgroundColor: _avatarColor(_players.indexOf(player)),
                child: Text(player.name.characters.first.toUpperCase()),
              ),
              title: Text(player.name),
              subtitle: Text(_clues[player.id] ?? 'No clue'),
            ),
          const SizedBox(height: 14),
          FilledButton.icon(
            onPressed: _beginVoting,
            icon: const Icon(Icons.how_to_vote_rounded),
            label: Text(
              _discussionRemaining == 0 ? 'Time is up — start voting' : 'End discussion and vote',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVoting() {
    final voter = _votingPlayer;
    final candidates = _players.where((player) {
      if (player.id == voter.id) {
        return false;
      }
      final filter = _voteCandidateFilter;
      return filter == null || filter.contains(player.id);
    }).toList(growable: false);

    return _panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _sectionTitle(
            '${voter.name}, vote privately',
            _voteCandidateFilter == null
                ? 'Choose the player you believe is the impostor, then pass the phone.'
                : 'Tie-breaker vote: choose between the tied suspects.',
          ),
          const SizedBox(height: 22),
          LinearProgressIndicator(value: (_voterIndex + 1) / _players.length),
          const SizedBox(height: 22),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: candidates.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.sizeOf(context).width > 560 ? 3 : 2,
              childAspectRatio: 1.35,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemBuilder: (context, index) {
              final candidate = candidates[index];
              final playerIndex = _players.indexOf(candidate);
              return FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: _avatarColor(playerIndex).withOpacity(0.30),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () => _submitVote(candidate.id),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: _avatarColor(playerIndex),
                      child: Text(candidate.name.characters.first.toUpperCase()),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      candidate.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 14),
          Text(
            'Vote ${_voterIndex + 1} of ${_players.length}',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white54),
          ),
        ],
      ),
    );
  }

  Widget _buildTieBreaker() {
    final tied = _voteCandidateFilter!
        .map(_playerName)
        .toList(growable: false)
      ..sort();
    return _panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Icon(Icons.balance_rounded, size: 70, color: Color(0xFFFFC857)),
          const SizedBox(height: 18),
          _sectionTitle(
            'The vote is tied',
            '${tied.join(' and ')} received the same number of votes. Each player gets one final vote between the tied suspects.',
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.06),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Text(
              'If the second vote is also tied, the game performs a fair random elimination between the tied suspects so the round always continues.',
              style: TextStyle(height: 1.4),
            ),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: _startTieBreakerVote,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Begin tie-breaker vote'),
          ),
        ],
      ),
    );
  }

  Widget _buildImpostorGuess() {
    final impostor = _playerName(_impostorId);
    return _panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Icon(Icons.theater_comedy_rounded, size: 74, color: Color(0xFFFF6B6B)),
          const SizedBox(height: 18),
          _sectionTitle(
            '$impostor was the impostor!',
            'The civilians caught the impostor, but there is one final chance: guess the exact secret word to steal the victory.',
          ),
          const SizedBox(height: 22),
          TextField(
            controller: _guessController,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _submitImpostorGuess(),
            decoration: const InputDecoration(
              labelText: 'Final secret-word guess',
              prefixIcon: Icon(Icons.psychology_alt_rounded),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: _submitImpostorGuess,
            icon: const Icon(Icons.bolt_rounded),
            label: const Text('Lock in guess'),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {
              _impostorGuessedWord = false;
              _completeRound(WinnerSide.civilians);
            },
            child: const Text('I do not know'),
          ),
        ],
      ),
    );
  }

  Widget _buildRoundResult() {
    final civiliansWon = _winner == WinnerSide.civilians;
    final eliminated = _eliminatedId == null ? 'Nobody' : _playerName(_eliminatedId!);
    return _panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(
            civiliansWon ? Icons.shield_rounded : Icons.theater_comedy_rounded,
            size: 80,
            color: civiliansWon ? const Color(0xFF9B8CFF) : const Color(0xFFFF6B6B),
          ),
          const SizedBox(height: 14),
          Text(
            civiliansWon ? 'CIVILIANS WIN' : 'IMPOSTOR WINS',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          Text(
            'Secret word: $_secretWord • Eliminated: $eliminated',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 24),
          for (var index = 0; index < _players.length; index++)
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: _players[index].id == _impostorId
                      ? const Color(0xFFFF6B6B).withOpacity(0.55)
                      : Colors.white.withOpacity(0.05),
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: _avatarColor(index),
                    child: Text(_players[index].name.characters.first.toUpperCase()),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _players[index].name,
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                        Text(
                          _players[index].id == _impostorId ? 'Impostor' : 'Civilian',
                          style: const TextStyle(color: Colors.white60),
                        ),
                        Text(
                          (_scoreBreakdown[_players[index].id] ?? const []).join(' • '),
                          style: const TextStyle(fontSize: 12, color: Colors.white60),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${_players[index].score} pts',
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: _continueSession,
            icon: Icon(
              _roundNumber >= _totalRounds
                  ? Icons.emoji_events_rounded
                  : Icons.skip_next_rounded,
            ),
            label: Text(
              _roundNumber >= _totalRounds
                  ? 'View session results'
                  : 'Start next round',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionResult() {
    final ranking = [..._players]
      ..sort((a, b) {
        final scoreCompare = b.score.compareTo(a.score);
        return scoreCompare != 0 ? scoreCompare : a.name.compareTo(b.name);
      });
    final topScore = ranking.first.score;
    final champions = ranking
        .where((player) => player.score == topScore)
        .map((player) => player.name)
        .join(' & ');

    return _panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Icon(Icons.emoji_events_rounded, size: 86, color: Color(0xFFFFC857)),
          const SizedBox(height: 14),
          Text(
            champions,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900),
          ),
          const Text(
            'SESSION CHAMPION',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFFFFC857), letterSpacing: 1.4),
          ),
          const SizedBox(height: 26),
          for (var index = 0; index < ranking.length; index++)
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 4),
              leading: CircleAvatar(
                backgroundColor: index == 0
                    ? const Color(0xFFFFC857)
                    : Colors.white.withOpacity(0.10),
                foregroundColor: index == 0 ? const Color(0xFF17111F) : Colors.white,
                child: Text('${index + 1}'),
              ),
              title: Text(
                ranking[index].name,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
              trailing: Text(
                '${ranking[index].score} pts',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
              ),
            ),
          const SizedBox(height: 18),
          FilledButton.icon(
            onPressed: () {
              _roundNumber = 1;
              _players = _players
                  .map((player) => player.copyWith(score: 0, clearRole: true))
                  .toList(growable: false);
              _recentWords.clear();
              _startRound();
            },
            icon: const Icon(Icons.replay_rounded),
            label: const Text('Play again with same players'),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: _returnToSetup,
            icon: const Icon(Icons.edit_rounded),
            label: const Text('Edit party setup'),
          ),
        ],
      ),
    );
  }

  Color _avatarColor(int index) {
    const colors = [
      Color(0xFF6D5DFB),
      Color(0xFFFF6B6B),
      Color(0xFF14B8A6),
      Color(0xFFF59E0B),
      Color(0xFFEC4899),
      Color(0xFF3B82F6),
      Color(0xFF84CC16),
      Color(0xFFA855F7),
      Color(0xFFF97316),
      Color(0xFF06B6D4),
      Color(0xFFEAB308),
      Color(0xFF8B5CF6),
    ];
    return colors[index % colors.length];
  }
}

class _FeaturePill extends StatelessWidget {
  const _FeaturePill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.07),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: const Color(0xFFFFC857)),
          const SizedBox(width: 7),
          Text(label),
        ],
      ),
    );
  }
}
