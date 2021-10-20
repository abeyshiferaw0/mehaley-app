import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:elf_play/util/l10n_util.dart';

class LocalizationCubit extends Cubit<Locale> {
  LocalizationCubit() : super(L10nUtil.english);

  changeLocale({required Locale locale}) {
    emit(locale);
  }
}
