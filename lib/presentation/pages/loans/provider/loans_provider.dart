// Providers for managing loan application state
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final loanAmountProvider = StateProvider<double>((ref) => 200);
final uploadedFilesProvider = StateProvider<Map<String, File>>((ref) => {});
final pendingContractProvider = StateProvider<dynamic>((ref) => null);

// Providers for managing document upload state
final idNumberProvider = StateProvider<String>((ref) => '');
final uploadedDocumentsProvider = StateProvider<Map<String, File>>((ref) => {});