class DataModel {
  DataModel({
    required this.closeTime,
    required this.openPrice,
    required this.highPrice,
    required this.lowPrice,
    required this.closePrice,
    required this.volume,
    required this.quoteVolume,
  });

  factory DataModel.fromList(List list) {
    return DataModel(
      closeTime: list[0] as int,
      openPrice: list[1] as int,
      highPrice: list[2] as int,
      lowPrice: list[3] as int,
      closePrice: list[4] as int,
      volume: list[5] as double,
      quoteVolume: list[6] as double,
    );
  }
  int closeTime;
  int openPrice;
  int highPrice;
  int lowPrice;
  int closePrice;
  double volume;
  double quoteVolume;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'closeTime': closeTime,
      'openPrice': openPrice,
      'highPrice': highPrice,
      'lowPrice': lowPrice,
      'closePrice': closePrice,
      'volume': volume,
      'quoteVolume': quoteVolume,
    };
  }
}
