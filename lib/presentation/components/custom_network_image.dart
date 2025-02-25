import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../infrastructure/services/app_helpers.dart';
import '../theme/app_style.dart';

class CustomNetworkImage extends StatelessWidget {
  final String? url;
  final double? height;
  final double? width;
  final double radius;
  final Color? color; // New color parameter
  final Color bgColor;
  final BoxFit fit;
  final bool profile;
  final String? name;

  const CustomNetworkImage({
    Key? key,
    required this.url,
     this.height,
     this.width,
    required this.radius,
    this.fit = BoxFit.cover,
    this.color, // New color parameter
    this.bgColor = AppStyle.mainBack,
    this.profile = false, this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: color != null // Check if color is provided
          ? ColorFiltered( // Apply color filter if color is provided
              colorFilter: ColorFilter.mode(color!, BlendMode.srcIn),
              child: _buildImage(),
            )
          : _buildImage(), // Otherwise, show the original image
    );
  }

  Widget _buildImage() {
    return AppHelpers.checkIsSvg(url)
        ? SvgPicture.network(
           url ?? "",
            width: width,
            height: height,
            fit: BoxFit.cover,
            placeholderBuilder: (_) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(radius),
                color: AppStyle.shimmerBase,
              ),
            ),
          )
        : CachedNetworkImage(
            height: height,
            width: width,
            imageUrl: url ?? "",
            fit: fit,
            progressIndicatorBuilder: (context, url, progress) {
              return Container(
                height: height,
                width: width,
                decoration: BoxDecoration(
                  color: AppStyle.shimmerBase,
                ),
              );
            },
            errorWidget: (context, url, error) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(radius),
                  color: bgColor,
                 image: profile
                      ? const DecorationImage(
                          image: AssetImage("assets/images/app_logo.png"),
                        )
                      : null,
                ),
                alignment: Alignment.center,
                child: profile
                    ? const SizedBox.shrink()
                    : const Icon(
                        FlutterRemix.image_line,
                        color: AppStyle.shimmerBaseDark,
                      ),
              );
            },
          );
  }
}
