# flutter_fader

[![pub package](https://img.shields.io/pub/v/flutter_fader.svg)](https://pub.dev/packages/flutter_fader)
[![codecov](https://codecov.io/gh/TNorbury/flutter-fader/branch/master/graph/badge.svg)](https://codecov.io/gh/TNorbury/flutter-fader)
[![style: effective dart](https://img.shields.io/badge/style-effective_dart-40c4ff.svg)](https://pub.dev/packages/effective_dart)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A widget for [Flutter](https://flutter.dev) that allows you to fade in and out a child widget.  
When a widget is faded out it is no longer in the view tree. Meaning that it can't be used or interacted with. Handy for hiding buttons.

![Example of fader with buttons](./readme_assets/fader_button.gif)
![Example of fader with scroll](./readme_assets/fader_scroll.gif)

## Getting started

In your Flutter project, add the package to your dependencies

```yml
dependencies:
  ...
  flutter_fader: ^1.0.4
```

## Usage example

Examples of how to use the widget, and that can also be ran on your device, can be found in the [example directory](https://github.com/TNorbury/flutter-fader/tree/master/example)

Import the fader package

```dart
import 'package:flutter_fader/flutter_fader.dart';
```

Create a fader controller, this allows you to control when the Fader fades in or out

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
