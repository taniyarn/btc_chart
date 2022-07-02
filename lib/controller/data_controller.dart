import 'dart:convert';

import 'package:btc_chart/model/data_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final getDataFuture =
    ChangeNotifierProvider<GetDataFromApi>((ref) => GetDataFromApi());

class GetDataFromApi extends ChangeNotifier {
  GetDataFromApi() {
    getData();
  }
  List<DataModel> listDataModel = [];

  Future getData() async {
    listDataModel = [];
    try {
      final response = await http.get(Uri.parse(
        'https://api.cryptowat.ch/markets/bitflyer/btcjpy/ohlc?periods=86400&after=1640962800',
      ));

      final body = jsonDecode(response.body) as Map;
      final result = body['result'] as Map;
      final data = result['86400'] as List;

      for (var i = 0; i < data.length; i++) {
        listDataModel.add(DataModel.fromList(data[i] as List));
      }
    } catch (e) {
      print(e.toString());
    }

    notifyListeners();
  }
}
