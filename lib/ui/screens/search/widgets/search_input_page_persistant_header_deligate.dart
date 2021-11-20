import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mehaley/business_logic/blocs/search_page_bloc/search_result_bloc/search_result_bloc.dart';
import 'package:mehaley/business_logic/cubits/search_cancel_cubit.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/ui/screens/search/widgets/search_page_input.dart';

class SearchInputPersistentSliverHeaderDelegate
    extends SliverPersistentHeaderDelegate {
  final FocusNode focusNode;

  SearchInputPersistentSliverHeaderDelegate({required this.focusNode});

  @override
  Widget build(context, double shrinkOffset, bool overlapsContent) {
    return SearchPageInput(
      focusNode: focusNode,
      onSearchEmpty: () {
        //REMOVE SEARCH
        BlocProvider.of<SearchCancelCubit>(context).changeSearchingState(
          cancelSearchingView: true,
        );
      },
      onSearchQueryChange: (key) {
        //FETCH SEARCH REQUEST
        if (key != '') {
          EasyDebounce.debounce(
              AppValues.searchPageDebouncer, Duration(seconds: 1), () {
            BlocProvider.of<SearchResultBloc>(context).add(
              LoadSearchResultEvent(key: key),
            );
          });
          BlocProvider.of<SearchCancelCubit>(context).changeSearchingState(
            cancelSearchingView: false,
          );
        }
      },
    );
  }

  @override
  double get maxExtent => AppValues.searchPersistentSliverInputHeaderHeight;

  @override
  double get minExtent => AppValues.searchPersistentSliverInputHeaderHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => false;
}
