import 'package:btc_chart/model/line_chart_data.dart';
import 'package:btc_chart/view/line_chart_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LineChart extends ConsumerStatefulWidget {
  const LineChart({
    Key? key,
    required this.data,
    required this.horizontalAxisInterval,
  }) : super(key: key);
  final LineChartData data;
  final double horizontalAxisInterval;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LineChartState();
}

class _LineChartState extends ConsumerState<LineChart> {
  final notifier = ValueNotifier(Offset.zero);

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (e) => notifier.value = e.localPosition,
      onPointerMove: (e) => notifier.value = e.localPosition,
      child: CustomPaint(
        painter: LineChartPainter(
          notifier: notifier,
          data: widget.data,
          horizontalAxisInterval: widget.horizontalAxisInterval,
        ),
        child: const SizedBox.expand(),
      ),
    );
  }
}
