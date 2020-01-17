import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:transparent_image/transparent_image.dart';


class DrawerTitle extends StatelessWidget {

  final IconData icon;
  final String text;
  final PageController pageController;
  final int page;


  DrawerTitle( this.icon, this.text, this.pageController, this.page);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: (){
          Navigator.of(context).pop();
          pageController.jumpToPage(page);
        },
        child: Container(
          height: 60.0,
          child: Row(
            children: <Widget>[
              Icon(
                icon,
                size: 32.0,
                color: pageController.page.round() == page ?
                Theme.of(context).primaryColor :
                Colors.grey[700],
              ),
              SizedBox( width: 32.0,),
              Text(
                text,
                style:  TextStyle(
                  fontSize: 16.0,
                  color:  pageController.page.round() == page ?
                  Theme.of(context).primaryColor :
                  Colors.grey[700],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

