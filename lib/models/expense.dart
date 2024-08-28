class ExpenseModel {
  final double amount;
  final String topic;
  final int id;
  DateTime? dateTime;

  ExpenseModel({
    required this.amount,
    required this.topic,
    required this.id,
    this.dateTime,
  });

  toJson() {
    return {
      "amount": amount,
      "topic": topic,
      "id": id,
      "datetime": DateTime.fromMillisecondsSinceEpoch(id).toIso8601String()
    };
  }
}
