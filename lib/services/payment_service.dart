import 'dart:math';

enum PaymentMethod { bankTransfer, eWallet, virtualCard }

extension PaymentMethodExtension on PaymentMethod {
  String get label {
    switch (this) {
      case PaymentMethod.bankTransfer:
        return 'Transfer Bank';
      case PaymentMethod.eWallet:
        return 'E-Wallet';
      case PaymentMethod.virtualCard:
        return 'Kartu Kredit Virtual';
    }
  }

  String get description {
    switch (this) {
      case PaymentMethod.bankTransfer:
        return 'Pembayaran melalui transfer bank.';
      case PaymentMethod.eWallet:
        return 'Pembayaran cepat menggunakan dompet digital.';
      case PaymentMethod.virtualCard:
        return 'Pembayaran dengan kartu kredit virtual.';
    }
  }
}

class PaymentResult {
  final bool success;
  final String transactionId;
  final String message;

  PaymentResult({
    required this.success,
    required this.transactionId,
    required this.message,
  });
}

class PaymentService {
  static Future<PaymentResult> processPayment(
    double amount,
    PaymentMethod method,
  ) async {
    await Future.delayed(const Duration(seconds: 2));
    final success = Random().nextInt(100) < 92;
    final transactionId = 'TRX${DateTime.now().millisecondsSinceEpoch % 1000000}';
    final message = success
        ? 'Pembayaran berhasil melalui ${method.label}.'
        : 'Pembayaran gagal. Silakan coba lagi.';
    return PaymentResult(
      success: success,
      transactionId: transactionId,
      message: message,
    );
  }
}
