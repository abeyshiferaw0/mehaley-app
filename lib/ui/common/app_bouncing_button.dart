import 'package:flutter/material.dart';

class AppBouncingButton extends StatefulWidget {
  const AppBouncingButton({
    Key? key,
    required this.onTap,
    required this.child,
    this.onLongTap,
    this.disableBouncing = false,
    this.shrinkRatio = 1,
  }) : super(key: key);

  final Widget child;
  final VoidCallback onTap;
  final VoidCallback? onLongTap;
  final bool disableBouncing;
  final int? shrinkRatio;

  @override
  _AppBouncingButtonState createState() => _AppBouncingButtonState();
}

class _AppBouncingButtonState extends State<AppBouncingButton>
    with TickerProviderStateMixin {
  //ANIMATION CONTROLLER
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 100,
      ),
      lowerBound: 0.0,
      upperBound: 0.02,
    )..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var opacity = 1 - (_controller.value * 25);
    var scale = 1 - (_controller.value * widget.shrinkRatio!.toDouble());

    if (widget.onLongTap != null) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        //onTap: widget.onTap,
        //onTapDown: !widget.disableBouncing ? _onTapDown : (details) {},
        onLongPress: () {
          widget.onLongTap!();
        },
        onTapCancel: () => _cancelTap(),
        onTapUp: !widget.disableBouncing ? _onTapUp : null,
        onTapDown: (details) =>
            !widget.disableBouncing ? _controller.forward() : null,
        child: Transform.scale(
          scale: scale,
          child: Opacity(
            opacity: opacity,
            child: widget.child,
          ),
        ),
      );
    } else {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        //onTap: widget.onTap,
        //onTapDown: !widget.disableBouncing ? _onTapDown : (details) {},
        onTapCancel: () => _cancelTap(),
        onTapUp: !widget.disableBouncing ? _onTapUp : null,
        onTapDown: (details) =>
            !widget.disableBouncing ? _controller.forward() : null,
        child: Transform.scale(
          scale: scale,
          child: Opacity(
            opacity: opacity,
            child: widget.child,
          ),
        ),
      );
    }
  }

  _onTapUp(details) async {
    // EasyDebounce.debounce(
    //   AppValues.bouncingButtonDebouncer,
    //   Duration(microseconds: 100),
    //   () {
    //     _controller.reverse().then((value) => widget.onTap());
    //   },
    // );
    _controller.reverse().then(
          (value) => _controller.forward().then(
                (value) => _controller.reverse().then(
                      (value) => widget.onTap(),
                    ),
              ),
        );
  }

  _cancelTap() {
    _controller.reverse();
  }
}
