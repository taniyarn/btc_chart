import 'package:btc_chart/model/spot.dart';
import 'package:equatable/equatable.dart';

class LineChartBarData extends Equatable {
  const LineChartBarData(this.spots);
  final List<Spot> spots;

  @override
  List<Object?> get props => [spots];
}
