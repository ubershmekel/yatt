import 'package:flutter/material.dart';

class PoppyButton extends StatefulWidget {
  const PoppyButton({
    super.key,
    required this.button,
  });

  final Widget button;

  @override
  State<PoppyButton> createState() => PoppyButtonState();
}

class PoppyButtonState extends State<PoppyButton> {
  final animDuration = const Duration(milliseconds: 300);
  bool _visible = true;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 60.0,
        child: FittedBox(
            child: AnimatedOpacity(
                opacity: _visible ? 1.0 : 0.5,
                duration: animDuration,
                child: widget.button)));
  }

  hide() async {
    setState(() {
      _visible = false;
    });
    await Future.delayed(animDuration);
  }

  show() async {
    setState(() {
      _visible = true;
    });
    await Future.delayed(animDuration);
  }

  pulse() async {
    for (int i = 0; i < 10; i++) {
      await hide();
      await show();
    }
  }
}
