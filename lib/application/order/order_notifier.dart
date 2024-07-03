// ignore_for_file: use_build_context_synchronously

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:riverpodtemp/domain/iterface/cart.dart';
import 'package:riverpodtemp/domain/iterface/draw.dart';
import 'package:riverpodtemp/infrastructure/models/data/addons_data.dart';
import 'package:riverpodtemp/infrastructure/models/data/order_active_model.dart';
import 'package:riverpodtemp/infrastructure/services/app_constants.dart';
import 'package:riverpodtemp/infrastructure/services/local_storage.dart';
import 'package:riverpodtemp/infrastructure/services/marker_image_cropper.dart';
import 'package:riverpodtemp/infrastructure/services/tr_keys.dart';
import 'package:riverpodtemp/presentation/routes/app_router.dart';
import '../../domain/iterface/orders.dart';
import '../../domain/iterface/payments.dart';
import '../../domain/iterface/shops.dart';
import '../../infrastructure/models/models.dart';
import '../../infrastructure/models/request/cart_request.dart';
import '../../infrastructure/services/app_connectivity.dart';
import '../../infrastructure/services/app_helpers.dart';
import 'order_state.dart';
import 'package:intl/intl.dart' as intl;

class OrderNotifier extends StateNotifier<OrderState> {
  final OrdersRepositoryFacade _orderRepository;
  final ShopsRepositoryFacade _shopsRepository;
  final PaymentsRepositoryFacade paymentsRepository;
  final CartRepositoryFacade _cartRepository;
  final DrawRepositoryFacade _drawRouting;

  OrderNotifier(this._orderRepository, this._shopsRepository,
      this.paymentsRepository, this._cartRepository, this._drawRouting)
      : super(const OrderState());

  void setAddressInfo(
      {String? office, String? house, String? floor, String? note}) {
    state = state.copyWith(
        office: office ?? state.office,
        house: house ?? state.house,
        floor: floor ?? state.floor,
        note: note ?? state.note);
  }

  void setUser({String? username, String? phone}) {
    state = state.copyWith(
      username: username ?? state.office,
      phoneNumber: phone ?? state.house,
    );
  }

  Future<void> fetchDriver(BuildContext context) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      if (state.orderData?.deliveryMan?.id == null) {
        return;
      }
      final response = await _orderRepository
          .getDriverLocation(state.orderData?.deliveryMan?.id ?? 0);
      response.when(
        success: (data) async {
          final ImageCropperForMarker image = ImageCropperForMarker();
          Map<MarkerId, Marker> list = Map.from(state.markers);
          list.addAll({
            const MarkerId("Driver"): Marker(
                markerId: const MarkerId("Driver"),
                position: LatLng(
                  data.latitude ?? AppConstants.demoLatitude,
                  data.longitude ?? AppConstants.demoLongitude,
                ),
                icon: await image.resizeAndCircle(
                    state.orderData?.deliveryMan?.img ?? "", 120)),
          });
          state = state.copyWith(
            markers: list,
          );
        },
        failure: (activeFailure, status) {
          if (context.mounted) {
            AppHelpers.showCheckTopSnackBar(
              context,
              activeFailure,
            );
          }
        },
      );
    } else {
      if (context.mounted) {
        AppHelpers.showNoConnectionSnackBar(context);
      }
    }
  }

  void checkBox(bool value) {
    state = state.copyWith(sendOtherUser: value);
  }

  void changeActive(bool isChange) {
    state = state.copyWith(isActive: isChange);
  }

  void setPromoCode(String? promoCode) {
    state = state.copyWith(promoCode: promoCode);
  }

  void resetState() {
    state = state.copyWith(
        orderData: null, selectDate: null, isButtonLoading: false);
  }

  void changeTabIndex(int index) {
    state = state.copyWith(tabIndex: index);
  }

  void setTimeAndDay(TimeOfDay timeOfDay, DateTime day) {
    state = state.copyWith(selectTime: timeOfDay, selectDate: day);
  }

  void checkWorkingDay() {
    int todayWeekIndex = 0;
    int tomorrowWeekIndex = 0;
    for (int i = 0; i < state.shopData!.shopWorkingDays!.length; i++) {
      if (state.shopData!.shopWorkingDays![i].day ==
              intl.DateFormat("EEEE").format(DateTime.now()).toLowerCase() &&
          !(state.shopData!.shopWorkingDays![i].disabled ?? true)) {
        state = state.copyWith(isTodayWorkingDay: true);
        todayWeekIndex = i;
        break;
      } else {
        state = state.copyWith(isTodayWorkingDay: false);
      }
    }
    for (int i = 0; i < state.shopData!.shopWorkingDays!.length; i++) {
      if (state.shopData!.shopWorkingDays![i].day ==
              intl.DateFormat("EEEE")
                  .format(DateTime.now().add(const Duration(days: 1)))
                  .toLowerCase() &&
          !(state.shopData!.shopWorkingDays![i].disabled ?? true)) {
        state = state.copyWith(isTomorrowWorkingDay: true);
        tomorrowWeekIndex = i;
        break;
      } else {
        state = state.copyWith(isTomorrowWorkingDay: false);
      }
    }

    if (state.isTodayWorkingDay) {
      for (int i = 0; i < state.shopData!.shopClosedDate!.length; i++) {
        if (DateTime.now().year ==
                state.shopData!.shopClosedDate![i].day!.year &&
            DateTime.now().month ==
                state.shopData!.shopClosedDate![i].day!.month &&
            DateTime.now().day == state.shopData!.shopClosedDate![i].day!.day) {
          state = state.copyWith(isTodayWorkingDay: false);
          break;
        } else {
          state = state.copyWith(isTodayWorkingDay: true);
        }
      }
      if (state.isTodayWorkingDay) {
        TimeOfDay startTimeOfDay = TimeOfDay(
          hour: int.tryParse(state
                      .shopData!.shopWorkingDays?[todayWeekIndex].from
                      ?.substring(
                          0,
                          state.shopData!.shopWorkingDays?[todayWeekIndex].from
                                  ?.indexOf("-") ??
                              0) ??
                  "") ??
              0,
          minute: int.tryParse(state
                      .shopData!.shopWorkingDays?[todayWeekIndex].from
                      ?.substring((state.shopData!
                                  .shopWorkingDays?[todayWeekIndex].from
                                  ?.indexOf("-") ??
                              0) +
                          1) ??
                  "") ??
              0,
        );
        TimeOfDay endTimeOfDay = TimeOfDay(
          hour: int.tryParse(state.shopData!.shopWorkingDays?[todayWeekIndex].to
                      ?.substring(
                          0,
                          state.shopData!.shopWorkingDays?[todayWeekIndex].to
                                  ?.indexOf("-") ??
                              0) ??
                  "") ??
              0,
          minute: int.tryParse(state
                      .shopData!.shopWorkingDays?[todayWeekIndex].to
                      ?.substring((state
                                  .shopData!.shopWorkingDays?[todayWeekIndex].to
                                  ?.indexOf("-") ??
                              0) +
                          1) ??
                  "") ??
              0,
        );
        state = state.copyWith(
          startTodayTime: startTimeOfDay,
          endTodayTime: endTimeOfDay,
        );
        if (DateTime.now().hour < endTimeOfDay.hour) {
          state = state.copyWith(
              selectDate: DateTime.now(),
              selectTime: DateTime.now().hour > startTimeOfDay.hour
                  ? TimeOfDay(
                      hour: DateTime.now().hour, minute: DateTime.now().minute)
                  : TimeOfDay(
                      hour: startTimeOfDay.hour,
                      minute: startTimeOfDay.minute));
        }
      }
    }

    if (state.isTomorrowWorkingDay) {
      for (int i = 0; i < state.shopData!.shopClosedDate!.length; i++) {
        if (DateTime.now().add(const Duration(days: 1)).year ==
                state.shopData!.shopClosedDate![i].day!.year &&
            DateTime.now().add(const Duration(days: 1)).month ==
                state.shopData!.shopClosedDate![i].day!.month &&
            DateTime.now().add(const Duration(days: 1)).day ==
                state.shopData!.shopClosedDate![i].day!.day) {
          state = state.copyWith(isTomorrowWorkingDay: false);
          break;
        } else {
          state = state.copyWith(isTomorrowWorkingDay: true);
        }
      }
      if (state.isTomorrowWorkingDay) {
        TimeOfDay startTimeOfDay = TimeOfDay(
          hour: int.tryParse(state
                      .shopData!.shopWorkingDays?[tomorrowWeekIndex].from
                      ?.substring(
                          0,
                          state.shopData!.shopWorkingDays?[tomorrowWeekIndex]
                                  .from
                                  ?.indexOf("-") ??
                              0) ??
                  "") ??
              0,
          minute: int.tryParse(state
                      .shopData!.shopWorkingDays?[tomorrowWeekIndex].from
                      ?.substring((state.shopData!
                                  .shopWorkingDays?[tomorrowWeekIndex].from
                                  ?.indexOf("-") ??
                              0) +
                          1) ??
                  "") ??
              0,
        );
        TimeOfDay endTimeOfDay = TimeOfDay(
          hour: int.tryParse(state
                      .shopData!.shopWorkingDays?[tomorrowWeekIndex].to
                      ?.substring(
                          0,
                          state.shopData!.shopWorkingDays?[tomorrowWeekIndex].to
                                  ?.indexOf("-") ??
                              0) ??
                  "") ??
              0,
          minute: int.tryParse(state
                      .shopData!.shopWorkingDays?[tomorrowWeekIndex].to
                      ?.substring((state.shopData!
                                  .shopWorkingDays?[tomorrowWeekIndex].to
                                  ?.indexOf("-") ??
                              0) +
                          1) ??
                  "") ??
              0,
        );
        state = state.copyWith(
          startTomorrowTime: startTimeOfDay,
          endTomorrowTime: endTimeOfDay,
        );
        if (state.selectDate == null) {
          state = state.copyWith(
              selectDate: DateTime.now().add(const Duration(days: 1)),
              selectTime: TimeOfDay(
                  hour: startTimeOfDay.hour, minute: startTimeOfDay.minute));
        }
      }
    }
  }

  changeBranch(int index) {
    state = state.copyWith(branchIndex: index);
  }

  Future<void> fetchShop(BuildContext context, String uuid) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      state = state.copyWith(isLoading: true);
      final response = await _shopsRepository.getSingleShop(uuid: uuid);
      response.when(
        success: (data) async {
          state = state.copyWith(isLoading: false, shopData: data.data);
          checkWorkingDay();
          final ImageCropperForMarker image = ImageCropperForMarker();
          Set<Marker> list = {};
          list.add(Marker(
              markerId: const MarkerId("Shop"),
              position: LatLng(
                data.data?.location?.latitude ?? AppConstants.demoLatitude,
                data.data?.location?.longitude ?? AppConstants.demoLongitude,
              ),
              icon:
                  await image.resizeAndCircle(data.data?.logoImg ?? "", 120)));
          state = state.copyWith(shopMarkers: list);
        },
        failure: (activeFailure, status) {
          state = state.copyWith(isLoading: false);
          AppHelpers.showCheckTopSnackBar(
            context,
            activeFailure,
          );
        },
      );
    } else {
      if (context.mounted) {
        AppHelpers.showNoConnectionSnackBar(context);
      }
    }
  }

  Future<void> fetchShopBranch(BuildContext context, int shopId) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      final response = await _shopsRepository.getShopBranch(uuid: shopId);
      response.when(
        success: (data) async {
          state = state.copyWith(branches: data.data);
        },
        failure: (activeFailure, status) {},
      );
    } else {
      if (context.mounted) {
        AppHelpers.showNoConnectionSnackBar(context);
      }
    }
  }

  Future<void> getCalculate(
      {required BuildContext context,
      required int cartId,
      required double long,
      required double lat,
      required DeliveryTypeEnum type,
      bool isLoading = true}) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      if (isLoading) {
        state = state.copyWith(isLoading: true);
      } else {
        state = state.copyWith(isButtonLoading: true);
      }
      final response = await _orderRepository.getCalculate(
          cartId: cartId,
          lat: lat,
          long: long,
          type: type,
          coupon: state.promoCode);
      response.when(
        success: (data) async {
          if (isLoading) {
            state = state.copyWith(
              isLoading: false,
              calculateData: data,
            );
          } else {
            state = state.copyWith(
              isButtonLoading: false,
              calculateData: data,
            );
          }
        },
        failure: (activeFailure, status) {
          if (isLoading) {
            state = state.copyWith(isLoading: false);
          } else {
            state = state.copyWith(isButtonLoading: false);
          }
          AppHelpers.showCheckTopSnackBar(
            context,
            activeFailure,
          );
          if (status == 401) {
            context.router.popUntilRoot();
            context.replaceRoute(const LoginRoute());
          }
        },
      );
    } else {
      if (context.mounted) {
        AppHelpers.showNoConnectionSnackBar(context);
      }
    }
  }

  setNotes({required int stockId, required String note}) {
    List<ProductNote> list = List.from(state.notes);
    bool isAdd = true;
    for (int i = 0; i < list.length; i++) {
      if (list[i].stockId == stockId) {
        list[i].comment = note;
        isAdd = false;
        break;
      }
    }
    if (isAdd) {
      list.add(ProductNote(stockId: stockId, comment: note));
    }

    state = state.copyWith(notes: list);
  }

  sendTips({
    required BuildContext context,
    required num? price,
    required PaymentData payment,
    VoidCallback? onSuccess,
    ValueChanged<String>? onWebview,
  }) async {
    final num wallet = LocalStorage.getWalletData()?.price ?? 0;
    if (payment.tag == "wallet" && wallet < (price ?? 0)) {
      AppHelpers.showCheckTopSnackBarInfo(
          context, AppHelpers.getTranslation(TrKeys.notEnoughMoney));
      state = state.copyWith(isButtonLoading: false);
      return;
    }
    if (payment.tag?.toLowerCase() != "cash") {
      final res = await _orderRepository.tipProcess(
          state.orderData?.id, payment.tag ?? '', payment.id, price);
      res.map(success: (key) {
        onSuccess?.call();
        if (payment.tag?.toLowerCase() != 'wallet') {
          onWebview?.call(key.data);
        }
      }, failure: (e) {
        state = state.copyWith(isButtonLoading: false);
        if (context.mounted) {
          AppHelpers.showCheckTopSnackBar(
            context,
            e.error,
          );
        }
      });
    }
  }

  Future createOrder({
    required BuildContext context,
    required OrderBodyData data,
    required PaymentData payment,
    VoidCallback? onSuccess,
    ValueChanged<String>? onWebview,
  }) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      state = state.copyWith(isButtonLoading: true);
      if (data.deliveryType == DeliveryTypeEnum.delivery) {
        final res = await _shopsRepository.checkDriverZone(
            LatLng(data.location.latitude ?? 0, data.location.longitude ?? 0),
            shopId: data.shopId);
        res.when(success: (s) async {
          final num wallet = LocalStorage.getWalletData()?.price ?? 0;
          if (payment.tag == "wallet" &&
              wallet < (state.calculateData?.totalPrice ?? 0)) {
            AppHelpers.showCheckTopSnackBarInfo(
                context, AppHelpers.getTranslation(TrKeys.notEnoughMoney));
            state = state.copyWith(isButtonLoading: false);
            return;
          }
          if (payment.tag != "cash" && payment.tag != "wallet") {
            final res = await _orderRepository.process(data, payment.tag ?? '');
            res.map(success: (key) {
              onWebview?.call(key.data);
            }, failure: (e) {
              state = state.copyWith(isButtonLoading: false);
              if (context.mounted) {
                AppHelpers.showCheckTopSnackBar(
                  context,
                  e.error,
                );
              }
            });
            return;
          }
          final response = await _orderRepository.createOrder(data);
          response.when(
            success: (data) async {
              final ImageCropperForMarker image = ImageCropperForMarker();

              state = state.copyWith(
                  orderData: data, isButtonLoading: false, isMapLoading: true);

              Map<MarkerId, Marker> list = {
                const MarkerId("Shop"): Marker(
                    markerId: const MarkerId("Shop"),
                    position: LatLng(
                      data.shop?.location?.latitude ??
                          AppConstants.demoLatitude,
                      data.shop?.location?.longitude ??
                          AppConstants.demoLongitude,
                    ),
                    icon: await image.resizeAndCircle(
                        data.shop?.logoImg ?? "", 120)),
                const MarkerId("User"): Marker(
                    markerId: const MarkerId("User"),
                    position: LatLng(
                      data.location?.latitude ?? AppConstants.demoLatitude,
                      data.location?.longitude ?? AppConstants.demoLongitude,
                    ),
                    icon:
                        await image.resizeAndCircle(data.user?.img ?? "", 120)),
              };
              state = state.copyWith(markers: list, isMapLoading: false);
              getRoutingAll(
                  context: context,
                  end: LatLng(data.location?.latitude ?? 0,
                      data.location?.longitude ?? 0),
                  start: LatLng(data.shop?.location?.latitude ?? 0,
                      data.shop?.location?.longitude ?? 0));
            },
            failure: (activeFailure, status) {
              state = state.copyWith(isButtonLoading: false);
              if (context.mounted) {
                AppHelpers.showCheckTopSnackBar(
                  context,
                  activeFailure,
                );
              }
            },
          );
        }, failure: (activeFailure, e) {
          state = state.copyWith(isButtonLoading: false);
          if (context.mounted) {
            AppHelpers.showCheckTopSnackBar(
              context,
              activeFailure,
            );
          }
        });
        return;
      }

      final num wallet = LocalStorage.getWalletData()?.price ?? 0;
      if (payment.tag == "wallet" &&
          wallet < (state.calculateData?.totalPrice ?? 0)) {
        AppHelpers.showCheckTopSnackBarInfo(
            context, AppHelpers.getTranslation(TrKeys.notEnoughMoney));
        state = state.copyWith(isButtonLoading: false);
        return;
      }
      if (payment.tag != "cash" && payment.tag != "wallet") {
        final res =
            await _orderRepository.process(data, payment.tag ?? "stripe");
        res.map(success: (key) {
          onWebview?.call(key.data);
        }, failure: (e) {
          state = state.copyWith(isButtonLoading: false);
          if (context.mounted) {
            AppHelpers.showCheckTopSnackBar(context, e.error);
          }
        });
        return;
      }

      ///eref@fsdf.ff
      ///4242424242424242
      ///04/44
      final response = await _orderRepository.createOrder(data);
      response.when(
        success: (data) async {
          final ImageCropperForMarker image = ImageCropperForMarker();

          state = state.copyWith(
              orderData: data, isButtonLoading: false, isMapLoading: true);

          Map<MarkerId, Marker> list = {
            const MarkerId("Shop"): Marker(
                markerId: const MarkerId("Shop"),
                position: LatLng(
                  data.shop?.location?.latitude ?? AppConstants.demoLatitude,
                  data.shop?.location?.longitude ?? AppConstants.demoLongitude,
                ),
                icon:
                    await image.resizeAndCircle(data.shop?.logoImg ?? "", 120)),
            const MarkerId("User"): Marker(
                markerId: const MarkerId("User"),
                position: LatLng(
                  data.location?.latitude ?? AppConstants.demoLatitude,
                  data.location?.longitude ?? AppConstants.demoLongitude,
                ),
                icon: await image.resizeAndCircle(data.user?.img ?? "", 120)),
          };
          state = state.copyWith(markers: list, isMapLoading: false);
          getRoutingAll(
              context: context,
              end: LatLng(
                  data.location?.latitude ?? 0, data.location?.longitude ?? 0),
              start: LatLng(data.shop?.location?.latitude ?? 0,
                  data.shop?.location?.longitude ?? 0));
        },
        failure: (activeFailure, status) {
          state = state.copyWith(isButtonLoading: false);
          if (context.mounted) {
            AppHelpers.showCheckTopSnackBar(
              context,
              activeFailure,
            );
          }
        },
      );
    } else {
      if (context.mounted) {
        AppHelpers.showNoConnectionSnackBar(context);
      }
    }
  }

  void repeatOrder({
    required BuildContext context,
    required int shopId,
    required VoidCallback onSuccess,
    List<Detail>? listOfProduct,
  }) async {
    state = state.copyWith(isCheckShopOrder: false);
    if (shopId == 0) {
      final connected = await AppConnectivity.connectivity();
      if (connected) {
        state = state.copyWith(isAddLoading: true);
        List<CartRequest> list = [];
        listOfProduct?.forEach((element) {
          for (Addons addon in element.addons ?? []) {
            list.add(
              CartRequest(
                  stockId: addon.stocks?.id,
                  quantity: addon.quantity,
                  parentId: element.stock?.id ?? 0),
            );
          }
          list.add(CartRequest(
            stockId: element.stock?.id ?? 0,
            quantity: element.quantity ?? 0,
          ));
        });
        final response = await _cartRepository.insertCart(
          cart:
              CartRequest(shopId: state.orderData?.shop?.id ?? 0, carts: list),
        );
        response.when(
          success: (data) {
            state = state.copyWith(isAddLoading: false);
            onSuccess();
          },
          failure: (activeFailure, status) {
            state = state.copyWith(isAddLoading: false);
            AppHelpers.showCheckTopSnackBar(
              context,
              activeFailure,
            );
          },
        );
      } else {
        if (context.mounted) {
          AppHelpers.showNoConnectionSnackBar(context);
        }
      }
    } else {
      state = state.copyWith(isCheckShopOrder: true);
    }
  }

  Future<void> showOrder(
      BuildContext context, num orderId, bool isRefresh) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      if (!isRefresh) {
        state = state.copyWith(isLoading: true, isMapLoading: true);
      }
      final response = await _orderRepository.getSingleOrder(orderId);
      response.when(
        success: (data) async {
          final ImageCropperForMarker image = ImageCropperForMarker();
          if (!isRefresh) {
            state = state.copyWith(
              orderData: data,
              isLoading: false,
            );
            Map<MarkerId, Marker> list = Map.from(state.markers);
            list.addAll({
              const MarkerId("Shop"): Marker(
                  markerId: const MarkerId("Shop"),
                  position: LatLng(
                    data.shop?.location?.latitude ?? AppConstants.demoLatitude,
                    data.shop?.location?.longitude ??
                        AppConstants.demoLongitude,
                  ),
                  icon: await image.resizeAndCircle(
                      data.shop?.logoImg ?? "", 120)),
              const MarkerId("User"): Marker(
                  markerId: const MarkerId("User"),
                  position: LatLng(
                    data.location?.latitude ?? AppConstants.demoLatitude,
                    data.location?.longitude ?? AppConstants.demoLongitude,
                  ),
                  icon: await image.resizeAndCircle(data.user?.img ?? "", 120)),
            });

            state = state.copyWith(markers: list, isMapLoading: false);
            fetchDriver(context);
            getRoutingAll(
                context: context,
                end: LatLng(data.location?.latitude ?? 0,
                    data.location?.longitude ?? 0),
                start: LatLng(data.shop?.location?.latitude ?? 0,
                    data.shop?.location?.longitude ?? 0));
          } else {
            state = state.copyWith(orderData: data);
            Map<MarkerId, Marker> list = Map.from(state.markers);
            list.addAll({
              const MarkerId("Shop"): Marker(
                  markerId: const MarkerId("Shop"),
                  position: LatLng(
                    data.shop?.location?.latitude ?? AppConstants.demoLatitude,
                    data.shop?.location?.longitude ??
                        AppConstants.demoLongitude,
                  ),
                  icon: await image.resizeAndCircle(
                      data.shop?.logoImg ?? "", 120)),
              const MarkerId("User"): Marker(
                  markerId: const MarkerId("User"),
                  position: LatLng(
                    data.location?.latitude ?? AppConstants.demoLatitude,
                    data.location?.longitude ?? AppConstants.demoLongitude,
                  ),
                  icon: await image.resizeAndCircle(data.user?.img ?? "", 120)),
            });
            state = state.copyWith(markers: list);
          }
        },
        failure: (activeFailure, status) {
          if (!isRefresh) {
            state = state.copyWith(isLoading: false);
          }
          if (context.mounted) {
            AppHelpers.showCheckTopSnackBar(
              context,
              activeFailure,
            );
          }
        },
      );
    } else {
      if (context.mounted) {
        AppHelpers.showNoConnectionSnackBar(context);
      }
    }
  }

  Future<void> cancelOrder(BuildContext context, num orderId) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      state = state.copyWith(isButtonLoading: true);
      final response = await _orderRepository.cancelOrder(orderId);
      response.when(
        success: (data) async {
          state = state.copyWith(isButtonLoading: false);
          context.popRoute(context);
        },
        failure: (activeFailure, status) {
          state = state.copyWith(isButtonLoading: false);
          if (context.mounted) {
            AppHelpers.showCheckTopSnackBar(
              context,
              activeFailure,
            );
          }
        },
      );
    } else {
      if (context.mounted) {
        AppHelpers.showNoConnectionSnackBar(context);
      }
    }
  }

  Future<void> refundOrder(BuildContext context, String title) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      state = state.copyWith(isButtonLoading: true);
      final response =
          await _orderRepository.refundOrder(state.orderData?.id ?? 0, title);
      response.when(
        success: (data) async {
          state = state.copyWith(isButtonLoading: false);
          AppHelpers.showCheckTopSnackBarDone(
              context, AppHelpers.getTranslation(TrKeys.successfully));
          context.popRoute(context);
        },
        failure: (activeFailure, status) {
          state = state.copyWith(isButtonLoading: false);
          if (context.mounted) {
            AppHelpers.showCheckTopSnackBar(
              context,
              activeFailure,
            );
          }
        },
      );
    } else {
      if (context.mounted) {
        AppHelpers.showNoConnectionSnackBar(context);
      }
    }
  }

  Future<void> addReview(
      BuildContext context, String comment, double rating) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      state = state.copyWith(isButtonLoading: true);
      final response = await _orderRepository.addReview(
          state.orderData?.id ?? 0,
          rating: rating,
          comment: comment);
      response.when(
        success: (data) async {
          state = state.copyWith(isButtonLoading: false);
          context.popRoute(context);
        },
        failure: (activeFailure, status) {
          state = state.copyWith(isButtonLoading: false);
          if (context.mounted) {
            AppHelpers.showCheckTopSnackBar(
              context,
              activeFailure,
            );
          }
        },
      );
    } else {
      if (context.mounted) {
        AppHelpers.showNoConnectionSnackBar(context);
      }
    }
  }

  Future<void> getRoutingAll({
    required BuildContext context,
    required LatLng start,
    required LatLng end,
  }) async {
    if (await AppConnectivity.connectivity()) {
      state = state.copyWith(polylineCoordinates: []);
      final response = await _drawRouting.getRouting(start: start, end: end);
      response.when(
        success: (data) {
          List<LatLng> list = [];
          List ls = data.features[0].geometry.coordinates;
          for (int i = 0; i < ls.length; i++) {
            list.add(LatLng(ls[i][1], ls[i][0]));
          }
          state = state.copyWith(
            polylineCoordinates: list,
          );
        },
        failure: (failure, status) {
          state = state.copyWith(polylineCoordinates: []);
        },
      );
    } else {
      if (context.mounted) {
        AppHelpers.showNoConnectionSnackBar(context);
      }
    }
  }
}
