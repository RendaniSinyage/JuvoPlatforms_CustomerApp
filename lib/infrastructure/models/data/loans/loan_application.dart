import 'dart:io';

class LoanApplicationModel {
  final String idNumber;
  final double amount;
  final Map<String, File> documents;
  final String? savedApplicationId; // Added field for saved application ID

  LoanApplicationModel({
    required this.idNumber,
    required this.amount,
    required this.documents,
    this.savedApplicationId, // Optional parameter for saved applications
  });

  Map<String, dynamic> toJson() {
    return {
      'id_number': idNumber,
      'amount': amount,
      'saved_application_id': savedApplicationId,
    };
  }
}