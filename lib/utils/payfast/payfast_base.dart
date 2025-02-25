/*

import 'enums/frequency_cycle_period.dart';
import 'enums/payment_type.dart';
import 'enums/recurring_payment_types.dart';
import 'models/billing_types/recurring_billing.dart';
import 'models/billing_types/recurring_billing_types/subscription_payment.dart';
import 'models/billing_types/recurring_billing_types/tokenization_billing.dart';
import 'models/billing_types/simple_billing.dart';
import 'models/merchant_details.dart';
import 'signature_service.dart';

class Payfast {
  String passphrase;
  PaymentType paymentType;
  bool production;

  RecurringBilling? recurringBilling;
  SimpleBilling? simpleBilling;
  MerchantDetails merchantDetails;

  // Customer details
  String? emailAddress;
  String? cellNumber;
  String? nameFirst;
  String? nameLast;

  Payfast({
    required this.passphrase,
    required this.paymentType,
    required this.production,
    required this.merchantDetails,
    this.emailAddress,
    this.cellNumber,
    this.nameFirst,
    this.nameLast,
  });

  String generateURL() {
    Map<String, dynamic> queryParameters = {};

    // Simple Payment
    if (paymentType == PaymentType.simplePayment) {
      Map<String, dynamic> simpleQueryParameters = {
        ...merchantDetails.toMap(),
        'amount': simpleBilling?.amount,
        'item_name': simpleBilling?.itemName,
      };

      // Add customer details if provided
      if (emailAddress != null && emailAddress!.isNotEmpty) {
        simpleQueryParameters['email_address'] = emailAddress;
      }

      if (cellNumber != null && cellNumber!.isNotEmpty) {
        simpleQueryParameters['cell_number'] = cellNumber;
      }

      if (nameFirst != null && nameFirst!.isNotEmpty) {
        simpleQueryParameters['name_first'] = nameFirst;
      }

      if (nameLast != null && nameLast!.isNotEmpty) {
        simpleQueryParameters['name_last'] = nameLast;
      }

      queryParameters = simpleQueryParameters;
    }
    // Recurring Billing
    else if (paymentType == PaymentType.recurringBilling) {
      // Subscription
      if (recurringBilling?.recurringPaymentType == RecurringPaymentType.subscription) {
        Map<String, dynamic> recurringSubscriptionQueryParameters = {
          ...merchantDetails.toMap(),
          'amount': recurringBilling?.subscriptionPayment?.amount,
          'item_name': recurringBilling?.subscriptionPayment?.itemName,
          'subscription_type': recurringBilling?.subscriptionPayment?.subscriptionsType,
          'billing_date': recurringBilling?.subscriptionPayment?.billingDate,
          'recurring_amount': recurringBilling?.subscriptionPayment?.recurringAmount,
          'frequency': recurringBilling?.subscriptionPayment?.frequency,
          'cycles': recurringBilling?.subscriptionPayment?.cycles,
        };

        // Add customer details if provided
        if (emailAddress != null && emailAddress!.isNotEmpty) {
          recurringSubscriptionQueryParameters['email_address'] = emailAddress;
        }

        if (cellNumber != null && cellNumber!.isNotEmpty) {
          recurringSubscriptionQueryParameters['cell_number'] = cellNumber;
        }

        if (nameFirst != null && nameFirst!.isNotEmpty) {
          recurringSubscriptionQueryParameters['name_first'] = nameFirst;
        }

        if (nameLast != null && nameLast!.isNotEmpty) {
          recurringSubscriptionQueryParameters['name_last'] = nameLast;
        }

        queryParameters = recurringSubscriptionQueryParameters;
      }
      // Tokenization
      else if (recurringBilling?.recurringPaymentType == RecurringPaymentType.tokenization) {
        Map<String, dynamic> recurringTokenizationQueryParameters = {
          ...merchantDetails.toMap(),
          'amount': '250',
          'item_name': 'Netflix',
          'subscription_type': recurringBilling?.tokenizationBilling?.subscriptionType,
        };

        // Add customer details if provided
        if (emailAddress != null && emailAddress!.isNotEmpty) {
          recurringTokenizationQueryParameters['email_address'] = emailAddress;
        }

        if (cellNumber != null && cellNumber!.isNotEmpty) {
          recurringTokenizationQueryParameters['cell_number'] = cellNumber;
        }

        if (nameFirst != null && nameFirst!.isNotEmpty) {
          recurringTokenizationQueryParameters['name_first'] = nameFirst;
        }

        if (nameLast != null && nameLast!.isNotEmpty) {
          recurringTokenizationQueryParameters['name_last'] = nameLast;
        }

        queryParameters = recurringTokenizationQueryParameters;
      } else {
        throw Exception("Payment type not selected");
      }
    }

    // Calculate signature with all parameters including customer details
    String signature = SignatureService.createSignature(queryParameters, passphrase);

    return Uri.decodeComponent(
      Uri(
        scheme: 'https',
        host: '${production ? 'payfast' : 'sandbox.payfast'}.co.za',
        path: '/eng/process',
        queryParameters: {
          ...queryParameters,
          'signature': signature,
        },
      ).toString(),
    );
  }

  void createSimplePayment({
    required String amount,
    required String itemName,
  }) {
    simpleBilling = SimpleBilling(
      amount: amount,
      itemName: itemName,
    );
  }

  void setRecurringBillingType(RecurringPaymentType recurringPaymentType) {
    recurringBilling =
        RecurringBilling(recurringPaymentType: recurringPaymentType);
  }

  void setupRecurringBillingSubscription({
    required int amount,
    required String itemName,
    required String billingDate,
    required int cycles,
    required FrequencyCyclePeriod cyclePeriod,
    required int recurringAmount,
  }) {
    recurringBilling!.subscriptionPayment = SubscriptionPayment(
      amount: amount.toString(),
      itemName: itemName,
      billingDate: billingDate,
      recurringAmount: recurringAmount.toString(),
      frequency: (cyclePeriod.index + 3).toString(),
      cycles: cycles.toString(),
    );
  }

  void setupRecurringBillingTokenization([
    int? amount,
    String? itemName,
  ]) {
    recurringBilling!.tokenizationBilling = TokenizationBilling(
      amount?.toString(),
      itemName,
    );
  }

  void chargeTokenization() {
    Map<String, dynamic> recurringTokenizationQueryParameters = {
      'token': '3ee21522-7cc9-464d-837a-3e791c5a6f1d',
      'merchant-id': '10026561',
      'version': 'v1',
      'timestamp': '2022-07-25',
      'amount': '444',
      'item_name': 'Netflix',
    };

    Map<String, dynamic> signatureEntry = {
      'signature': SignatureService.createSignature(
          recurringTokenizationQueryParameters, 'JoshuaMunstermann'),
    };

    recurringTokenizationQueryParameters.addEntries(signatureEntry.entries);
  }
}*/