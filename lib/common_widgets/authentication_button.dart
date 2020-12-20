import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:uapps_authentication/common_widgets/custom_raised_button.dart';

class AuthenticationButton extends CustomRaisedButton {
  final String label;
  final VoidCallback onPressed;
  final Color color;
  final Color textColor;

  AuthenticationButton({
    @required this.label,
    this.onPressed,
    this.color,
    this.textColor,
  })  : assert(label != null),
        super(
          color: color,
          onPressed: onPressed,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 15.0,
              color: textColor,
            ),
          ),
        );
}
