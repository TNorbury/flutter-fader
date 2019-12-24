import 'package:flutter/material.dart';

/// Class that utilizies both [AnimatedOpacity] and [Visibility] to allow a widget
/// to fade out, and then be hidden (so that it can't be interacted with)
class Fader extends StatefulWidget {
  final Widget _child;
  final Duration _duration;
  final FaderController _controller;
  final Curve _curve;

  /// [Widget] [child] The widget that will be faded in and out
  /// [Duration] [duration] How long the fade out animation should last
  /// [FaderController] [controller] The controller that'll be used to fade
  /// the child widget in and out
  /// [Curve] [curve]
  Fader({
    Key key,
    @required Widget child,
    @required duration,
    @required FaderController controller,
    Curve curve = Curves.linear,
  })  : _child = child,
        _duration = duration,
        _controller = controller,
        _curve = curve,
        super(key: key);

  @override
  _FaderState createState() => _FaderState();
}

class _FaderState extends State<Fader> {
  bool _visible = true;
  double _opacity = 1.0;

  FadeState _currentFadeState;

  // Fading in has to be done in two parts so that the fade in animation actually
  // works and the widget doesn't just appear on screen.
  // First step is to make the widget visible again, second step is to fade the opacity
  // from 0 to 1.
  bool _fadeInStepOneDone = false;

  @override
  void initState() {
    // listen to the controller
    widget._controller.addListener(_fade);

    super.initState();
  }

  @override
  void dispose() {
    widget._controller.removeListener(_fade);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // If the widget has been set to visible again, but has yet to be faded back in
    // then we'll add a post frame call back so that we can set the opactiy
    if (_currentFadeState == FadeState.FadeIn &&
        _visible == true &&
        _opacity == 0.0) {
      WidgetsBinding.instance.addPostFrameCallback(_fadeInCallback);
    }

    return Visibility(
      visible: _visible,
      child: AnimatedOpacity(
        opacity: _opacity,
        duration: widget._duration,
        curve: widget._curve
        child: widget._child,
        onEnd: () {
          // If we're finished fading out, then we'll turn off visibility
          if (_opacity == 0.0) {
            _visible = false;
          }
        },
      ),
    );
  }

  void _fade(FadeState fadeState) {
    setState(() {
      // If we're fading out, then set the opacity to 0 (clear). The visibility
      // will be handled when the
      if (fadeState == FadeState.FadeOut) {
        _opacity = 0.0;
        _fadeInStepOneDone = false;
      }

      // Otherwise, if we're fading in, then make our child visible, and then make
      // it opaque.
      else if (fadeState == FadeState.FadeIn) {
        // step one, make the widget visible
        if (!_fadeInStepOneDone) {
          _visible = true;
        }
        // step two, fade it in
        else {
          _opacity = 1.0;
        }
      }

      _currentFadeState = fadeState;
    });
  }

  /// After the widgets get rebuilt with visibility turned back on, then we'll
  /// rebuild again with the opacity change
  void _fadeInCallback(Duration duration) {
    _fadeInStepOneDone = true;
  }
}

// A fader will either fade in or fade out
enum FadeState { FadeIn, FadeOut }

/// Controller for the fader. Allows the user to fade the widget in and out.
/// While there are methods for adding and removing listeners, since I was those
/// methods to take a boolean, I'm just using the name, without actually overridding
/// them.
class FaderController {
  List<void Function(FadeState fadeSate)> _listeners = [];

  dispose() {
    _listeners.clear();
  }

  void fadeIn() {
    // Go over all the listeners and tell them to fade in
    for (var listener in _listeners) {
      listener(FadeState.FadeIn);
    }
  }

  void fadeOut() {
    // Go over all the listeners and tell them to fade out
    for (var listener in _listeners) {
      listener(FadeState.FadeOut);
    }
  }

  // Adds a new listener to the controller
  void addListener(void Function(FadeState fadeSate) listener) {
    _listeners.add(listener);
  }

  // Removes the given listener (if it exists) from the controller
  void removeListener(void Function(FadeState fadeSate) listener) {
    _listeners.remove(listener);
  }
}
