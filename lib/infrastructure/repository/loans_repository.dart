import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:foodyman/app_constants.dart';
import 'package:foodyman/domain/di/dependency_manager.dart';
import 'package:foodyman/infrastructure/models/data/loans/loan_contract_model.dart';
import 'package:foodyman/infrastructure/services/app_helpers.dart';
import 'package:foodyman/infrastructure/services/local_storage.dart';
import 'package:foodyman/domain/handlers/handlers.dart';
import 'package:http/http.dart' as http;
import 'dart:math';
import 'package:http_parser/http_parser.dart';
import 'package:payfast/payfast.dart';
import '../../domain/interface/loans.dart';
import '../../utils/payfast/payfast_webview.dart';
import '../models/data/loans/loan_application.dart';

class LoansRepository implements LoansRepositoryFacade {

  @override
  Future<ApiResult<dynamic>> submitLoanApplication({
    required LoanApplicationModel applicationData,
  }) async {
    debugPrint('==> Starting loan application submission');
    debugPrint('==> ID Number: ${applicationData.idNumber}');
    debugPrint('==> Amount: ${applicationData.amount}');
    debugPrint('==> Currency ID: ${LocalStorage.getSelectedCurrency()?.id ?? 1}');
    debugPrint('==> Document count: ${applicationData.documents.length}');
    debugPrint('==> Saved Application ID: ${applicationData.savedApplicationId}');

    try {
      final client = dioHttp.client(requireAuth: true);
      debugPrint('==> Created authenticated client');

      // Create multipart request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${AppConstants.baseUrl}/api/v1/dashboard/user/loan/application'),
      );
      debugPrint('==> Created request to ${request.url}');

      // Add authentication headers
      request.headers['Authorization'] = 'Bearer ${LocalStorage.getToken()}';
      request.headers['Accept'] = 'application/json';
      debugPrint('==> Added authorization headers');

      // Add loan application data fields
      request.fields['id_number'] = applicationData.idNumber;
      request.fields['amount'] = applicationData.amount.toString();
      request.fields['currency_id'] = (LocalStorage.getSelectedCurrency()?.id ?? 1).toString();

      // Add saved application ID if available (for updating existing applications)
      if (applicationData.savedApplicationId != null) {
        request.fields['saved_application_id'] = applicationData.savedApplicationId!;
        debugPrint('==> Added saved application ID: ${applicationData.savedApplicationId}');
      }

      debugPrint('==> Added application fields');

      // Add document files with proper field naming
      for (var entry in applicationData.documents.entries) {
        // Format key as 'documents[DocType]'
        String fieldName = 'documents[${entry.key}]';

        debugPrint('==> Adding document: $fieldName from path ${entry.value.path}');

        request.files.add(
            await http.MultipartFile.fromPath(
              fieldName,
              entry.value.path,
              contentType: MediaType('application', 'pdf'),
            )
        );
      }

      debugPrint('==> Added ${applicationData.documents.length} documents to request');

      // Send the request
      debugPrint('==> Sending multipart request');
      final streamedResponse = await request.send();
      debugPrint('==> Got streamed response with status: ${streamedResponse.statusCode}');
      final response = await http.Response.fromStream(streamedResponse);
      debugPrint('==> Converted to standard response');

      // Check response
      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('==> Loan application successful: ${response.body}');
        return ApiResult.success(data: json.decode(response.body));
      } else {
        debugPrint('==> Loan application failed with status ${response.statusCode}: ${response.body}');
        return ApiResult.failure(
          error: json.decode(response.body)['message'] ?? 'Loan application failed',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      debugPrint('==> loan application submission failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }
  // Fetch Loan Transactions Method
  @override
  Future<ApiResult<List<dynamic>>> fetchLoanTransactions(int page) async {
    debugPrint('==> Fetching loan transactions, page: $page');
    final data = {
      'page': page,
      'type': 'loan', // Add a filter for loan-type transactions
      if (LocalStorage.getSelectedCurrency() != null)
        'currency_id': LocalStorage.getSelectedCurrency()?.id,
      "lang": LocalStorage.getLanguage()?.locale ?? "en"
    };
    debugPrint('==> Query parameters: ${jsonEncode(data)}');

    try {
      final client = dioHttp.client(requireAuth: true);
      debugPrint('==> Created authenticated client');

      debugPrint('==> Sending GET request to /api/v1/dashboard/user/wallet/histories');
      final response = await client.get(
        '/api/v1/dashboard/user/wallet/histories',
        queryParameters: data,
      );
      debugPrint('==> Got response: ${jsonEncode(response.data)}');

      // Check if the response contains wallet histories
      if (response.data != null &&
          response.data['data'] != null &&
          response.data['data'] is List) {
        // Filter for loan transactions if needed
        final transactions = response.data['data'] as List;
        debugPrint('==> Found ${transactions.length} loan transactions');
        return ApiResult.success(data: transactions);
      }

      // Return empty list if no data
      debugPrint('==> No loan transactions found');
      return const ApiResult.success(data: []);
    } catch (e) {
      debugPrint('==> get loan transactions failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }


  @override
  Future<ApiResult<bool>> checkLoanEligibility({
    required String idNumber,
    required double amount,
  }) async {
    debugPrint('==> Checking loan eligibility for ID: $idNumber, amount: $amount');
    try {
      final client = dioHttp.client(requireAuth: true);
      debugPrint('==> Created authenticated client');

      final data = {
        'id_number': idNumber,
        'amount': amount,
        'currency_id': LocalStorage.getSelectedCurrency()?.id ?? 1,
      };
      debugPrint('==> Request data: ${jsonEncode(data)}');

      debugPrint('==> Sending POST request to /api/v1/dashboard/user/loan/eligibility');
      final response = await client.post(
        '/api/v1/dashboard/user/loan/eligibility',
        data: data,
      );
      debugPrint('==> Got response: ${jsonEncode(response.data)}');

      // Assuming the API returns a boolean or a status indicating eligibility
      final isEligible = response.data['is_eligible'] ?? false;
      debugPrint('==> Eligibility result: $isEligible');

      return ApiResult.success(
        data: isEligible,
      );
    } catch (e) {
      debugPrint('==> loan eligibility check failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<dynamic>> getLoanDetails(String loanId) async {
    debugPrint('==> Getting loan details for ID: $loanId');
    try {
      final client = dioHttp.client(requireAuth: true);
      debugPrint('==> Created authenticated client');

      final queryParams = {
        'currency_id': LocalStorage.getSelectedCurrency()?.id ?? 1,
        'lang': LocalStorage.getLanguage()?.locale ?? 'en',
      };
      debugPrint('==> Query parameters: ${jsonEncode(queryParams)}');

      debugPrint('==> Sending GET request to /api/v1/dashboard/user/loan/$loanId');
      final response = await client.get(
        '/api/v1/dashboard/user/loan/$loanId',
        queryParameters: queryParams,
      );
      debugPrint('==> Got response: ${jsonEncode(response.data)}');

      return ApiResult.success(data: response.data['data']);
    } catch (e) {
      debugPrint('==> get loan details failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<bool>> cancelLoanApplication(String loanId) async {
    debugPrint('==> Cancelling loan application with ID: $loanId');
    try {
      final client = dioHttp.client(requireAuth: true);
      debugPrint('==> Created authenticated client');

      debugPrint('==> Sending POST request to /api/v1/dashboard/user/loan/$loanId/cancel');
      await client.post(
        '/api/v1/dashboard/user/loan/$loanId/cancel',
      );
      debugPrint('==> Loan cancellation successful');

      return const ApiResult.success(data: true);
    } catch (e) {
      debugPrint('==> cancel loan application failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<String>> tokenizeCardWithVerificationFee({
    required BuildContext context,
    bool forceCardPayment = true,
    bool enableTokenization = true,
  }) async {
    debugPrint('==> Starting card tokenization with verification fee');
    try {
      // Similar to processWalletTopUp, but with a fixed R5 amount
      final data = {
        'total_price': 5.0,
        'currency_id': LocalStorage.getSelectedCurrency()?.id ?? 1,
      };

      debugPrint('==> tokenization charge request: ${jsonEncode(data)}');
      final client = dioHttp.client(requireAuth: true);
      debugPrint('==> Created authenticated client');

      debugPrint('==> Sending GET request to /api/v1/dashboard/user/order-pay-fast-process');
      var res = await client.get(
        '/api/v1/dashboard/user/order-pay-fast-process',
        data: data,
      );

      debugPrint('==> tokenization response: ${jsonEncode(res.data)}');

      final apiData = res.data?["data"]?["data"] ?? {};
      debugPrint('==> API data extracted: ${jsonEncode(apiData)}');

      // Get user information
      final user = LocalStorage.getUser();
      final email = user?.email;
      final phone = user?.phone;
      final firstName = user?.firstname;
      final lastName = user?.lastname;
      debugPrint('==> User info - Email: $email, Phone: $phone, Name: $firstName $lastName');

      // Use PayFastService for payment
      debugPrint('==> Generating PayFast payment URL');
      final paymentUrl = Payfast.enhancedPayment(
        passphrase: AppConstants.passphrase,
        merchantId: AppConstants.merchantId,
        merchantKey: AppConstants.merchantKey,
        production: apiData["sandbox"] != 1,
        amount: '5.00',
        itemName: 'Loan Tokenization',
        notifyUrl: apiData["notify_url"] ?? "",
        cancelUrl: apiData["cancel_url"] ?? "",
        returnUrl: apiData["return_url"] ?? "",
        paymentId: res.data?["data"]?["id"]?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
        email: email,
        phone: phone,
        firstName: firstName,
        lastName: lastName,
        forceCardPayment: forceCardPayment,
        enableTokenization: enableTokenization,
      );
      debugPrint('==> Generated payment URL: $paymentUrl');

      // Preload the WebView if context is available
      if (context != null) {
        try {
          debugPrint('==> Preloading PayFast WebView');
          PayFastWebViewPreloader.preloadPayFastWebView(context, paymentUrl);
          debugPrint('==> WebView preloaded successfully');
        } catch (e) {
          debugPrint('==> Unable to preload PayFast WebView: $e');
        }
      }

      return ApiResult.success(data: paymentUrl);
    } catch (e, s) {
      debugPrint('==> tokenization charge failure: $e, $s');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<LoanContractModel>> fetchLoanContract(String loanId) async {
    debugPrint('==> Fetching loan contract for loan ID: $loanId');
    try {
      final client = dioHttp.client(requireAuth: true);
      debugPrint('==> Created authenticated client');

      final queryParams = {
        'lang': LocalStorage.getLanguage()?.locale ?? 'en',
      };
      debugPrint('==> Query parameters: ${jsonEncode(queryParams)}');

      debugPrint('==> Sending GET request to /api/v1/dashboard/user/loan/$loanId/contract');
      final response = await client.get(
        '/api/v1/dashboard/user/loan/$loanId/contract',
        queryParameters: queryParams,
      );
      debugPrint('==> Got response: ${jsonEncode(response.data)}');

      final contractData = response.data['data'];
      debugPrint('==> Contract data extracted: ${jsonEncode(contractData)}');

      debugPrint('==> Converting to LoanContractModel');
      final contract = LoanContractModel.fromJson(contractData);
      debugPrint('==> Contract model created successfully');

      return ApiResult.success(
        data: contract,
      );
    } catch (e) {
      debugPrint('==> fetch loan contract failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<bool>> acceptLoanContract({
    required String loanId,
    required String contractId,
  }) async {
    debugPrint('==> Accepting loan contract - Loan ID: $loanId, Contract ID: $contractId');
    try {
      final client = dioHttp.client(requireAuth: true);
      debugPrint('==> Created authenticated client');

      final data = {
        'contract_id': contractId,
      };
      debugPrint('==> Request data: ${jsonEncode(data)}');

      debugPrint('==> Sending POST request to /api/v1/dashboard/user/loan/$loanId/contract/accept');
      await client.post(
        '/api/v1/dashboard/user/loan/$loanId/contract/accept',
        data: data,
      );
      debugPrint('==> Contract acceptance successful');

      return const ApiResult.success(data: true);
    } catch (e) {
      debugPrint('==> accept loan contract failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> checkLoanHistoryEligibility() async {
    debugPrint('==> Checking loan history eligibility');
    try {
      final client = dioHttp.client(requireAuth: true);
      debugPrint('==> Created authenticated client');

      final queryParams = {
        'lang': LocalStorage.getLanguage()?.locale ?? 'en',
      };
      debugPrint('==> Query parameters: ${jsonEncode(queryParams)}');

      debugPrint('==> Sending GET request to /api/v1/dashboard/user/loan/history-eligibility');
      final response = await client.get(
        '/api/v1/dashboard/user/loan/history-eligibility',
        queryParameters: queryParams,
      );
      debugPrint('==> Got response: ${jsonEncode(response.data)}');

      final eligibilityData = response.data['data'] ?? {};
      debugPrint('==> Eligibility data: ${jsonEncode(eligibilityData)}');

      return ApiResult.success(
        data: eligibilityData,
      );
    } catch (e) {
      debugPrint('==> check loan history eligibility failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<bool>> markApplicationAsRejected({
    required Map<String, dynamic> financialDetails,
  }) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      debugPrint('==> Marking application as rejected');
      debugPrint('==> Financial details: ${jsonEncode(financialDetails)}');

      // Create the data structure with status explicitly set to 'rejected'
      final data = {
        'id_number': financialDetails['id_number'],
        'amount': financialDetails['loan_amount'] ?? 200.0,
        'status': 'rejected',  // Explicitly set the status
        'additional_data': {
          'financial_details': financialDetails['financial_details'] ?? {},
          'rejection_reason': financialDetails['rejection_reason'] ?? 'Failed eligibility check',
          'rejection_date': financialDetails['rejection_date'] ?? DateTime.now().toIso8601String(),
        }
      };

      debugPrint('==> Request data: ${jsonEncode(data)}');

      // Use the save-incomplete endpoint but explicitly set the status to rejected
      final response = await client.post(
        '/api/v1/dashboard/user/loan/save-incomplete',
        data: data,
      );
      debugPrint('==> Got response: ${jsonEncode(response.data)}');

      return const ApiResult.success(data: true);
    } catch (e) {
      debugPrint('==> mark application as rejected failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> checkFinancialEligibility({
    required double monthlyIncome,
    required double groceryExpenses,
    required double otherExpenses,
    required double existingCredits,
  }) async {
    debugPrint('==> Checking financial eligibility');
    debugPrint('==> Monthly Income: $monthlyIncome');
    debugPrint('==> Grocery Expenses: $groceryExpenses');
    debugPrint('==> Other Expenses: $otherExpenses');
    debugPrint('==> Existing Credits: $existingCredits');

    try {
      final client = dioHttp.client(requireAuth: true);
      debugPrint('==> Created authenticated client');

      final data = {
        'monthly_income': monthlyIncome,
        'grocery_expenses': groceryExpenses,
        'other_expenses': otherExpenses,
        'existing_credits': existingCredits,
        'currency_id': LocalStorage.getSelectedCurrency()?.id ?? 1,
      };
      debugPrint('==> Request data: ${jsonEncode(data)}');

      debugPrint('==> Sending POST request to /api/v1/dashboard/user/loan/financial-eligibility');
      final response = await client.post(
        '/api/v1/dashboard/user/loan/financial-eligibility',
        data: data,
      );
      debugPrint('==> Got response: ${jsonEncode(response.data)}');

      final eligibilityData = response.data['data'] ?? {};
      debugPrint('==> Financial eligibility data: ${jsonEncode(eligibilityData)}');

      return ApiResult.success(
        data: eligibilityData,
      );
    } catch (e) {
      debugPrint('==> check financial eligibility failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<String>> saveIncompleteLoanApplication({
    required Map<String, dynamic> financialDetails,
  }) async {
    debugPrint('==> Saving incomplete loan application');
    debugPrint('==> Financial details: ${jsonEncode(financialDetails)}');

    try {
      final client = dioHttp.client(requireAuth: true);
      debugPrint('==> Created authenticated client');

      // Structure the data properly for saving
      final data = {
        'id_number': financialDetails['id_number'],
        'amount': financialDetails['loan_amount'] ?? 200.0,
        'additional_data': {
          'financial_details': financialDetails['financial_details'] ?? {},
          'uploaded_documents': financialDetails['uploaded_documents'] ?? {},
        }
      };

      debugPrint('==> Request data: ${jsonEncode(data)}');

      debugPrint('==> Sending POST request to /api/v1/dashboard/user/loan/save-incomplete');
      final response = await client.post(
        '/api/v1/dashboard/user/loan/save-incomplete',
        data: data,
      );
      debugPrint('==> Got response: ${jsonEncode(response.data)}');

      final applicationId = response.data['data']?['application_id']?.toString() ?? '';
      debugPrint('==> Application ID received: $applicationId');

      return ApiResult.success(
        data: applicationId,
      );
    } catch (e) {
      debugPrint('==> save incomplete loan application failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<bool>> declineLoanContract({
    required String loanId,
  }) async {
    debugPrint('==> Declining loan contract for loan ID: $loanId');
    try {
      final client = dioHttp.client(requireAuth: true);
      debugPrint('==> Created authenticated client');

      debugPrint('==> Sending POST request to /api/v1/dashboard/user/loan/$loanId/contract/decline');
      await client.post(
        '/api/v1/dashboard/user/loan/$loanId/contract/decline',
      );
      debugPrint('==> Contract declined successfully');

      return const ApiResult.success(data: true);
    } catch (e) {
      debugPrint('==> decline loan contract failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }


  @override
  Future<ApiResult<Map<String, dynamic>>> fetchSavedApplication() async {
    try {
      final client = dioHttp.client(requireAuth: true);
      debugPrint('==> Fetching saved loan application');

      final response = await client.get('/api/v1/dashboard/user/loan/saved-application');
      debugPrint('==> Saved application response: ${jsonEncode(response.data)}');

      if (response.data != null && response.data['data'] != null) {
        final applicationData = response.data['data'];
        debugPrint('==> Application data found: ${jsonEncode(applicationData)}');

        // Parse additional_data to extract financial details
        if (applicationData['additional_data'] != null &&
            applicationData['additional_data'] is String &&
            applicationData['additional_data'].isNotEmpty) {
          try {
            final additionalData = jsonDecode(applicationData['additional_data']);
            debugPrint('==> Successfully parsed additional_data: $additionalData');

            // Add parsed financial details to the application data
            applicationData['financial_details'] = additionalData;
          } catch (e) {
            debugPrint('==> Failed to parse additional_data: $e');
          }
        }

        return ApiResult.success(data: applicationData);
      }

      debugPrint('==> No saved application found');
      return ApiResult.success(data: {});
    } catch (e) {
      debugPrint('==> fetch saved application failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<List<Map<String, dynamic>>>> fetchSavedApplications() async {
    try {
      final client = dioHttp.client(requireAuth: true);
      debugPrint('==> Fetching saved loan applications');

      final response = await client.get(
        '/api/v1/dashboard/user/loan/saved-applications',
        queryParameters: {
          'page': 1,
          'per_page': 10,
        },
      );
      debugPrint('==> Saved applications response: ${jsonEncode(response.data)}');

      if (response.data != null && response.data['data'] != null) {
        List<dynamic> applicationsData = response.data['data'];

        List<Map<String, dynamic>> processedApplications = [];

        for (var applicationData in applicationsData) {
          Map<String, dynamic> processedApplication = Map<String, dynamic>.from(applicationData);

          // Parse additional_data
          if (processedApplication['additional_data'] != null) {
            try {
              dynamic additionalData;
              if (processedApplication['additional_data'] is String) {
                additionalData = jsonDecode(processedApplication['additional_data']);
              } else if (processedApplication['additional_data'] is Map) {
                additionalData = processedApplication['additional_data'];
              }

              if (additionalData != null) {
                processedApplication['financial_details'] =
                additionalData is Map ? Map<String, dynamic>.from(additionalData) : additionalData;
              }
            } catch (e) {
              debugPrint('==> Failed to parse additional_data: $e');
            }
          }

          processedApplications.add(processedApplication);
        }

        debugPrint('==> Processed applications: ${jsonEncode(processedApplications)}');
        return ApiResult.success(data: processedApplications);
      }

      debugPrint('==> No saved applications found');
      return ApiResult.success(data: []);
    } catch (e) {
      debugPrint('==> fetch saved applications failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<String>> generateAndEmailContractPdf({
    required String loanId,
    required bool isAcceptance,
  }) async {
    debugPrint('==> Generating and emailing contract PDF for loan ID: $loanId');
    debugPrint('==> Is acceptance document: $isAcceptance');

    try {
      final client = dioHttp.client(requireAuth: true);
      debugPrint('==> Created authenticated client');

      final data = {
        'is_acceptance': isAcceptance,
      };
      debugPrint('==> Request data: ${jsonEncode(data)}');

      debugPrint('==> Sending POST request to /api/v1/dashboard/user/loan/$loanId/generate-pdf');
      final response = await client.post(
        '/api/v1/dashboard/user/loan/$loanId/generate-pdf',
        data: data,
      );
      debugPrint('==> Got response: ${jsonEncode(response.data)}');

      final pdfPath = response.data['pdf_path'] ?? '';
      debugPrint('==> PDF path received: $pdfPath');

      return ApiResult.success(
        data: pdfPath,
      );
    } catch (e) {
      debugPrint('==> generate contract PDF failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  Future<ApiResult<int>> getCompletedLoanCount() async {
    try {
      final result = await fetchLoanTransactions(1);

      return result.when(
        success: (transactions) {
          // Filter for successfully repaid loans
          final completedLoans = transactions.where((loan) =>
          loan['status']?.toString().toLowerCase() == 'paid' ||
              loan['status']?.toString().toLowerCase() == 'completed'
          ).toList();

          return ApiResult.success(data: completedLoans.length);
        },
        failure: (error, statusCode) {
          // Default to 0 if we can't determine
          return ApiResult.success(data: 0);
        },
      );
    } catch (e) {
      debugPrint('==> get completed loan count failure: $e');
      return ApiResult.success(data: 0);
    }
  }

  double getQualifyingAmount(int completedLoanCount) {
    switch (completedLoanCount) {
      case 0:
        return 500.0; // First time
      case 1:
        return 1500.0; // Second time
      case 2:
        return 2500.0; // Third time
      default:
        return 10000.0; // More than 3 loans
    }
  }

  Future<ApiResult<double>> calculatePreApprovalAmount(Map<String, dynamic> financialDetails) async {
    try {
      // First, get the loan history tier
      final countResult = await getCompletedLoanCount();
      int loanCount = 0;

      countResult.when(
          success: (count) {
            loanCount = count;
          },
          failure: (_, __) {
            loanCount = 0;
          }
      );

      // Get tier-based maximum
      final tierMaximum = getQualifyingAmount(loanCount);

      // Calculate risk-based amount
      final riskBasedAmount = _calculateRiskBasedAmount(
        loanCount: loanCount,
        tierMaximum: tierMaximum,
        financialDetails: financialDetails,
      );

      return ApiResult.success(data: riskBasedAmount);
    } catch (e) {
      debugPrint('==> calculate pre-approval amount failure: $e');
      // Default to minimum amount on error
      return ApiResult.success(data: 200.0);
    }
  }

  double _calculateRiskBasedAmount({
    required int loanCount,
    required double tierMaximum,
    required Map<String, dynamic> financialDetails,
  }) {
    // Extract financial metrics
    final monthlyIncome = financialDetails['monthly_income'] as double? ?? 0.0;
    final groceryExpenses = financialDetails['grocery_expenses'] as double? ?? 0.0;
    final otherExpenses = financialDetails['other_expenses'] as double? ?? 0.0;
    final existingCredits = financialDetails['existing_credits'] as double? ?? 0.0;

    // Calculate total expenses
    final totalExpenses = groceryExpenses + otherExpenses + existingCredits;

    // Calculate debt-to-income ratio (DTI)
    final dti = monthlyIncome > 0 ? totalExpenses / monthlyIncome : 1.0;

    // Calculate discretionary income
    final discretionaryIncome = monthlyIncome - totalExpenses;

    // Risk scoring based on financial metrics
    double riskScore = 0.0;

    // DTI scoring (lower is better)
    if (dti <= 0.2) {
      riskScore += 3.0; // Excellent DTI
    } else if (dti <= 0.3) {
      riskScore += 2.0; // Good DTI
    } else if (dti <= 0.4) {
      riskScore += 1.0; // Acceptable DTI
    }

    // Discretionary income scoring (higher is better)
    if (discretionaryIncome >= 10000) {
      riskScore += 3.0; // Excellent discretionary income
    } else if (discretionaryIncome >= 5000) {
      riskScore += 2.0; // Good discretionary income
    } else if (discretionaryIncome >= 2000) {
      riskScore += 1.0; // Acceptable discretionary income
    }

    // Income scoring (higher is better)
    if (monthlyIncome >= 20000) {
      riskScore += 3.0; // High income
    } else if (monthlyIncome >= 10000) {
      riskScore += 2.0; // Good income
    } else if (monthlyIncome >= 5000) {
      riskScore += 1.0; // Acceptable income
    }

    // Maximum possible score is 9.0

    // Calculate percentage of tier maximum based on risk score
    double percentageOfMaximum = 0.0;

    if (riskScore >= 7.0) {
      percentageOfMaximum = 1.0; // 100% of tier maximum
    } else if (riskScore >= 5.0) {
      percentageOfMaximum = 0.8; // 80% of tier maximum
    } else if (riskScore >= 3.0) {
      percentageOfMaximum = 0.6; // 60% of tier maximum
    } else {
      percentageOfMaximum = 0.4; // 40% of tier maximum (minimum)
    }

    // Calculate pre-approval amount
    double preApprovalAmount = tierMaximum * percentageOfMaximum;

    // Ensure it's at least the minimum loan amount
    preApprovalAmount = max(preApprovalAmount, 200.0);

    // Round to nearest 100
    preApprovalAmount = (preApprovalAmount / 100).round() * 100;

    return preApprovalAmount;
  }
}