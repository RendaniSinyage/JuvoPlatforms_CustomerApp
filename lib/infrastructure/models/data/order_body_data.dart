import 'package:riverpodtemp/infrastructure/models/data/order_data.dart';
import 'package:riverpodtemp/infrastructure/models/data/shop_data.dart';
import 'package:riverpodtemp/infrastructure/services/app_constants.dart';
import 'package:riverpodtemp/infrastructure/services/local_storage.dart';

class OrderBodyData {
  final int cartId;
  final String? note;
  final int shopId;
  final int? paymentId;
  final num deliveryFee;
  final DeliveryTypeEnum deliveryType;
  final String? coupon;
  final Location location;
  final AddressModel address;
  final String deliveryDate;
  final String deliveryTime;
  final String? username;
  final String? phone;
  final List<ProductNote> notes;

  OrderBodyData({
    required this.cartId,
    required this.shopId,
    required this.paymentId,
    required this.deliveryFee,
    required this.deliveryType,
    this.coupon,
    required this.location,
    required this.address,
    required this.deliveryDate,
    required this.deliveryTime,
    required this.notes,
    this.note,
    this.username,
    this.phone,
  });

  Map toJson() {
    return {
      "cart_id": cartId,
      "currency_id": LocalStorage.getSelectedCurrency()?.id ?? 0,
      "rate": LocalStorage.getSelectedCurrency()?.rate ?? 1,
      "shop_id": shopId,
      if (username != null) "username": username,
      if (phone != null) "phone": phone,
      if (paymentId != null) "payment_id": paymentId,
      "delivery_fee": deliveryFee,
      // "address_id": addressId,
      "delivery_type":
          deliveryType == DeliveryTypeEnum.delivery ? "delivery" : "pickup",
      if(coupon != null && (coupon?.trim().isNotEmpty ?? false))
      "coupon": coupon,
      "location": location.toJson(),
      "address": address.toJson(),
      "delivery_date": deliveryDate,
      "delivery_time": deliveryTime,
      "note": note,
      'lang': LocalStorage.getLanguage()?.locale,
      if (notes.isNotEmpty)
        "notes": {
          for (int i = 0; i < notes.length; i++)
            "${notes[i].stockId}": notes[i].comment
        }
    };
  }
}

class AddressModel {
  final String? address;
  final String? office;
  final String? house;
  final String? floor;

  AddressModel({
    this.address,
    this.office,
    this.house,
    this.floor,
  });

  Map toJson() {
    return {
      "address": address,
      "office": office,
      "house": house,
      "floor": floor
    };
  }

  factory AddressModel.fromJson(Map? data) {
    return AddressModel(
      address: data?["address"],
      office: data?["office"],
      house: data?["house"],
      floor: data?["floor"],
    );
  }
}

class ShopOrder {
  final int shopId;
  final int? deliveryAddressId;
  final num? deliveryFee;
  final int? deliveryTypeId;
  final String? coupon;
  final String? deliveryDate;
  final String? deliveryTime;
  final num tax;
  final List<ProductOrder> products;

  ShopOrder({
    required this.shopId,
    this.deliveryFee,
    this.deliveryTypeId,
    this.deliveryAddressId,
    this.coupon,
    this.deliveryDate,
    this.deliveryTime,
    required this.tax,
    required this.products,
  });

  @override
  String toString() {
    return "{\"shop_id\":$shopId, \"delivery_address_id\":$deliveryAddressId, \"delivery_fee\":$deliveryFee, \"delivery_type_id\":$deliveryTypeId, \"coupon\":\"$coupon\", \"delivery_date\":\"$deliveryDate\", \"delivery_time\":\"$deliveryTime\", \"tax\":$tax, \"products\":$products}";
  }
}

class ProductOrder {
  final int stockId;
  final num price;
  final int quantity;
  final num tax;
  final num discount;
  final num totalPrice;

  ProductOrder({
    required this.stockId,
    required this.price,
    required this.quantity,
    required this.tax,
    required this.discount,
    required this.totalPrice,
  });

  @override
  String toString() {
    return "{\"stock_id\":$stockId, \"price\":$price, \"qty\":$quantity, \"tax\":$tax, \"discount\":$discount, \"total_price\":$totalPrice}";
  }
}
