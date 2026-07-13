import 'package:flutter/material.dart';

class GameScaffold extends StatelessWidget {
  const GameScaffold({
    required this.title,
    required this.body,
    this.subtitle,
    this.actions,
    this.showBackButton = true,
    super.key,
  });

  final String title;
  final String? subtitle;
  final Widget body;
  final List<Widget>? actions;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: showBackButton,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
            if (subtitle != null)
              Text(
                subtitle!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white60,
                    ),
              ),
          ],
        ),
        actions: actions,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: false,
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0B1120),
              Color(0xFF1B1230),
              Color(0xFF0B1120),
            ],
          ),
        ),
        child: SafeArea(
          top: false,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 920),
                    child: body,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class ActionCard extends StatelessWidget {
  const ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.accent = const Color(0xFFFFC857),
    super.key,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '$title. $subtitle',
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: const Color(0xFF172033),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: accent.withOpacity(0.16),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: accent),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(color: Colors.white64, height: 1.35),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      ),
    );
  }
}

class CountPill extends StatelessWidget {
  const CountPill({required this.label, required this.value, super.key});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Text('$value $label'),
    );
  }
}
