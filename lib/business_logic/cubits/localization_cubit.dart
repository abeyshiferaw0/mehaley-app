import 'package:bloc/bloc.dart';
import 'package:mehaley/data/models/enums/app_languages.dart';
import 'package:mehaley/util/l10n_util.dart';

class LocalizationCubit extends Cubit<AppLanguage> {
  LocalizationCubit() : super(L10nUtil.getCurrentLocale());

  changeLocale({required AppLanguage appLanguage}) {
    AppLanguage currentAppLanguage = L10nUtil.changeLocale(appLanguage);
    emit(currentAppLanguage);
  }
}
