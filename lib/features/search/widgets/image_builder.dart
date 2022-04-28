import 'package:flutter/material.dart';

class ImageBuilder extends StatelessWidget {
  final String imageUrl;
  ImageBuilder(this.imageUrl);


  @override
  Widget build(BuildContext context) {
  double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: 300,
      width: screenWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.fill,
      ),
      ),
    );
  }
}