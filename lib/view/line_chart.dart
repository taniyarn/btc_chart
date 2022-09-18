import 'package:btc_chart/controller/ohlc_controller.dart';
import 'package:btc_chart/model/spot.dart';
import 'package:btc_chart/view/line_chart_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LineChart extends ConsumerStatefulWidget {
  const LineChart({
    Key? key,
    required this.data,
    required this.horizontalAxisInterval,
  }) : super(key: key);
  final List<Spot> data;
  final double horizontalAxisInterval;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LineChartState();
}

class _LineChartState extends ConsumerState<LineChart> {
  bool _onTapped = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        return GestureDetector(
          onPanDown: (details) {
            final percentage = details.localPosition.dx / maxWidth;
            final newSelectedIndex =
                ((widget.data.length - 1) * percentage).round();
            ref.read(selectedIndexProvider.notifier).state = newSelectedIndex;
            setState(() {
              _onTapped = true;
            });
          },
          onPanUpdate: (details) {
            final percentage = details.localPosition.dx / maxWidth;
            final newSelectedIndex =
                ((widget.data.length - 1) * percentage).round();
            ref.read(selectedIndexProvider.notifier).state = newSelectedIndex;
          },
          onPanEnd: (_) {
            ref.read(selectedIndexProvider.notifier).state =
                widget.data.length - 1;
            setState(() {
              _onTapped = false;
            });
          },
          child: CustomPaint(
            painter: LineChartPainter(
              data: widget.data,
              horizontalAxisInterval: widget.horizontalAxisInterval,
              selectedIndex:
                  _onTapped ? ref.watch(selectedIndexProvider) : null,
            ),
            child: Container(),
          ),
        );
      },
    );
  }
}
