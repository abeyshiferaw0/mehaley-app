import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/data/models/song.dart';
import 'package:elf_play/data/repositories/player_data_repository.dart';
import 'package:elf_play/util/audio_player_util.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:meta/meta.dart';

part 'audio_player_event.dart';
part 'audio_player_state.dart';

class AudioPlayerBloc extends Bloc<AudioPlayerEvent, AudioPlayerState> {
  final AudioPlayer audioPlayer;
  final PlayerDataRepository playerDataRepository;

  AudioPlayerBloc({
    required this.playerDataRepository,
    required this.audioPlayer,
  }) : super(AudioPlayerInitialState()) {
    audioPlayer.setCanUseNetworkResourcesForLiveStreamingWhilePaused(true);
    //audioPlayer.setSkipSilenceEnabled(true);

    //INITIALIZE AUDIO SESSION
    AudioPlayerUtil.initAudioSession();

    //LISTEN FOR VOLUME CHANGE
    audioPlayerListenForVolume();

    //LISTEN FOR PLAYER STATE CHANGE
    audioPlayerListenForPlayingState();

    //LISTEN FOR CURRENT MEDIA ITEM CHANGE
    audioPlayerCurrentSongListen();

    //LISTEN TO PLAY PAUSE CHANGE
    audioPlayerPlayPauseListen();

    //LISTEN FOR PLAYER SHUFFLE CHANGE
    audioPlayerShuffleListen();

    //LISTEN FOR PLAYER LOOP CHANGE
    audioPlayerLoopListen();

    //LISTEN FOR POSITION STREAM
    audioPlayerPositionListen();

    //LISTEN FOR BUFFERED POSITION STREAM
    audioPlayerBufferedPositionListen();

    //LISTEN FOR DURATION STREAM
    audioPlayerDurationListen();

    //LISTEN FOR PLAYER QUEUE AND CURRENT INDEX CHANGE
    audioPlayerQueueListen();
  }

  @override
  Stream<AudioPlayerState> mapEventToState(
    AudioPlayerEvent event,
  ) async* {
    if (event is SetPlayerQueueEvent) {
      //SETTING AUDIO PLAYER QUEUE
      setAudioPlayerQueue(event);
    } else if (event is SetMutedEvent) {
      //SET PLAYER VOLUME
      setMuted();
    } else if (event is PlayerVolumeChangedEvent) {
      //SET PLAYER VOLUME
      yield AudioPlayerVolumeChangedState(volume: event.volume);
    } else if (event is ReportPlayerEvent) {
      //REPORT PLAYER ERRORS
      yield AudioPlayerErrorState(msg: event.msg, error: event.error);
    } else if (event is ChangeCurrentSongEvent) {
      //CHANGE CURRENT PLAYING SONG ITEM LISTENER
      yield AudioPlayerCurrentSongChangeState(song: event.song);
    } else if (event is PlayerStateChangedEvent) {
      //PLAYER STATE CHANGED
      yield AudioPlayerStateChangedState(playerState: event.playerState);
    } else if (event is PlayPauseEvent) {
      //PLAY PAUSE AUDIO
      playPauseAudio();
    } else if (event is PlayPauseChangedEvent) {
      //CHANGE PLAY PAUSE UI LISTENER
      yield AudioPlayerPlayPauseStateChangedState(isPlaying: event.isPlaying);
    } else if (event is PlayNextSongEvent) {
      //PLAY NEXT SONG IF AVAILABLE
      playNextSong();
    } else if (event is PlayPreviousSongEvent) {
      //PLAY PREVIOUS SONG IF AVAILABLE
      playPreviousSong();
    } else if (event is ShufflePlayerQueueEvent) {
      //SHUFFLE PLAYER QUEUE
      shufflePlayerQueue();
    } else if (event is ShufflePlayerOnQueueEvent) {
      //SHUFFLE PLAYER QUEUE
      shufflePlayerOnQueue();
    } else if (event is PlayerShuffleChangedEvent) {
      //CHANGE SHUFFLE QUEUE LISTENER
      yield AudioPlayerShuffleChangedState(isEnabled: event.isEnabled);
    } else if (event is LoopPlayerQueueEvent) {
      //LOOP PLAYER QUEUE
      loopPlayerQueue();
    } else if (event is PlayerLoopChangedEvent) {
      //LOOP PLAYER QUEUE LISTENER
      yield AudioPlayerLoopChangedState(loopMode: event.loopMode);
    } else if (event is PositionChangedEvent) {
      //PLAYER SONG POSITION LISTENER
      yield AudioPlayerPositionChangedState(duration: event.duration);
    } else if (event is BufferedPositionChangedEvent) {
      //PLAYER SONG (TOTAL) DURATION LISTENER
      yield AudioPlayerBufferedPositionChangedState(duration: event.duration);
    } else if (event is DurationChangedEvent) {
      //PLAYER DURATION LISTENER
      yield AudioPlayerDurationChangedState(duration: event.duration);
    } else if (event is SeekAudioPlayerEvent) {
      //SEEK PLAYER DURATION POSITION
      seekPlayerPosition(event.duration);
    } else if (event is SeekAudioPlayerToEvent) {
      //SEEK PLAYER DURATION POSITION
      seekPlayerToPosition(event.song);
    } else if (event is ChangePlayerVideoMode) {
      //PLAYER BG VIDEO MODE CHANGED
      yield AudioPlayerVideoModeChangedState(enabled: event.enable);
    } else if (event is PlayerQueueChangedEvent) {
      //PLAYER QUEUE CHANGED
      yield AudioPlayerQueueChangedState(
        queue: event.queue,
        currentIndex: event.currentIndex,
      );
    } else if (event is UpdateQueueItemsMovedEvent) {
      //UPDATE QUEUE MOVED ITEMS
      updateQueueItemsMoved(event.newMedia, event.oldMedia);
    } else {
      throw "EVENT NOT RECOGNIZED";
    }
  }

  @override
  Future<void> close() {
    audioPlayer.dispose();
    return super.close();
  }

  void setAudioPlayerQueue(event) {
    try {
      audioPlayer
          .setAudioSource(
        ConcatenatingAudioSource(
          useLazyPreparation: true,
          shuffleOrder: DefaultShuffleOrder(),
          children: event.queue,
        ),
        initialIndex: event.index,
        initialPosition: Duration(milliseconds: 0),
      )
          .catchError(
        (error) {
          audioPlayer.pause();
          this.add(
            ReportPlayerEvent(
              msg: "Unable to play audio",
              error: error.toString(),
            ),
          );
        },
      );
    } on PlayerException catch (error) {
      this.add(ReportPlayerEvent(
          msg: "Something Went Wrong With Player", error: error.toString()));
    } on PlayerInterruptedException catch (error) {
      this.add(ReportPlayerEvent(
          msg: "Something Went Wrong With Player", error: error.toString()));
    } catch (error) {
      this.add(ReportPlayerEvent(
          msg: "Something Went Wrong With Player", error: error.toString()));
    }

    //START PLAYING
    if (event.startPlaying) {
      audioPlayer.play();
    }
  }

  void playPauseAudio() {
    if (audioPlayer.playing) {
      audioPlayer.pause();
    } else {
      audioPlayer.play();
    }
  }

  void playNextSong() {
    if (audioPlayer.hasNext) {
      audioPlayer.seekToNext();
    } else {
      if (audioPlayer.sequence != null) {
        if (audioPlayer.sequence!.length > 0) {
          audioPlayer.seek(Duration(seconds: 1), index: 0);
        }
      }
    }
  }

  void playPreviousSong() {
    if (audioPlayer.hasPrevious) {
      audioPlayer.seekToPrevious();
    } else {
      if (audioPlayer.sequence != null) {
        if (audioPlayer.sequence!.length > 0) {
          audioPlayer.seek(Duration(seconds: 1), index: 0);
        }
      }
    }
  }

  void shufflePlayerQueue() {
    audioPlayer.setShuffleModeEnabled(!audioPlayer.shuffleModeEnabled);
    if (audioPlayer.shuffleModeEnabled) {
      audioPlayer.shuffle();
    }
  }

  void shufflePlayerOnQueue() {
    audioPlayer.setShuffleModeEnabled(true);
    audioPlayer.shuffle();
  }

  void audioPlayerShuffleListen() {
    audioPlayer.shuffleModeEnabledStream.listen((shuffleMode) {
      this.add(PlayerShuffleChangedEvent(isEnabled: shuffleMode));
    });
  }

  void audioPlayerPlayPauseListen() {
    audioPlayer.playingStream.listen((event) {
      this.add(PlayPauseChangedEvent(isPlaying: event));
    });
  }

  void audioPlayerCurrentSongListen() {
    audioPlayer.sequenceStateStream.listen(
      (sequenceState) {
        if (sequenceState == null) return;
        final currentItem = sequenceState.currentSource;
        MediaItem mediaItem = (currentItem!.tag as MediaItem);
        Song song = Song.fromMap(mediaItem.extras![AppValues.songExtraStr]);
        this.add(ChangeCurrentSongEvent(song: song));

        ///DEBUG ALSO CHECK FOR DATA SAVER
        //checkForVideoBg(mediaItem);

        ///ADD SONG TO RECENTLY PLAYED LIST
        playerDataRepository.addToRecentlyPlayed(song);
      },
    );
  }

  void loopPlayerQueue() {
    if (audioPlayer.loopMode == LoopMode.off) {
      audioPlayer.setLoopMode(LoopMode.all);
    } else if (audioPlayer.loopMode == LoopMode.all) {
      audioPlayer.setLoopMode(LoopMode.one);
    } else if (audioPlayer.loopMode == LoopMode.one) {
      audioPlayer.setLoopMode(LoopMode.off);
    }
  }

  void audioPlayerLoopListen() {
    audioPlayer.loopModeStream.listen((loopMode) {
      this.add(PlayerLoopChangedEvent(loopMode: loopMode));
    });
  }

  void audioPlayerPositionListen() {
    audioPlayer.positionStream.listen((duration) {
      this.add(PositionChangedEvent(duration: duration));
    });
  }

  void audioPlayerBufferedPositionListen() {
    audioPlayer.bufferedPositionStream.listen((duration) {
      this.add(BufferedPositionChangedEvent(duration: duration));
    });
  }

  void audioPlayerDurationListen() {
    audioPlayer.durationStream.listen((duration) {
      print("audioPlayer.durationStream ${duration.toString()}");
      this.add(
        DurationChangedEvent(
            duration: duration != null ? duration : Duration.zero),
      );
    });
  }

  void seekPlayerPosition(Duration duration) async {
    audioPlayer.seek(duration);
  }

  void seekPlayerToPosition(Song song) async {
    List<Song> queue = [];
    audioPlayer.sequence!.forEach((mediaItem) {
      queue.add(
        Song.fromMap(
          (mediaItem.tag as MediaItem).extras![AppValues.songExtraStr],
        ),
      );
    });

    int currentIndex = queue.indexOf(song);

    audioPlayer.seek(Duration.zero, index: currentIndex);
  }

  // void checkForVideoBg(MediaItem mediaItem) {
  //   if (mediaItem.extras != null) {
  //     Song song = Song.fromMap(mediaItem.extras![AppValues.songExtraStr]);
  //     if (song.songBgVideo.songMediumBgVideoUrl != null) {
  //       if ((song.songBgVideo.songMediumBgVideoUrl as String).isNotEmpty) {
  //         //DEBUG MAKE FALSE TO TRUE FOR AUDIO MODE
  //         this.add(ChangePlayerVideoMode(enable: false));
  //       } else {
  //         this.add(ChangePlayerVideoMode(enable: false));
  //       }
  //     } else {
  //       this.add(ChangePlayerVideoMode(enable: false));
  //     }
  //   } else {
  //     this.add(ChangePlayerVideoMode(enable: false));
  //   }
  // }

  void audioPlayerQueueListen() {
    audioPlayer.sequenceStateStream.listen((sequenceState) {
      //GET NEW QUEUE

      if (sequenceState == null) return;
      List<Song> queue = [];
      sequenceState.effectiveSequence.forEach((mediaItem) {
        queue.add(
          Song.fromMap(
            (mediaItem.tag as MediaItem).extras![AppValues.songExtraStr],
          ),
        );
      });
      //GET CURRENT PLAYING SONG INDEX FOR THE QUEUE
      Song currentSong = Song.fromMap(
          (audioPlayer.sequenceState!.currentSource!.tag as MediaItem)
              .extras![AppValues.songExtraStr]);
      int currentIndex = queue.indexOf(currentSong);

      this.add(
        PlayerQueueChangedEvent(queue: queue, currentIndex: currentIndex),
      );
    });
  }

  void updateQueueItemsMoved(Song newSong, Song oldSong) {
    if (audioPlayer.sequenceState == null) return;

    int oldIndex = 0;
    int newIndex = 0;

    //GET OLD INDEX
    var i = 0;
    for (IndexedAudioSource source
        in audioPlayer.sequenceState!.effectiveSequence) {
      if (int.parse((source.tag as MediaItem).id) == oldSong.songId) {
        oldIndex = i;
      }
      i++;
    }

    //GET NEW INDEX
    i = 0;
    for (IndexedAudioSource source
        in audioPlayer.sequenceState!.effectiveSequence) {
      if (int.parse((source.tag as MediaItem).id) == newSong.songId) {
        newIndex = i;
      }
      i++;
    }

    if (audioPlayer.shuffleModeEnabled) {
      //REORDER SHUFFLED LIST
      int indexShuffle =
          audioPlayer.sequenceState!.shuffleIndices.removeAt(oldIndex);
      audioPlayer.sequenceState!.shuffleIndices.insert(
        newIndex,
        indexShuffle,
      );
    } else {
      //REORDER LIST
      IndexedAudioSource indexedAudioSource =
          audioPlayer.sequenceState!.effectiveSequence.removeAt(oldIndex);
      audioPlayer.sequenceState!.effectiveSequence.insert(
        newIndex,
        indexedAudioSource,
      );
    }

    //CHECK AGAIN FOR PLAYER QUEUE CHANGE
    checkPlayerQueueChange();
  }

  void audioPlayerListenForPlayingState() {
    audioPlayer.playerStateStream.listen((playerState) {
      this.add(PlayerStateChangedEvent(playerState: playerState));
    });
  }

  void checkPlayerQueueChange() {
    //GET NEW QUEUE
    List<Song> queue = [];
    audioPlayer.sequenceState!.effectiveSequence.forEach((mediaItem) {
      queue.add(Song.fromMap(
          (mediaItem.tag as MediaItem).extras![AppValues.songExtraStr]));
    });
    //GET CURRENT PLAYING SONG INDEX FOR THE QUEUE
    Song currentSong = Song.fromMap(
        (audioPlayer.sequenceState!.currentSource!.tag as MediaItem)
            .extras![AppValues.songExtraStr]);
    int currentIndex = queue.indexOf(currentSong);
    this.add(PlayerQueueChangedEvent(queue: queue, currentIndex: currentIndex));
  }

  void setMuted() {
    if (audioPlayer.volume == 0.0) {
      audioPlayer.setVolume(1.0);
    } else {
      audioPlayer.setVolume(0.0);
    }
  }

  void audioPlayerListenForVolume() {
    audioPlayer.volumeStream.listen((event) {
      this.add(PlayerVolumeChangedEvent(volume: event));
    });
  }
}
