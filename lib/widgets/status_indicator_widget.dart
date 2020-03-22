import 'package:flutter/material.dart';

class StatusIndicatorWidget extends StatefulWidget {
  final IconData icon;
  final String errorMessage;
  final Color backgroundColor;

  StatusIndicatorWidget.success(
      {this.backgroundColor = Colors.green,
      this.icon = Icons.check,
      this.errorMessage = ''});

  StatusIndicatorWidget.error(
      {this.backgroundColor = Colors.red,
      this.icon = Icons.error,
      @required this.errorMessage});

  @override
  _StatusIndicatorWidgetState createState() => _StatusIndicatorWidgetState();
}

class _StatusIndicatorWidgetState extends State<StatusIndicatorWidget>
    with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _iconSizeAnimation;

  @override
  void initState() {
    _controller = AnimationController(
        duration: const Duration(milliseconds: 700), vsync: this);

    _iconSizeAnimation = Tween<double>(begin: 0.0, end: 110.0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.bounceInOut));

    _controller.forward();
    super.initState();

    if (widget.errorMessage.isNotEmpty) {}
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.backgroundColor,
      child: Stack(
        children: <Widget>[
          LayoutBuilder(
            builder: (context, constraints) {
              return Center(
                child: Container(
                  width: constraints.maxWidth - (constraints.maxWidth / 5),
                  height: constraints.maxWidth - (constraints.maxWidth / 5),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey,
                            blurRadius: 7.0,
                            offset: const Offset(0.0, 0.0))
                      ]),
                  child: Center(
                      child: AnimatedBuilder(
                    animation: _iconSizeAnimation,
                    builder: (context, _) {
                      return Icon(widget.icon,
                          size: _iconSizeAnimation.value,
                          color: widget.icon == Icons.error
                              ? Colors.red
                              : Colors.green);
                    },
                  )),
                ),
              );
            },
          ),
          widget.errorMessage.isEmpty
              ? Container()
              : Positioned(
                  bottom: 0.0,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(15.0),
                    color: Colors.red,
                    child: Wrap(
                      children: <Widget>[
                        Text(widget.errorMessage,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0))
                      ],
                    ),
                  ),
                )
        ],
      ),
    );
  }
}
