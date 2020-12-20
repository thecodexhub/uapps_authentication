import 'package:flutter/material.dart';

class CustomRaisedButton extends StatelessWidget {
  CustomRaisedButton({
    Key key,
    this.height: 45.0,
    this.borderRadius: 30.0,
    this.color,
    this.onPressed,
    this.child,
  }) : super(key: key);
  final double height;
  final double borderRadius;
  final Color color;
  final Widget child;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        color: color,
        elevation: 4.0,
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}
