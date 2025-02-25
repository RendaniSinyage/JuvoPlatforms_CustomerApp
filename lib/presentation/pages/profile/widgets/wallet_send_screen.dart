import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodyman/domain/di/dependency_manager.dart';
import 'package:foodyman/infrastructure/services/app_helpers.dart';
import 'package:foodyman/infrastructure/services/local_storage.dart';
import 'package:foodyman/infrastructure/services/tr_keys.dart';
import 'package:foodyman/infrastructure/models/data/user.dart';
import 'package:foodyman/infrastructure/services/app_validators.dart';
import 'package:foodyman/presentation/components/keyboard_dismisser.dart';
import 'package:foodyman/presentation/components/title_icon.dart';
import 'package:foodyman/presentation/theme/theme.dart';

// Provider for search results
final userSearchProvider = StateProvider<List<UserModel>>((ref) => []);
final selectedUserProvider = StateProvider<UserModel?>((ref) => null);

class WalletSendScreen extends ConsumerStatefulWidget {
  const WalletSendScreen({super.key});

  @override
  ConsumerState<WalletSendScreen> createState() => _WalletSendScreenState();
}

class _WalletSendScreenState extends ConsumerState<WalletSendScreen> {
  final _searchController = TextEditingController();
  final _amountController = TextEditingController();
  final _debouncer = Debouncer(milliseconds: 500);

  bool _isLoading = false;
  bool _isSearching = false;
  bool _searchComplete = false;

  @override
  void dispose() {
    _searchController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _searchUser(String query) async {
    // Clear previous search results when input is cleared
    if (query.isEmpty) {
      ref.read(userSearchProvider.notifier).state = [];
      ref.read(selectedUserProvider.notifier).state = null;
      setState(() {
        _searchComplete = false;
      });
      return;
    }

    // Check if the input is a valid complete email or phone
    bool isValidInput = false;

    // Email validation
    if (query.contains('@') && AppValidators.isValidEmail(query)) {
      isValidInput = true;
    }
    // Phone validation (starts with 0 + 9 more digits = 10 total)
    else if (query.startsWith('0') && query.length == 10 && RegExp(r'^\d+$').hasMatch(query)) {
      isValidInput = true;
    }
    // Phone with country code (starts with + or just the country code) + 9 digits
    else if ((query.startsWith('+') || RegExp(r'^\d+$').hasMatch(query)) &&
        (query.startsWith('+') ? query.length >= 11 : query.length >= 10)) {
      // For +XX format or XX format followed by 9 digits
      if ((query.startsWith('+') && query.length >= 11) ||
          (!query.startsWith('+') && query.length >= 10)) {
        isValidInput = true;
      }
    }

    // Only proceed with search if we have a valid complete input
    if (!isValidInput) {
      // Update UI to show waiting for complete input
      setState(() {
        _searchComplete = false;
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    try {
      final result = await walletRepository.searchSending({
        'search': query,
      });

      result.when(
        success: (data) {
          ref.read(userSearchProvider.notifier).state = data;
          setState(() {
            _searchComplete = true;
          });
        },
        failure: (error, statusCode) {
          AppHelpers.showCheckTopSnackBarInfo(
            context,
            error,
          );
          ref.read(userSearchProvider.notifier).state = [];
        },
      );
    } catch (e) {
      AppHelpers.showCheckTopSnackBarInfo(
        context,
        'Failed to search users',
      );
      ref.read(userSearchProvider.notifier).state = [];
    } finally {
      setState(() {
        _isSearching = false;
      });
    }
  }

  void _navigateBack() {
    Navigator.of(context).pop();
  }

  Future<void> _sendWalletBalance() async {
    final selectedUser = ref.read(selectedUserProvider);
    if (selectedUser == null) {
      AppHelpers.showCheckTopSnackBarInfo(
        context,
        AppHelpers.getTranslation(TrKeys.pleaseSelectRecipient),
      );
      return;
    }

    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      AppHelpers.showCheckTopSnackBarInfo(
        context,
        AppHelpers.getTranslation(TrKeys.pleaseEnterValidAmount),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await walletRepository.sendWalletBalance(
        selectedUser.uuid!,
        amount,
      );

      setState(() {
        _isLoading = false;
      });

      result.when(
        success: (data) {
          AppHelpers.showCheckTopSnackBarDone(
            context,
            AppHelpers.getTranslation(TrKeys.moneySentSuccessfully),
          );
          _navigateBack();
        },
        failure: (error, statusCode) {
          AppHelpers.showCheckTopSnackBarInfo(
            context,
            error,
          );
        },
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      AppHelpers.showCheckTopSnackBarInfo(
        context,
        'Failed to send money',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isLtr = LocalStorage.getLangLtr();
    final searchResults = ref.watch(userSearchProvider);
    final selectedUser = ref.watch(selectedUserProvider);

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
            height: MediaQuery.of(context).size.height * 0.7,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  8.verticalSpace,
                  Center(
                    child: Container(
                      height: 4.h,
                      width: 48.w,
                      decoration: BoxDecoration(
                        color: AppStyle.dragElement,
                        borderRadius: BorderRadius.all(Radius.circular(40.r)),
                      ),
                    ),
                  ),
                  24.verticalSpace,
                  TitleAndIcon(
                    title: AppHelpers.getTranslation(TrKeys.sendMoney),
                    paddingHorizontalSize: 0,
                    titleSize: 18,
                  ),
                  24.verticalSpace,
                  Text(
                    AppHelpers.getTranslation(TrKeys.searchRecipient),
                    style: AppStyle.interSemi(size: 16.sp),
                  ),
                  16.verticalSpace,
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: AppHelpers.getTranslation(TrKeys.searchByPhoneOrEmail),
                      prefixIcon: const Icon(Icons.search, color: AppStyle.textGrey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: const BorderSide(color: AppStyle.borderColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: BorderSide(color: AppStyle.primary),
                      ),
                    ),
                    onChanged: (value) {
                      _debouncer.run(() {
                        _searchUser(value);
                      });
                    },
                  ),
                  16.verticalSpace,
                  // Search Results or Loading Indicator
                  if (_isSearching)
                    Center(child: CircularProgressIndicator(color: AppStyle.primary))
                  else if (selectedUser != null)
                    _buildSelectedUser(selectedUser)
                  else if (_searchComplete && searchResults.isEmpty)
                      Center(
                        child: Text(
                          AppHelpers.getTranslation(TrKeys.noUsersFound),
                          style: AppStyle.interNormal(color: AppStyle.textGrey),
                        ),
                      )
                    else if (searchResults.isNotEmpty)
                        _buildSearchResults(searchResults),

                  // Amount Input and Send Button (only shown when a user is selected)
                  if (selectedUser != null) ...[
                    24.verticalSpace,
                    Text(
                      AppHelpers.getTranslation(TrKeys.enterAmount),
                      style: AppStyle.interSemi(size: 16.sp),
                    ),
                    16.verticalSpace,
                    TextField(
                      controller: _amountController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        hintText: '0.00',
                        prefixIcon: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          child: Text(
                            'R',
                            style: AppStyle.interBold(size: 18.sp),
                          ),
                        ),
                        prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: const BorderSide(color: AppStyle.borderColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: BorderSide(color: AppStyle.primary),
                        ),
                      ),
                    ),
                    36.verticalSpace,
                    ElevatedButton(
                      onPressed: _sendWalletBalance,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppStyle.primary,
                        minimumSize: Size(double.infinity, 50.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: _isLoading
                          ? CircularProgressIndicator(color: AppStyle.white)
                          : Text(
                        AppHelpers.getTranslation(TrKeys.sendNow),
                        style: AppStyle.interSemi(
                          size: 16.sp,
                          color: AppStyle.white,
                        ),
                      ),
                    ),
                  ],
                  24.verticalSpace,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchResults(List<UserModel> users) {
    return Container(
      decoration: BoxDecoration(
        color: AppStyle.white,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: AppStyle.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: users.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final user = users[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: AppStyle.primary.withOpacity(0.1),
              backgroundImage: user.img != null ? NetworkImage(user.img!) : null,
              child: user.img == null
                  ? Text(
                user.firstname?.substring(0, 1).toUpperCase() ?? '',
                style: AppStyle.interBold(color: AppStyle.primary),
              )
                  : null,
            ),
            title: Text(
              '${user.firstname} ${user.lastname}',
              style: AppStyle.interSemi(size: 14.sp),
            ),
            subtitle: Text(
              user.email ?? user.phone ?? '',
              style: AppStyle.interNormal(size: 12.sp, color: AppStyle.textGrey),
            ),
            onTap: () {
              ref.read(selectedUserProvider.notifier).state = user;
              _searchController.text = '${user.firstname} ${user.lastname}';
            },
          );
        },
      ),
    );
  }

  Widget _buildSelectedUser(UserModel user) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppStyle.white,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: AppStyle.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppStyle.primary.withOpacity(0.1),
            backgroundImage: user.img != null ? NetworkImage(user.img!) : null,
            radius: 20.r,
            child: user.img == null
                ? Text(
              user.firstname?.substring(0, 1).toUpperCase() ?? '',
              style: AppStyle.interBold(color: AppStyle.primary),
            )
                : null,
          ),
          16.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${user.firstname} ${user.lastname}',
                  style: AppStyle.interSemi(size: 16.sp),
                ),
                4.verticalSpace,
                Text(
                  user.email ?? user.phone ?? '',
                  style: AppStyle.interNormal(size: 14.sp, color: AppStyle.textGrey),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: AppStyle.red),
            onPressed: () {
              ref.read(selectedUserProvider.notifier).state = null;
              _searchController.clear();
            },
          ),
        ],
      ),
    );
  }
}

// Debouncer class for search input
class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}