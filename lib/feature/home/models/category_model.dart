import 'package:flutter/material.dart';

class CategoryModel {
  final String id;
  final String title;
  final String emoji;
  final List<Color> gradientColors;

  const CategoryModel({
    required this.id,
    required this.title,
    required this.emoji,
    required this.gradientColors,
  });
}
