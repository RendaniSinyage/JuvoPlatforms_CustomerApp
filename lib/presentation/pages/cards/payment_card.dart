import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodyman/domain/di/dependency_manager.dart';
import 'package:foodyman/infrastructure/models/data/saved_card.dart';
import 'package:foodyman/infrastructure/services/app_helpers.dart';
import 'package:foodyman/infrastructure/services/tr_keys.dart';
import 'package:foodyman/presentation/theme/theme.dart';

import '../../components/buttons/custom_button.dart';

/// A widget for displaying, selecting, and managing saved payment cards
class SavedCardsWidget extends ConsumerStatefulWidget {
  final Function(SavedCardModel?) onCardSelected;
  final SavedCardModel? initialSelectedCard;
  final bool hideManagement;

  const SavedCardsWidget({
    super.key,
    required this.onCardSelected,
    this.initialSelectedCard,
    this.hideManagement = false,
  });

  @override
  ConsumerState<SavedCardsWidget> createState() => _SavedCardsWidgetState();
}

class _SavedCardsWidgetState extends ConsumerState<SavedCardsWidget> {
  final _repository = ordersRepository;
  bool _isLoading = true;
  bool _deletingCard = false;
  List<SavedCardModel> _savedCards = [];
  SavedCardModel? _selectedCard;

  @override
  void initState() {
    super.initState();
    _selectedCard = widget.initialSelectedCard;
    _loadSavedCards();
  }

  Future<void> _loadSavedCards() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _repository.getSavedCards();

      result.when(
        success: (cards) {
          setState(() {
            _savedCards = cards;
            _isLoading = false;

            // If there's only one card, select it automatically
            if (_savedCards.length == 1 && _selectedCard == null) {
              _selectedCard = _savedCards.first;
              widget.onCardSelected(_selectedCard);
            }
            // If we have cards but no selection, select the first one
            else if (_savedCards.isNotEmpty && _selectedCard == null) {
              _selectedCard = _savedCards.first;
              widget.onCardSelected(_selectedCard);
            }
            // If we had a selected card, make sure it still exists in the updated list
            else if (_selectedCard != null) {
              final stillExists = _savedCards.any((card) => card.id == _selectedCard!.id);
              if (!stillExists) {
                _selectedCard = _savedCards.isNotEmpty ? _savedCards.first : null;
                widget.onCardSelected(_selectedCard);
              }
            }
          });
        },
        failure: (error, statusCode) {
          setState(() {
            _isLoading = false;
          });

          AppHelpers.showCheckTopSnackBarInfo(
            context,
            'Failed to load saved cards: $error',
          );
        },
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      AppHelpers.showCheckTopSnackBarInfo(
        context,
        'Failed to load saved cards',
      );
    }
  }

  Future<void> _deleteCard(SavedCardModel card) async {
    setState(() {
      _deletingCard = true;
    });

    try {
      final result = await _repository.deleteCard(card.id);

      result.when(
        success: (success) {
          // If the deleted card was selected, prepare to select a different one
          final wasSelected = _selectedCard?.id == card.id;

          // Remove the card from our list immediately for UI feedback
          setState(() {
            _savedCards.removeWhere((c) => c.id == card.id);

            if (wasSelected) {
              // If we have other cards, select the first one
              if (_savedCards.isNotEmpty) {
                _selectedCard = _savedCards.first;
                widget.onCardSelected(_selectedCard);
              } else {
                _selectedCard = null;
                widget.onCardSelected(null);
              }
            }

            _deletingCard = false;
          });

          AppHelpers.showCheckTopSnackBarDone(
            context,
            AppHelpers.getTranslation(TrKeys.successfullyDeleted),
          );
        },
        failure: (error, statusCode) {
          setState(() {
            _deletingCard = false;
          });

          AppHelpers.showCheckTopSnackBarInfo(
            context,
            'Failed to delete card: $error',
          );
        },
      );
    } catch (e) {
      setState(() {
        _deletingCard = false;
      });

      AppHelpers.showCheckTopSnackBarInfo(
        context,
        'Failed to delete card',
      );
    }
  }

  void _confirmDeleteCard(SavedCardModel card) {
    AppHelpers.showAlertDialog(
      context: context,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppHelpers.getTranslation(TrKeys.areYouSure),
            style: AppStyle.interSemi(size: 16.sp),
            textAlign: TextAlign.center,
          ),
          24.verticalSpace,
          CustomButton(
            background: AppStyle.red,
            textColor: AppStyle.white,
            title: AppHelpers.getTranslation(TrKeys.delete),
            onPressed: () {
              Navigator.pop(context);
              _deleteCard(card);
            },
          ),
          16.verticalSpace,
          CustomButton(
            borderColor: AppStyle.black,
            background: AppStyle.transparent,
            title: AppHelpers.getTranslation(TrKeys.cancel),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator(color: AppStyle.primary));
    }

    if (_savedCards.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.credit_card_off,
              size: 48.r,
              color: AppStyle.textGrey,
            ),
            16.verticalSpace,
            Text(
              AppHelpers.getTranslation(TrKeys.noSavedCard),
              style: AppStyle.interSemi(size: 16.sp),
              textAlign: TextAlign.center,
            ),
            8.verticalSpace,
            Text(
              AppHelpers.getTranslation(TrKeys.addNewCardDescription),
              style: AppStyle.interNormal(
                size: 14.sp,
                color: AppStyle.textGrey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_savedCards.length >= 2)
        Text(
          AppHelpers.getTranslation(TrKeys.selectCard),
          style: AppStyle.interSemi(size: 16.sp),
        ),
        12.verticalSpace,

        // Cards list (vertical list instead of horizontal)
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: _savedCards.length,
          separatorBuilder: (context, index) => SizedBox(height: 12.h),
          itemBuilder: (context, index) {
            final card = _savedCards[index];
            final isSelected = _selectedCard?.id == card.id;

            return InkWell(
              onTap: () {
                setState(() {
                  _selectedCard = card;
                });
                widget.onCardSelected(_selectedCard);
              },
              borderRadius: BorderRadius.circular(12.r),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: isSelected ? AppStyle.primary.withOpacity(0.05) : AppStyle.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: isSelected ? AppStyle.primary : AppStyle.borderColor,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    // Radio button for selection indicator
                    Radio<String>(
                      value: card.id,
                      groupValue: _selectedCard?.id,
                      activeColor: AppStyle.primary,
                      onChanged: (_) {
                        setState(() {
                          _selectedCard = card;
                        });
                        widget.onCardSelected(_selectedCard);
                      },
                    ),
                    12.horizontalSpace,

                    // Card icon based on card type
                    Container(
                      height: 40.h,
                      width: 40.w,
                      decoration: BoxDecoration(
                        color: AppStyle.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Icon(
                        _getCardIcon(card.cardType),
                        color: AppStyle.primary,
                        size: 24.sp,
                      ),
                    ),
                    16.horizontalSpace,

                    // Card details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                card.cardType,
                                style: AppStyle.interSemi(size: 16.sp),
                              ),
                              8.horizontalSpace,
                              Text(
                                '•••• ${card.lastFour}',
                                style: AppStyle.interNormal(size: 14.sp),
                              ),
                            ],
                          ),
                          6.verticalSpace,
                          Text(
                            '${AppHelpers.getTranslation(TrKeys.expires)}: ${card.expiryDate}',
                            style: AppStyle.interNormal(
                              size: 12.sp,
                              color: AppStyle.textGrey,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Delete button (only show if management is not hidden)
                    if (!widget.hideManagement)
                      IconButton(
                        onPressed: () => _confirmDeleteCard(card),
                        icon: Icon(
                          Icons.close,
                          color: Colors.red.shade400,
                          size: 20.r,
                        ),
                        tooltip: AppHelpers.getTranslation(TrKeys.delete),
                      ),
                  ],
                ),
              ),
            );
          },
        ),

        if (_deletingCard) ...[
          16.verticalSpace,
          Center(
            child: CircularProgressIndicator(
              color: AppStyle.primary,
              strokeWidth: 3,
            ),
          ),
        ],
      ],
    );
  }

  IconData _getCardIcon(String cardType) {
    final type = cardType.toLowerCase();
    if (type.contains('visa')) {
      return Icons.credit_card;
    } else if (type.contains('master')) {
      return Icons.credit_card;
    } else if (type.contains('amex')) {
      return Icons.credit_card;
    } else {
      return Icons.credit_card;
    }
  }
}