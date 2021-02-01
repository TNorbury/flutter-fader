import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_fader/flutter_fader.dart';

void main() {
  runApp(FaderWithScroll());
}

class FaderWithScroll extends StatelessWidget {
  FaderWithScroll({Key? key}) : super(key: key) {
    _scrollController.addListener(() {
      bool scrollingDown = _scrollController.position.userScrollDirection ==
          ScrollDirection.reverse;

      // If we're scrolling down, then fade out
      if (scrollingDown) {
        _faderController.fadeOut();
      }

      // If we're scrolling up, then fade in
      else {
        _faderController.fadeIn();
      }
    });
  }

  final FaderController _faderController = FaderController();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Fader Example",
      home: Scaffold(
        appBar: AppBar(
          title: Text("Fader Example - Scroll"),
        ),
        floatingActionButton: Fader(
          controller: _faderController,
          duration: const Duration(milliseconds: 500),
          child: FloatingActionButton(
            child: Icon(Icons.gesture),
            onPressed: () {},
          ),
        ),
        body: Center(
          child: ListView.builder(
            controller: _scrollController,
            itemCount: 100,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text("Item #" + index.toString()),
              );
            },
          ),
        ),
      ),
    );
  }
}
