import 'package:btc_chart/model/line_chart_data.dart';
import 'package:btc_chart/view/line_chart_painter.dart';
import 'package:flutter/material.dart';

class LineChart extends StatelessWidget {
  const LineChart({
    Key? key,
    required this.data,
    required this.horizontalAxisInterval,
  }) : super(key: key);
  final List<LineChartData> data;
  final double horizontalAxisInterval;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: LineChartPainter(
        data: data,
        horizontalAxisInterval: horizontalAxisInterval,
      ),
      child: Container(),
    );
  }
}
