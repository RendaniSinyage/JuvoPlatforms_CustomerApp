import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Loan amount (slider value)
final loanAmountProvider = StateProvider<double>((ref) => 200.0);

// ID number for loan application
final idNumberProvider = StateProvider<String>((ref) => '');

// Provider to store financial details
final financialDetailsProvider = StateProvider<Map<String, dynamic>>((ref) => {});

// Provider to store uploaded documents
final uploadedDocumentsProvider = StateProvider<Map<String, File>>((ref) => {});

// Provider to store accepted qualifying amount
// Changed from double? to double with a default value of 0.0
final acceptedQualifyingAmountProvider = StateProvider<double?>((ref) => null);

// Provider to store pending contract data
final pendingContractProvider = StateProvider<dynamic>((ref) => null);

// Provider to store saved application ID when continuing from a saved application
final savedApplicationIdProvider = StateProvider<String?>((ref) => null);

// Provider to track if user has an application in pending_review status
final hasPendingApplicationProvider = StateProvider<bool>((ref) => false);