import 'package:bloc/bloc.dart';
import 'package:mehaley/data/data_providers/settings_data_provider.dart';
import 'package:mehaley/data/models/enums/setting_enums/app_currency.dart';

class CurrencyCubit extends Cubit<AppCurrency> {
  CurrencyCubit() : super(SettingsDataProvider().getPreferredCurrency());

  changePreferredCurrency({required AppCurrency mAppCurrency}) {
    AppCurrency appCurrency =
        SettingsDataProvider().changePreferredCurrencyByValue(mAppCurrency);
    emit(appCurrency);
  }
}
