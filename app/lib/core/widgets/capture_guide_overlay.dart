import 'package:flutter/material.dart';

/// Visual guide overlay for farmers: leaf frame, lighting tips.
class CaptureGuideOverlay extends StatelessWidget {
  const CaptureGuideOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        fit: StackFit.expand,
        children: [
          CustomPaint(painter: _LeafFramePainter()),
          Positioned(
            left: 12,
            right: 12,
            bottom: 12,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                children: [
                  Icon(Icons.wb_sunny_outlined, color: Colors.amber, size: 18),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Lumière naturelle • Fond uniforme • Feuille entière • Image nette',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LeafFramePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.greenAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final rect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height * 0.42),
        width: size.width * 0.72,
        height: size.height * 0.48,
      ),
      const Radius.circular(20),
    );
    canvas.drawRRect(rect, paint);

    final cornerSize = 22.0;
    final rectBounds = rect.outerRect;
    final corners = [
      rectBounds.topLeft,
      rectBounds.topRight,
      rectBounds.bottomLeft,
      rectBounds.bottomRight,
    ];
    for (final corner in corners) {
      canvas.drawCircle(corner, 4, Paint()..color = Colors.greenAccent);
    }
    canvas.drawLine(rectBounds.topLeft, rectBounds.topLeft + Offset(cornerSize, 0), paint);
    canvas.drawLine(rectBounds.topLeft, rectBounds.topLeft + Offset(0, cornerSize), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
