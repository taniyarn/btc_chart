import 'dart:convert';

import 'package:btc_chart/model/line_chart_data.dart';
import 'package:btc_chart/model/ohlc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final ohlcProvider = FutureProvider<List<Ohlc>>((ref) async {
  final ohlcs = await OhlcApi().getData();
  final data = ref.read(selectedOhlcProvider.notifier);
  data.state = LineChartData(ohlcs.last.closeTime, ohlcs.last.closePrice);
  return OhlcApi().getData();
});
final selectedOhlcProvider = StateProvider<LineChartData?>((ref) => null);

class OhlcApi {
  Future<List<Ohlc>> getData() async {
    final ohlcs = <Ohlc>[];

    final response = await http.get(Uri.parse(
      'https://api.cryptowat.ch/markets/bitflyer/btcjpy/ohlc?periods=86400&after=1640962800',
    ));

    final body = jsonDecode(response.body) as Map;
    final result = body['result'] as Map;
    final data = result['86400'] as List;

    for (var i = 0; i < data.length; i++) {
      ohlcs.add(Ohlc.fromList(data[i] as List));
    }

    return ohlcs;
  }
}
