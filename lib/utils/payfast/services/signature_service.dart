import 'dart:convert';
import 'package:crypto/crypto.dart' as crypto;

class SignatureService {
  /// Creates a PayFast-compatible signature for payment parameters
  ///
  /// This method strictly follows PayFast's signature generation requirements:
  /// 1. Sort all parameters alphabetically by key name
  /// 2. Concatenate all parameter key-value pairs with & between each pair
  /// 3. Append the passphrase with a leading &
  /// 4. Generate an MD5 hash of the resulting string
  static String createSignature(Map<String, dynamic> queryParameters, String passphrase) {
    // Create a copy of the parameters to avoid modifying the original
    final params = Map<String, String>.from(queryParameters.map(
            (key, value) => MapEntry(key, value?.toString() ?? '')
    ));

    // Filter out null values and empty strings
    params.removeWhere((key, value) => value == null || value.isEmpty);

    // Sort keys alphabetically
    final sortedKeys = params.keys.toList()..sort();

    // Build parameter string
    final parameterString = sortedKeys.map((key) {
      final value = params[key]!;
      return '$key=$value';
    }).join('&');

    // Add passphrase
    final signatureString = passphrase.isNotEmpty
        ? '$parameterString&passphrase=$passphrase'
        : parameterString;

    // Generate MD5 hash
    return crypto.md5.convert(utf8.encode(signatureString)).toString();
  }
}