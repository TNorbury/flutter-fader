# flutter_fader

A widget for [Flutter](https://flutter.dev) that allows you to fade in and out child widgets.  
When a widget is faded out it is no longer in the view tree. Meaning that it can't be used or interacted with. Handy for hiding buttons

## Getting started

In your Flutter project, add this package to your dependencies

```yml
dependencies:
  ...
  flutter_fader: ^1.0.0
```

## Usage example

Examples that show complete usage, and can also be ran on your device, go to the [examples directory](https://github.com/TNorbury/flutter-fader/tree/master/examples)

Import the fader package

```dart
import 'package:flutter_test/flutter_test.dart';
```

Create a fader controller

```dart
FaderController faderController = new FaderController();
```

Create a fader widget, and pass it the fader controller
```dart
Fader(
  controller: faderController,
  duration: const Duration(milliseconds: 50),
  child: Text("Hello, world!"),
)
```

Now you can fade the child widget in and out at will
```dart
faderController.fadeOut();
faderController.fadeIn();
```
