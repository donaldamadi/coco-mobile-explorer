import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:math';

class ImageBuilder extends StatelessWidget {
  final String imageUrl;
  final Map<String, dynamic> segmentation;
  final Map<String, dynamic> caption;
  ImageBuilder(this.imageUrl, this.segmentation, this.caption);


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    print(jsonDecode(segmentation["segmentation"]).runtimeType);
    return Container(
      height: 300,
      width: screenWidth,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.fill,
        ),
      ),
      child: Container(
        color: Colors.transparent,
        child: CustomPaint(
          foregroundPainter: PolygonPainter(jsonDecode(segmentation["segmentation"])),
          painter: PolygonPainter(jsonDecode(segmentation["segmentation"])),
        ),
      ),
    );
  }
}

class PolygonPainter extends CustomPainter {
  final List<dynamic> segments;
  PolygonPainter(this.segments);
  @override
  void paint(Canvas canvas, Size size) {
    Path? polygon = Path();
    Random random = Random();
    var r = (random.nextDouble() * 255).floor();
    var g = (random.nextDouble() * 255).floor();
    var b = (random.nextDouble() * 255).floor();
    final paint = Paint()
      ..strokeWidth = 3
      ..color = Color.fromARGB(30, r, g, b)
      ..style = PaintingStyle.fill;

    // Drawing the polygon
    for (var segment = 0; segment < segments.length; segment++) {
      var poly = segments[segment];
      print(segment);
      polygon.moveTo(poly[0], poly[1]);
      for (var m = 0; m < poly.length - 2; m += 2) {
        polygon.lineTo(poly[m + 2], poly[m + 3]);
      }
      polygon.lineTo(poly[0], poly[1]);
      polygon.close();

      canvas.drawPath(polygon, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
