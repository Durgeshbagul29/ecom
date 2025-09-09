import 'package:flutter/cupertino.dart';

class AppCurvedEdges extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    // Top To Bottom Line
    path.lineTo(0, size.height);

    // First Curve
    final firstPointCurve1 = Offset(0, size.height - 20);
    final secondPointCurve1 = Offset(30, size.height - 20);

    path.quadraticBezierTo(
      firstPointCurve1.dx,
      firstPointCurve1.dy,
      secondPointCurve1.dx,
      secondPointCurve1.dy,
    );

    // Second Curve
    final firstPointCurve2 = Offset(0, size.height - 20);
    final secondPointCurve2 = Offset(size.width - 30, size.height - 20);

    path.quadraticBezierTo(
      firstPointCurve2.dx,
      firstPointCurve2.dy,
      secondPointCurve2.dx,
      secondPointCurve2.dy,
    );

    // Third Curve
    final firstPointCurve3 = Offset(size.width, size.height - 20);
    final secondPointCurve3 = Offset(size.width, size.height);

    path.quadraticBezierTo(
      firstPointCurve3.dx,
      firstPointCurve3.dy,
      secondPointCurve3.dx,
      secondPointCurve3.dy,
    );

    // Bottom To Top Line
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }

}