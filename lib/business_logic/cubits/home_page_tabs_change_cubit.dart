import 'package:bloc/bloc.dart';
import 'package:mehaley/data/models/enums/enums.dart';

class HomePageTabsChangeCubit extends Cubit<GroupType?> {
  HomePageTabsChangeCubit() : super(null);

  changeGroupType(GroupType? groupType) async {
    emit(groupType);
  }
}
