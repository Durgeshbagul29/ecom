class AppPricingCalculator {

  /// Calculate Price based on tax and shipping
  static double calculateTotalPrice(double productPrice, String location) {
    double taxRate = getTaxRateForLocation(location);
    double taxAmount = productPrice * taxRate;

    double shippingCost = getShippingCost(location);

    double totalPrice = productPrice + taxAmount + shippingCost;
    return totalPrice;
  }

  /// Calculate shipping cost
  static String calculateShippingCost(double productPrice, String location) {
    double shippingCost = getShippingCost(location);
    return shippingCost.toStringAsFixed(2);
  }

  /// Calculate tax
  static String calculateTax(double productPrice, String location) {
    double taxRate = getTaxRateForLocation(location);
    double taxAmount = productPrice * taxRate;
    return taxAmount.toStringAsFixed(2);
  }

  static double getTaxRateForLocation(String location) {
    // Example tax rates by location
    switch (location.toLowerCase()) {
      case "us":
        return 0.07; // 7%
      case "uk":
        return 0.2; // 20%
      case "in":
        return 0.18; // 18%
      default:
        return 0.1; // default 10%
    }
  }

  static double getShippingCost(String location) {
    // Example flat shipping cost
    switch (location.toLowerCase()) {
      case "us":
        return 5.0;
      case "uk":
        return 8.0;
      case "in":
        return 3.0;
      default:
        return 10.0;
    }
  }
}
