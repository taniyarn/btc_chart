import 'package:btc_chart/model/line_chart_data.dart';
import 'package:btc_chart/view/chart_const.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show NumberFormat;

class LineChartPainter extends CustomPainter {
  LineChartPainter({
    required this.data,
    required this.horizontalAxisInterval,
    required this.selectedIndex,
  });

  final List<LineChartData> data;
  final double horizontalAxisInterval;
  final int? selectedIndex;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: size.width,
      height: size.height * heightRatio,
    );

    drawBorder(canvas, rect);
    drawChart(canvas, rect);
    drawLabels(canvas, rect);
    if (selectedIndex != null) {
      drawLine(canvas, rect, selectedIndex!);
      drawCircle(canvas, rect, selectedIndex!);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  void drawBorder(Canvas canvas, Rect rect) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.5)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final gridNum = data.getGridNum(horizontalAxisInterval);
    final span = rect.height / (gridNum - 1);
    var y = rect.bottom;

    for (var i = 0; i < gridNum; i++) {
      canvas.drawLine(
        Offset(rect.left + borderSpacing, y),
        Offset(rect.right, y),
        paint,
      );
      y -= span;
    }
  }

  void drawChart(Canvas canvas, Rect rect) {
    final paintStroke = Paint()
      ..color = bitcoinColor
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;
    final paintFill = Paint()
      ..color = bitcoinColor
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          bitcoinColor.withOpacity(0.4),
          bitcoinColor.withOpacity(0.1),
        ],
      ).createShader(rect);

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

  void drawLabels(Canvas canvas, Rect rect) {
    final labelStyle = TextStyle(
      color: Colors.grey.shade600,
      fontSize: 12,
    );
    drawXLabel(canvas, rect, labelStyle);
    drawYLabel(canvas, rect, labelStyle);
  }

  void drawXLabel(Canvas canvas, Rect rect, TextStyle labelStyle) {
    final span = data.length ~/ (xLableNum + 1);

    var year = 0;
    for (var i = 1; i <= xLableNum; i++) {
      final dateTime = DateTime.fromMillisecondsSinceEpoch(
        data[i * span].x.toInt() * 1000,
      );

      var formatedDateTime = '';

      if (dateTime.year != year) {
        formatedDateTime = '${dateTime.year}/';
      }

      formatedDateTime += '${dateTime.month}/${dateTime.day}';
      year = dateTime.year;

      drawText(
        canvas,
        Offset(
          rect.left + rect.width * i * span / data.length,
          rect.bottom + bottomPadding,
        ),
        textWidth,
        labelStyle,
        formatedDateTime,
      );
    }
  }

  void drawYLabel(Canvas canvas, Rect rect, TextStyle labelStyle) {
    final gridNum = data.getGridNum(horizontalAxisInterval);
    final span = rect.height / (gridNum - 1);
    var y = rect.bottom;

    for (var i = 0; i < gridNum; i++) {
      drawText(
        canvas,
        Offset(rect.left, y),
        textWidth,
        labelStyle,
        NumberFormat('#,###').format(
          data.minChartY(horizontalAxisInterval) + i * horizontalAxisInterval,
        ),
        isCentered: false,
      );
      y -= span;
    }
  }

  void drawText(
    Canvas canvas,
    Offset position,
    double width,
    TextStyle style,
    String text, {
    bool isCentered = true,
  }) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: width);
    textPainter.paint(
      canvas,
      Offset(
        isCentered
            ? position.dx - textPainter.width / 2
            : position.dx + leftPadding,
        position.dy - textPainter.height / 2,
      ),
    );
  }

  void drawLine(
    Canvas canvas,
    Rect rect,
    int selectedIndex,
  ) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.5)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final dx = rect.left + rect.width * selectedIndex / (data.length - 1);
    var dy = rect.top;
    const dashWidth = 4;
    const dashSpace = 4;

    while (dy < rect.bottom) {
      canvas.drawLine(
        Offset(
          dx,
          dy,
        ),
        Offset(
          dx,
          dy + dashWidth,
        ),
        paint,
      );
      dy += dashWidth + dashSpace;
    }
  }

  void drawCircle(
    Canvas canvas,
    Rect rect,
    int selectedIndex,
  ) {
    final paint = Paint()
      ..color = bitcoinColor
      ..style = PaintingStyle.fill;

    final minChartY = data.minChartY(horizontalAxisInterval);
    final deltaChartY = data.maxChartY(horizontalAxisInterval) - minChartY;

    canvas.drawCircle(
      Offset(
        rect.left + rect.width * selectedIndex / (data.length - 1),
        rect.bottom -
            (data[selectedIndex].y - minChartY) / deltaChartY * rect.height,
      ),
      4,
      paint,
    );
  }
}
