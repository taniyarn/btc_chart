import 'package:btc_chart/view/chart_const.dart';
import 'package:btc_chart/view/chart_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bitcoin chart',
      theme: ThemeData(
        primaryColor: bitcoinColor,
      ),
      home: const ChartView(),
    );
  }
}
