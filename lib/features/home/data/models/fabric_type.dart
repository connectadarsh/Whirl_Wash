import 'package:flutter/material.dart';

enum FabricType {
  cotton('Cotton', Icons.grass_rounded),
  synthetic('Synthetic', Icons.science_rounded),
  silk('Silk', Icons.auto_awesome_rounded),
  wool('Wool', Icons.cloud_rounded),
  dontKnow('Not Sure', Icons.help_outline_rounded);

  final String label;
  final IconData icon;
  const FabricType(this.label, this.icon);
}
