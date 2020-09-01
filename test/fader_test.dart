import 'package:flutter/material.dart';
import 'package:flutter_fader/flutter_fader.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Verify that the fader builds and displays the child widget',
      (tester) async {
    var _faderController = FaderController();
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
    var faderController = FaderController();
    final fader = Fader(
      controller: faderController,
      duration: const Duration(milliseconds: 50),
      child: Text("Test!"),
    );

    final app = TestApp(
      fader: fader,
    );

    await tester.pumpWidget(app);

    // Now tell the controller to fade out, and wait for the animation to finish
    faderController.fadeOut();
    await tester.pumpAndSettle(const Duration(milliseconds: 300));

    // Verify that the test isn't displayed
    final textFinder = find.text("Test!");
    expect(textFinder, findsNothing);
  });

  testWidgets("Verify that the fader fades in", (WidgetTester tester) async {
    var faderController = FaderController();
    final fader = Fader(
      controller: faderController,
      duration: const Duration(milliseconds: 50),
      child: Text("Test!"),
    );

    final app = TestApp(
      fader: fader,
    );

    await tester.pumpWidget(app);

    // Now tell the controller to fade out
    faderController.fadeOut();
    await tester.pumpAndSettle(const Duration(milliseconds: 300));

    // And tell it to fade back in
    faderController.fadeIn();
    await tester.pumpAndSettle(const Duration(milliseconds: 300));

    // Verify that the test text is displayed
    final textFinder = find.text("Test!");
    expect(textFinder, findsOneWidget);
  });

  testWidgets(
    "Child widget shouldn't be visible if startVisible is false",
    (WidgetTester tester) async {
      var faderController = FaderController();
      final fader = Fader(
        controller: faderController,
        duration: const Duration(milliseconds: 50),
        startVisible: false,
        child: Text("Test!"),
      );

      final app = TestApp(
        fader: fader,
      );

      // Nothing'll be displayed initially
      await tester.pumpWidget(app);
      expect(find.text("Test!"), findsNothing);

      faderController.fadeIn();
      await tester.pumpAndSettle();
      expect(find.text("Test!"), findsOneWidget);
    },
  );

  test(
    "The controller shouldn't be usable after being disposed",
    () {
      // Create a controller, then dispose it.
      var faderController = FaderController();
      faderController.dispose();

      // Call all the methods of the controller, they should all throw
      // exceptions
      expect(() => faderController.fadeIn(), throwsException);
      expect(() => faderController.fadeOut(), throwsException);
      expect(() => faderController.addListener(null), throwsException);
      expect(() => faderController.removeListener(null), throwsException);
    },
  );
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
