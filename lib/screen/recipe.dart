import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class Recipe extends StatefulWidget {
  final String recipeId;

  Recipe({required this.recipeId});

  @override
  _RecipeState createState() => _RecipeState();
}

class _RecipeState extends State<Recipe> {
  late YoutubePlayerController _controller;
  late DocumentSnapshot _recipe;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    fetchRecipe();
  }

  Future<void> fetchRecipe() async {
    var recipeDoc = await FirebaseFirestore.instance
        .collection('recipes')
        .doc(widget.recipeId)
        .get();
    setState(() {
      _recipe = recipeDoc;
      _isFavorite = _recipe['favoriteState'];
      _controller = YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(_recipe['videoUrl'])!,
        flags: YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
        ),
      );
    });
  }

  void toggleFavorite() async {
    setState(() {
      _isFavorite = !_isFavorite;
    });
    await FirebaseFirestore.instance
        .collection('recipes')
        .doc(widget.recipeId)
        .update({'favoriteState': _isFavorite});
  }

  @override
  Widget build(BuildContext context) {
    if (_recipe == null) return CircularProgressIndicator();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              expandedHeight: 400,
              flexibleSpace: FlexibleSpaceBar(
                background: YoutubePlayer(
                  controller: _controller,
                  showVideoProgressIndicator: true,
                  progressIndicatorColor: Colors.blueAccent,
                ),
              ),
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(10),
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(70),
                      topRight: Radius.circular(70),
                    ),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 15),
                      Container(
                        width: 80,
                        height: 4,
                        color: Colors.grey,
                      )
                    ],
                  ),
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: CircleAvatar(
                    backgroundColor: Color.fromRGBO(250, 250, 250, 0.6),
                    radius: 18,
                    child: IconButton(
                      icon: Icon(
                        _isFavorite ? Icons.favorite : Icons.favorite_border,
                        size: 25,
                        color: Colors.red,
                      ),
                      onPressed: toggleFavorite,
                    ),
                  ),
                ),
              ],
              title: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: CircleAvatar(
                  backgroundColor: Color.fromRGBO(250, 250, 250, 0.6),
                  radius: 18,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(
                      Icons.arrow_back,
                      size: 25,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      _recipe['recipeName'],
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Ingredients:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(_recipe['ingredients']),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Instructions:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(_recipe['instructions']),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}