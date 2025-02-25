import 'package:foodyman/domain/handlers/handlers.dart';
import 'package:foodyman/infrastructure/models/models.dart';

import '../../infrastructure/models/data/user.dart';
import '../../infrastructure/models/data/wallet_data.dart';

abstract class WalletRepositoryFacade {
  Future<ApiResult<List<UserModel>>> searchSending(Map<String, dynamic> params);
  Future<ApiResult<WalletHistoryData>> sendWalletBalance(String userUuid, double amount);
}