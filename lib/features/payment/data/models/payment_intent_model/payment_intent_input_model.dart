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
    // Convert amount to integer in cents as required by Stripe
    // If amount is null or can't be parsed, default to 0
    // final amountInCents = int.tryParse(amount) != null
    //     ? (int.parse(amount) * 100).toString()
    //     : '0';

    return {
      "amount": (int.parse(amount) * 100).toString(),
      "currency": currency,
      "customer": customerId,
      "automatic_payment_methods[enabled]": true
    };
  }
}
