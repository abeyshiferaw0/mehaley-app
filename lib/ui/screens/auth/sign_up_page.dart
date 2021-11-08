import 'package:elf_play/business_logic/blocs/auth_bloc/auth_bloc.dart';
import 'package:elf_play/config/app_router.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/ui/common/app_snack_bar.dart';
import 'package:elf_play/ui/common/sign_up_page_authing_covor.dart';
import 'package:elf_play/ui/screens/auth/widgets/sign_up_page_front.dart';
import 'package:elf_play/ui/screens/auth/widgets/sign_up_page_gradient.dart';
import 'package:elf_play/ui/screens/auth/widgets/sign_up_page_staggered_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
              msg: AppLocalizations.of(context)!.authenticationFailedMsg,
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
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            SignUpPageStaggeredAnimatedList(),
            // Center(
            //   child: Container(
            //     height: ScreenUtil(context: context).getScreenHeight(),
            //     child: LottieBuilder.network(
            //       "https://assets7.lottiefiles.com/private_files/lf30_k9aqcmp8.json",
            //       fit: BoxFit.cover,
            //     ),
            //   ),
            // ),
            SignUpPageGradient(),
            SignUpPageFront(),
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
