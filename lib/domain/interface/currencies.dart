import 'package:foodyman/infrastructure/models/models.dart';
import 'package:foodyman/domain/handlers/handlers.dart';

abstract class CurrenciesRepositoryFacade {
  Future<ApiResult<CurrenciesResponse>> getCurrencies();
}
