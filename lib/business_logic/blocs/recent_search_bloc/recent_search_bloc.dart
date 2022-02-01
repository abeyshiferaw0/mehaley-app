import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:mehaley/config/app_hive_boxes.dart';
import 'package:mehaley/util/pages_util_functions.dart';
import 'package:meta/meta.dart';

part 'recent_search_event.dart';
part 'recent_search_state.dart';

class RecentSearchBloc extends Bloc<RecentSearchEvent, RecentSearchState> {
  RecentSearchBloc() : super(RecentSearchInitial()) {
    initRecentBox();
  }

  @override
  Stream<RecentSearchState> mapEventToState(
    RecentSearchEvent event,
  ) async* {
    Box recentBox = AppHiveBoxes.instance.recentSearchesBox;
    if (event is AddRecentSearchEvent) {
      if (recentBox.values.length > 8) {
        ///REMOVE LAST IF ITEMS ARE MORE THAN 8
        recentBox.delete(recentBox.keys.last);
      }
      recentBox.put(PagesUtilFunctions.getItemKey(event.item), event.item);
      yield RecentChangedState(items: recentBox.values.toList());
    } else if (event is LoadRecentSearchEvent) {
      yield RecentChangedState(items: recentBox.values.toList());
    } else if (event is RemoveRecentSearchEvent) {
      recentBox.delete(PagesUtilFunctions.getItemKey(event.item));
      yield RecentChangedState(items: recentBox.values.toList());
    } else if (event is RemoveAllRecentSearchEvent) {
      await recentBox.clear();
      yield RecentChangedState(items: recentBox.values.toList());
    } else if (event is RecentSearchInitEvent) {
      yield RecentChangedState(items: event.items);
    }
  }

  void initRecentBox() async {
    this.add(
      RecentSearchInitEvent(
        items: AppHiveBoxes.instance.recentSearchesBox.values.toList(),
      ),
    );
  }
}
