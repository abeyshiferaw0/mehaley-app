import 'package:cached_network_image/cached_network_image.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';

class SignUpPageStaggeredAnimatedList extends StatefulWidget {
  const SignUpPageStaggeredAnimatedList({Key? key}) : super(key: key);

  @override
  _SignUpPageStaggeredAnimatedListState createState() =>
      _SignUpPageStaggeredAnimatedListState();
}

class _SignUpPageStaggeredAnimatedListState
    extends State<SignUpPageStaggeredAnimatedList> {
  ScrollController scrollController = ScrollController();

  List<String> imageUrls = [
    'https://images.unsplash.com/photo-1599386918765-917d878d3304?ixid=MnwxMjA3fDB8MHxzZWFyY2h8NXx8ZXRoaW9waWFufGVufDB8fDB8fA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
    'https://images.unsplash.com/photo-1612937373987-b1b7db233867?ixid=MnwxMjA3fDB8MHxzZWFyY2h8Nnx8ZXRoaW9waWFufGVufDB8fDB8fA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
    'https://images.unsplash.com/photo-1612937373987-b1b7db233867?ixid=MnwxMjA3fDB8MHxzZWFyY2h8Nnx8ZXRoaW9waWFufGVufDB8fDB8fA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
    'https://images.unsplash.com/photo-1625268448699-8fdb2073a94c?ixid=MnwxMjA3fDB8MHxzZWFyY2h8Nnx8ZXRoaW9waWFuJTIwb3J0b2RveHxlbnwwfHwwfHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
    'https://pbs.twimg.com/media/ENqiwFMWsAIENaQ.jpg',
    'https://m.psecn.photoshelter.com/img-get2/I00004kO4aPjhTdU/fit=1000x750/7487-2a.jpg',
    'https://photos.lensculture.com/large/653a1a6f-ac81-425f-84bd-6f7207aaabfd.jpg',
    'https://render.fineartamerica.com/images/rendered/search/poster/5.5/8/break/images/artworkimages/medium/1/orthodox-ethiopian-priest-five-dominyk-lever.jpg',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTSv1jYqt1McCFCAOcwYv0ilp0n1U0JVvCDHQ&usqp=CAU',
  ];

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      scrollImageGrid(scrollController.position.maxScrollExtent);
    });
    // Setup the listener.
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels ==
            scrollController.position.minScrollExtent) {
          Future.delayed(Duration(seconds: 2), () {
            scrollImageGrid(scrollController.position.maxScrollExtent);
          });
        } else {
          Future.delayed(Duration(seconds: 2), () {
            scrollImageGrid(0.0);
          });
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StaggeredGridView.countBuilder(
        crossAxisCount: 4,
        itemCount: 9 * 3,
        controller: scrollController,
        itemBuilder: (BuildContext context, int index) => buildGridCell(index),
        staggeredTileBuilder: (int index) => new StaggeredTile.count(
          1,
          index.isEven ? 1.8 : 1.5,
        ),
        mainAxisSpacing: AppPadding.padding_20,
        crossAxisSpacing: AppPadding.padding_20,
      ),
    );
  }

  Opacity buildGridCell(int index) {
    List<String> images = [];
    images.addAll(imageUrls);
    images.addAll(imageUrls);
    images.addAll(imageUrls);
    return Opacity(
      opacity: 0.8,
      child: Container(
        color: Colors.green,
        child: CachedNetworkImage(
            fit: BoxFit.cover,
            imageUrl: images[index],
            fadeInDuration: Duration(milliseconds: 600),
            placeholder: (context, url) => buildGridImagePlaceholder(),
            errorWidget: (context, url, error) => buildGridImagePlaceholder()),
      ),
    );
  }

  Container buildGridImagePlaceholder() {
    return Container(
      color: AppColors.darkGrey,
      child: Center(
        child: SvgPicture.asset(
          'assets/icons/ic_app.svg',
          width: AppIconSizes.icon_size_24,
          color: AppColors.grey,
        ),
      ),
    );
  }

  scrollImageGrid(double scrollExtent) {
    scrollController.animateTo(
      scrollExtent,
      duration: Duration(seconds: 15),
      curve: Curves.linear,
    );
  }
}
