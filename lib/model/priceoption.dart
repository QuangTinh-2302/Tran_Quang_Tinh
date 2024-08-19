class PriceOption{
  late final String supplierRetailPrice;
  final String terminalPrice;
  final String latestPrice;
  final String discountAmount;
  final double discountPercent;
  final String sellPrice;
  final String minLatestPrice;
  final String maxLatestPrice;
  final String bestComboDiscount;


  PriceOption({
    required this.supplierRetailPrice,
    required this.terminalPrice,
    required this.latestPrice,
    required this.discountAmount,
    required this.discountPercent,
    required this.sellPrice,
    required this.minLatestPrice,
    required this.maxLatestPrice,
    required this.bestComboDiscount
  });
  factory PriceOption.fromJson(Map<String, dynamic> json){
    return PriceOption(
      supplierRetailPrice : json['supplierRetailPrice'],
      terminalPrice : json['terminalPrice'],
      latestPrice : json['latestPrice'],
      discountAmount : json['discountAmount'],
      discountPercent : json['discountPercent'],
      sellPrice : json['sellPrice'],
      minLatestPrice : json['minLatestPrice'],
      maxLatestPrice : json['maxLatestPrice'],
      bestComboDiscount : json['bestComboDiscount'],
    );
  }
}