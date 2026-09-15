import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CategoryModel {
  final String id;
  final String title;
  final FaIconData icon;
  final List<Color> gradientColors;
  final String? posterImage;
  final String? seriesCount;
  final String? tag;
  final Color? accentColor;

  CategoryModel({
    required this.id,
    required this.title,
    required this.icon,
    required this.gradientColors,
    this.posterImage,
    this.seriesCount,
    this.tag,
    this.accentColor,
  });
}

