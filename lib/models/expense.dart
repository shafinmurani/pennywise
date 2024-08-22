class ExpenseModel {
  final double amount;
  final String topic;
  final int id;

  ExpenseModel({required this.amount, required this.topic, required this.id});

  toJson() {
    return {
      "amount": amount,
      "topic": topic,
      "id": id,
    };
  }
}
