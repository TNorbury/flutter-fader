import 'package:flutter/material.dart';

/// Widget that utilizies both [AnimatedOpacity] and [Visibility] to allow a widget
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
  /// [Curve] [curve] The curve for the animation (Optional, default is linear)
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

  // Fading in has to be done in two steps:
  // 1.) Make the widget visible, this puts it back into the view tree, and allows
  //     us to interact with it/do things to it.
  // 2.) Change the opacity (with an animation), so that the child widget is "visible"
  //     (at this point, it exists, but is still transparent).
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
    // If the widget has become visible again, but has yet to be faded back in,
    // then we'll add a post-frame call back so that we can set the opactiy, and
    // update after this current frame is done
    if (_currentFadeState == FadeState.FadeIn && _visible && _opacity == 0.0) {
      WidgetsBinding.instance.addPostFrameCallback(_fadeInCallback);
    }

    return Visibility(
      visible: _visible,
      child: AnimatedOpacity(
        opacity: _opacity,
        duration: widget._duration,
        curve: widget._curve,
        child: widget._child,
        onEnd: () {
          // If we're finished fading out, then we'll turn off visibility
          if (_opacity == 0.0 && _visible) {
            setState(() {
              _visible = false;
            });
          }
        },
      ),
    );
  }

  void _fade(FadeState fadeState) {
    setState(() {
      // If we're fading out, then set the opacity to 0 (clear). The visibility
      // will be changed when the fade out animation ends.
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
      }

      _currentFadeState = fadeState;
    });
  }

  /// After the widget gets rebuilt with visibility turned back on, then we'll
  /// rebuild again with the opacity change. 
  /// (This gets called as a post-frame callback).
  void _fadeInCallback(Duration duration) {
    setState(() {
      _fadeInStepOneDone = true;

      // step two, fade it in
      _opacity = 1.0;
    });
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
