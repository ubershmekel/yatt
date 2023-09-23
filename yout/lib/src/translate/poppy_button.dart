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

// 3 seconds felt a bit too fast
const autoNextDuration = Duration(seconds: 4);

class PoppyButtonState extends State<PoppyButton> {
  final animDuration = const Duration(milliseconds: 300);
  final GlobalKey _containerKey = GlobalKey();

  bool _visible = true;
  bool _isAutoClicking = false;
  Size? _size;
  Duration _duration = autoNextDuration;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      SizedBox(
          key: _containerKey,
          height: 60.0,
          child: FittedBox(
              child: AnimatedOpacity(
                  opacity: _visible ? 1.0 : 0.5,
                  duration: animDuration,
                  child: widget.button))),
      ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          child: AnimatedContainer(
            duration: _duration,
            width: _isAutoClicking ? _size!.width : 0,
            height: 20,
            onEnd: () async {
              if (_isAutoClicking) {
                _duration = Duration.zero;
                setState(() {
                  _isAutoClicking = false;
                });
                await Future.delayed(const Duration(milliseconds: 1));
                _duration = autoNextDuration;
              }
            },
            alignment: Alignment.bottomLeft,
            color: const Color.fromARGB(120, 120, 120, 120),
          )),
    ]);
  }

  @override
  void initState() {
    super.initState();
    // Get size value after widgets are created.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _size = _getSize();
      });
    });
  }

  Size? _getSize() {
    if (_containerKey.currentContext != null) {
      final RenderBox renderBox =
          _containerKey.currentContext!.findRenderObject() as RenderBox;
      Size size = renderBox.size;
      return size;
    }
    return null;
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

  autoClick() {
    setState(() {
      _isAutoClicking = !_isAutoClicking;
    });
  }
}
