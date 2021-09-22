import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/ui/screens/home/widgets/item_home_user_lib.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class HomeUserLibrary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: EdgeInsets.only(left: AppMargin.margin_16),
          child: Text(
            "Good Morning",
            style: TextStyle(
              color: Colors.white,
              fontSize: AppFontSizes.font_size_16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: AppMargin.margin_16,
            right: AppMargin.margin_16,
          ),
          child: GridView.count(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: NeverScrollableScrollPhysics(),
            childAspectRatio: (3.3 / 1),
            crossAxisSpacing: AppMargin.margin_8,
            mainAxisSpacing: AppMargin.margin_8,
            crossAxisCount: 2,
            children: [
              ItemHomeUserLib(
                text: "ኪዳስ",
                type: "Category",
                imageUrl:
                    '${AppApi.baseFileUrl}/LatinCross-631151317-5a22dd90beba330037d3cecb.jpg',
              ),
              ItemHomeUserLib(
                text: "በገና",
                type: "Playlist",
                imageUrl:
                    '${AppApi.baseFileUrl}/LatinCross-631151317-5a22dd90beba330037d3cecb_DJ5BoQ9.jpg',
              ),
              ItemHomeUserLib(
                text: "New Artists",
                type: "Playlist",
                imageUrl: '${AppApi.baseFileUrl}/Cherenet_Senay_YT3ky6K.jpg',
              ),
              ItemHomeUserLib(
                text: "መዝሙር",
                type: "Song",
                imageUrl:
                    '${AppApi.baseFileUrl}/Top_Tracks_Ethiopian_Orthodox_Tewahedo_dByUU8Q.jpg',
              ),
              ItemHomeUserLib(
                text: "ሐና ካም",
                type: "Artist",
                imageUrl: '${AppApi.baseFileUrl}/Tsedale_XpfCO13.jpg',
              ),
              ItemHomeUserLib(
                text: "ፌቨን ሎጣን",
                type: "Artist",
                imageUrl: '${AppApi.baseFileUrl}/Habtamu_Shibru_7IxFPYD.jpg',
              ),
            ],
          ),
        )
      ],
    );
  }
}
