import 'package:flutter/material.dart';

class ThemeModel {
  final String id;
  final String name;
  final int cost;
  final List<Color> gradientColors;
  final Color primaryColor;

  const ThemeModel({
    required this.id,
    required this.name,
    required this.cost,
    required this.gradientColors,
    required this.primaryColor,
  });
}

class StoreThemes {
  static const List<ThemeModel> themes = [
    ThemeModel(
      id: "default",
      name: "Klasik Mavi",
      cost: 0,
      gradientColors: [Color(0xFF75cff0), Color(0xFF38a3d1)],
      primaryColor: Color(0xFF75cff0),
    ),
    ThemeModel(
      id: "sunset",
      name: "Gün Batımı",
      cost: 500,
      gradientColors: [Color(0xFFff7e5f), Color(0xFFfeb47b)],
      primaryColor: Color(0xFFff7e5f),
    ),
    ThemeModel(
      id: "dark",
      name: "Gece Modu",
      cost: 1000,
      gradientColors: [Color(0xFF2c3e50), Color(0xFF000000)],
      primaryColor: Color(0xFF2c3e50),
    ),
    ThemeModel(
      id: "royal",
      name: "Kraliyet",
      cost: 1500,
      gradientColors: [Color(0xFF4A00E0), Color(0xFF8E2DE2)],
      primaryColor: Color(0xFF8E2DE2),
    ),
  ];

  static ThemeModel getTheme(String id) {
    return themes.firstWhere((t) => t.id == id, orElse: () => themes.first);
  }
}
