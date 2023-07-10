// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../entity/RecipeDetail.dart';
import 'RecipeListPage.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<TextEditingController> _controllers = [TextEditingController()];
  final _controller = TextEditingController();

  get ingredients => null;

  void _getRecipes() async {
    List<String> ingredients = _controllers
        .map((controller) => controller.text)
        .where((text) => text.isNotEmpty)
        .toList();

    final response = await http.post(
      Uri.http('10.0.2.2:5000', '/get_recipes'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'ingredients': ingredients,
      }),
    );
    if (response.statusCode == 200) {
      List<dynamic> recipes = jsonDecode(response.body);
      List<Recipe> recipeList =
          recipes.map((item) => Recipe.fromJson(item)).toList();
      if (recipeList.isEmpty) {
      } else {
        BuildContext context = this.context;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeListPage(recipeList: recipeList),
          ),
        );
      }
    } else {
      throw Exception('Failed to load recipes');
    }
  }

  void _addOrRemoveField(int index, String value) {
    if (value.isNotEmpty && index == _controllers.length - 1) {
      setState(() {
        _controllers.add(TextEditingController());
      });
    } else if (_controllers.length > 1 && value.isEmpty) {
      setState(() {
        _controllers.removeAt(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
        color: const Color(0xFFEDEFE3),
        child: Stack(
          children: [
            Positioned(
              left: 3,
              top: 30,
              child: Text('Kitchey',
                  style: GoogleFonts.getFont("Cookie",
                      fontSize: 75, color: Colors.grey)),
            ),
            Positioned(
                right: 0,
                top: 20,
                child: Opacity(
                  opacity: 0.5,
                  child: Image.asset(
                    "images/vegetable.png",
                    width: 233,
                    height: 246,
                    fit: BoxFit.cover,
                  ),
                )),
            Positioned(
              left: (MediaQuery.of(context).size.width - 369) / 2,
              top: 200,
              child: Container(
                width: 360,
                height: 400,
                decoration: BoxDecoration(
                  color: const Color(0xFFF6F3D4),
                  border: Border.all(color: Colors.black),
                  borderRadius: const BorderRadius.all(Radius.circular(25)),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Flexible(
                      child: ListView.builder(
                        itemCount: _controllers.length,
                        itemBuilder: (context, index) => Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 10, left: 25, bottom: 5),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  '${index + 1}.Ürün',
                                  style: GoogleFonts.getFont("Inter",
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 0, bottom: 5),
                              child: SizedBox(
                                width: 340,
                                height: 40,
                                child: TextField(
                                  controller: _controllers[index],
                                  decoration: InputDecoration(
                                    labelStyle: const TextStyle(),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide:
                                          const BorderSide(color: Colors.grey),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide:
                                          const BorderSide(color: Colors.blue),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 10),
                                    filled: true,
                                    fillColor: _controllers[index].text.isEmpty
                                        ? Colors.white.withOpacity(0.5)
                                        : Colors.white,
                                  ),
                                  onChanged: (value) {
                                    _addOrRemoveField(index, value);
                                    setState(() {});
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20, top: 20),
                      child: ElevatedButton(
                        onPressed: _getRecipes,
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      side: const BorderSide(
                                          color: Colors.black, width: 1))),
                          minimumSize: MaterialStateProperty.all<Size>(
                              const Size(233, 52)),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color(0xFFEDEFE3)),
                        ),
                        child: const Text(
                          'Başlat',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
