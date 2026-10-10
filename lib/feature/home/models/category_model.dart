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
    this.icon = FontAwesomeIcons.film,
    this.gradientColors = const [Color(0xFF261D0C), Color(0xFF14141E)],
    this.posterImage,
    this.seriesCount,
    this.tag,
    this.accentColor,
  });
}

