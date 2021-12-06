import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:mehaley/data/models/api_response/profile_page_data.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/data/repositories/profile_data_repository.dart';

part 'profile_page_event.dart';
part 'profile_page_state.dart';

class ProfilePageBloc extends Bloc<ProfilePageEvent, ProfilePageState> {
  ProfilePageBloc({required this.profileDataRepository})
      : super(ProfilePageInitial());

  final ProfileDataRepository profileDataRepository;

  @override
  Stream<ProfilePageState> mapEventToState(
    ProfilePageEvent event,
  ) async* {
    if (event is LoadProfilePageEvent) {
      //LOAD CACHE AND REFRESH
      yield ProfilePageLoadingState();
      try {
        //YIELD CACHE DATA
        final ProfilePageData profilePageData = await profileDataRepository
            .getProfileData(AppCacheStrategy.LOAD_CACHE_FIRST);
        yield ProfilePageLoadedState(profilePageData: profilePageData);

        if (isFromCatch(profilePageData.response)) {
          try {
            //REFRESH AFTER CACHE YIELD
            final ProfilePageData profilePageData =
                await profileDataRepository.getProfileData(
              AppCacheStrategy.CACHE_LATER,
            );
            yield ProfilePageLoadingState();
            yield ProfilePageLoadedState(profilePageData: profilePageData);
          } catch (error) {
            //DON'T YIELD ERROR  BECAUSE CACHE IS FETCHED
          }
        }
      } catch (error) {
        yield ProfilePageLoadingErrorState(error: error.toString());
      }
    }
  }

  bool isFromCatch(Response response) {
    if (response.extra['@fromNetwork@'] == null) return true;
    return !response.extra['@fromNetwork@'];
  }
}
