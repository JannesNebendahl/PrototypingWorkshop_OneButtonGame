import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc() : super(const StartState()) {
    on<NextRound>(_onNextRound);
    on<StartGame>(_onStartGame);
    on<RestartGame>(_onRestartGame);
  }

  List<VideoData> videoData = [];
  int roundIndex = 0;
  int scoreMs = 0;


  FutureOr<void> _onNextRound(NextRound event, Emitter<GameState> emit) {
    scoreMs += event.pointsCurrentRound;
    roundIndex++;

    if(roundIndex < (videoData.length))
    {
      emit(RoundState(scoreMs, videoData[roundIndex]));
    }
    else
    {
      emit(ResultState(scoreMs));
    }
  }

  FutureOr<void> _onStartGame(StartGame event, Emitter<GameState> emit) {
    roundIndex = 0;
    scoreMs = 0;
    videoData =  [
      const VideoData('assets/gepardenJagd.mp4', 17950, 'As soon as the cheetah touches the antelope, \ntake a photo!'),
      const VideoData('assets/gewitter.mp4', 12110, 'Take a photo of the lightning!'),
    ];
    emit(RoundState(scoreMs, videoData[roundIndex]));
  }

  FutureOr<void> _onRestartGame(RestartGame event, Emitter<GameState> emit) {
    emit(const StartState());
  }
}
