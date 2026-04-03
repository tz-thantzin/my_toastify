import 'package:flutter/material.dart';

typedef DemoExampleCallback = void Function(BuildContext context);

@immutable
class DemoExample {
  const DemoExample({
    required this.title,
    required this.description,
    required this.onRun,
    this.note,
  });

  final String title;
  final String description;
  final String? note;
  final DemoExampleCallback onRun;
}

@immutable
class DemoSection {
  const DemoSection({
    required this.title,
    required this.description,
    required this.examples,
  });

  final String title;
  final String description;
  final List<DemoExample> examples;
}
