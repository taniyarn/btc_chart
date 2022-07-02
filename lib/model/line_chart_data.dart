import 'dart:math';

class LineChartData {
  LineChartData(this.x, this.y);

  final num x;
  final num y;
}

extension ListExtensionForLineChartData on List<LineChartData> {
  num get minY {
    final temp = map((d) => d.y).toList()..sort();
    return temp.first;
  }

  num get maxY {
    final temp = map((d) => d.y).toList()..sort();
    return temp.last;
  }

  num minChartY(num interval) => (minY / interval).floor() * interval;

  num maxChartY(num interval) => (maxY / interval).ceil() * interval;

  int getGridNum(num interval) =>
      (maxY / interval).ceil() - (minY / interval).floor() + 1;
}
