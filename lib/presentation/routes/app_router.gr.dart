// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    AddressListRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AddressListPage(),
      );
    },
    ChatRoute.name: (routeData) {
      final args = routeData.argsAs<ChatRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ChatPage(
          key: args.key,
          roleId: args.roleId,
          name: args.name,
        ),
      );
    },
    CreateShopRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const CreateShopPage(),
      );
    },
    GenerateImageRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const GenerateImagePage(),
      );
    },
    HelpRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const HelpPage(),
      );
    },
    InfoRoute.name: (routeData) {
      final args = routeData.argsAs<InfoRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: InfoPage(
          key: args.key,
          index: args.index,
        ),
      );
    },
    LikeRoute.name: (routeData) {
      final args =
          routeData.argsAs<LikeRouteArgs>(orElse: () => const LikeRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: LikePage(
          key: args.key,
          isBackButton: args.isBackButton,
        ),
      );
    },
    LoginRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const LoginPage(),
      );
    },
    MainRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const MainPage(),
      );
    },
    MapSearchRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const MapSearchPage(),
      );
    },
    NoConnectionRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const NoConnectionPage(),
      );
    },
    NotificationListRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const NotificationListPage(),
      );
    },
    OrderRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const OrderPage(),
      );
    },
    OrderProgressRoute.name: (routeData) {
      final args = routeData.argsAs<OrderProgressRouteArgs>(
          orElse: () => const OrderProgressRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: OrderProgressPage(
          key: args.key,
          orderId: args.orderId,
        ),
      );
    },
    OrdersListRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const OrdersListPage(),
      );
    },
    ParcelListRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ParcelListPage(),
      );
    },
    ParcelRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ParcelPage(),
      );
    },
    ParcelProgressRoute.name: (routeData) {
      final args = routeData.argsAs<ParcelProgressRouteArgs>(
          orElse: () => const ParcelProgressRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ParcelProgressPage(
          key: args.key,
          parcelId: args.parcelId,
        ),
      );
    },
    ProfileRoute.name: (routeData) {
      final args = routeData.argsAs<ProfileRouteArgs>(
          orElse: () => const ProfileRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ProfilePage(
          key: args.key,
          isBackButton: args.isBackButton,
        ),
      );
    },
    RecommendedOneRoute.name: (routeData) {
      final args = routeData.argsAs<RecommendedOneRouteArgs>(
          orElse: () => const RecommendedOneRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: RecommendedOnePage(
          key: args.key,
          isNewsOfPage: args.isNewsOfPage,
          isShop: args.isShop,
        ),
      );
    },
    RecommendedRoute.name: (routeData) {
      final args = routeData.argsAs<RecommendedRouteArgs>(
          orElse: () => const RecommendedRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: RecommendedPage(
          key: args.key,
          isNewsOfPage: args.isNewsOfPage,
          isShop: args.isShop,
        ),
      );
    },
    RecommendedThreeRoute.name: (routeData) {
      final args = routeData.argsAs<RecommendedThreeRouteArgs>(
          orElse: () => const RecommendedThreeRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: RecommendedThreePage(
          key: args.key,
          isNewsOfPage: args.isNewsOfPage,
          isShop: args.isShop,
          isPopular: args.isPopular,
        ),
      );
    },
    RecommendedTwoRoute.name: (routeData) {
      final args = routeData.argsAs<RecommendedTwoRouteArgs>(
          orElse: () => const RecommendedTwoRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: RecommendedTwoPage(
          key: args.key,
          isNewsOfPage: args.isNewsOfPage,
          isShop: args.isShop,
          isPopular: args.isPopular,
        ),
      );
    },
    RegisterConfirmationRoute.name: (routeData) {
      final args = routeData.argsAs<RegisterConfirmationRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: RegisterConfirmationPage(
          key: args.key,
          userModel: args.userModel,
          isResetPassword: args.isResetPassword,
          verificationId: args.verificationId,
          editPhone: args.editPhone,
        ),
      );
    },
    RegisterRoute.name: (routeData) {
      final args = routeData.argsAs<RegisterRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: RegisterPage(
          key: args.key,
          isOnlyEmail: args.isOnlyEmail,
        ),
      );
    },
    ResetPasswordRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ResetPasswordPage(),
      );
    },
    ResultFilterRoute.name: (routeData) {
      final args = routeData.argsAs<ResultFilterRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ResultFilterPage(
          key: args.key,
          categoryId: args.categoryId,
        ),
      );
    },
    SearchRoute.name: (routeData) {
      final args = routeData.argsAs<SearchRouteArgs>(
          orElse: () => const SearchRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: SearchPage(
          key: args.key,
          isBackButton: args.isBackButton,
        ),
      );
    },
    ServiceTwoCategoryRoute.name: (routeData) {
      final args = routeData.argsAs<ServiceTwoCategoryRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ServiceTwoCategoryPage(
          key: args.key,
          index: args.index,
        ),
      );
    },
    SettingRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SettingPage(),
      );
    },
    ShareReferralFaqRoute.name: (routeData) {
      final args = routeData.argsAs<ShareReferralFaqRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ShareReferralFaqPage(
          key: args.key,
          terms: args.terms,
        ),
      );
    },
    ShareReferralRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ShareReferralPage(),
      );
    },
    ShopDetailRoute.name: (routeData) {
      final args = routeData.argsAs<ShopDetailRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ShopDetailPage(
          key: args.key,
          shop: args.shop,
          workTime: args.workTime,
        ),
      );
    },
    ShopRoute.name: (routeData) {
      final args = routeData.argsAs<ShopRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ShopPage(
          key: args.key,
          shopId: args.shopId,
          productId: args.productId,
          cartId: args.cartId,
          shop: args.shop,
          ownerId: args.ownerId,
        ),
      );
    },
    ShopsBannerRoute.name: (routeData) {
      final args = routeData.argsAs<ShopsBannerRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ShopsBannerPage(
          key: args.key,
          bannerId: args.bannerId,
          title: args.title,
          isAds: args.isAds,
        ),
      );
    },
    SplashRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SplashPage(),
      );
    },
    StoryListRoute.name: (routeData) {
      final args = routeData.argsAs<StoryListRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: StoryListPage(
          key: args.key,
          index: args.index,
          controller: args.controller,
        ),
      );
    },
    SubCategoryRoute.name: (routeData) {
      final args = routeData.argsAs<SubCategoryRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: SubCategoryPage(
          key: args.key,
          category: args.category,
          shopId: args.shopId,
          cartId: args.cartId,
        ),
      );
    },
    UiTypeRoute.name: (routeData) {
      final args = routeData.argsAs<UiTypeRouteArgs>(
          orElse: () => const UiTypeRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: UiTypePage(
          key: args.key,
          isBack: args.isBack,
        ),
      );
    },
    ViewMapRoute.name: (routeData) {
      final args = routeData.argsAs<ViewMapRouteArgs>(
          orElse: () => const ViewMapRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ViewMapPage(
          key: args.key,
          isParcel: args.isParcel,
          isPop: args.isPop,
          isShopLocation: args.isShopLocation,
          shopId: args.shopId,
          indexAddress: args.indexAddress,
          address: args.address,
        ),
      );
    },
    WalletHistoryRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const WalletHistoryPage(),
      );
    },
  };
}

/// generated route for
/// [AddressListPage]
class AddressListRoute extends PageRouteInfo<void> {
  const AddressListRoute({List<PageRouteInfo>? children})
      : super(
          AddressListRoute.name,
          initialChildren: children,
        );

  static const String name = 'AddressListRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ChatPage]
class ChatRoute extends PageRouteInfo<ChatRouteArgs> {
  ChatRoute({
    Key? key,
    required String roleId,
    required String name,
    List<PageRouteInfo>? children,
  }) : super(
          ChatRoute.name,
          args: ChatRouteArgs(
            key: key,
            roleId: roleId,
            name: name,
          ),
          initialChildren: children,
        );

  static const String name = 'ChatRoute';

  static const PageInfo<ChatRouteArgs> page = PageInfo<ChatRouteArgs>(name);
}

class ChatRouteArgs {
  const ChatRouteArgs({
    this.key,
    required this.roleId,
    required this.name,
  });

  final Key? key;

  final String roleId;

  final String name;

  @override
  String toString() {
    return 'ChatRouteArgs{key: $key, roleId: $roleId, name: $name}';
  }
}

/// generated route for
/// [CreateShopPage]
class CreateShopRoute extends PageRouteInfo<void> {
  const CreateShopRoute({List<PageRouteInfo>? children})
      : super(
          CreateShopRoute.name,
          initialChildren: children,
        );

  static const String name = 'CreateShopRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [GenerateImagePage]
class GenerateImageRoute extends PageRouteInfo<void> {
  const GenerateImageRoute({List<PageRouteInfo>? children})
      : super(
          GenerateImageRoute.name,
          initialChildren: children,
        );

  static const String name = 'GenerateImageRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [HelpPage]
class HelpRoute extends PageRouteInfo<void> {
  const HelpRoute({List<PageRouteInfo>? children})
      : super(
          HelpRoute.name,
          initialChildren: children,
        );

  static const String name = 'HelpRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [InfoPage]
class InfoRoute extends PageRouteInfo<InfoRouteArgs> {
  InfoRoute({
    Key? key,
    required int index,
    List<PageRouteInfo>? children,
  }) : super(
          InfoRoute.name,
          args: InfoRouteArgs(
            key: key,
            index: index,
          ),
          initialChildren: children,
        );

  static const String name = 'InfoRoute';

  static const PageInfo<InfoRouteArgs> page = PageInfo<InfoRouteArgs>(name);
}

class InfoRouteArgs {
  const InfoRouteArgs({
    this.key,
    required this.index,
  });

  final Key? key;

  final int index;

  @override
  String toString() {
    return 'InfoRouteArgs{key: $key, index: $index}';
  }
}

/// generated route for
/// [LikePage]
class LikeRoute extends PageRouteInfo<LikeRouteArgs> {
  LikeRoute({
    Key? key,
    bool isBackButton = true,
    List<PageRouteInfo>? children,
  }) : super(
          LikeRoute.name,
          args: LikeRouteArgs(
            key: key,
            isBackButton: isBackButton,
          ),
          initialChildren: children,
        );

  static const String name = 'LikeRoute';

  static const PageInfo<LikeRouteArgs> page = PageInfo<LikeRouteArgs>(name);
}

class LikeRouteArgs {
  const LikeRouteArgs({
    this.key,
    this.isBackButton = true,
  });

  final Key? key;

  final bool isBackButton;

  @override
  String toString() {
    return 'LikeRouteArgs{key: $key, isBackButton: $isBackButton}';
  }
}

/// generated route for
/// [LoginPage]
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute({List<PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [MainPage]
class MainRoute extends PageRouteInfo<void> {
  const MainRoute({List<PageRouteInfo>? children})
      : super(
          MainRoute.name,
          initialChildren: children,
        );

  static const String name = 'MainRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [MapSearchPage]
class MapSearchRoute extends PageRouteInfo<void> {
  const MapSearchRoute({List<PageRouteInfo>? children})
      : super(
          MapSearchRoute.name,
          initialChildren: children,
        );

  static const String name = 'MapSearchRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [NoConnectionPage]
class NoConnectionRoute extends PageRouteInfo<void> {
  const NoConnectionRoute({List<PageRouteInfo>? children})
      : super(
          NoConnectionRoute.name,
          initialChildren: children,
        );

  static const String name = 'NoConnectionRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [NotificationListPage]
class NotificationListRoute extends PageRouteInfo<void> {
  const NotificationListRoute({List<PageRouteInfo>? children})
      : super(
          NotificationListRoute.name,
          initialChildren: children,
        );

  static const String name = 'NotificationListRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [OrderPage]
class OrderRoute extends PageRouteInfo<void> {
  const OrderRoute({List<PageRouteInfo>? children})
      : super(
          OrderRoute.name,
          initialChildren: children,
        );

  static const String name = 'OrderRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [OrderProgressPage]
class OrderProgressRoute extends PageRouteInfo<OrderProgressRouteArgs> {
  OrderProgressRoute({
    Key? key,
    num? orderId,
    List<PageRouteInfo>? children,
  }) : super(
          OrderProgressRoute.name,
          args: OrderProgressRouteArgs(
            key: key,
            orderId: orderId,
          ),
          initialChildren: children,
        );

  static const String name = 'OrderProgressRoute';

  static const PageInfo<OrderProgressRouteArgs> page =
      PageInfo<OrderProgressRouteArgs>(name);
}

class OrderProgressRouteArgs {
  const OrderProgressRouteArgs({
    this.key,
    this.orderId,
  });

  final Key? key;

  final num? orderId;

  @override
  String toString() {
    return 'OrderProgressRouteArgs{key: $key, orderId: $orderId}';
  }
}

/// generated route for
/// [OrdersListPage]
class OrdersListRoute extends PageRouteInfo<void> {
  const OrdersListRoute({List<PageRouteInfo>? children})
      : super(
          OrdersListRoute.name,
          initialChildren: children,
        );

  static const String name = 'OrdersListRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ParcelListPage]
class ParcelListRoute extends PageRouteInfo<void> {
  const ParcelListRoute({List<PageRouteInfo>? children})
      : super(
          ParcelListRoute.name,
          initialChildren: children,
        );

  static const String name = 'ParcelListRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ParcelPage]
class ParcelRoute extends PageRouteInfo<void> {
  const ParcelRoute({List<PageRouteInfo>? children})
      : super(
          ParcelRoute.name,
          initialChildren: children,
        );

  static const String name = 'ParcelRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ParcelProgressPage]
class ParcelProgressRoute extends PageRouteInfo<ParcelProgressRouteArgs> {
  ParcelProgressRoute({
    Key? key,
    num? parcelId,
    List<PageRouteInfo>? children,
  }) : super(
          ParcelProgressRoute.name,
          args: ParcelProgressRouteArgs(
            key: key,
            parcelId: parcelId,
          ),
          initialChildren: children,
        );

  static const String name = 'ParcelProgressRoute';

  static const PageInfo<ParcelProgressRouteArgs> page =
      PageInfo<ParcelProgressRouteArgs>(name);
}

class ParcelProgressRouteArgs {
  const ParcelProgressRouteArgs({
    this.key,
    this.parcelId,
  });

  final Key? key;

  final num? parcelId;

  @override
  String toString() {
    return 'ParcelProgressRouteArgs{key: $key, parcelId: $parcelId}';
  }
}

/// generated route for
/// [ProfilePage]
class ProfileRoute extends PageRouteInfo<ProfileRouteArgs> {
  ProfileRoute({
    Key? key,
    bool isBackButton = true,
    List<PageRouteInfo>? children,
  }) : super(
          ProfileRoute.name,
          args: ProfileRouteArgs(
            key: key,
            isBackButton: isBackButton,
          ),
          initialChildren: children,
        );

  static const String name = 'ProfileRoute';

  static const PageInfo<ProfileRouteArgs> page =
      PageInfo<ProfileRouteArgs>(name);
}

class ProfileRouteArgs {
  const ProfileRouteArgs({
    this.key,
    this.isBackButton = true,
  });

  final Key? key;

  final bool isBackButton;

  @override
  String toString() {
    return 'ProfileRouteArgs{key: $key, isBackButton: $isBackButton}';
  }
}

/// generated route for
/// [RecommendedOnePage]
class RecommendedOneRoute extends PageRouteInfo<RecommendedOneRouteArgs> {
  RecommendedOneRoute({
    Key? key,
    bool isNewsOfPage = false,
    bool isShop = false,
    List<PageRouteInfo>? children,
  }) : super(
          RecommendedOneRoute.name,
          args: RecommendedOneRouteArgs(
            key: key,
            isNewsOfPage: isNewsOfPage,
            isShop: isShop,
          ),
          initialChildren: children,
        );

  static const String name = 'RecommendedOneRoute';

  static const PageInfo<RecommendedOneRouteArgs> page =
      PageInfo<RecommendedOneRouteArgs>(name);
}

class RecommendedOneRouteArgs {
  const RecommendedOneRouteArgs({
    this.key,
    this.isNewsOfPage = false,
    this.isShop = false,
  });

  final Key? key;

  final bool isNewsOfPage;

  final bool isShop;

  @override
  String toString() {
    return 'RecommendedOneRouteArgs{key: $key, isNewsOfPage: $isNewsOfPage, isShop: $isShop}';
  }
}

/// generated route for
/// [RecommendedPage]
class RecommendedRoute extends PageRouteInfo<RecommendedRouteArgs> {
  RecommendedRoute({
    Key? key,
    bool isNewsOfPage = false,
    bool isShop = false,
    List<PageRouteInfo>? children,
  }) : super(
          RecommendedRoute.name,
          args: RecommendedRouteArgs(
            key: key,
            isNewsOfPage: isNewsOfPage,
            isShop: isShop,
          ),
          initialChildren: children,
        );

  static const String name = 'RecommendedRoute';

  static const PageInfo<RecommendedRouteArgs> page =
      PageInfo<RecommendedRouteArgs>(name);
}

class RecommendedRouteArgs {
  const RecommendedRouteArgs({
    this.key,
    this.isNewsOfPage = false,
    this.isShop = false,
  });

  final Key? key;

  final bool isNewsOfPage;

  final bool isShop;

  @override
  String toString() {
    return 'RecommendedRouteArgs{key: $key, isNewsOfPage: $isNewsOfPage, isShop: $isShop}';
  }
}

/// generated route for
/// [RecommendedThreePage]
class RecommendedThreeRoute extends PageRouteInfo<RecommendedThreeRouteArgs> {
  RecommendedThreeRoute({
    Key? key,
    bool isNewsOfPage = false,
    bool isShop = false,
    bool isPopular = false,
    List<PageRouteInfo>? children,
  }) : super(
          RecommendedThreeRoute.name,
          args: RecommendedThreeRouteArgs(
            key: key,
            isNewsOfPage: isNewsOfPage,
            isShop: isShop,
            isPopular: isPopular,
          ),
          initialChildren: children,
        );

  static const String name = 'RecommendedThreeRoute';

  static const PageInfo<RecommendedThreeRouteArgs> page =
      PageInfo<RecommendedThreeRouteArgs>(name);
}

class RecommendedThreeRouteArgs {
  const RecommendedThreeRouteArgs({
    this.key,
    this.isNewsOfPage = false,
    this.isShop = false,
    this.isPopular = false,
  });

  final Key? key;

  final bool isNewsOfPage;

  final bool isShop;

  final bool isPopular;

  @override
  String toString() {
    return 'RecommendedThreeRouteArgs{key: $key, isNewsOfPage: $isNewsOfPage, isShop: $isShop, isPopular: $isPopular}';
  }
}

/// generated route for
/// [RecommendedTwoPage]
class RecommendedTwoRoute extends PageRouteInfo<RecommendedTwoRouteArgs> {
  RecommendedTwoRoute({
    Key? key,
    bool isNewsOfPage = false,
    bool isShop = false,
    bool isPopular = false,
    List<PageRouteInfo>? children,
  }) : super(
          RecommendedTwoRoute.name,
          args: RecommendedTwoRouteArgs(
            key: key,
            isNewsOfPage: isNewsOfPage,
            isShop: isShop,
            isPopular: isPopular,
          ),
          initialChildren: children,
        );

  static const String name = 'RecommendedTwoRoute';

  static const PageInfo<RecommendedTwoRouteArgs> page =
      PageInfo<RecommendedTwoRouteArgs>(name);
}

class RecommendedTwoRouteArgs {
  const RecommendedTwoRouteArgs({
    this.key,
    this.isNewsOfPage = false,
    this.isShop = false,
    this.isPopular = false,
  });

  final Key? key;

  final bool isNewsOfPage;

  final bool isShop;

  final bool isPopular;

  @override
  String toString() {
    return 'RecommendedTwoRouteArgs{key: $key, isNewsOfPage: $isNewsOfPage, isShop: $isShop, isPopular: $isPopular}';
  }
}

/// generated route for
/// [RegisterConfirmationPage]
class RegisterConfirmationRoute
    extends PageRouteInfo<RegisterConfirmationRouteArgs> {
  RegisterConfirmationRoute({
    Key? key,
    required UserModel userModel,
    bool isResetPassword = false,
    required String verificationId,
    bool editPhone = false,
    List<PageRouteInfo>? children,
  }) : super(
          RegisterConfirmationRoute.name,
          args: RegisterConfirmationRouteArgs(
            key: key,
            userModel: userModel,
            isResetPassword: isResetPassword,
            verificationId: verificationId,
            editPhone: editPhone,
          ),
          initialChildren: children,
        );

  static const String name = 'RegisterConfirmationRoute';

  static const PageInfo<RegisterConfirmationRouteArgs> page =
      PageInfo<RegisterConfirmationRouteArgs>(name);
}

class RegisterConfirmationRouteArgs {
  const RegisterConfirmationRouteArgs({
    this.key,
    required this.userModel,
    this.isResetPassword = false,
    required this.verificationId,
    this.editPhone = false,
  });

  final Key? key;

  final UserModel userModel;

  final bool isResetPassword;

  final String verificationId;

  final bool editPhone;

  @override
  String toString() {
    return 'RegisterConfirmationRouteArgs{key: $key, userModel: $userModel, isResetPassword: $isResetPassword, verificationId: $verificationId, editPhone: $editPhone}';
  }
}

/// generated route for
/// [RegisterPage]
class RegisterRoute extends PageRouteInfo<RegisterRouteArgs> {
  RegisterRoute({
    Key? key,
    required bool isOnlyEmail,
    List<PageRouteInfo>? children,
  }) : super(
          RegisterRoute.name,
          args: RegisterRouteArgs(
            key: key,
            isOnlyEmail: isOnlyEmail,
          ),
          initialChildren: children,
        );

  static const String name = 'RegisterRoute';

  static const PageInfo<RegisterRouteArgs> page =
      PageInfo<RegisterRouteArgs>(name);
}

class RegisterRouteArgs {
  const RegisterRouteArgs({
    this.key,
    required this.isOnlyEmail,
  });

  final Key? key;

  final bool isOnlyEmail;

  @override
  String toString() {
    return 'RegisterRouteArgs{key: $key, isOnlyEmail: $isOnlyEmail}';
  }
}

/// generated route for
/// [ResetPasswordPage]
class ResetPasswordRoute extends PageRouteInfo<void> {
  const ResetPasswordRoute({List<PageRouteInfo>? children})
      : super(
          ResetPasswordRoute.name,
          initialChildren: children,
        );

  static const String name = 'ResetPasswordRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ResultFilterPage]
class ResultFilterRoute extends PageRouteInfo<ResultFilterRouteArgs> {
  ResultFilterRoute({
    Key? key,
    required int categoryId,
    List<PageRouteInfo>? children,
  }) : super(
          ResultFilterRoute.name,
          args: ResultFilterRouteArgs(
            key: key,
            categoryId: categoryId,
          ),
          initialChildren: children,
        );

  static const String name = 'ResultFilterRoute';

  static const PageInfo<ResultFilterRouteArgs> page =
      PageInfo<ResultFilterRouteArgs>(name);
}

class ResultFilterRouteArgs {
  const ResultFilterRouteArgs({
    this.key,
    required this.categoryId,
  });

  final Key? key;

  final int categoryId;

  @override
  String toString() {
    return 'ResultFilterRouteArgs{key: $key, categoryId: $categoryId}';
  }
}

/// generated route for
/// [SearchPage]
class SearchRoute extends PageRouteInfo<SearchRouteArgs> {
  SearchRoute({
    Key? key,
    bool isBackButton = true,
    List<PageRouteInfo>? children,
  }) : super(
          SearchRoute.name,
          args: SearchRouteArgs(
            key: key,
            isBackButton: isBackButton,
          ),
          initialChildren: children,
        );

  static const String name = 'SearchRoute';

  static const PageInfo<SearchRouteArgs> page = PageInfo<SearchRouteArgs>(name);
}

class SearchRouteArgs {
  const SearchRouteArgs({
    this.key,
    this.isBackButton = true,
  });

  final Key? key;

  final bool isBackButton;

  @override
  String toString() {
    return 'SearchRouteArgs{key: $key, isBackButton: $isBackButton}';
  }
}

/// generated route for
/// [ServiceTwoCategoryPage]
class ServiceTwoCategoryRoute
    extends PageRouteInfo<ServiceTwoCategoryRouteArgs> {
  ServiceTwoCategoryRoute({
    Key? key,
    required int index,
    List<PageRouteInfo>? children,
  }) : super(
          ServiceTwoCategoryRoute.name,
          args: ServiceTwoCategoryRouteArgs(
            key: key,
            index: index,
          ),
          initialChildren: children,
        );

  static const String name = 'ServiceTwoCategoryRoute';

  static const PageInfo<ServiceTwoCategoryRouteArgs> page =
      PageInfo<ServiceTwoCategoryRouteArgs>(name);
}

class ServiceTwoCategoryRouteArgs {
  const ServiceTwoCategoryRouteArgs({
    this.key,
    required this.index,
  });

  final Key? key;

  final int index;

  @override
  String toString() {
    return 'ServiceTwoCategoryRouteArgs{key: $key, index: $index}';
  }
}

/// generated route for
/// [SettingPage]
class SettingRoute extends PageRouteInfo<void> {
  const SettingRoute({List<PageRouteInfo>? children})
      : super(
          SettingRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ShareReferralFaqPage]
class ShareReferralFaqRoute extends PageRouteInfo<ShareReferralFaqRouteArgs> {
  ShareReferralFaqRoute({
    Key? key,
    required String terms,
    List<PageRouteInfo>? children,
  }) : super(
          ShareReferralFaqRoute.name,
          args: ShareReferralFaqRouteArgs(
            key: key,
            terms: terms,
          ),
          initialChildren: children,
        );

  static const String name = 'ShareReferralFaqRoute';

  static const PageInfo<ShareReferralFaqRouteArgs> page =
      PageInfo<ShareReferralFaqRouteArgs>(name);
}

class ShareReferralFaqRouteArgs {
  const ShareReferralFaqRouteArgs({
    this.key,
    required this.terms,
  });

  final Key? key;

  final String terms;

  @override
  String toString() {
    return 'ShareReferralFaqRouteArgs{key: $key, terms: $terms}';
  }
}

/// generated route for
/// [ShareReferralPage]
class ShareReferralRoute extends PageRouteInfo<void> {
  const ShareReferralRoute({List<PageRouteInfo>? children})
      : super(
          ShareReferralRoute.name,
          initialChildren: children,
        );

  static const String name = 'ShareReferralRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ShopDetailPage]
class ShopDetailRoute extends PageRouteInfo<ShopDetailRouteArgs> {
  ShopDetailRoute({
    Key? key,
    required ShopData shop,
    required String workTime,
    List<PageRouteInfo>? children,
  }) : super(
          ShopDetailRoute.name,
          args: ShopDetailRouteArgs(
            key: key,
            shop: shop,
            workTime: workTime,
          ),
          initialChildren: children,
        );

  static const String name = 'ShopDetailRoute';

  static const PageInfo<ShopDetailRouteArgs> page =
      PageInfo<ShopDetailRouteArgs>(name);
}

class ShopDetailRouteArgs {
  const ShopDetailRouteArgs({
    this.key,
    required this.shop,
    required this.workTime,
  });

  final Key? key;

  final ShopData shop;

  final String workTime;

  @override
  String toString() {
    return 'ShopDetailRouteArgs{key: $key, shop: $shop, workTime: $workTime}';
  }
}

/// generated route for
/// [ShopPage]
class ShopRoute extends PageRouteInfo<ShopRouteArgs> {
  ShopRoute({
    Key? key,
    required String shopId,
    String? productId,
    String? cartId,
    ShopData? shop,
    int? ownerId,
    List<PageRouteInfo>? children,
  }) : super(
          ShopRoute.name,
          args: ShopRouteArgs(
            key: key,
            shopId: shopId,
            productId: productId,
            cartId: cartId,
            shop: shop,
            ownerId: ownerId,
          ),
          initialChildren: children,
        );

  static const String name = 'ShopRoute';

  static const PageInfo<ShopRouteArgs> page = PageInfo<ShopRouteArgs>(name);
}

class ShopRouteArgs {
  const ShopRouteArgs({
    this.key,
    required this.shopId,
    this.productId,
    this.cartId,
    this.shop,
    this.ownerId,
  });

  final Key? key;

  final String shopId;

  final String? productId;

  final String? cartId;

  final ShopData? shop;

  final int? ownerId;

  @override
  String toString() {
    return 'ShopRouteArgs{key: $key, shopId: $shopId, productId: $productId, cartId: $cartId, shop: $shop, ownerId: $ownerId}';
  }
}

/// generated route for
/// [ShopsBannerPage]
class ShopsBannerRoute extends PageRouteInfo<ShopsBannerRouteArgs> {
  ShopsBannerRoute({
    Key? key,
    required int bannerId,
    required String title,
    bool isAds = false,
    List<PageRouteInfo>? children,
  }) : super(
          ShopsBannerRoute.name,
          args: ShopsBannerRouteArgs(
            key: key,
            bannerId: bannerId,
            title: title,
            isAds: isAds,
          ),
          initialChildren: children,
        );

  static const String name = 'ShopsBannerRoute';

  static const PageInfo<ShopsBannerRouteArgs> page =
      PageInfo<ShopsBannerRouteArgs>(name);
}

class ShopsBannerRouteArgs {
  const ShopsBannerRouteArgs({
    this.key,
    required this.bannerId,
    required this.title,
    this.isAds = false,
  });

  final Key? key;

  final int bannerId;

  final String title;

  final bool isAds;

  @override
  String toString() {
    return 'ShopsBannerRouteArgs{key: $key, bannerId: $bannerId, title: $title, isAds: $isAds}';
  }
}

/// generated route for
/// [SplashPage]
class SplashRoute extends PageRouteInfo<void> {
  const SplashRoute({List<PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [StoryListPage]
class StoryListRoute extends PageRouteInfo<StoryListRouteArgs> {
  StoryListRoute({
    Key? key,
    required int index,
    required RefreshController controller,
    List<PageRouteInfo>? children,
  }) : super(
          StoryListRoute.name,
          args: StoryListRouteArgs(
            key: key,
            index: index,
            controller: controller,
          ),
          initialChildren: children,
        );

  static const String name = 'StoryListRoute';

  static const PageInfo<StoryListRouteArgs> page =
      PageInfo<StoryListRouteArgs>(name);
}

class StoryListRouteArgs {
  const StoryListRouteArgs({
    this.key,
    required this.index,
    required this.controller,
  });

  final Key? key;

  final int index;

  final RefreshController controller;

  @override
  String toString() {
    return 'StoryListRouteArgs{key: $key, index: $index, controller: $controller}';
  }
}

/// generated route for
/// [SubCategoryPage]
class SubCategoryRoute extends PageRouteInfo<SubCategoryRouteArgs> {
  SubCategoryRoute({
    Key? key,
    required CategoryData? category,
    required String shopId,
    required String? cartId,
    List<PageRouteInfo>? children,
  }) : super(
          SubCategoryRoute.name,
          args: SubCategoryRouteArgs(
            key: key,
            category: category,
            shopId: shopId,
            cartId: cartId,
          ),
          initialChildren: children,
        );

  static const String name = 'SubCategoryRoute';

  static const PageInfo<SubCategoryRouteArgs> page =
      PageInfo<SubCategoryRouteArgs>(name);
}

class SubCategoryRouteArgs {
  const SubCategoryRouteArgs({
    this.key,
    required this.category,
    required this.shopId,
    required this.cartId,
  });

  final Key? key;

  final CategoryData? category;

  final String shopId;

  final String? cartId;

  @override
  String toString() {
    return 'SubCategoryRouteArgs{key: $key, category: $category, shopId: $shopId, cartId: $cartId}';
  }
}

/// generated route for
/// [UiTypePage]
class UiTypeRoute extends PageRouteInfo<UiTypeRouteArgs> {
  UiTypeRoute({
    Key? key,
    bool isBack = false,
    List<PageRouteInfo>? children,
  }) : super(
          UiTypeRoute.name,
          args: UiTypeRouteArgs(
            key: key,
            isBack: isBack,
          ),
          initialChildren: children,
        );

  static const String name = 'UiTypeRoute';

  static const PageInfo<UiTypeRouteArgs> page = PageInfo<UiTypeRouteArgs>(name);
}

class UiTypeRouteArgs {
  const UiTypeRouteArgs({
    this.key,
    this.isBack = false,
  });

  final Key? key;

  final bool isBack;

  @override
  String toString() {
    return 'UiTypeRouteArgs{key: $key, isBack: $isBack}';
  }
}

/// generated route for
/// [ViewMapPage]
class ViewMapRoute extends PageRouteInfo<ViewMapRouteArgs> {
  ViewMapRoute({
    Key? key,
    bool isParcel = false,
    bool isPop = true,
    bool isShopLocation = false,
    int? shopId,
    int? indexAddress,
    AddressNewModel? address,
    List<PageRouteInfo>? children,
  }) : super(
          ViewMapRoute.name,
          args: ViewMapRouteArgs(
            key: key,
            isParcel: isParcel,
            isPop: isPop,
            isShopLocation: isShopLocation,
            shopId: shopId,
            indexAddress: indexAddress,
            address: address,
          ),
          initialChildren: children,
        );

  static const String name = 'ViewMapRoute';

  static const PageInfo<ViewMapRouteArgs> page =
      PageInfo<ViewMapRouteArgs>(name);
}

class ViewMapRouteArgs {
  const ViewMapRouteArgs({
    this.key,
    this.isParcel = false,
    this.isPop = true,
    this.isShopLocation = false,
    this.shopId,
    this.indexAddress,
    this.address,
  });

  final Key? key;

  final bool isParcel;

  final bool isPop;

  final bool isShopLocation;

  final int? shopId;

  final int? indexAddress;

  final AddressNewModel? address;

  @override
  String toString() {
    return 'ViewMapRouteArgs{key: $key, isParcel: $isParcel, isPop: $isPop, isShopLocation: $isShopLocation, shopId: $shopId, indexAddress: $indexAddress, address: $address}';
  }
}

/// generated route for
/// [WalletHistoryPage]
class WalletHistoryRoute extends PageRouteInfo<void> {
  const WalletHistoryRoute({List<PageRouteInfo>? children})
      : super(
          WalletHistoryRoute.name,
          initialChildren: children,
        );

  static const String name = 'WalletHistoryRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}
