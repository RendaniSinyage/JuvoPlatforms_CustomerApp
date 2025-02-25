import 'package:flutter/material.dart';
import '../../infrastructure/models/data/loans/loan_application.dart';
import '../../infrastructure/models/data/loans/loan_contract_model.dart';
import '../handlers/handlers.dart';

abstract class LoansRepositoryFacade {
  /// Submit a new loan application
  ///
  /// [applicationData] contains all details of the loan application
  /// Returns the response from the server or an error
  Future<ApiResult<dynamic>> submitLoanApplication({
    required LoanApplicationModel applicationData,
  });

  /// Tokenize card with a verification fee
  ///
  /// [context] BuildContext for potential WebView preloading
  /// [forceCardPayment] forces card payment method
  /// [enableTokenization] enables card tokenization
  /// Returns the payment URL or an error
  Future<ApiResult<String>> tokenizeCardWithVerificationFee({
    required BuildContext context,
    bool forceCardPayment = true,
    bool enableTokenization = true,
  });

  /// Fetch loan transactions for the current user
  ///
  /// [page] is the pagination parameter
  /// Returns a list of loan transactions or an error
  Future<ApiResult<List<dynamic>>> fetchLoanTransactions(int page);

  /// Check loan eligibility
  ///
  /// [idNumber] is the user's identification number
  /// [amount] is the requested loan amount
  /// Returns eligibility status or an error
  Future<ApiResult<bool>> checkLoanEligibility({
    required String idNumber,
    required double amount,
  });

  /// Get detailed loan information
  ///
  /// [loanId] is the unique identifier for a specific loan
  /// Returns detailed loan information or an error
  Future<ApiResult<dynamic>> getLoanDetails(String loanId);

  /// Cancel a pending loan application
  ///
  /// [loanId] is the unique identifier for the loan application
  /// Returns success status or an error
  Future<ApiResult<bool>> cancelLoanApplication(String loanId);

  /// Fetch the contract for a specific loan
  ///
  /// [loanId] is the unique identifier for the loan
  /// Returns the loan contract details or an error
  Future<ApiResult<LoanContractModel>> fetchLoanContract(String loanId);

  /// Accept the loan contract
  ///
  /// [loanId] is the unique identifier for the loan
  /// [contractId] is the unique identifier for the contract
  /// Returns success status or an error
  Future<ApiResult<bool>> acceptLoanContract({
    required String loanId,
    required String contractId,
  });

  /// Mark a loan application as rejected after failing eligibility
  ///
  /// [financialDetails] contains the financial information provided and rejection details
  /// Returns a success boolean indicating if the rejection was recorded successfully
  Future<ApiResult<bool>> markApplicationAsRejected({
    required Map<String, dynamic> financialDetails,
  });

  /// Check previous loan history for disqualifying factors
  ///
  /// Returns a map indicating various disqualification reasons
  Future<ApiResult<Map<String, dynamic>>> checkLoanHistoryEligibility();

  /// Submit initial financial details for preliminary eligibility
  ///
  /// [financialDetails] contains income and expense information
  /// Returns eligibility status and additional details
  Future<ApiResult<Map<String, dynamic>>> checkFinancialEligibility({
  required double monthlyIncome,
  required double groceryExpenses,
  required double otherExpenses,
  required double existingCredits,
  });

  /// Save incomplete loan application with financial details
  ///
  /// [financialDetails] contains income and expense information
  /// Returns saved application ID or error
  Future<ApiResult<String>> saveIncompleteLoanApplication({
  required Map<String, dynamic> financialDetails,
  });

  /// Decline a pending loan contract
  ///
  /// This method allows a user to decline a loan contract, which typically
  /// results in the cancellation of the associated loan application.
  ///
  /// [loanId] The unique identifier of the loan application with the contract
  ///
  /// Returns:
  /// - [ApiResult<bool>] indicating the success or failure of declining the contract
  /// - `true` if the contract was successfully declined
  /// - Throws an error if the contract cannot be declined due to various reasons
  ///
  /// Potential failure scenarios include:
  /// - Invalid loan ID
  /// - Contract no longer in a state that allows declination
  /// - Network or server-side errors
  ///
  /// Example usage:
  /// ```dart
  /// final result = await loanRepository.declineLoanContract(loanId: '12345');
  /// result.when(
  ///   success: (declined) {
  ///     if (declined) {
  ///       // Contract successfully declined
  ///     }
  ///   },
  ///   failure: (error, statusCode) {
  ///     // Handle declination failure
  ///   }
  /// );
  /// ```
  Future<ApiResult<bool>> declineLoanContract({
    required String loanId,
  });

  /// Generate and email a loan contract PDF
  ///
  /// [loanId] is the unique identifier for the loan
  /// [isAcceptance] indicates whether it's an acceptance or paid-up letter
  /// Returns the path of the generated PDF or an error
  Future<ApiResult<String>> generateAndEmailContractPdf({
    required String loanId,
    required bool isAcceptance,
  });

  /// Fetches the user's most recent saved incomplete loan application
  ///
  /// Returns the saved application data including amount, ID number, and
  /// any additional data such as financial details, or empty if none exists
  Future<ApiResult<Map<String, dynamic>>> fetchSavedApplication();


  /// Fetches the user's most recent saved loan applications
  ///All Statuses
  /// Returns the saved application data including amount, ID number, and
  /// any additional data such as financial details, or empty if none exists
  Future<ApiResult<List<Map<String, dynamic>>>> fetchSavedApplications();

}