import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fader/fader.dart';

void main() {
  testWidgets('Verify that the fader builds and displays the child widget',
      (WidgetTester tester) async {
    FaderController _faderController = new FaderController();
    final fader = Fader(
      controller: _faderController,
      duration: const Duration(milliseconds: 250),
      child: Text("Test!"),
    );

    final app = TestApp(
      fader: fader,
    );

    // pump the widget so that it exists
    await tester.pumpWidget(app);
    expect(fader != null, true);

    // Verify that the test is displayed
    final textFinder = find.text("Test!");
    expect(textFinder, findsOneWidget);
  });

  testWidgets("Verify that the fader fades out", (WidgetTester tester) async {
    FaderController _faderController = new FaderController();
    final fader = Fader(
      controller: _faderController,
      duration: const Duration(milliseconds: 50),
      child: Text("Test!"),
    );

    final app = TestApp(
      fader: fader,
    );

    await tester.pumpWidget(app);

    // Now tell the controller to fade out, and wait for the animation to finish
    _faderController.fadeOut();
    await tester.pumpAndSettle(const Duration(milliseconds: 300));

    // Verify that the test isn't displayed
    final textFinder = find.text("Test!");
    expect(textFinder, findsNothing);
  });

  testWidgets("Verify that the fader fades in", (WidgetTester tester) async {
    FaderController _faderController = new FaderController();
    final fader = Fader(
      controller: _faderController,
      duration: const Duration(milliseconds: 50),
      child: Text("Test!"),
    );

    final app = TestApp(
      fader: fader,
    );

    await tester.pumpWidget(app);

    // Now tell the controller to fade out
    _faderController.fadeOut();
    await tester.pumpAndSettle(const Duration(milliseconds: 300));

    // And tell it to fade back in
    _faderController.fadeIn();
    await tester.pumpAndSettle(const Duration(milliseconds: 300));

    // Verify that the test text is displayed
    final textFinder = find.text("Test!");
    expect(textFinder, findsOneWidget);
  });
}

/// This is being used so that we can give the fader somewhere to live
class TestApp extends StatelessWidget {
  final Fader _fader;

  const TestApp({Key key, @required fader})
      : _fader = fader,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        body: Center(
          child: Column(
            children: <Widget>[
              _fader,
            ],
          ),
        ),
      ),
    );
  }
}
