import 'package:flutter/material.dart';
import 'package:flutter_fader/flutter_fader.dart';

void main() {
  runApp(FaderWithButtons());
}

class FaderWithButtons extends StatelessWidget {
  FaderWithButtons({Key? key}) : super(key: key);

  final FaderController _faderController = FaderController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Fader Example",
      home: Scaffold(
        appBar: AppBar(
          title: Text("Fader Example - Buttons"),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Fader(
                controller: _faderController,
                duration: const Duration(milliseconds: 500),
                child: RaisedButton(
                  onPressed: () {
                    _faderController.fadeOut();
                  },
                  child: Text("Fade me out!"),
                ),
              ),
              RaisedButton(
                onPressed: () {
                  _faderController.fadeIn();
                },
                child: Text("Fade him in!"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
