import 'package:foodyman/infrastructure/models/models.dart';
import 'package:foodyman/domain/handlers/handlers.dart';

import '../../infrastructure/models/data/order_active_model.dart';

abstract class PaymentsRepositoryFacade {
  Future<ApiResult<PaymentsResponse?>> getPayments();

  Future<ApiResult<TransactionsResponse>> createTransaction({
    required int orderId,
    required int paymentId,
  });
}