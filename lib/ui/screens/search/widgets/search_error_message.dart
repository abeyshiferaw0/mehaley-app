import 'package:elf_play/business_logic/blocs/search_page_bloc/search_result_bloc/search_result_bloc.dart';
import 'package:elf_play/business_logic/cubits/search_cancel_cubit.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/ui/common/app_bouncing_button.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchErrorMessage extends StatelessWidget {
  const SearchErrorMessage({required this.searchKey});

  final String searchKey;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Something went wrong",
              style: TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.bold,
                fontSize: AppFontSizes.font_size_10.sp,
              ),
            ),
            SizedBox(
              height: AppMargin.margin_8,
            ),
            Text(
              "Check your internet Connection",
              style: TextStyle(
                color: AppColors.lightGrey,
                fontSize: AppFontSizes.font_size_8.sp,
              ),
            ),
            SizedBox(
              height: AppMargin.margin_16,
            ),
            AppBouncingButton(
              onTap: () {
                if (searchKey.isEmpty || key == '') {
                  BlocProvider.of<SearchCancelCubit>(context)
                      .changeSearchingState(cancelSearchingView: true);
                } else {
                  BlocProvider.of<SearchResultBloc>(context).add(
                    LoadSearchResultEvent(key: searchKey),
                  );
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppPadding.padding_32,
                  vertical: AppPadding.padding_8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(120),
                ),
                child: Text(
                  "Try Again",
                  style: TextStyle(
                    color: AppColors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: AppFontSizes.font_size_10.sp,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
