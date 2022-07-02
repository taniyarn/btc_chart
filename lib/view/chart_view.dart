import 'package:btc_chart/controller/data_controller.dart';
import 'package:btc_chart/model/line_chart_data.dart';
import 'package:btc_chart/view/line_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChartView extends ConsumerWidget {
  const ChartView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(getDataFuture);
    return Scaffold(
      appBar: AppBar(
        title: Text('Fetch Data'),
      ),
      body: viewModel.listDataModel.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : LineChart(
              data: viewModel.listDataModel
                  .map(
                    (data) => LineChartData(
                      data.closeTime,
                      data.closePrice,
                    ),
                  )
                  .toList(),
              horizontalAxisInterval: 1000000,
            ),
    );
  }
}
