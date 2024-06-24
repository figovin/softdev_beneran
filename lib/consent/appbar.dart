import 'package:flutter/material.dart';
import 'package:recipe/consent/colors.dart';

import '../userAuth/recipeFormScreen.dart';

PreferredSizeWidget appbar(BuildContext context) {
  return AppBar(
    automaticallyImplyLeading: false,
    elevation: 0,
    title: GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RecipeFormScreen()),
        );
      },
      child: Icon(
        Icons.fastfood,
        size: 27,
      ),
    ),
    actions: [
      Padding(
        padding: const EdgeInsets.only(right: 15),
        child: CircleAvatar(
          radius: 18,
          backgroundImage: AssetImage('images/profileFoto.jpg'),
        ),
      ),
    ],
    backgroundColor: maincolor,
  );
}
