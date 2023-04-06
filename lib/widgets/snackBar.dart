import 'package:flutter/material.dart';

void showSnackBar(context, color, message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: color,
      content: Text(message),
    ),
  );
}
