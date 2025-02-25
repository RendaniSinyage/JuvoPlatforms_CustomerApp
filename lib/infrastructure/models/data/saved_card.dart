import 'package:flutter/foundation.dart';

/// Model class representing a saved payment card
class SavedCardModel {
  final String id;
  final String token;
  final String lastFour;
  final String cardType;
  final String expiryDate;
  final String cardHolderName;
  final bool isDefault;

  SavedCardModel({
    required this.id,
    required this.token,
    required this.lastFour,
    required this.cardType,
    required this.expiryDate,
    required this.cardHolderName,
    this.isDefault = false,
  });

  /// Create a SavedCardModel from JSON
  factory SavedCardModel.fromJson(Map<String, dynamic> json) {
    // Print the JSON for debugging
    debugPrint('Parsing card JSON: $json');

    return SavedCardModel(
      id: json['id']?.toString() ?? '',
      token: json['token']?.toString() ?? '',
      lastFour: json['last_four']?.toString() ?? '',
      cardType: json['card_type']?.toString() ?? 'Card',
      expiryDate: json['expiry_date']?.toString() ?? '',
      cardHolderName: json['card_holder_name']?.toString() ?? '',
      isDefault: json['is_default'] == true || json['is_default'] == 1,
    );
  }

  /// Convert the SavedCardModel to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'token': token,
      'last_four': lastFour,
      'card_type': cardType,
      'expiry_date': expiryDate,
      'card_holder_name': cardHolderName,
      'is_default': isDefault,
    };
  }

  /// Create a copy of this SavedCardModel with some fields replaced
  SavedCardModel copyWith({
    String? id,
    String? token,
    String? lastFour,
    String? cardType,
    String? expiryDate,
    String? cardHolderName,
    bool? isDefault,
  }) {
    return SavedCardModel(
      id: id ?? this.id,
      token: token ?? this.token,
      lastFour: lastFour ?? this.lastFour,
      cardType: cardType ?? this.cardType,
      expiryDate: expiryDate ?? this.expiryDate,
      cardHolderName: cardHolderName ?? this.cardHolderName,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  @override
  String toString() {
    return 'SavedCardModel(id: $id, token: $token, lastFour: $lastFour, '
        'cardType: $cardType, expiryDate: $expiryDate, isDefault: $isDefault)';
  }
}