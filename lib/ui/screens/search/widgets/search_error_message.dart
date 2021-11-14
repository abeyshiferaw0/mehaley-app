import 'package:elf_play/app_language/app_locale.dart';
import 'package:elf_play/business_logic/blocs/search_page_bloc/search_result_bloc/search_result_bloc.dart';
import 'package:elf_play/business_logic/cubits/search_cancel_cubit.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/ui/common/app_bouncing_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

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
              AppLocale.of().somethingWentWrong,
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
              AppLocale.of().checkYourInternetConnection,
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
                  AppLocale.of().tryAgain,
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
