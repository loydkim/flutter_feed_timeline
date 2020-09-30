import 'package:flutter/material.dart';

class FloatButton extends FloatingActionButton {
  final String label;
  final Icon icon;
  final Function() onPressed;
//backgroundColor: Colors.pink,
  const FloatButton({
    this.label,
    this.icon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
        label: Text(label), icon: icon, onPressed: onPressed);
  }
}
