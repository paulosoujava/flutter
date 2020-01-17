import 'package:flutter/material.dart';
import 'package:gif/ui/home_page.dart';

void main() {
  runApp(MaterialApp(
      home: HomePage(),
      theme: ThemeData(
          hintColor: Colors.white,
          primaryColor: Colors.white,
          inputDecorationTheme: InputDecorationTheme(
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white))))),

  );
}
//https://api.giphy.com/v1/gifs/trending?api_key=Ia0IvuiX6eAidOHQ1HezmHTGjcI7Mcxt&limit=20&rating=G

//https://api.giphy.com/v1/gifs/search?api_key=Ia0IvuiX6eAidOHQ1HezmHTGjcI7Mcxt&q=dogs&limit=25&offset=25&rating=G&lang=en
