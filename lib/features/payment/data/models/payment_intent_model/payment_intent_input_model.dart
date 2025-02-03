class PaymentIntentInputModel {
  final String amount;
  final String currency;
  final String customerId;
  PaymentIntentInputModel({
    required this.amount,
    required this.currency,
    required this.customerId,
  });
  toJson() {
    return {
      "amount": amount,
      "currency": currency,
      "customer": customerId,
      "automatic_payment_methods[enabled]": true
    };
  }
}
