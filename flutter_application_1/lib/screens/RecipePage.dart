// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../entity/RecipeDetail.dart';

class RecipePage extends StatelessWidget {
  const RecipePage({super.key, required this.recipe});
  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xFFEDEFE3),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset('images/vegetable.png',
                        width: 369, height: 342),
                    Padding(
                      padding: EdgeInsets.only(top: 50),
                      child: Opacity(
                        opacity: 0.85,
                        child: RecipeView(
                          recipe: recipe,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(5),
              child: Text('Kitchey',
                  style: GoogleFonts.getFont("Cookie",
                      fontSize: 60, color: Colors.grey)),
            ),
          ],
        ),
      ),
    );
  }
}

class RecipeView extends StatefulWidget {
  final Recipe? recipe;
  const RecipeView({super.key, this.recipe});

  @override
  RecipePageView createState() => RecipePageView();
}

class RecipePageView extends State<RecipeView> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, '/recipeListPage');
        return false;
      },
      child: MaterialApp(
        home: Scaffold(
          backgroundColor: const Color(0xFFEDEFE3),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(0),
              child: Container(
                height: 750,
                width: 350,
                decoration: BoxDecoration(
                  color: const Color(0xFFFEFDF8),
                  border: Border.all(color: const Color(0xFFD1D2CD), width: 1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          title: Container(
                            alignment: Alignment.center,
                            width: 350,
                            height: 50,
                            decoration: const BoxDecoration(
                              color: Color(0xFFF6F3D4),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(17),
                                topRight: Radius.circular(17),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.zero,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  widget.recipe!.recipeName,
                                  style: GoogleFonts.getFont(
                                    "Roboto",
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          subtitle: Text(widget.recipe!.recipeType),
                        ),
                        // Malzemeler listesi
                        Padding(
                          padding: EdgeInsets.all(13),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                height: 475,
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      const Text(
                                        'Malzemeler',
                                        style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      ...?widget.recipe?.recipeMaterial
                                          .map((material) =>
                                              Text('- ' + material))
                                          .toList(),
                                      const SizedBox(height: 20),
                                      const Text(
                                        'Tarif',
                                        style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(widget.recipe!.recipeDescription),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
