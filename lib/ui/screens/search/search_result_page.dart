import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/business_logic/blocs/search_page_bloc/search_result_bloc/search_result_bloc.dart';
import 'package:mehaley/business_logic/cubits/search_cancel_cubit.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/ui/common/app_loading.dart';
import 'package:mehaley/ui/screens/search/widgets/search_empty_message.dart';
import 'package:mehaley/ui/screens/search/widgets/search_error_message.dart';
import 'package:mehaley/ui/screens/search/widgets/search_input_page_persistant_header_deligate.dart';
import 'package:mehaley/ui/screens/search/widgets/search_recent_or_message.dart';
import 'package:mehaley/ui/screens/search/widgets/search_result_list.dart';
import 'package:mehaley/util/screen_util.dart';

class SearchResultPage extends StatefulWidget {
  const SearchResultPage({Key? key, required this.isVoiceTyping})
      : super(key: key);

  final bool isVoiceTyping;

  @override
  _SearchResultPageState createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  //DOMINANT COLOR;
  Color dominantColor = AppColors.appGradientDefaultColorBlack;
  late FocusNode focusNode;

  @override
  void initState() {
    if (widget.isVoiceTyping) {
      Future.delayed(Duration(milliseconds: 300), () {
        showSpeechSearchSheet();
      });
    }
    focusNode = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.pagesBgColor,
        resizeToAvoidBottomInset: false,
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SizedBox(
                height: AppMargin.margin_16,
              ),
            ),
            buildSearchInputHeader(),
            SliverToBoxAdapter(
              child: SizedBox(
                height: AppMargin.margin_16,
              ),
            ),
            SliverToBoxAdapter(
              child: buildResultBlocBuilder(),
            ),
          ],
        ),
      ),
    );
  }

  SliverPersistentHeader buildSearchInputHeader() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: SearchInputPersistentSliverHeaderDelegate(
        focusNode: focusNode,
      ),
    );
  }

  Widget buildResultBlocBuilder() {
    return BlocBuilder<SearchCancelCubit, bool>(
      builder: (context, state) {
        if (state) {
          return SearchRecentOrMessage();
        } else {
          return BlocBuilder<SearchResultBloc, SearchResultState>(
            builder: (context, state) {
              if (state is SearchResultPageLoadedState) {
                if (state.searchPageResultData.result.length > 0) {
                  return SearchResultList(
                    searchPageResultData: state.searchPageResultData,
                    searchKey: state.key,
                    focusNode: focusNode,
                  );
                } else {
                  return SearchEmptyMessage(
                    searchKey: state.key,
                  );
                }
              }
              if (state is SearchResultPageLoadingState) {
                return AppLoading(
                  size: AppValues.loadingWidgetSize * 0.5,
                );
              }
              if (state is SearchResultPageLoadingErrorState) {
                return SearchErrorMessage(
                  searchKey: state.key,
                );
              }
              //DEBUG SHOW RECENT SEARCH IF NOT EMPTY
              return SearchRecentOrMessage();
            },
          );
        }
      },
    );
  }

  Positioned buildVoiceSearchButton() {
    return Positioned(
      right: AppMargin.margin_28,
      bottom: AppMargin.margin_28,
      child: GestureDetector(
        onTap: () {
          showSpeechSearchSheet();
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(
            AppValues.searchResultMicButtonSize,
          ),
          child: Container(
            color: AppColors.black,
            width: AppValues.searchResultMicButtonSize,
            height: AppValues.searchResultMicButtonSize,
            child: Icon(
              FlutterRemix.mic_line,
              color: AppColors.darkOrange,
              size: AppIconSizes.icon_size_32,
            ),
          ),
        ),
      ),
    );
  }

  void showSpeechSearchSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      backgroundColor: AppColors.white,
      builder: (context) {
        return Container(
          height: ScreenUtil(context: context).getScreenHeight() * 0.5,
          child: Column(
            children: [],
          ),
        );
      },
    );
  }
}
