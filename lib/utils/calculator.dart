class ElectricityCalculator {
  /// Calculates total charges based on tiered block rates (in RM)
  static double calculateTotalCharges(double units) {
    double total = 0.0;

    if (units <= 0) return 0.0;

    // Block 1: 1–200 kWh @ 21.8 sen/kWh
    if (units <= 200) {
      total = units * 0.218;
    }
    // Block 2: 201–300 kWh @ 33.4 sen/kWh
    else if (units <= 300) {
      total = 200 * 0.218;
      total += (units - 200) * 0.334;
    }
    // Block 3: 301–600 kWh @ 51.6 sen/kWh
    else if (units <= 600) {
      total = 200 * 0.218;
      total += 100 * 0.334;
      total += (units - 300) * 0.516;
    }
    // Block 4: 601–1000 kWh @ 54.6 sen/kWh
    else {
      total = 200 * 0.218;
      total += 100 * 0.334;
      total += 300 * 0.516;
      total += (units - 600) * 0.546;
    }

    return double.parse(total.toStringAsFixed(4));
  }

  /// Calculates final cost after applying rebate
  static double calculateFinalCost(double totalCharges, double rebatePercent) {
    double rebateAmount = totalCharges * (rebatePercent / 100);
    double finalCost = totalCharges - rebateAmount;
    return double.parse(finalCost.toStringAsFixed(4));
  }
}