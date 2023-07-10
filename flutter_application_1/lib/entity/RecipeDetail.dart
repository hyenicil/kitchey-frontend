import 'dart:convert';

class Recipe {
  final int recipeID;
  final String recipeName;
  final String recipeType;
  final List<String> recipeMaterial;
  final String recipeCount;
  final String recipePrepartion;
  final String recipeCooking;
  final String recipeDescription;
  final double score;

  Recipe({
    required this.recipeID,
    required this.recipeName,
    required this.recipeType,
    required this.recipeMaterial,
    required this.recipeCount,
    required this.recipePrepartion,
    required this.recipeCooking,
    required this.recipeDescription,
    required this.score,
  });
  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      recipeID: json['recipeID'] ?? 0,
      recipeName: json['recipeName'] ?? '',
      recipeType: json['recipeType'] ?? '',
      recipeMaterial: List<String>.from(json['recipeMaterial'] ?? []),
      recipeCount: json['recipeCount'] ?? '',
      recipePrepartion: json['recipePrepartion'] ?? '',
      recipeCooking: json['recipeCooking'] ?? '',
      recipeDescription: json['recipeDescription'] ?? '',
      score: json.containsKey('score') ? json['score'] : 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'recipeID': recipeID,
      'recipeName': recipeName,
      'recipeType': recipeType,
      'recipeMaterial': recipeMaterial,
      'recipeCount': recipeCount,
      'recipePrepartion': recipePrepartion,
      'recipeCooking': recipeCooking,
      'recipeDescription': recipeDescription,
      'score': score,
    };
  }

  factory Recipe.fromJsonTwo(Map<String, dynamic> json) {
    List<String> materialList = [];
    String materialString = json['recipeMaterial'] ?? "[]";
    var materialJson = jsonDecode(materialString);
    for (var material in materialJson) {
      materialList.add(material.toString());
    }

    return Recipe(
      recipeID: json['recipeID'] ?? 0,
      recipeName: json['recipeName'] ?? '',
      recipeType: json['recipeType'] ?? '',
      recipeMaterial: materialList,
      recipeCount: json['recipeCount'] ?? '',
      recipePrepartion: json['recipePrepartion'] ?? '',
      recipeCooking: json['recipeCooking'] ?? '',
      recipeDescription: json['recipeDescription'] ?? '',
      score:
          0.0, // Bu değeri varsayılan olarak 0.0 yapıyoruz çünkü JSON verisi içinde bu alan yok.
    );
  }
}
