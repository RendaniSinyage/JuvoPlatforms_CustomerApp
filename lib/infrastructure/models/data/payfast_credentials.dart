class PayFastCredentials {
  //final String merchantId;
  final String merchantKey;
  final String passphrase;
  final bool isSandbox;

  PayFastCredentials({
    //required this.merchantId,
    required this.merchantKey,
    required this.passphrase,
    this.isSandbox = true,
  });

  factory PayFastCredentials.fromJson(Map<String, dynamic> json) {
    return PayFastCredentials(
     // merchantId: json['merchant_id'] as String,
      merchantKey: json['merchant_key'] as String,
      passphrase: json['passphrase'] as String,
      isSandbox: json['is_sandbox'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
     // 'merchant_id': merchantId,
      'merchant_key': merchantKey,
      'passphrase': passphrase,
      'is_sandbox': isSandbox,
    };
  }
}