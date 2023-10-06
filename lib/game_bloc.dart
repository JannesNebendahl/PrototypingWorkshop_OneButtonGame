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
      const VideoData('assets/gewitter.mp4', 6550, 'Take a photo of the lightning!'),
      const VideoData('assets/Torschuss.mp4', 4260, 'Take a photo, when to goalkeeper touches the ball!'),
      const VideoData('assets/gepardenJagd.mp4', 10530, 'As soon as the cheetah touches the antelope, \ntake a photo!'),
      const VideoData('assets/Nescar.mp4', 6160, 'Take a photo, when the winner crosses the finish line!'),
      const VideoData('assets/Skispringen.mp4', 8000, 'Take a photo, when the skier touches the ground!')
    ];
    emit(RoundState(scoreMs, videoData[roundIndex]));
  }

  FutureOr<void> _onRestartGame(RestartGame event, Emitter<GameState> emit) {
    emit(const StartState());
  }
}
