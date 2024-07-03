// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:riverpodtemp/infrastructure/models/models.dart';
import 'package:riverpodtemp/infrastructure/services/app_helpers.dart';
import 'package:riverpodtemp/infrastructure/services/tr_keys.dart';
import 'package:riverpodtemp/presentation/components/custom_network_image.dart';
import 'package:riverpodtemp/presentation/components/title_icon.dart';
import 'package:riverpodtemp/presentation/pages/home/widgets/banner_screen.dart';

class CustomGridTile {
  CustomGridTile(this.crossAxisCount, this.mainAxisCount, {this.banner});

  BannerData? banner;
  final int crossAxisCount;
  final int mainAxisCount;

  copyWith({BannerData? banner}) {
    return CustomGridTile(crossAxisCount, mainAxisCount,
        banner: banner ?? BannerData());
  }
}

List<CustomGridTile> tiles = [
  CustomGridTile(12, 7),
  CustomGridTile(6, 8),
  CustomGridTile(6, 7),
  CustomGridTile(6, 7),
  CustomGridTile(6, 6),
  CustomGridTile(12, 6),
];

class ExploreThree extends StatefulWidget {
  final List<BannerData> list;

  const ExploreThree({super.key, required this.list});

  @override
  State<ExploreThree> createState() => _ExploreThreeState();
}

class _ExploreThreeState extends State<ExploreThree> {
  @override
  void initState() {
    for (int i = 0; i < widget.list.length; i++) {
      tiles[i] = tiles[i].copyWith(banner: widget.list[i]);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if(widget.list.isNotEmpty)
          TitleAndIcon(title: AppHelpers.getTranslation(TrKeys.explore)),
        Padding(
          padding: REdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: StaggeredGrid.count(
            crossAxisCount: 12,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            children: [
              ...widget.list.mapIndexed((index, tile) {
                return StaggeredGridTile.count(
                  crossAxisCellCount: tiles[index].crossAxisCount,
                  mainAxisCellCount: tiles[index].mainAxisCount,
                  child: InkWell(
                    onTap: (){
                      AppHelpers.showCustomModalBottomSheet(
                          context: context,
                          modal: BannerScreen(
                            isAds: true,
                            bannerId:widget.list[index].id ?? 0,
                            image: widget.list[index].img ?? "",
                            desc: widget.list[index].translation?.description ?? "",
                            list: widget.list[index].shops ?? [],
                          ),
                          isDarkMode: false);
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CustomNetworkImage(
                        url: widget.list[index].img ?? "",
                        height: double.infinity,
                        width: double.infinity,
                        radius: 16,
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}
