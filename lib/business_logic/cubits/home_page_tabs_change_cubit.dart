import 'package:bloc/bloc.dart';
import 'package:mehaley/data/models/enums/enums.dart';

class HomePageTabsChangeCubit extends Cubit<GroupType?> {
  HomePageTabsChangeCubit() : super(null);

  changeGroupType(GroupType? groupType) async {
    print("AppBouncingButton clickedd ${state}");
    emit(groupType);
    emit(GroupType.NONE);
  }
}
