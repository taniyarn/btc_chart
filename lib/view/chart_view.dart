import 'package:btc_chart/controller/ohlc_controller.dart';
import 'package:btc_chart/model/line_chart_bar_data.dart';
import 'package:btc_chart/model/line_chart_data.dart';
import 'package:btc_chart/model/spot.dart';
import 'package:btc_chart/view/chart_const.dart';
import 'package:btc_chart/view/line_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChartView extends ConsumerWidget {
  const ChartView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ohlcs = ref.watch(ohlcProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Line Chart Sample',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
        backgroundColor: bitcoinColor,
      ),
      body: ohlcs.when(
        data: (_ohlcs) => Column(
          children: [
            Expanded(
              child: LineChart(
                data: LineChartData([
                  LineChartBarData(
                    spots: _ohlcs
                        .map(
                          (ohlc) => Spot(
                            ohlc.closeTime,
                            ohlc.closePrice,
                          ),
                        )
                        .toList(),
                    color: Colors.blue,
                  ),
                  LineChartBarData(
                    spots: _ohlcs
                        .map(
                          (ohlc) => Spot(
                            ohlc.closeTime,
                            ohlc.closePrice / 10,
                          ),
                        )
                        .toList(),
                    color: Colors.red,
                  ),
                  LineChartBarData(
                    spots: _ohlcs
                        .map(
                          (ohlc) => Spot(
                            ohlc.closeTime,
                            ohlc.closePrice / 20,
                          ),
                        )
                        .toList(),
                    color: Colors.green,
                  ),
                ]),
                horizontalAxisInterval: horizontalAxisInterval,
              ),
            ),
          ],
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(
            color: bitcoinColor,
          ),
        ),
        error: (error, _) => Text(error.toString()),
      ),
    );
  }
}
