import 'package:flutter/material.dart';

///function used to create a custom key for the
///favourite icon used in the upcoming launches data tables.

Key customKey(String value, bool flag) {
  return Key(value + flag.toString());
}
