import 'package:flutter/material.dart';

import '../features/home/full_home_page.dart';
import 'full_game_controller.dart';

class FullSuspectGameApp extends StatefulWidget {
  const FullSuspectGameApp({this.controller, super.key});

  final FullGameController? controller;

  @override
  State<FullSuspectGameApp> createState() => _FullSuspectGameAppState();
}

class _FullSuspectGameAppState extends State<FullSuspectGameApp> {
  late final FullGameController _controller;
  late final bool _ownsController;

  @override
  void initState() {
    super.initState();
    _ownsController = widget.controller == null;
    _controller = widget.controller ?? FullGameController();
  }

  @override
  void dispose() {
    if (_ownsController) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final highContrast = _controller.highContrast;
        return FullGameScope(
          controller: _controller,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Suspect! Impostor Party',
            theme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.dark,
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFFFFC857),
                brightness: Brightness.dark,
                contrastLevel: highContrast ? 1.0 : 0.35,
              ),
              scaffoldBackgroundColor: const Color(0xFF0B1120),
              cardTheme: CardThemeData(
                elevation: 0,
                color: highContrast
                    ? const Color(0xFF1B2638)
                    : const Color(0xFF172033),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                  side: BorderSide(
                    color: Colors.white.withOpacity(highContrast ? 0.30 : 0.08),
                  ),
                ),
              ),
              inputDecorationTheme: InputDecorationTheme(
                filled: true,
                fillColor: Colors.white.withOpacity(highContrast ? 0.12 : 0.06),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
              ),
              filledButtonTheme: FilledButtonThemeData(
                style: FilledButton.styleFrom(
                  minimumSize: const Size(48, 52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              outlinedButtonTheme: OutlinedButtonThemeData(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(48, 52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
            builder: (context, child) {
              final media = MediaQuery.of(context);
              return MediaQuery(
                data: media.copyWith(
                  textScaler: TextScaler.linear(
                    media.textScaler.scale(1) * _controller.textScale,
                  ),
                  disableAnimations: _controller.reducedMotion,
                ),
                child: child ?? const SizedBox.shrink(),
              );
            },
            home: const FullHomePage(),
          ),
        );
      },
    );
  }
}

class FullGameScope extends InheritedNotifier<FullGameController> {
  const FullGameScope({
    required FullGameController controller,
    required super.child,
    super.key,
  }) : super(notifier: controller);

  static FullGameController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<FullGameScope>();
    assert(scope != null, 'FullGameScope is missing above this context.');
    return scope!.notifier!;
  }
}
