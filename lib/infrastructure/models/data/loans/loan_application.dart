import 'dart:io';

class LoanApplicationModel {
  final String idNumber;
  final double amount;
  final Map<String, File> documents;

  LoanApplicationModel({
    required this.idNumber,
    required this.amount,
    required this.documents,
  });

  Map<String, dynamic> toJson() => {
    'id_number': idNumber,
    'amount': amount,
  };
}