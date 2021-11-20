import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/auth_bloc/auth_bloc.dart';
import 'package:mehaley/config/app_router.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/ui/common/app_snack_bar.dart';
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
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
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
          Navigator.pushNamedAndRemoveUntil(context, AppRouterPaths.mainScreen,
              ModalRoute.withName(AppRouterPaths.splashRoute));
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.black,
        extendBody: true,
        resizeToAvoidBottomInset: false,
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
    );
  }
}
