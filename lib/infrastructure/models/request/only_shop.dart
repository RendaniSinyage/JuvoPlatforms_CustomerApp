

import 'package:riverpodtemp/infrastructure/services/local_storage.dart';

class OnlyShopRequest {
  final String? lan;
  OnlyShopRequest({
    this.lan,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["lang"] = LocalStorage.getLanguage()?.locale ?? "en";
   if(LocalStorage.getSelectedCurrency() != null) map["currency_id"] = LocalStorage.getSelectedCurrency()?.id;
    return map;
  }
}