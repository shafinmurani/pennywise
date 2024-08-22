class IncomeModel{
  final double amount;
  final String source;
  final String id;

  IncomeModel({required this.amount, required this.source, required this.id});

  toJson() {
    return {
      "amount": amount,
      "source": source,
      "id": id,
    };
  }
}
