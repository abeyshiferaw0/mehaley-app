import 'package:bloc/bloc.dart';
import 'package:elf_play/data/models/enums/app_languages.dart';
import 'package:elf_play/util/l10n_util.dart';

class LocalizationCubit extends Cubit<AppLanguage> {
  LocalizationCubit() : super(L10nUtil.getCurrentLocale());

  changeLocale({required AppLanguage appLanguage}) {
    AppLanguage currentAppLanguage = L10nUtil.changeLocale(appLanguage);
    emit(currentAppLanguage);
  }
}
