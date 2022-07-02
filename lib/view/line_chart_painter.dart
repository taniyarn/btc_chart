import 'package:btc_chart/model/line_chart_data.dart';
import 'package:flutter/material.dart';

class LineChartPainter extends CustomPainter {
  LineChartPainter({
    required this.data,
    required this.horizontalAxisInterval,
  });

  final List<LineChartData> data;
  final double horizontalAxisInterval;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: size.width,
      height: size.height / 2,
    );
    drawBorder(canvas, rect);
    drawChart(canvas, rect);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  void drawBorder(Canvas canvas, Rect rect) {
    var paint = Paint()
      ..color = Colors.grey.withOpacity(0.5)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final gridNum = data.getGridNum(horizontalAxisInterval);
    final span = rect.height / (gridNum - 1);
    var y = rect.bottom;

    for (var i = 0; i < gridNum; i++) {
      canvas.drawLine(Offset(rect.left, y), Offset(rect.right, y), paint);
      y -= span;
    }
  }

  void drawChart(Canvas canvas, Rect rect) {
    final paintStroke = Paint()
      ..color = Colors.green
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;
    final paintFill = Paint()
      ..color = Colors.green
      ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.green.withOpacity(0.8),
            Colors.green.withOpacity(0.1),
          ]).createShader(rect);

    final span = rect.width / (data.length - 1);
    final path = Path();
    var x = rect.left;
    var first = true;

    final minChartY = data.minChartY(horizontalAxisInterval);
    final deltaChartY = data.maxChartY(horizontalAxisInterval) - minChartY;

    for (final d in data) {
      final y = rect.bottom - (d.y - minChartY) / deltaChartY * rect.height;

      if (first) {
        path.moveTo(x, y);
        first = false;
      } else {
        path.lineTo(x, y);
      }

      x += span;
    }

    canvas.drawPath(path, paintStroke);

    path
      ..lineTo(rect.right, rect.bottom)
      ..lineTo(rect.left, rect.bottom);

    canvas.drawPath(path, paintFill);
  }
}
