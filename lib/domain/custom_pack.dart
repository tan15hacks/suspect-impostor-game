import 'dart:convert';

class CustomWordEntry {
  const CustomWordEntry({
    required this.id,
    required this.word,
    this.alternateWord,
    this.enabled = true,
  });

  final String id;
  final String word;
  final String? alternateWord;
  final bool enabled;

  Map<String, Object?> toJson() => {
        'id': id,
        'word': word,
        'alternateWord': alternateWord,
        'enabled': enabled,
      };

  factory CustomWordEntry.fromJson(Map<String, Object?> json) {
    return CustomWordEntry(
      id: json['id'] as String,
      word: json['word'] as String,
      alternateWord: json['alternateWord'] as String?,
      enabled: json['enabled'] as bool? ?? true,
    );
  }
}

class CustomWordPack {
  const CustomWordPack({
    required this.id,
    required this.name,
    required this.language,
    required this.familySafe,
    required this.colorValue,
    required this.iconCodePoint,
    required this.words,
    this.enabled = true,
  });

  final String id;
  final String name;
  final String language;
  final bool familySafe;
  final int colorValue;
  final int iconCodePoint;
  final List<CustomWordEntry> words;
  final bool enabled;

  Map<String, Object?> toJson() => {
        'format': 'suspect-custom-pack',
        'version': 1,
        'id': id,
        'name': name,
        'language': language,
        'familySafe': familySafe,
        'colorValue': colorValue,
        'iconCodePoint': iconCodePoint,
        'enabled': enabled,
        'words': words.map((word) => word.toJson()).toList(growable: false),
      };

  String toPrettyJson() => const JsonEncoder.withIndent('  ').convert(toJson());

  factory CustomWordPack.fromJson(Map<String, Object?> json) {
    if (json['format'] != 'suspect-custom-pack' || json['version'] != 1) {
      throw const FormatException('Unsupported custom-pack format.');
    }
    final rawWords = json['words'];
    if (rawWords is! List<Object?>) {
      throw const FormatException('Custom pack has no valid word list.');
    }
    return CustomWordPack(
      id: json['id'] as String,
      name: json['name'] as String,
      language: json['language'] as String,
      familySafe: json['familySafe'] as bool? ?? true,
      colorValue: json['colorValue'] as int? ?? 0xFF6D5DFB,
      iconCodePoint: json['iconCodePoint'] as int? ?? 0xe40a,
      enabled: json['enabled'] as bool? ?? true,
      words: rawWords
          .map((word) => CustomWordEntry.fromJson(
                Map<String, Object?>.from(word! as Map),
              ))
          .toList(growable: false),
    );
  }

  factory CustomWordPack.fromJsonString(String source) {
    final decoded = jsonDecode(source);
    if (decoded is! Map<String, Object?>) {
      throw const FormatException('Custom pack must be a JSON object.');
    }
    return CustomWordPack.fromJson(decoded);
  }
}

class PackValidationIssue {
  const PackValidationIssue({
    required this.code,
    required this.message,
    required this.isCritical,
  });

  final String code;
  final String message;
  final bool isCritical;
}

class PackValidationResult {
  const PackValidationResult(this.issues);

  final List<PackValidationIssue> issues;

  bool get isValid => issues.every((issue) => !issue.isCritical);
  int get criticalCount => issues.where((issue) => issue.isCritical).length;
}

class CustomPackValidator {
  const CustomPackValidator._();

  static PackValidationResult validate(CustomWordPack pack) {
    final issues = <PackValidationIssue>[];
    final name = pack.name.trim();
    if (name.isEmpty) {
      issues.add(const PackValidationIssue(
        code: 'empty_name',
        message: 'Pack name cannot be empty.',
        isCritical: true,
      ));
    }
    if (name.length > 40) {
      issues.add(const PackValidationIssue(
        code: 'long_name',
        message: 'Pack name must be 40 characters or fewer.',
        isCritical: true,
      ));
    }
    if (!{'en', 'fil', 'tgl'}.contains(pack.language)) {
      issues.add(const PackValidationIssue(
        code: 'invalid_language',
        message: 'Language must be English, Filipino, or Taglish.',
        isCritical: true,
      ));
    }
    if (pack.words.where((word) => word.enabled).length < 6) {
      issues.add(const PackValidationIssue(
        code: 'small_pool',
        message: 'Add at least 6 enabled words for reliable play.',
        isCritical: true,
      ));
    }

    final ids = <String>{};
    final normalizedWords = <String>{};
    for (var index = 0; index < pack.words.length; index++) {
      final entry = pack.words[index];
      final position = index + 1;
      if (!ids.add(entry.id)) {
        issues.add(PackValidationIssue(
          code: 'duplicate_id',
          message: 'Word $position has a duplicate identifier.',
          isCritical: true,
        ));
      }
      final trimmed = entry.word.trim();
      if (trimmed.isEmpty) {
        issues.add(PackValidationIssue(
          code: 'empty_word',
          message: 'Word $position is empty.',
          isCritical: true,
        ));
        continue;
      }
      if (entry.word != trimmed) {
        issues.add(PackValidationIssue(
          code: 'outer_whitespace',
          message: '“${entry.word}” has leading or trailing spaces.',
          isCritical: false,
        ));
      }
      if (trimmed.length > 48) {
        issues.add(PackValidationIssue(
          code: 'long_word',
          message: '“$trimmed” is longer than 48 characters.',
          isCritical: true,
        ));
      }
      final normalized = _normalize(trimmed);
      if (!normalizedWords.add(normalized)) {
        issues.add(PackValidationIssue(
          code: 'duplicate_word',
          message: '“$trimmed” duplicates another word in the pack.',
          isCritical: true,
        ));
      }

      final alternate = entry.alternateWord?.trim();
      if (alternate != null && alternate.isNotEmpty) {
        if (_normalize(alternate) == normalized) {
          issues.add(PackValidationIssue(
            code: 'self_pair',
            message: '“$trimmed” cannot be paired with itself.',
            isCritical: true,
          ));
        }
        if (alternate.length > 48) {
          issues.add(PackValidationIssue(
            code: 'long_alternate',
            message: 'The alternate word paired with “$trimmed” is too long.',
            isCritical: true,
          ));
        }
      }
    }

    return PackValidationResult(List.unmodifiable(issues));
  }

  static List<CustomWordEntry> importPlainText(String text) {
    final entries = <CustomWordEntry>[];
    final seen = <String>{};
    final lines = const LineSplitter().convert(text);
    for (final rawLine in lines) {
      final line = rawLine.trim();
      if (line.isEmpty || line.startsWith('#')) {
        continue;
      }
      final parts = line.split('|').map((value) => value.trim()).toList();
      final word = parts.first;
      final normalized = _normalize(word);
      if (normalized.isEmpty || !seen.add(normalized)) {
        continue;
      }
      entries.add(CustomWordEntry(
        id: 'custom-${entries.length + 1}',
        word: word,
        alternateWord: parts.length > 1 && parts[1].isNotEmpty ? parts[1] : null,
      ));
    }
    return List.unmodifiable(entries);
  }

  static String _normalize(String value) {
    return value
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9\u00c0-\u024f\s-]'), '')
        .replaceAll(RegExp(r'\s+'), ' ');
  }
}
