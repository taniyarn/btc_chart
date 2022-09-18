import 'package:btc_chart/model/line_chart_bar_data.dart';
import 'package:btc_chart/model/line_chart_data.dart';
import 'package:btc_chart/model/spot.dart';
import 'package:btc_chart/view/chart_const.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show NumberFormat;

class LineChartPainter extends CustomPainter {
  LineChartPainter({
    required this.notifier,
    required this.data,
    required this.horizontalAxisInterval,
  })  : _selectedBarData = null,
        super(repaint: notifier);

  final ValueNotifier<Offset> notifier;
  final LineChartData data;
  final double horizontalAxisInterval;

  LineChartBarData? _selectedBarData;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: size.width,
      height: size.height * heightRatio,
    );
    _selectedBarData = null;
    for (final barData in data.barsData) {
      drawTappableArea(canvas, rect, barData);
    }
    for (final barData in data.barsData) {
      drawChart(canvas, rect, barData);
    }

    drawBorder(canvas, rect);

    drawLabels(canvas, rect);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

  void drawBorder(Canvas canvas, Rect rect) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.5)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.fill;

    // TODO: Calculate GridNum dynamically
    final gridNum =
        data.barsData.first.spots.getGridNum(horizontalAxisInterval);
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

  void drawTappableArea(Canvas canvas, Rect rect, LineChartBarData barData) {
    final span = rect.width / (barData.spots.length - 1);
    var x = rect.left;

    final minChartY = barData.spots.minChartY(horizontalAxisInterval);
    final deltaChartY =
        barData.spots.maxChartY(horizontalAxisInterval) - minChartY;

    final points = <Offset>[];
    for (final d in barData.spots) {
      final y = rect.bottom - (d.y - minChartY) / deltaChartY * rect.height;
      points.add(Offset(x, y));
      x += span;
    }

    const tappableWidth = 32.0;
    final tappablePath = Path();
    for (var i = 0; i < points.length - 3; i++) {
      final dr = points[i + 3] - points[i];
      final dn = Offset(-dr.dy / dr.distance, dr.dx / dr.distance);
      final cornerLeftTop = points[i] + dn * tappableWidth / 2;
      final cornerRightTop = cornerLeftTop + dr;
      final cornerRightBottom = cornerRightTop - dn * tappableWidth;
      final cornerLeftBottom = cornerRightBottom - dr;
      final rectangle = Path()
        ..moveTo(cornerLeftTop.dx, cornerLeftTop.dy)
        ..lineTo(cornerRightTop.dx, cornerRightTop.dy)
        ..lineTo(cornerRightBottom.dx, cornerRightBottom.dy)
        ..lineTo(cornerLeftBottom.dx, cornerLeftBottom.dy)
        ..lineTo(cornerLeftTop.dx, cornerLeftTop.dy);
      tappablePath.addPath(rectangle, Offset.zero);
    }

    final selected = tappablePath.contains(notifier.value);

    _selectedBarData ??= selected ? barData : null;

    final paintStroke = Paint()
      ..color = barData.color.withOpacity(selected ? 0.3 : 0.1)
      ..strokeWidth = 3.0
      ..style = PaintingStyle.fill;

    canvas.drawPath(tappablePath, paintStroke);
  }

  void drawChart(Canvas canvas, Rect rect, LineChartBarData barData) {
    final paintStroke = Paint()
      ..color = barData.color.withOpacity(0.3)
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    final span = rect.width / (barData.spots.length - 1);
    final path = Path();
    var x = rect.left;

    final minChartY = barData.spots.minChartY(horizontalAxisInterval);
    final deltaChartY =
        barData.spots.maxChartY(horizontalAxisInterval) - minChartY;

    final points = <Offset>[];
    for (final d in barData.spots) {
      final y = rect.bottom - (d.y - minChartY) / deltaChartY * rect.height;

      points.add(Offset(x, y));

      x += span;
    }
    path.addPolygon(points, false);

    if (_selectedBarData == null || barData == _selectedBarData) {
      paintStroke.color = paintStroke.color.withOpacity(1);
    }
    canvas.drawPath(path, paintStroke);
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
    final span = data.barsData.first.spots.length ~/ (xLableNum + 1);

    var year = 0;
    for (var i = 1; i <= xLableNum; i++) {
      final dateTime = DateTime.fromMillisecondsSinceEpoch(
        data.barsData.first.spots[i * span].x.toInt() * 1000,
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
          rect.left + rect.width * i * span / data.barsData.first.spots.length,
          rect.bottom + bottomPadding,
        ),
        textWidth,
        labelStyle,
        formatedDateTime,
      );
    }
  }

  void drawYLabel(Canvas canvas, Rect rect, TextStyle labelStyle) {
    // TODO: Calculate GridNum dynamically
    final gridNum =
        data.barsData.first.spots.getGridNum(horizontalAxisInterval);
    final span = rect.height / (gridNum - 1);
    var y = rect.bottom;

    for (var i = 0; i < gridNum; i++) {
      drawText(
        canvas,
        Offset(rect.left, y),
        textWidth,
        labelStyle,
        NumberFormat('#,###').format(
          // TODO: Calculate minChartY dynamically
          data.barsData.first.spots.minChartY(horizontalAxisInterval) +
              i * horizontalAxisInterval,
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
}
