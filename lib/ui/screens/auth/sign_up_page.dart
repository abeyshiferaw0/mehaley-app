import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/app_start_bloc/app_start_bloc.dart';
import 'package:mehaley/business_logic/blocs/auth_bloc/auth_bloc.dart';
import 'package:mehaley/business_logic/cubits/app_user_widgets_cubit.dart';
import 'package:mehaley/config/app_router.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/ui/common/app_snack_bar.dart';
import 'package:mehaley/ui/common/dialog/dialog_first_time_lan_and_currency.dart';
import 'package:mehaley/ui/common/sign_up_page_authing_covor.dart';
import 'package:mehaley/ui/screens/auth/widgets/sign_up_page_front.dart';
import 'package:mehaley/ui/screens/auth/widgets/sign_up_page_gradient.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  void initState() {
    BlocProvider.of<AppStartBloc>(context).add(
      IsAppFirstLaunchEvent(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppStartBloc, AppStartState>(
      listener: (context, state) {
        if (state is IsAppFirstLaunchState) {
          if (state.isFirstTime) {
            ///SHOW DEFAULT LANGUAGE AND CURRENCY DIALOG FIRST TIME LAUNCHE
            showDialog(
              context: context,
              barrierDismissible: true,
              builder: (context) {
                return DialogFirstTimeLanAndCurrency(
                  onLanguageChange: () {
                    setState(() {});
                  },
                );
              },
            );
          }
        }
      },
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              buildAppSnackBar(
                bgColor: AppColors.errorRed,
                txtColor: AppColors.white,
                msg: AppLocale.of().authenticationFailedMsg,
                isFloating: false,
              ),
            );
          }
          if (state is AuthSuccessState) {
            Navigator.pushNamedAndRemoveUntil(
                context,
                AppRouterPaths.mainScreen,
                ModalRoute.withName(AppRouterPaths.splashRoute));
            BlocProvider.of<AppUserWidgetsCubit>(context).updateAppUser(
              state.appUser,
            );
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.black,
          //resizeToAvoidBottomInset: true,
          body: Stack(
            children: [
              ///BACKGROUND IMAGE
              SignUpPageBg(),

              ///FRONT PAGE UI
              SignUpPageFront(),

              ///LOADING SHADE
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is AuthLoadingState) {
                    return SignUpPageAuthingCovor(
                      showLoading: false,
                    );
                  } else {
                    return SizedBox();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
