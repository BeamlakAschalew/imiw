import 'package:flutter/material.dart';

TextStyle statusStyle(bool? status) {
  return TextStyle(
      fontSize: 75,
      color: status == null
          ? Colors.orange
          : status
              ? Colors.green
              : Colors.red);
}

const TextStyle statusMessageStyle = TextStyle(
  fontSize: 25,
);
const TextStyle mediumFontSize = TextStyle(
  fontSize: 20,
);
