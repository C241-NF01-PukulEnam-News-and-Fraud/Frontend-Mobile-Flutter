class FraudData {
  final List<String> Entities;
  final List<String> Bias;
  final List<double> Result;

  FraudData({
    required this.Entities,
    required this.Bias,
    required this.Result,
  });

  factory FraudData.fromJson(Map<String, dynamic> json) {
    return FraudData(
      Entities: List<String>.from(json['entities']),
      Bias: List<String>.from(json['bias']),
      Result: List<double>.from(json['result']),
    );
  }

  String get Sentiment => Bias.isNotEmpty ? Bias[0] : 'unknown';
}
