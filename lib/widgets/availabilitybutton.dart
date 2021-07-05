import 'package:flutter/material.dart';

class AvailabilityButton extends StatelessWidget {
  final String text;
  final Color color;
  final Function onPressed;

  AvailabilityButton({this.text, this.color, this.onPressed});

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return RaisedButton(
      onPressed: onPressed,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      color: color,
      textColor: Colors.white,
      padding: EdgeInsets.all(14),
      child: Container(
        width: 200,
        child: Center(
          child: Text(
            text,
            style: TextStyle(fontFamily: 'Brand-Bold', fontSize: 20),
          ),
        ),
      ),
    );
  }
}
