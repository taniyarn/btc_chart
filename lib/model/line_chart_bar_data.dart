import 'package:btc_chart/model/spot.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

class LineChartBarData extends Equatable {
  const LineChartBarData({
    required this.spots,
    required this.color,
  });

  final List<Spot> spots;
  final Color color;

  @override
  List<Object?> get props => [spots, color];
}
