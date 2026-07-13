import 'package:flutter/material.dart';

import '../../app/full_game_app.dart';
import '../../core/widgets/game_scaffold.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TextEditingController? _nameController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _nameController ??= TextEditingController(
      text: FullGameScope.of(context).displayName,
    );
  }

  @override
  void dispose() {
    _nameController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = FullGameScope.of(context);
    return GameScaffold(
      title: 'Settings & Accessibility',
      subtitle: 'Readable, comfortable, and family-safe defaults',
      body: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _SectionTitle('Profile'),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        controller: _nameController,
                        maxLength: 18,
                        decoration: const InputDecoration(
                          labelText: 'Local display name',
                          prefixIcon: Icon(Icons.person_rounded),
                        ),
                      ),
                      const SizedBox(height: 8),
                      FilledButton.icon(
                        onPressed: () {
                          controller.updateDisplayName(_nameController!.text);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Local profile name updated.')),
                          );
                        },
                        icon: const Icon(Icons.save_rounded),
                        label: const Text('Save profile name'),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: controller.language,
                        decoration: const InputDecoration(
                          labelText: 'Interface language',
                          prefixIcon: Icon(Icons.language_rounded),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'English', child: Text('English')),
                          DropdownMenuItem(value: 'Filipino', child: Text('Filipino')),
                          DropdownMenuItem(value: 'Taglish', child: Text('Taglish')),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            controller.updateLanguage(value);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),
              const _SectionTitle('Gameplay'),
              Card(
                child: Column(
                  children: [
                    SwitchListTile(
                      value: controller.familySafe,
                      title: const Text('Family-safe mode'),
                      subtitle: const Text('Prefer content marked suitable for general audiences.'),
                      onChanged: controller.updateFamilySafe,
                    ),
                    const Divider(height: 1),
                    SwitchListTile(
                      value: controller.haptics,
                      title: const Text('Haptic feedback'),
                      subtitle: const Text('Use restrained vibration for reveals, votes, and results.'),
                      onChanged: controller.updateHaptics,
                    ),
                    const Divider(height: 1),
                    SwitchListTile(
                      value: controller.timerSounds,
                      title: const Text('Timer sounds'),
                      subtitle: const Text('Play audible warning cues near countdown deadlines.'),
                      onChanged: controller.updateTimerSounds,
                    ),
                    const Divider(height: 1),
                    SwitchListTile(
                      value: controller.confirmBeforeLeaving,
                      title: const Text('Confirm before leaving'),
                      subtitle: const Text('Ask before exiting an active private match.'),
                      onChanged: controller.updateConfirmBeforeLeaving,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              const _SectionTitle('Accessibility'),
              Card(
                child: Column(
                  children: [
                    SwitchListTile(
                      value: controller.reducedMotion,
                      title: const Text('Reduced motion'),
                      subtitle: const Text('Disable nonessential transitions and dramatic movement.'),
                      onChanged: controller.updateReducedMotion,
                    ),
                    const Divider(height: 1),
                    SwitchListTile(
                      value: controller.highContrast,
                      title: const Text('High contrast'),
                      subtitle: const Text('Increase color separation and border visibility.'),
                      onChanged: controller.updateHighContrast,
                    ),
                    const Divider(height: 1),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Text size: ${(controller.textScale * 100).round()}%',
                            style: const TextStyle(fontWeight: FontWeight.w800),
                          ),
                          Slider(
                            min: 0.9,
                            max: 1.35,
                            divisions: 9,
                            value: controller.textScale,
                            label: '${(controller.textScale * 100).round()}%',
                            onChanged: controller.updateTextScale,
                          ),
                          const Text(
                            'Important statuses use icons and text in addition to color. Secret roles remain excluded from accessibility labels until intentionally revealed.',
                            style: TextStyle(color: Colors.white60, height: 1.4),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              const _SectionTitle('Diagnostics'),
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _DiagnosticRow(
                        icon: Icons.storage_rounded,
                        label: 'Local app controller',
                        status: 'Available',
                      ),
                      _DiagnosticRow(
                        icon: Icons.cloud_off_rounded,
                        label: 'Firebase private rooms',
                        status: 'Not connected in this web slice',
                      ),
                      _DiagnosticRow(
                        icon: Icons.ad_units_rounded,
                        label: 'Ads and Play Billing',
                        status: 'Requires Android console configuration',
                      ),
                      _DiagnosticRow(
                        icon: Icons.web_rounded,
                        label: 'Build target',
                        status: 'Flutter Web full shell',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
      ),
    );
  }
}

class _DiagnosticRow extends StatelessWidget {
  const _DiagnosticRow({
    required this.icon,
    required this.label,
    required this.status,
  });

  final IconData icon;
  final String label;
  final String status;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFFFFC857)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontWeight: FontWeight.w800)),
                Text(status, style: const TextStyle(color: Colors.white60)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
