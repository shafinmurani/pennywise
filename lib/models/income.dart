class IncomeModel {
  final double amount;
  final String source;
  final int id;
  DateTime? dateTime;

  IncomeModel({
    required this.amount,
    required this.source,
    required this.id,
    this.dateTime,
  });

  toJson() {
    return {
      "amount": amount,
      "source": source,
      "id": id,
      "datetime": DateTime.fromMillisecondsSinceEpoch(id).toIso8601String()
    };
  }
}
