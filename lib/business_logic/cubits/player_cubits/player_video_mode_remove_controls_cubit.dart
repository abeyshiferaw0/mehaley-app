import 'package:bloc/bloc.dart';

class PlayerVideoModeRemoveControlsCubit extends Cubit<VideoModeControls> {
  PlayerVideoModeRemoveControlsCubit() : super(VideoModeControls.SHOW_CONTROLS);

  removeControls() {
    emit(VideoModeControls.REMOVE_CONTROLS);
  }

  showControls() {
    emit(VideoModeControls.SHOW_CONTROLS);
  }

  changeControls() {
    if (state == VideoModeControls.SHOW_CONTROLS) {
      emit(VideoModeControls.REMOVE_CONTROLS);
    } else {
      emit(VideoModeControls.SHOW_CONTROLS);
    }
  }
}

enum VideoModeControls { SHOW_CONTROLS, REMOVE_CONTROLS }
