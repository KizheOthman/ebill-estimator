class BillRecord {
  int? id;
  String month;
  double unitUsed;
  double totalCharges;
  double rebatePercent;
  double finalCost;

  BillRecord({
    this.id,
    required this.month,
    required this.unitUsed,
    required this.totalCharges,
    required this.rebatePercent,
    required this.finalCost,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'month': month,
      'unitUsed': unitUsed,
      'totalCharges': totalCharges,
      'rebatePercent': rebatePercent,
      'finalCost': finalCost,
    };
  }

  factory BillRecord.fromMap(Map<String, dynamic> map) {
    return BillRecord(
      id: map['id'],
      month: map['month'],
      unitUsed: map['unitUsed'],
      totalCharges: map['totalCharges'],
      rebatePercent: map['rebatePercent'],
      finalCost: map['finalCost'],
    );
  }
}