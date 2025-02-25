import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:foodyman/app_constants.dart';
import 'package:foodyman/domain/di/dependency_manager.dart';
import 'package:foodyman/infrastructure/models/data/loans/loan_contract_model.dart';
import 'package:foodyman/infrastructure/services/app_helpers.dart';
import 'package:foodyman/infrastructure/services/local_storage.dart';
import 'package:foodyman/domain/handlers/handlers.dart';
import 'package:http/http.dart' as http;
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

    try {
      final client = dioHttp.client(requireAuth: true);
      debugPrint('==> Created authenticated client');

      // Create multipart request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${AppConstants.baseUrl}/api/v1/dashboard/user/loan-applications'),
      );
      debugPrint('==> Created request to ${request.url}');

      // Add authentication headers
      request.headers['Authorization'] =
      'Bearer ${LocalStorage.getToken()}';
      request.headers['Accept'] = 'application/json';
      debugPrint('==> Added authorization headers');

      // Add loan application data fields
      request.fields['id_number'] = applicationData.idNumber;
      request.fields['amount'] = applicationData.amount.toString();
      request.fields['currency_id'] =
          (LocalStorage.getSelectedCurrency()?.id ?? 1).toString();
      debugPrint('==> Added application fields');

      // Add document files
      for (var entry in applicationData.documents.entries) {
        debugPrint('==> Adding document: ${entry.key} from path ${entry.value.path}');
        request.files.add(
            await http.MultipartFile.fromPath(
              entry.key.toLowerCase().replaceAll(' ', '_'),
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
    required double amount,
  }) async {
    try {
      final data = {
        'amount': amount,
        'status': 'rejected',
        'additional_data': jsonEncode({
          'financial_details': financialDetails,
          'rejection_reason': financialDetails['rejection_reason'],
          'rejection_date': financialDetails['rejection_date'],
        }),
      };

      final client = dioHttp.client(requireAuth: true);
      await client.post(
        '/api/v1/loan/save-incomplete',
        data: data,
      );

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

      final data = {
        ...financialDetails,
        'currency_id': LocalStorage.getSelectedCurrency()?.id ?? 1,
      };
      debugPrint('==> Request data: ${jsonEncode(data)}');

      debugPrint('==> Sending POST request to /api/v1/dashboard/user/loan/save-incomplete');
      final response = await client.post(
        '/api/v1/dashboard/user/loan/save-incomplete',
        data: data,
      );
      debugPrint('==> Got response: ${jsonEncode(response.data)}');

      final applicationId = response.data['data']['application_id']?.toString() ?? '';
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
      final response = await client.get('/api/v1/loan/saved-application');

      if (response.data != null && response.data['data'] != null) {
        final applicationData = response.data['data'];

        // Parse additional_data back from JSON if it exists
        if (applicationData['additional_data'] != null) {
          try {
            applicationData['financial_details'] =
                jsonDecode(applicationData['additional_data']);
          } catch (e) {
            debugPrint('Failed to parse additional_data: $e');
          }
        }

        return ApiResult.success(data: applicationData);
      }

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
}