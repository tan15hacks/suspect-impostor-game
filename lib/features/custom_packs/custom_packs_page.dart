import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/full_game_app.dart';
import '../../core/widgets/game_scaffold.dart';
import '../../domain/custom_pack.dart';

class CustomPacksPage extends StatelessWidget {
  const CustomPacksPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = FullGameScope.of(context);
    return GameScaffold(
      title: 'Custom Word Packs',
      subtitle: 'Private, offline, and fully validated',
      actions: [
        IconButton(
          tooltip: 'Create pack',
          onPressed: () => _openEditor(context),
          icon: const Icon(Icons.add_rounded),
        ),
      ],
      body: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          final packs = controller.customPacks;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Build your own category',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Enter one word per line. Add a curated Two Similar Words pair with “Main Word | Alternate Word”. Packs stay inside this running app and use the same validation rules as bundled content.',
                        style: TextStyle(color: Colors.white64, height: 1.45),
                      ),
                      const SizedBox(height: 14),
                      FilledButton.icon(
                        onPressed: () => _openEditor(context),
                        icon: const Icon(Icons.create_new_folder_rounded),
                        label: const Text('Create custom pack'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),
              if (packs.isEmpty)
                Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: const Color(0xFF172033),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white.withOpacity(0.08)),
                  ),
                  child: const Column(
                    children: [
                      Icon(Icons.inventory_2_outlined, size: 58, color: Colors.white54),
                      SizedBox(height: 12),
                      Text(
                        'No custom packs saved in this session',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Create a pack with at least six unique words to use the validator and JSON export.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white60),
                      ),
                    ],
                  ),
                )
              else
                for (final pack in packs) ...[
                  _PackCard(
                    pack: pack,
                    onEdit: () => _openEditor(context, existing: pack),
                    onDuplicate: () => controller.duplicatePack(pack.id),
                    onExport: () => _showExport(context, pack),
                    onDelete: () => _confirmDelete(context, pack),
                  ),
                  const SizedBox(height: 12),
                ],
            ],
          );
        },
      ),
    );
  }

  Future<void> _openEditor(
    BuildContext context, {
    CustomWordPack? existing,
  }) async {
    final pack = await Navigator.of(context).push<CustomWordPack>(
      MaterialPageRoute<CustomWordPack>(
        builder: (_) => CustomPackEditorPage(existing: existing),
      ),
    );
    if (pack != null && context.mounted) {
      FullGameScope.of(context).savePack(pack);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${pack.name} saved and validated.')),
      );
    }
  }

  Future<void> _confirmDelete(BuildContext context, CustomWordPack pack) async {
    final approved = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete custom pack?'),
        content: Text('“${pack.name}” and its ${pack.words.length} words will be removed.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (approved == true && context.mounted) {
      FullGameScope.of(context).deletePack(pack.id);
    }
  }

  Future<void> _showExport(BuildContext context, CustomWordPack pack) async {
    final json = pack.toPrettyJson();
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Export ${pack.name}'),
        content: SizedBox(
          width: 620,
          child: SingleChildScrollView(
            child: SelectableText(json, style: const TextStyle(fontFamily: 'monospace')),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          FilledButton.icon(
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: json));
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Pack JSON copied to clipboard.')),
                );
              }
            },
            icon: const Icon(Icons.copy_rounded),
            label: const Text('Copy JSON'),
          ),
        ],
      ),
    );
  }
}

class _PackCard extends StatelessWidget {
  const _PackCard({
    required this.pack,
    required this.onEdit,
    required this.onDuplicate,
    required this.onExport,
    required this.onDelete,
  });

  final CustomWordPack pack;
  final VoidCallback onEdit;
  final VoidCallback onDuplicate;
  final VoidCallback onExport;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final pairCount = pack.words.where((word) => word.alternateWord?.isNotEmpty ?? false).length;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Color(pack.colorValue),
                  child: const Icon(Icons.category_rounded, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pack.name,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                      ),
                      Text(
                        '${pack.words.length} words • $pairCount similar-word pairs • ${pack.language.toUpperCase()}',
                        style: const TextStyle(color: Colors.white60),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                OutlinedButton.icon(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit_rounded),
                  label: const Text('Edit'),
                ),
                OutlinedButton.icon(
                  onPressed: onDuplicate,
                  icon: const Icon(Icons.copy_all_rounded),
                  label: const Text('Duplicate'),
                ),
                OutlinedButton.icon(
                  onPressed: onExport,
                  icon: const Icon(Icons.ios_share_rounded),
                  label: const Text('Export'),
                ),
                TextButton.icon(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline_rounded),
                  label: const Text('Delete'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CustomPackEditorPage extends StatefulWidget {
  const CustomPackEditorPage({this.existing, super.key});

  final CustomWordPack? existing;

  @override
  State<CustomPackEditorPage> createState() => _CustomPackEditorPageState();
}

class _CustomPackEditorPageState extends State<CustomPackEditorPage> {
  late final TextEditingController _nameController;
  late final TextEditingController _wordsController;
  late String _language;
  late bool _familySafe;
  PackValidationResult? _validation;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _nameController = TextEditingController(text: existing?.name ?? '');
    _language = existing?.language ?? 'en';
    _familySafe = existing?.familySafe ?? true;
    _wordsController = TextEditingController(
      text: existing == null
          ? ''
          : existing.words
              .map((word) => word.alternateWord?.isNotEmpty ?? false
                  ? '${word.word} | ${word.alternateWord}'
                  : word.word)
              .join('\n'),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _wordsController.dispose();
    super.dispose();
  }

  CustomWordPack _buildPack() {
    final id = widget.existing?.id ?? 'pack-${DateTime.now().millisecondsSinceEpoch}';
    final imported = CustomPackValidator.importPlainText(_wordsController.text);
    return CustomWordPack(
      id: id,
      name: _nameController.text.trim(),
      language: _language,
      familySafe: _familySafe,
      colorValue: widget.existing?.colorValue ?? 0xFF6D5DFB,
      iconCodePoint: widget.existing?.iconCodePoint ?? Icons.category_rounded.codePoint,
      words: [
        for (var index = 0; index < imported.length; index++)
          CustomWordEntry(
            id: '$id-word-$index',
            word: imported[index].word,
            alternateWord: imported[index].alternateWord,
            enabled: imported[index].enabled,
          ),
      ],
      enabled: true,
    );
  }

  void _validate() {
    setState(() {
      _validation = CustomPackValidator.validate(_buildPack());
    });
  }

  void _save() {
    final pack = _buildPack();
    final validation = CustomPackValidator.validate(pack);
    setState(() => _validation = validation);
    if (!validation.isValid) {
      return;
    }
    Navigator.of(context).pop(pack);
  }

  @override
  Widget build(BuildContext context) {
    return GameScaffold(
      title: widget.existing == null ? 'Create Custom Pack' : 'Edit Custom Pack',
      subtitle: 'Plain text and curated similar-word pairs',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _nameController,
            maxLength: 40,
            decoration: const InputDecoration(
              labelText: 'Pack name',
              prefixIcon: Icon(Icons.inventory_2_rounded),
            ),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: _language,
            decoration: const InputDecoration(
              labelText: 'Language',
              prefixIcon: Icon(Icons.language_rounded),
            ),
            items: const [
              DropdownMenuItem(value: 'en', child: Text('English')),
              DropdownMenuItem(value: 'fil', child: Text('Filipino')),
              DropdownMenuItem(value: 'tgl', child: Text('Taglish')),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() => _language = value);
              }
            },
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            value: _familySafe,
            title: const Text('Family-safe pack'),
            subtitle: const Text('Marks the pack as suitable for general party sessions.'),
            onChanged: (value) => setState(() => _familySafe = value),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _wordsController,
            minLines: 12,
            maxLines: 24,
            decoration: const InputDecoration(
              alignLabelWithHint: true,
              labelText: 'Words — one entry per line',
              hintText: 'Adobo\nSinigang | Nilaga\nJeepney | Bus',
              helperText: 'Use “Main Word | Alternate Word” for curated similar-word pairs.',
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _validate,
                  icon: const Icon(Icons.fact_check_rounded),
                  label: const Text('Validate'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton.icon(
                  onPressed: _save,
                  icon: const Icon(Icons.save_rounded),
                  label: const Text('Save pack'),
                ),
              ),
            ],
          ),
          if (_validation != null) ...[
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      _validation!.isValid
                          ? 'Validation passed'
                          : '${_validation!.criticalCount} critical validation issue(s)',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: _validation!.isValid
                            ? const Color(0xFF5EEAD4)
                            : const Color(0xFFFF8A8A),
                      ),
                    ),
                    if (_validation!.issues.isEmpty)
                      const Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text('The pack is ready to save and export.'),
                      )
                    else
                      for (final issue in _validation!.issues)
                        ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(
                            issue.isCritical
                                ? Icons.error_outline_rounded
                                : Icons.info_outline_rounded,
                          ),
                          title: Text(issue.message),
                        ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
