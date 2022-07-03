import 'package:btc_chart/controller/ohlc_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ChartHeader extends ConsumerWidget {
  const ChartHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedOhlc = ref.watch(selectedOhlcProvider);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Bitcoin',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 24,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '${NumberFormat('#,###').format(
              selectedOhlc!.y,
            )}円',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 24,
            ),
          ),
        ),
      ],
    );
  }
}
