class LoanContractModel {
  final String id;
  final String title;
  final String content;
  final DateTime createdAt;

  LoanContractModel({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
  });

  factory LoanContractModel.fromJson(Map<String, dynamic> json) {
    return LoanContractModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? 'Loan Contract',
      content: json['content'] ?? '',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }
}