import 'package:elf_play/business_logic/blocs/sync_song/sync_song_bloc.dart';
import 'package:elf_play/config/app_router.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/util/auth_util.dart';
import 'package:elf_play/util/debouncer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    Debouncer(milliseconds: 2000).run(() {
      ///DEBUG
      ///CHECK AUTH HERE
      checkIfUserLoggedIn();
    });
    //BlocProvider.of<SyncSongBloc>(context).add(DumSongEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkGreen,
      body: BlocBuilder<SyncSongBloc, SyncSongState>(
        builder: (context, state) {
          return Container(
            color: AppColors.darkGreen,
          );
        },
      ),
    );
  }

  void checkIfUserLoggedIn() async {
    bool isUserLoggedIn = await AuthUtil.isUserLoggedIn();
    if (isUserLoggedIn) {
      Navigator.popAndPushNamed(context, AppRouterPaths.mainScreen);
    } else {
      Navigator.popAndPushNamed(context, AppRouterPaths.signUp);
    }
  }
}
