// ignore_for_file: file_names, unnecessary_null_comparison
import 'dart:convert';

// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart'
    show
        Alignment,
        Border,
        BorderRadius,
        BoxDecoration,
        BuildContext,
        Center,
        Color,
        Colors,
        Column,
        Container,
        CrossAxisAlignment,
        Curves,
        Divider,
        EdgeInsets,
        Expanded,
        Flexible,
        FontWeight,
        Icon,
        IconButton,
        Icons,
        Image,
        InkWell,
        ListView,
        MainAxisAlignment,
        MaterialApp,
        MaterialPageRoute,
        Navigator,
        Opacity,
        Padding,
        PageController,
        PageView,
        Row,
        Scaffold,
        SizedBox,
        Stack,
        State,
        StatefulWidget,
        StatelessWidget,
        Text,
        TextOverflow,
        TextStyle,
        Widget,
        WillPopScope;
import 'package:flutter_application_1/screens/RecipePage.dart';
import 'package:google_fonts/google_fonts.dart';

import '../entity/RecipeDetail.dart';

class RecipeListPage extends StatelessWidget {
  const RecipeListPage({
    super.key,
    required this.recipeList,
  });
  final List<dynamic> recipeList;

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
                        child: MyListView(
                          recipeList: recipeList,
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
                      fontSize: 75, color: Colors.grey)),
            ),
          ],
        ),
      ),
    );
  }
}

class MyListView extends StatefulWidget {
  const MyListView({super.key, required this.recipeList});
  final List<dynamic> recipeList;

  @override
  _MyListViewState createState() => _MyListViewState();
}

class _MyListViewState extends State<MyListView> {
  final PageController _pageController = PageController();
  int _currentPage = 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 670,
      width: 350,
      decoration: BoxDecoration(
        color: const Color(0xFFFEFDF8),
        border: Border.all(color: const Color(0xFFD1D2CD), width: 1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Expanded(
            child: WillPopScope(
              onWillPop: () async {
                if (_pageController.page == 0) {
                  Navigator.of(context).pop();
                } else {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeIn,
                  );
                }
                return false;
              },
              child: PageView.builder(
                controller: _pageController,
                itemCount: (widget.recipeList.length / 6).ceil(),
                itemBuilder: (BuildContext context, int page) {
                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: 6,
                    itemBuilder: (BuildContext context, int index) {
                      int recipeIndex = (page * 6) + index;
                      if (recipeIndex < widget.recipeList.length) {
                        return InkWell(
                          onTap: () => _getRecipe(
                              context, widget.recipeList[recipeIndex].recipeID),
                          child: Column(
                            children: [
                              Container(
                                height: 70,
                                padding: const EdgeInsets.only(left: 10),
                                child: Row(
                                  children: [
                                    Image.asset('images/fork.png',
                                        width: 30, height: 30),
                                    const SizedBox(width: 10.0),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Row(
                                            children: [
                                              const Icon(Icons.circle,
                                                  size: 8.0),
                                              const SizedBox(width: 4.0),
                                              Flexible(
                                                child: Text(
                                                  '${widget.recipeList[recipeIndex].recipeName}',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Flexible(
                                            child: Text(
                                              '${widget.recipeList[index].recipeMaterial.join(', ')}',
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (index != widget.recipeList.length - 1)
                                const Divider(
                                    color: Colors.grey, thickness: 1.0),
                            ],
                          ),
                        );
                      } else {
                        return SizedBox.shrink();
                      }
                    },
                  );
                },
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page + 1;
                  });
                },
              ),
            ),
          ),
          SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeIn,
                    );
                  },
                  icon: const Icon(Icons.arrow_left),
                ),
                Text('Sayfa $_currentPage'),
                IconButton(
                  onPressed: () {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeIn,
                    );
                  },
                  icon: const Icon(Icons.arrow_right),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _getRecipe(BuildContext context, int recipeId) async {
    final response = await http.get(
      Uri.http('10.0.2.2:5000', '/get_recipe/$recipeId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    dynamic recipeJson = jsonDecode(response.body);

    if (recipeJson.isNotEmpty) {
      Map<String, dynamic> recipeData = recipeJson;

      Recipe recipe = Recipe.fromJson(recipeData);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RecipePage(recipe: recipe),
        ),
      );
    } else {
      throw Exception('Failed to load recipes');
    }
  }
}
