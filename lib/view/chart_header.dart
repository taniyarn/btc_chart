import 'dart:ui';

import 'package:btc_chart/controller/ohlc_controller.dart';
import 'package:btc_chart/view/chart_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ChartHeader extends ConsumerWidget {
  const ChartHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ohlcs = ref.watch(ohlcProvider);
    final selectedIndex = ref.watch(selectedIndexProvider);
    final dateTime = DateTime.fromMillisecondsSinceEpoch(
      ohlcs.value![selectedIndex].closeTime * 1000,
    );

    final formatedDateTime =
        '${dateTime.year}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.day.toString().padLeft(2, '0')}';
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(headerPadding),
          child: Text(
            '${NumberFormat('#,###').format(
              ohlcs.value![selectedIndex].closePrice,
            )}円',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFeatures: const [
                FontFeature.tabularFigures(),
              ],
            ),
          ),
        ),
        Text(
          formatedDateTime,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 16,
            fontFeatures: const [
              FontFeature.tabularFigures(),
            ],
          ),
        )
      ],
    );
  }
}
