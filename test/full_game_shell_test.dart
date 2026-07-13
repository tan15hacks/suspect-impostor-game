import 'package:flutter_test/flutter_test.dart';
import 'package:suspect_impostor_game/app/full_game_app.dart';
import 'package:suspect_impostor_game/app/full_game_controller.dart';
import 'package:suspect_impostor_game/domain/custom_pack.dart';

void main() {
  testWidgets('full shell exposes playable and management navigation', (tester) async {
    await tester.pumpWidget(const FullSuspectGameApp());
    await tester.pumpAndSettle();

    expect(find.text('Play Offline Classic'), findsOneWidget);
    expect(find.text('Advanced Match Setup'), findsOneWidget);
    expect(find.text('Custom Word Packs'), findsOneWidget);
    expect(find.text('Achievements'), findsOneWidget);
    expect(find.text('How to Play'), findsOneWidget);
  });

  testWidgets('advanced setup opens and validates mode controls', (tester) async {
    await tester.pumpWidget(const FullSuspectGameApp());
    await tester.pumpAndSettle();

    final setupLink = find.text('Advanced Match Setup');
    await tester.ensureVisible(setupLink);
    await tester.tap(setupLink);
    await tester.pumpAndSettle();

    expect(find.text('Choose a game mode'), findsOneWidget);
    expect(find.text('Classic Impostor'), findsWidgets);
    expect(find.text('Two Similar Words'), findsOneWidget);

    final validateButton = find.text('Validate setup');
    await tester.ensureVisible(validateButton);
    await tester.tap(validateButton);
    await tester.pump();
    expect(find.text('Balanced configuration ready.'), findsOneWidget);
  });

  testWidgets('custom pack screen opens its functional editor', (tester) async {
    await tester.pumpWidget(const FullSuspectGameApp());
    await tester.pumpAndSettle();

    final packsLink = find.text('Custom Word Packs');
    await tester.ensureVisible(packsLink);
    await tester.tap(packsLink);
    await tester.pumpAndSettle();

    final createButton = find.text('Create custom pack');
    await tester.ensureVisible(createButton);
    await tester.tap(createButton);
    await tester.pumpAndSettle();

    expect(find.text('Create Custom Pack'), findsOneWidget);
    expect(find.text('Pack name'), findsOneWidget);
    expect(find.text('Words — one entry per line'), findsOneWidget);
    expect(find.text('Validate'), findsOneWidget);
    expect(find.text('Save pack'), findsOneWidget);
  });

  test('controller saves, duplicates, and deletes custom packs', () {
    final controller = FullGameController();
    const pack = CustomWordPack(
      id: 'pack-1',
      name: 'Food Pack',
      language: 'en',
      familySafe: true,
      colorValue: 0xFF6D5DFB,
      iconCodePoint: 0xe40a,
      words: [
        CustomWordEntry(id: '1', word: 'Pizza'),
        CustomWordEntry(id: '2', word: 'Burger'),
        CustomWordEntry(id: '3', word: 'Pasta'),
        CustomWordEntry(id: '4', word: 'Taco'),
        CustomWordEntry(id: '5', word: 'Donut'),
        CustomWordEntry(id: '6', word: 'Popcorn'),
      ],
    );

    controller.savePack(pack);
    expect(controller.customPacks, hasLength(1));

    controller.duplicatePack(pack.id);
    expect(controller.customPacks, hasLength(2));

    controller.deletePack(pack.id);
    expect(controller.customPacks, hasLength(1));
    controller.dispose();
  });
}
