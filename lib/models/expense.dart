class Expense {
  final double amount;
  final String topic;
  final String id;

  Expense({required this.amount, required this.topic, required this.id});

  toJson() {
    return {
      "amount": amount,
      "topic": topic,
      "id": id,
    };
  }
}
