import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodyman/application/profile/profile_provider.dart';
import 'package:foodyman/infrastructure/services/app_helpers.dart';
import 'package:foodyman/infrastructure/services/local_storage.dart';
import 'package:foodyman/infrastructure/services/tr_keys.dart';
import 'package:foodyman/infrastructure/models/data/user.dart';
import 'package:foodyman/presentation/theme/theme.dart';

//@routePage()
class WelcomeText extends StatelessWidget {
  const WelcomeText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firstName = LocalStorage.getUser()?.firstname;
    final lastName = LocalStorage.getUser()?.lastname;
    String greetingText = '';
    String signedText = '';

    if (firstName!.isNotEmpty && lastName!.isNotEmpty) {
      greetingText =
          '${AppHelpers.getTranslation(TrKeys.hello)} \u{1F44B}\n$firstName'; //\n$lastName';
      signedText = AppHelpers.getTranslation(TrKeys.signedtext);
    } else {
      greetingText =
          '${AppHelpers.getTranslation(TrKeys.hey)} \u{1F44B}\n${AppHelpers.getTranslation(TrKeys.there)}';
      signedText = AppHelpers.getTranslation(TrKeys.signtext);
    }

    // Split the signedText into words
    List<String> words = signedText.split(' ');

    // Add line breaks after the fifth word
    String formattedSignedText = '';
    for (int i = 0; i < words.length; i++) {
      formattedSignedText += words[i];
      if ((i + 1) % 4 == 0 && i != words.length - 1) {
        formattedSignedText += '\n';
      } else {
        formattedSignedText += ' ';
      }
    }

    return Container(
      color: AppStyle.white,
      padding: const EdgeInsets.all(16.0),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            bottom: 0,
            child: Image.asset(
              'assets/images/order.png',
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                greetingText,
                style: AppStyle.interBold(
                  size: 32,
                  letterSpacing: -0.3,
                  color: AppStyle.black,
                ),
              ),
              Text(
                formattedSignedText,
                style: AppStyle.interNormal(
                  size: 16,
                  letterSpacing: -0.3,
                  color: AppStyle.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}