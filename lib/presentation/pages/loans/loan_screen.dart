import 'dart:async';
import 'dart:convert';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart' as intl;

import '../../../domain/handlers/handlers.dart';
import '../../../infrastructure/repository/loans_repository.dart';
import '../../../infrastructure/services/app_helpers.dart';
import '../../../infrastructure/services/local_storage.dart';
import '../../../infrastructure/services/tr_keys.dart';
import '../../components/app_bars/common_app_bar.dart';
import '../../components/buttons/custom_button.dart';
import '../../components/keyboard_dismisser.dart';
import '../../components/title_icon.dart';
import '../../theme/theme.dart';
import '../chat/chat/chat_page.dart';
import 'widgets/loan_contract_screen.dart';
import 'widgets/loan_eligibility_screen.dart';
import 'provider/loans_provider.dart';

@RoutePage()
class LoanScreen extends ConsumerStatefulWidget {
  const LoanScreen({super.key});

  @override
  ConsumerState<LoanScreen> createState() => _LoanScreenState();
}

class _LoanScreenState extends ConsumerState<LoanScreen> {
  // Screen state variables
  List<dynamic> _loanTransactions = [];
  List<dynamic> _savedApplications = [];
  bool _isLoading = true;
  bool _sliderDisabled = false;
  bool _isLoanBlocked = false;
  dynamic _savedApplication;
  dynamic _rejectedApplication;

  // Repository
  late LoansRepository _loansRepository;

  @override
  void initState() {
    super.initState();
    _loansRepository = LoansRepository();

    // Fetch all loan-related data
    _fetchAllLoanData();
  }

  // Check loan blocking status and show dialog if needed
  void _checkAndShowBlockedStatusIfNeeded() {
    if (_isLoanBlocked) {
      // Show the loan blocked dialog
      AppHelpers.showAlertDialog(
        isDismissible: false,
        context: context,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.block,
              size: 48.r,
              color: AppStyle.red,
            ),
            16.verticalSpace,
            Text(
              'Loan Application Blocked',
              style: AppStyle.interSemi(size: 18.sp, color: AppStyle.red),
              textAlign: TextAlign.center,
            ),
            16.verticalSpace,
            Text(
              'You have multiple cancelled loan applications in a short time period. Please contact customer support for assistance.',
              style: AppStyle.interNormal(size: 14.sp),
              textAlign: TextAlign.center,
            ),
            24.verticalSpace,
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    background: AppStyle.white,
                    borderColor: AppStyle.borderColor,
                    textColor: AppStyle.textGrey,
                    title: 'Cancel',
                    onPressed: () {
                      // Close dialog and loan screen
                      Navigator.of(context).pop(); // Close dialog
                      Navigator.of(context).pop(); // Close loan screen
                    },
                  ),
                ),
                16.horizontalSpace,
                Expanded(
                  child: CustomButton(
                    background: AppStyle.red,
                    textColor: AppStyle.white,
                    title: 'Support',
                    onPressed: () {
                      // Close dialog and loan screen, then navigate to chat route
                      Navigator.of(context).pop(); // Close dialog
                      Navigator.of(context).pop(); // Close loan screen

                      AppHelpers.showCustomModalBottomSheet(
                        context: context,
                        modal: ProviderScope(
                          child: Consumer(
                            builder: (context, ref, _) => ChatPage(
                                roleId: "admin",
                                name: "Admin"), // Use the ChatRoute component
                          ),
                        ),
                        isDarkMode: false,
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }

  Future<void> _checkConsecutiveCancelledApplications() async {
    try {
      debugPrint('Checking for consecutive cancelled applications');

      // Filter only cancelled applications from saved applications
      final cancelledApplications = _savedApplications.where((app) {
        final status = app['status']?.toString().toLowerCase() ?? '';
        return status == 'cancelled';
      }).toList();

      debugPrint(
          'Found ${cancelledApplications.length} cancelled applications');

      // Block if 3 or more cancelled applications exist
      if (cancelledApplications.length >= 3) {
        // Sort applications by created_at in descending order
        cancelledApplications.sort((a, b) {
          try {
            final dateA =
                DateTime.parse(a['created_at'] ?? DateTime.now().toString());
            final dateB =
                DateTime.parse(b['created_at'] ?? DateTime.now().toString());
            return dateB.compareTo(dateA); // Most recent first
          } catch (e) {
            return 0;
          }
        });

        // Get the 3 most recent cancellations
        final recentCancellations = cancelledApplications.take(3).toList();

        // Check if these cancellations are within a 30-day timeframe
        if (recentCancellations.length >= 3) {
          final now = DateTime.now();
          final oldestOfRecent =
              DateTime.parse(recentCancellations.last['created_at']);
          final daysDifference = now.difference(oldestOfRecent).inDays;

          debugPrint(
              'Most recent 3 cancellations: oldest date is $oldestOfRecent, $daysDifference days ago');

          // Block if the 3 most recent cancellations are within 30 days
          if (daysDifference <= 30) {
            debugPrint('BLOCKING USER: 3 cancellations within 30 days');
            setState(() {
              _isLoanBlocked = true;
            });
            return;
          }
        }
      }

      setState(() {
        _isLoanBlocked = false;
      });
    } catch (e) {
      debugPrint('Error checking consecutive cancellations: $e');
      setState(() {
        _isLoanBlocked = false;
      });
    }
  }

  Future<void> _fetchAllLoanData() async {
    setState(() {
      _isLoading = true;
      _savedApplication = null;
      _rejectedApplication = null;
      _savedApplications = [];
    });

    try {
      debugPrint("Fetching loan data");

      // Use Future.wait to fetch both data sources concurrently
      final results = await Future.wait([
        _loansRepository.fetchLoanTransactions(1),
        _loansRepository.fetchSavedApplications()
      ]);

      final transactionsResult = results[0] as ApiResult<List<dynamic>>;
      final savedApplicationsResult =
          results[1] as ApiResult<List<Map<String, dynamic>>>;

      debugPrint("All data fetched");

      // Process transactions result
      transactionsResult.when(
        success: (transactions) {
          debugPrint("Found ${transactions.length} transactions");
          setState(() {
            _loanTransactions = transactions;
          });

          // Check for pending contract loans
          _checkPendingContractLoans(transactions);
        },
        failure: (error, _) {
          debugPrint("Failed to fetch transactions: $error");
          AppHelpers.showCheckTopSnackBarInfo(context, error);
        },
      );

      // Additional method to check for active or overdue loans
      _checkActiveOrOverdueLoans(transactionsResult);

      // Process saved applications result
      savedApplicationsResult.when(
        success: (applications) {
          debugPrint("Found ${applications.length} saved applications");

          // Store all saved applications
          setState(() {
            _savedApplications = applications;
          });

          // Process saved applications to find incomplete and rejected ones
          if (applications.isNotEmpty) {
            _processSavedApplications(applications);

            // Check for consecutive cancelled applications
            _checkConsecutiveCancelledApplications();
          } else {
            debugPrint("No saved applications found");
            setState(() {
              _savedApplication = null;
              _rejectedApplication = null;
              _isLoanBlocked = false;
            });
          }
        },
        failure: (error, _) {
          debugPrint('Failed to fetch saved applications: $error');
          setState(() {
            _savedApplications = [];
            _savedApplication = null;
            _rejectedApplication = null;
            _isLoanBlocked = false;
          });
        },
      );
    } catch (e) {
      debugPrint('Error fetching loan data: $e');
      setState(() {
        _savedApplications = [];
        _savedApplication = null;
        _rejectedApplication = null;
        _isLoanBlocked = false;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _processSavedApplications(List<dynamic> applications) {
    if (applications.isEmpty) {
      debugPrint("No saved applications found");
      return;
    }

    debugPrint("Processing ${applications.length} saved applications");

    // Log all applications for detailed debugging
    for (var app in applications) {
      debugPrint(
          "Application ID: ${app['id']}, Status: ${app['status']}, Amount: ${app['amount']}");
    }

    // Sort applications by updated_at in descending order to get most recent first
    applications.sort((a, b) {
      try {
        final dateA = DateTime.parse(a['updated_at'] ?? DateTime.now().toString());
        final dateB = DateTime.parse(b['updated_at'] ?? DateTime.now().toString());
        return dateB.compareTo(dateA);
      } catch (e) {
        return 0;
      }
    });

    // Comprehensive list of statuses to check
    final processingStatuses = [
      'incomplete',
      'rejected',
      'pending_review',
      'pending_contract',
      'pending_disbursal',
      'overdue'
    ];

    // Find the most recent application with processing statuses
    dynamic processableApp;
    for (var app in applications) {
      final status = app['status']?.toString().toLowerCase() ?? '';
      if (processingStatuses.contains(status)) {
        processableApp = app;
        debugPrint("Found processable application ID: ${app['id']}, Status: $status");
        break;
      }
    }

    // Process the application if found
    if (processableApp != null) {
      final status = processableApp['status']?.toString().toLowerCase() ?? '';

      debugPrint("Processing application with status: $status");

      // Determine which processing method to use based on status
      if (status == 'incomplete') {
        _processIncompleteApplication(processableApp);
      } else if (status == 'rejected') {
        _processRejectedApplication(processableApp);
      } else {
        // For other statuses like pending_review, pending, draft, in_progress
        setState(() {
          _savedApplication = processableApp;

          // Extract financial details from additional_data if available
          Map<String, dynamic> financialDetails = {};

          if (processableApp['additional_data'] != null) {
            debugPrint("Additional data found: ${processableApp['additional_data']}");

            // Check if additional_data is already a Map
            if (processableApp['additional_data'] is Map) {
              var additionalData = processableApp['additional_data'] as Map;

              // Extract financial details
              if (additionalData.containsKey('financial_details')) {
                financialDetails = Map<String, dynamic>.from(additionalData['financial_details']);
                debugPrint("Extracted financial details from map: $financialDetails");
              }
            }
            // If additional_data is a JSON string, parse it
            else if (processableApp['additional_data'] is String) {
              try {
                Map<String, dynamic> additionalData = jsonDecode(processableApp['additional_data']);
                if (additionalData.containsKey('financial_details')) {
                  financialDetails = Map<String, dynamic>.from(additionalData['financial_details']);
                  debugPrint("Extracted financial details from string: $financialDetails");
                }
              } catch (e) {
                debugPrint("Error parsing additional_data string: $e");
              }
            }

            // Include financial details with the application data
            if (financialDetails.isNotEmpty) {
              _savedApplication = {
                ..._savedApplication,
                'financial_details': financialDetails
              };
            }
          }

          // If loan amount is present, set it in the provider
          if (processableApp['amount'] != null) {
            try {
              double amount = double.tryParse(processableApp['amount'].toString()) ?? 200.0;
              debugPrint("Setting loan amount: $amount");
              ref.read(loanAmountProvider.notifier).state = amount;
            } catch (e) {
              debugPrint("Error parsing amount: $e");
            }
          }
        });
      }
    } else {
      // Clear saved application if none found
      setState(() {
        _savedApplication = null;
        _rejectedApplication = null;
      });
    }

    // Find the most recent rejected application
    dynamic rejectedApp;
    for (var app in applications) {
      final status = app['status']?.toString().toLowerCase() ?? '';
      if (status == 'rejected') {
        rejectedApp = app;
        debugPrint("Found rejected application ID: ${app['id']}");
        break;
      }
    }

    // Process the rejected application if found
    if (rejectedApp != null) {
      _processRejectedApplication(rejectedApp);
    } else {
      setState(() {
        _rejectedApplication = null;
      });
    }

    // Additional debugging
    debugPrint("Final saved application: $_savedApplication");
    debugPrint("Final rejected application: $_rejectedApplication");
  }


  void _processIncompleteApplication(dynamic application) {
    debugPrint("Processing incomplete application: ${application['id']}");

    // Update loan amount if present
    if (application['amount'] != null) {
      double amount = 0;
      try {
        amount = double.tryParse(application['amount'].toString()) ?? 200.0;
      } catch (e) {
        debugPrint("Error parsing amount: $e");
        amount = 200.0;
      }
      debugPrint("Setting loan amount: $amount");
      ref.read(loanAmountProvider.notifier).state = amount;

      // Set slider to disabled
      setState(() {
        _sliderDisabled = true;
      });
    }

    // Extract ID number if available
    if (application['id_number'] != null) {
      final idNumber = application['id_number'].toString();
      debugPrint("Setting ID number: $idNumber");
      ref.read(idNumberProvider.notifier).state = idNumber;
    }

    // Extract financial details from additional_data if available
    Map<String, dynamic> financialDetails = {};

    if (application['additional_data'] != null) {
      debugPrint("Additional data found: ${application['additional_data']}");

      // Check if additional_data is already a Map
      if (application['additional_data'] is Map) {
        var additionalData = application['additional_data'] as Map;

        // Extract financial details
        if (additionalData.containsKey('financial_details')) {
          financialDetails =
              Map<String, dynamic>.from(additionalData['financial_details']);
          debugPrint("Extracted financial details from map: $financialDetails");
        }
      }
      // If additional_data is a JSON string, parse it
      else if (application['additional_data'] is String) {
        try {
          Map<String, dynamic> additionalData =
              jsonDecode(application['additional_data']);
          if (additionalData.containsKey('financial_details')) {
            financialDetails =
                Map<String, dynamic>.from(additionalData['financial_details']);
            debugPrint(
                "Extracted financial details from string: $financialDetails");
          }
        } catch (e) {
          debugPrint("Error parsing additional_data string: $e");
        }
      }
    }

    // Store in state with financial details
    setState(() {
      _savedApplication = application;
      // Include financial details with the application data
      if (financialDetails.isNotEmpty) {
        _savedApplication = {
          ..._savedApplication,
          'financial_details': financialDetails
        };
      }
    });
  }

  void _processRejectedApplication(dynamic application) {
    debugPrint("Processing rejected application: ${application['id']}");

    // Extract financial details from additional_data if available
    Map<String, dynamic> financialDetails = {};

    if (application['additional_data'] != null) {
      debugPrint("Additional data found: ${application['additional_data']}");

      // Check if additional_data is already a Map
      if (application['additional_data'] is Map) {
        var additionalData = application['additional_data'] as Map;

        // Extract financial details
        if (additionalData.containsKey('financial_details')) {
          financialDetails =
              Map<String, dynamic>.from(additionalData['financial_details']);
          debugPrint("Extracted financial details from map: $financialDetails");
        }
      }
      // If additional_data is a JSON string, parse it
      else if (application['additional_data'] is String) {
        try {
          Map<String, dynamic> additionalData =
              jsonDecode(application['additional_data']);
          if (additionalData.containsKey('financial_details')) {
            financialDetails =
                Map<String, dynamic>.from(additionalData['financial_details']);
            debugPrint(
                "Extracted financial details from string: $financialDetails");
          }
        } catch (e) {
          debugPrint("Error parsing additional_data string: $e");
        }
      }
    }

    // Store in state with financial details
    setState(() {
      _rejectedApplication = application;
      // Include financial details with the application data
      if (financialDetails.isNotEmpty) {
        _rejectedApplication = {
          ..._rejectedApplication,
          'financial_details': financialDetails
        };
      }
    });
  }

  Future<void> _fetchLoanTransactions() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _loansRepository.fetchLoanTransactions(1);

      result.when(
        success: (transactions) {
          setState(() {
            _loanTransactions = transactions;
            _isLoading = false;
          });
        },
        failure: (error, statusCode) {
          setState(() {
            _isLoading = false;
            _loanTransactions = [];
          });
          AppHelpers.showCheckTopSnackBarInfo(context, error);
        },
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
        _loanTransactions = [];
      });
      AppHelpers.showCheckTopSnackBarInfo(
        context,
        'Failed to load loan transactions',
      );
    }
  }

  Future<void> _checkPendingContractLoans(List<dynamic> transactions) async {
    try {
      // Find loans with 'pending_contract' status
      final pendingContractLoans = transactions
          .where((loan) =>
              loan['status']?.toString().toLowerCase() == 'pending_contract')
          .toList();

      debugPrint("Found ${pendingContractLoans.length} pending contract loans");

      if (pendingContractLoans.isNotEmpty) {
        // Update the pending contract provider
        final firstPendingLoan = pendingContractLoans.first;
        debugPrint("Setting pending contract: ${firstPendingLoan['id']}");
        ref.read(pendingContractProvider.notifier).state = firstPendingLoan;

        // Fetch contract details
        await _fetchLoanContract(firstPendingLoan['id']?.toString());
      } else {
        debugPrint("No pending contract loans found");
      }
    } catch (e) {
      debugPrint("Error checking pending contracts: $e");
      AppHelpers.showCheckTopSnackBarInfo(
        context,
        'Failed to check pending contract loans',
      );
    }
  }

  Future<void> _fetchLoanContract(String? loanId) async {
    if (loanId == null) return;

    try {
      final result = await _loansRepository.fetchLoanContract(loanId);

      result.when(
        success: (contract) {
          // Instead of showing the modal, navigate to LoanContractScreen
          _navigateToLoanContractScreen(
              ref.read(pendingContractProvider), contract);
        },
        failure: (error, statusCode) {
          AppHelpers.showCheckTopSnackBarInfo(context, error);
        },
      );
    } catch (e) {
      AppHelpers.showCheckTopSnackBarInfo(
        context,
        'Failed to fetch loan contract',
      );
    }
  }

  Future<void> _acceptLoanContract(dynamic contract) async {
    final pendingLoan = ref.read(pendingContractProvider);

    if (pendingLoan == null) {
      AppHelpers.showCheckTopSnackBarInfo(
        context,
        'No pending loan found',
      );
      return;
    }

    try {
      final result = await _loansRepository.acceptLoanContract(
        loanId: pendingLoan['id'].toString(),
        contractId: contract.id,
      );

      result.when(
        success: (_) {
          AppHelpers.showCheckTopSnackBarDone(
            context,
            'Loan contract accepted successfully',
          );

          // Clear pending contract
          ref.read(pendingContractProvider.notifier).state = null;

          // Refresh loan transactions
          _fetchLoanTransactions();
        },
        failure: (error, statusCode) {
          AppHelpers.showCheckTopSnackBarInfo(
            context,
            error,
          );
        },
      );
    } catch (e) {
      AppHelpers.showCheckTopSnackBarInfo(
        context,
        'Failed to accept loan contract',
      );
    }
  }

  void _navigateToLoanEligibilityScreen() {
    // Store the selected loan amount in provider
    // (The slider already updates the provider value when changed)

    // If there's a saved application, store the ID in the provider
    if (_savedApplication != null && _savedApplication['id'] != null) {
      debugPrint('Setting saved application ID: ${_savedApplication['id']}');
      ref.read(savedApplicationIdProvider.notifier).state =
          _savedApplication['id'].toString();
    } else {
      // Clear any existing saved application ID
      ref.read(savedApplicationIdProvider.notifier).state = null;
    }

    // Prepare financial details from saved application if available
    Map<String, dynamic>? financialDetails;

    if (_savedApplication != null) {
      debugPrint(
          'Preparing to pass saved application data to eligibility screen');

      // First try to get financial details from the flattened structure
      if (_savedApplication['financial_details'] != null) {
        financialDetails =
            Map<String, dynamic>.from(_savedApplication['financial_details']);
        debugPrint(
            'Using financial details from flattened structure: $financialDetails');
      }
      // If not found, try to get from additional_data
      else if (_savedApplication['additional_data'] != null) {
        // Handle both object and string formats of additional_data
        if (_savedApplication['additional_data'] is Map) {
          if (_savedApplication['additional_data']['financial_details'] !=
              null) {
            financialDetails = Map<String, dynamic>.from(
                _savedApplication['additional_data']['financial_details']);
          }
        } else if (_savedApplication['additional_data'] is String) {
          try {
            final additionalData =
                jsonDecode(_savedApplication['additional_data']);
            if (additionalData['financial_details'] != null) {
              financialDetails = Map<String, dynamic>.from(
                  additionalData['financial_details']);
            }
          } catch (e) {
            debugPrint('Error parsing additional_data string: $e');
          }
        }

        debugPrint(
            'Using financial details from additional_data: $financialDetails');
      }
    }

    // Navigate to the eligibility screen with financial details if available
    // First pop the current screen
    Navigator.of(context).pop();

    // Then show the eligibility screen as a modal
    AppHelpers.showCustomModalBottomSheet(
      context: context,
      modal: ProviderScope(
        child: Consumer(
          builder: (context, ref, _) => LoanEligibilityScreen(
            financialDetails: financialDetails,
          ),
        ),
      ),
      isDarkMode: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isLtr = LocalStorage.getLangLtr();
    // Check for pending contract
    final pendingContract = ref.watch(pendingContractProvider);

    // If there's a pending contract, show contract acceptance view
    if (pendingContract != null) {
      return _buildPendingContractView(pendingContract);
    }

    // If loan is blocked due to consecutive cancellations
    if (_isLoanBlocked) {
      return _buildLoanBlockedView();
    }

    return Directionality(
      textDirection: isLtr ? TextDirection.ltr : TextDirection.rtl,
      child: KeyboardDismisser(
        child: Container(
          decoration: BoxDecoration(
            color: AppStyle.bgGrey.withOpacity(0.96),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.r),
              topRight: Radius.circular(16.r),
            ),
          ),
          width: double.infinity,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height *
                0.85, // Increased to 85% for more space
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      8.verticalSpace,
                      Center(
                        child: Container(
                          height: 4.h,
                          width: 48.w,
                          decoration: BoxDecoration(
                            color: AppStyle.dragElement,
                            borderRadius:
                                BorderRadius.all(Radius.circular(40.r)),
                          ),
                        ),
                      ),
                      24.verticalSpace,
                      TitleAndIcon(
                        title: AppHelpers.getTranslation(TrKeys.loans),
                        paddingHorizontalSize: 0,
                        titleSize: 18,
                      ),
                      24.verticalSpace,
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: _fetchAllLoanData,
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Previous Loans Section
                                Text(
                                  'Loan History',
                                  style: AppStyle.interSemi(size: 16.sp),
                                ),
                                8.verticalSpace,
                                _buildPreviousLoansSection(),

                                24.verticalSpace,

                                // Pending Application Notice (if applicable)
                                _buildPendingApplicationNotice(),

                                // Loan Amount Slider
                                Text(
                                  'Loan Amount',
                                  style: AppStyle.interSemi(size: 16.sp),
                                ),
                                16.verticalSpace,
                                _buildLoanAmountSlider(),

                                24.verticalSpace,

                                // Continue to Eligibility Check Button
                                CustomButton(
                                  title: ref
                                          .watch(hasPendingApplicationProvider)
                                      ? 'Application Under Review'
                                      : (_savedApplication != null
                                          ? 'Continue Application'
                                          : 'Continue to Eligibility Check'),
                                  onPressed: ref
                                          .watch(hasPendingApplicationProvider)
                                      ? null // Disable button if there's a pending application
                                      : _navigateToLoanEligibilityScreen,
                                  background:
                                      ref.watch(hasPendingApplicationProvider)
                                          ? AppStyle.textGrey
                                          : AppStyle.primary,
                                  textColor: AppStyle.white,
                                ),

                                24.verticalSpace,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildPreviousLoansSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppStyle.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: AppStyle.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: _buildLoansList(),
    );
  }

  Widget _buildPendingContractView(dynamic pendingLoan) {
    return Scaffold(
      backgroundColor: AppStyle.bgGrey,
      body: Column(
        children: [
          CommonAppBar(
            child: Text(
              'Loan Contract',
              style: AppStyle.interNoSemi(
                size: 18,
                color: AppStyle.black,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.description_outlined,
                      size: 64.r,
                      color: AppStyle.primary,
                    ),
                    16.verticalSpace,
                    Text(
                      'Loan Contract Pending',
                      style: AppStyle.interBold(
                        size: 18.sp,
                        color: AppStyle.black,
                      ),
                    ),
                    16.verticalSpace,
                    Text('Your loan application requires contract acceptance.',
                        style: AppStyle.interNormal(
                          size: 14.sp,
                          color: AppStyle.black,
                        )),
                    16.verticalSpace,
                    Text(
                      'Loan Amount: ${AppHelpers.numberFormat(number: pendingLoan['amount'])}',
                      style: AppStyle.interNormal(
                        size: 14.sp,
                        color: AppStyle.textGrey,
                      ),
                    ),
                    24.verticalSpace,
                    CustomButton(
                      title: 'View Contract',
                      onPressed: () {
                        // Directly fetch and navigate
                        _fetchLoanContract(pendingLoan['id']?.toString());
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoansList() {
    // Prepare the list of loans to display based on priority
    final List<dynamic> combinedLoans = [];

    // Flag to track if higher priority items exist
    bool hasHigherPriorityItems = false;
    bool hasPendingReviewApplication = false;
    bool isUserBlocked = false;

    // 1. Highest Priority: Pending Contract
    if (ref.watch(pendingContractProvider) != null) {
      combinedLoans.add({
        'type': 'pending_contract',
        'data': ref.watch(pendingContractProvider),
      });
      hasHigherPriorityItems = true;
      isUserBlocked = true;
    }

    // 2. Next Priority: Pending Disbursal
    final pendingDisbursalTransactions = _loanTransactions.where((loan) {
      final status = loan['status']?.toString().toLowerCase() ?? '';
      return status == 'pending_disbursal';
    }).toList();

    if (pendingDisbursalTransactions.isNotEmpty) {
      pendingDisbursalTransactions.sort((a, b) {
        final dateA = DateTime.parse(a['created_at'] ?? DateTime.now().toString());
        final dateB = DateTime.parse(b['created_at'] ?? DateTime.now().toString());
        return dateB.compareTo(dateA);
      });

      combinedLoans.addAll(pendingDisbursalTransactions.take(1).map((loan) => {
        'type': 'pending_disbursal',
        'data': loan,
      }));
      hasHigherPriorityItems = true;
      isUserBlocked = true;
    }

    // 3. Next Priority: Active or Overdue Loans
    final activeOverdueLoans = _loanTransactions.where((loan) {
      final status = loan['status']?.toString().toLowerCase() ?? '';
      return status == 'active' || status == 'overdue';
    }).toList();

    if (activeOverdueLoans.isNotEmpty) {
      activeOverdueLoans.sort((a, b) {
        final dateA = DateTime.parse(a['created_at'] ?? DateTime.now().toString());
        final dateB = DateTime.parse(b['created_at'] ?? DateTime.now().toString());
        return dateB.compareTo(dateA);
      });

      combinedLoans.add({
        'type': 'active_overdue',
        'data': activeOverdueLoans.first,
      });
      hasHigherPriorityItems = true;
      isUserBlocked = true;
    }

    // 4. Next Priority: Pending Review Applications
    final pendingReviewApplications = _loanTransactions.where((loan) {
      final status = loan['status']?.toString().toLowerCase() ?? '';
      return status == 'pending_review' || status == 'pending' || status == 'draft';
    }).toList();

    if (pendingReviewApplications.isNotEmpty) {
      pendingReviewApplications.sort((a, b) {
        final dateA = DateTime.parse(a['created_at'] ?? DateTime.now().toString());
        final dateB = DateTime.parse(b['created_at'] ?? DateTime.now().toString());
        return dateB.compareTo(dateA);
      });

      combinedLoans.add({
        'type': 'pending_review',
        'data': pendingReviewApplications.first,
      });
      hasPendingReviewApplication = true;
      hasHigherPriorityItems = true;
      isUserBlocked = true;
    }

    // 5. Saved/Processable Application
    if (!hasHigherPriorityItems) {
      final nonClickableStatuses = ['pending_review', 'pending_disbursal', 'pending_contract', 'rejected'];

      // Check for saved application with non-clickable statuses
      if (_savedApplication != null) {
        final status = _savedApplication['status']?.toString().toLowerCase() ?? '';

        // Add application based on status
        if (nonClickableStatuses.contains(status) || status == 'incomplete') {
          combinedLoans.add({
            'type': status == 'incomplete' ? 'saved_application' : 'non_clickable_application',
            'data': _savedApplication,
          });

          // Set blocking state for non-incomplete statuses
          if (status != 'incomplete') {
            isUserBlocked = true;
          }
        }
      }
    }

    // 6. Rejected Application
    if (!hasHigherPriorityItems && _rejectedApplication != null) {
      combinedLoans.add({
        'type': 'rejected',
        'data': _rejectedApplication,
      });
    }

    // 7. Add remaining transactions
    final addedTransactionIds = combinedLoans
        .where((loan) =>
    loan['type'] == 'transaction' ||
        loan['type'] == 'pending_review' ||
        loan['type'] == 'active_overdue' ||
        loan['type'] == 'pending_disbursal')
        .map((loan) => loan['data']['id'])
        .toSet();

    final remainingTransactions = _loanTransactions
        .where((loan) => !addedTransactionIds.contains(loan['id']))
        .toList();

    combinedLoans.addAll(remainingTransactions.map((loan) => {
      'type': 'transaction',
      'data': loan,
    }));

    // Debug print
    debugPrint('Combined loans list length: ${combinedLoans.length}');
    debugPrint('Is user blocked: $isUserBlocked');

    // Update the provider state
    ref.read(hasPendingApplicationProvider.notifier).state = isUserBlocked;

    // If no loans exist
    if (combinedLoans.isEmpty) {
      return Column(
        children: [
          Icon(
            Icons.credit_score_outlined,
            size: 48.r,
            color: AppStyle.textGrey,
          ),
          16.verticalSpace,
          Text(
            'No Loan Applications',
            style: AppStyle.interSemi(
              size: 16.sp,
              color: AppStyle.black,
            ),
          ),
          8.verticalSpace,
          Text(
            'Your active, pending, and previous loans will appear here',
            style: AppStyle.interNormal(
              size: 14.sp,
              color: AppStyle.textGrey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: combinedLoans.length,
      separatorBuilder: (context, index) => const Divider(color: AppStyle.borderColor),
      itemBuilder: (context, index) {
        final loan = combinedLoans[index];

        // Handle pending contract
        if (loan['type'] == 'pending_contract') {
          final pendingLoan = loan['data'];
          return ListTile(
            leading: Icon(Icons.pending, color: AppStyle.primary, size: 32.r),
            title: Text(
              'Pending Contract Review',
              style: AppStyle.interSemi(size: 14.sp, color: AppStyle.primary),
            ),
            subtitle: Text(
              'Loan Amount: ${_formatLoanAmount(pendingLoan['amount'])}',
              style: AppStyle.interNormal(
                size: 12.sp,
                color: AppStyle.textGrey,
              ),
            ),
            trailing: Text(
              'In Review',
              style: AppStyle.interSemi(
                size: 12.sp,
                color: AppStyle.primary,
              ),
            ),
          );
        }

        // Handle pending disbursal
        if (loan['type'] == 'pending_disbursal') {
          final disbursalLoan = loan['data'];
          return ListTile(
            leading: Icon(Icons.payment, color: AppStyle.primary, size: 32.r),
            title: Text(
              'Pending Disbursal',
              style: AppStyle.interSemi(size: 14.sp, color: AppStyle.primary),
            ),
            subtitle: Text(
              'Loan Amount: ${_formatLoanAmount(disbursalLoan['amount'])}',
              style: AppStyle.interNormal(
                size: 12.sp,
                color: AppStyle.textGrey,
              ),
            ),
            trailing: Text(
              'Processing',
              style: AppStyle.interSemi(
                size: 12.sp,
                color: AppStyle.primary,
              ),
            ),
          );
        }

        // Handle active or overdue loans
        if (loan['type'] == 'active_overdue') {
          final activeLoan = loan['data'];
          return ListTile(
            leading: Icon(
                activeLoan['status']?.toString().toLowerCase() == 'overdue'
                    ? Icons.warning
                    : Icons.check_circle,
                color: activeLoan['status']?.toString().toLowerCase() == 'overdue'
                    ? AppStyle.red
                    : Colors.green,
                size: 32.r
            ),
            title: Text(
              activeLoan['status']?.toString().toLowerCase() == 'overdue'
                  ? 'Overdue Loan'
                  : 'Active Loan',
              style: AppStyle.interSemi(
                  size: 14.sp,
                  color: activeLoan['status']?.toString().toLowerCase() == 'overdue'
                      ? AppStyle.red
                      : Colors.green
              ),
            ),
            subtitle: Text(
              'Loan Amount: ${_formatLoanAmount(activeLoan['amount'])}',
              style: AppStyle.interNormal(
                size: 12.sp,
                color: AppStyle.textGrey,
              ),
            ),
            trailing: Text(
              activeLoan['status']?.toString().toUpperCase() ?? '',
              style: AppStyle.interSemi(
                size: 12.sp,
                color: activeLoan['status']?.toString().toLowerCase() == 'overdue'
                    ? AppStyle.red
                    : Colors.green,
              ),
            ),
          );
        }

        // Handle non-clickable applications (pending_review, pending, draft)
        if (loan['type'] == 'non_clickable_application') {
          final nonClickableLoan = loan['data'];
          final status = nonClickableLoan['status']?.toString().toLowerCase() ?? '';

          return ListTile(
            leading: Icon(
                status == 'pending_review'
                    ? Icons.hourglass_top
                    : status == 'pending'
                    ? Icons.pending_outlined
                    : Icons.drafts_outlined,
                color: Colors.orange,
                size: 32.r
            ),
            title: Text(
              status == 'pending_review'
                  ? 'Application Under Review'
                  : status == 'pending'
                  ? 'Pending Application'
                  : 'Draft Application',
              style: AppStyle.interSemi(
                  size: 14.sp,
                  color: Colors.orange
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Loan Amount: ${_formatLoanAmount(nonClickableLoan['amount'])}',
                  style: AppStyle.interNormal(
                    size: 12.sp,
                    color: AppStyle.textGrey,
                  ),
                ),
                Text(
                  'Submitted: ${_formatDate(nonClickableLoan['created_at'])}',
                  style: AppStyle.interNormal(
                    size: 12.sp,
                    color: AppStyle.textGrey,
                  ),
                ),
              ],
            ),
            trailing: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Text(
                status == 'pending_review'
                    ? 'Under Review'
                    : status == 'pending'
                    ? 'Pending'
                    : 'Draft',
                style: AppStyle.interSemi(
                  size: 12.sp,
                  color: Colors.orange,
                ),
              ),
            ),
          );
        }

        // Handle saved (incomplete) application - ONLY THIS IS CLICKABLE
        if (loan['type'] == 'saved_application') {
          final savedLoan = loan['data'];
          return ListTile(
            leading: Icon(Icons.save, color: AppStyle.primary, size: 32.r),
            title: Text(
              'Saved Application',
              style: AppStyle.interSemi(size: 14.sp, color: AppStyle.primary),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Loan Amount: ${_formatLoanAmount(savedLoan['amount'])}',
                  style: AppStyle.interNormal(
                    size: 12.sp,
                    color: AppStyle.textGrey,
                  ),
                ),
                if (savedLoan['id_number'] != null)
                  Text(
                    'ID: ${savedLoan['id_number']}',
                    style: AppStyle.interNormal(
                      size: 12.sp,
                      color: AppStyle.textGrey,
                    ),
                  ),
              ],
            ),
            trailing: TextButton(
              onPressed: () {
                // Continue with application
                _navigateToLoanEligibilityScreen();
              },
              child: Text(
                'Continue',
                style: AppStyle.interSemi(
                  size: 12.sp,
                  color: AppStyle.primary,
                ),
              ),
            ),
          );
        }

        // Handle rejected application
        if (loan['type'] == 'rejected') {
          final rejectedLoan = loan['data'];
          return ListTile(
            leading: Icon(Icons.cancel, color: AppStyle.red, size: 32.r),
            title: Text(
              'Application Rejected',
              style: AppStyle.interSemi(size: 14.sp, color: AppStyle.red),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Loan Amount: ${_formatLoanAmount(rejectedLoan['amount'])}',
                  style: AppStyle.interNormal(
                    size: 12.sp,
                    color: AppStyle.textGrey,
                  ),
                ),
                if (rejectedLoan['additional_data']?['rejection_reason'] != null)
                  Text(
                    'Reason: ${rejectedLoan['additional_data']['rejection_reason']}',
                    style: AppStyle.interNormal(
                      size: 12.sp,
                      color: AppStyle.textGrey,
                    ),
                  ),
              ],
            ),
            trailing: Text(
              'Not Eligible',
              style: AppStyle.interSemi(
                size: 12.sp,
                color: AppStyle.red,
              ),
            ),
          );
        }

        // Handle regular transactions
        final transaction = loan['data'];
        return ListTile(
          title: Text(
            'Loan Amount: ${_formatLoanAmount(transaction['price'] ?? transaction['amount'])}',
            style: AppStyle.interSemi(size: 14.sp),
          ),
          subtitle: Text(
            'Date: ${_formatDate(transaction['created_at'])}',
            style: AppStyle.interNormal(
              size: 12.sp,
              color: AppStyle.textGrey,
            ),
          ),
          trailing: Text(
            transaction['status'] ?? '',
            style: AppStyle.interSemi(
              size: 14.sp,
              color: _getStatusColor(transaction['status']),
            ),
          ),
        );
      },
    );
  }
  // Helper method to format loan amounts consistently
  String _formatLoanAmount(dynamic amount) {
    if (amount == null) return 'R 0.00';

    double numAmount = 0;
    try {
      if (amount is String) {
        numAmount = double.tryParse(amount) ?? 0;
      } else if (amount is num) {
        numAmount = amount.toDouble();
      }
    } catch (e) {
      debugPrint('Error parsing amount: $e');
    }

    return AppHelpers.numberFormat(number: numAmount);
  }

  // Helper method to format dates consistently
  String _formatDate(dynamic dateStr) {
    if (dateStr == null) return '';

    try {
      final date = DateTime.parse(dateStr.toString());
      return intl.DateFormat('MMM dd, yyyy').format(date);
    } catch (e) {
      debugPrint('Error parsing date: $e');
      return '';
    }
  }

  Widget _buildLoanAmountSlider() {
    final hasPendingApplication = ref.watch(hasPendingApplicationProvider);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: AppStyle.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: AppStyle.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            hasPendingApplication
                ? 'Cannot apply while application is under review'
                : 'R ${intl.NumberFormat('#,##0').format(ref.watch(loanAmountProvider))}',
            style: AppStyle.interBold(
              size: 18.sp,
              color:
                  hasPendingApplication ? AppStyle.textGrey : AppStyle.primary,
            ),
          ),
          16.verticalSpace,
          AbsorbPointer(
            absorbing: _sliderDisabled || hasPendingApplication,
            child: Slider(
              value: ref.watch(loanAmountProvider),
              min: 200,
              max: 10000,
              divisions: 98,
              label:
                  'R ${intl.NumberFormat('#,##0').format(ref.watch(loanAmountProvider))}',
              onChanged: (double value) {
                ref.read(loanAmountProvider.notifier).state =
                    value.roundToDouble();
              },
              // Make it look disabled visually
              activeColor: (_sliderDisabled || hasPendingApplication)
                  ? AppStyle.textGrey
                  : AppStyle.primary,
              inactiveColor: AppStyle.borderColor,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'R 200',
                style: AppStyle.interNormal(
                  size: 12.sp,
                  color: AppStyle.textGrey,
                ),
              ),
              Text(
                'R 10,000',
                style: AppStyle.interNormal(
                  size: 12.sp,
                  color: AppStyle.textGrey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String? status) {
    if (status == null) return AppStyle.textGrey;
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      case 'pending_contract':
        return Colors.blue;
      default:
        return AppStyle.textGrey;
    }
  }

  void _navigateToLoanContractScreen(
      dynamic loanApplication, dynamic contract) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProviderScope(
          child: Consumer(
            builder: (context, ref, _) => LoanContractScreen(
              loanApplication: loanApplication,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPendingApplicationNotice() {
    final hasPendingApplication = ref.watch(hasPendingApplicationProvider);

    if (!hasPendingApplication) {
      return const SizedBox
          .shrink(); // Return empty widget if no pending application
    }

    return Container(
      margin: EdgeInsets.only(bottom: 24.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.orange.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: Colors.orange,
                size: 24.r,
              ),
              12.horizontalSpace,
              Expanded(
                child: Text(
                  'Application Under Review',
                  style: AppStyle.interSemi(
                    size: 16.sp,
                    color: Colors.orange,
                  ),
                ),
              ),
            ],
          ),
          12.verticalSpace,
          Text(
            'Your loan application is currently being reviewed by our team. You cannot apply for another loan until this application is processed.',
            style: AppStyle.interNormal(
              size: 14.sp,
              color: AppStyle.black,
            ),
          ),
          16.verticalSpace,
          Text(
            'Please check back later for updates on your application status.',
            style: AppStyle.interNormal(
              size: 14.sp,
              color: AppStyle.textGrey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoanBlockedView() {
    return Scaffold(
      backgroundColor: AppStyle.bgGrey,
      body: Column(
        children: [
          CommonAppBar(
            child: Text(
              'Loan Application Blocked',
              style: AppStyle.interNoSemi(
                size: 18,
                color: AppStyle.black,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.block,
                      size: 64.r,
                      color: AppStyle.red,
                    ),
                    16.verticalSpace,
                    Text(
                      'Loan Application Temporarily Blocked',
                      style: AppStyle.interBold(
                        size: 18.sp,
                        color: AppStyle.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    16.verticalSpace,
                    Text(
                      'You have multiple consecutive cancelled loan applications. '
                      'Please contact customer support for further assistance.',
                      style: AppStyle.interNormal(
                        size: 14.sp,
                        color: AppStyle.textGrey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    24.verticalSpace,
                    CustomButton(
                      background: AppStyle.red,
                      textColor: AppStyle.white,
                      title: 'Contact Support',
                      onPressed: () {
                        // Close dialog and loan screen, then navigate to chat route

                        Navigator.of(context).pop(); // Close loan screen

                        AppHelpers.showCustomModalBottomSheet(
                          context: context,
                          modal: ProviderScope(
                            child: Consumer(
                              builder: (context, ref, _) => ChatPage(
                                  roleId: "admin",
                                  name: "Admin"), // Use the ChatRoute component
                            ),
                          ),
                          isDarkMode: false,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _checkActiveOrOverdueLoans(ApiResult<List<dynamic>> transactionsResult) {
    transactionsResult.when(
        success: (transactions) {
          // Check for active or overdue loans
          final activeOverdueLoans = transactions.where((loan) {
            final status = loan['status']?.toString().toLowerCase() ?? '';
            return status == 'active' || status == 'overdue';
          }).toList();

          if (activeOverdueLoans.isNotEmpty) {
            // Sort to get the most recent active/overdue loan
            activeOverdueLoans.sort((a, b) {
              final dateA = DateTime.parse(a['created_at'] ?? DateTime.now().toString());
              final dateB = DateTime.parse(b['created_at'] ?? DateTime.now().toString());
              return dateB.compareTo(dateA);
            });

            final latestActiveOverdueLoan = activeOverdueLoans.first;

            setState(() {
              ref.read(hasPendingApplicationProvider.notifier).state = true;
            });
          }
        },
        failure: (error, _) {
          debugPrint("Failed to check active/overdue loans: $error");
        }
    );
  }
}
