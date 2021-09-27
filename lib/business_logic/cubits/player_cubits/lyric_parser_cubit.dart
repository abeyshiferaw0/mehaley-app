// import 'dart:async';
//
// import 'package:bloc/bloc.dart';
// import 'package:elf_play/business_logic/blocs/player_page_bloc/audio_player_bloc.dart';
// import 'package:elf_play/data/models/lyric_item.dart';
// import 'package:lyrics_parser/lyrics_parser.dart';
//
// class LyricParserCubit extends Cubit<List<LyricItem>> {
//   late StreamSubscription subscription;
//   final AudioPlayerBloc audioPlayerBloc;
//
//   LyricParserCubit({required this.audioPlayerBloc}) : super([]) {
//     subscription = audioPlayerBloc.stream.listen((state) {
//       if (state is AudioPlayerCurrentSongChangeState) {
//         if (song.lyricIncluded) {
//           this.add(
//             LoadSongLyricEvent(songId: song.songId),
//           );
//         } else {
//           this.add(
//             RemoveLyricWidgetEvent(),
//           );
//         }
//       }
//     });
//
//     subscription = audioPlayerBloc.stream.listen((state) {
//       if (state is LyricDataLoaded) {
//         parseLyric(state.lyric);
//       } else if (state is RemoveLyricWidgetState) {
//         emit([]);
//       }
//     });
//   }
//
//   void parseLyric(lyric) async {
//     final parser = LyricsParser(lyric.lyric.textAm);
//     final result = await parser.parse();
//     List<LyricItem> lyricList = [];
//     int i = 0;
//     for (final lyric in result.lyricList) {
//       if (lyric.startTimeMillisecond != null) {
//         lyricList.add(
//           LyricItem(
//             startTimeMillisecond: lyric.startTimeMillisecond!.toDouble(),
//             content: lyric.content,
//             index: i,
//           ),
//         );
//         i++;
//       }
//     }
//     emit(lyricList);
//   }
//
//   @override
//   Future<void> close() {
//     subscription.cancel();
//     return super.close();
//   }
// }
