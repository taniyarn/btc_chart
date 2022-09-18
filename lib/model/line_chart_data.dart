import 'package:btc_chart/model/line_chart_bar_data.dart';
import 'package:equatable/equatable.dart';

class LineChartData extends Equatable {
  const LineChartData(this.barsData);

  final List<LineChartBarData> barsData;

  @override
  List<Object?> get props => [barsData];
}
