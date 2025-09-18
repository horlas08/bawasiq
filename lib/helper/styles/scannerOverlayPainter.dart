import 'package:project/helper/utils/generalImports.dart';

class ScannerOverlayPainter extends CustomPainter {
  final Size cutOutSize;
  final Color overlayColor;
  final Color borderColor;

  ScannerOverlayPainter({
    required this.cutOutSize,
    required this.overlayColor,
    required this.borderColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = overlayColor;

    final cutOutRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: cutOutSize.width,
      height: cutOutSize.height,
    );

    final background = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final cutout = Path()..addRRect(RRect.fromRectAndRadius(cutOutRect, Radius.circular(16)));
    final overlay = Path.combine(PathOperation.difference, background, cutout);

    canvas.drawPath(overlay, paint);

    // Draw white border
    final borderPaint = Paint()
      ..color = borderColor
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    canvas.drawRRect(
      RRect.fromRectAndRadius(cutOutRect, Radius.circular(16)),
      borderPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}