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

  List<GameData> gameData = [];
  int roundIndex = 0;
  int scoreMs = 0;


  FutureOr<void> _onNextRound(NextRound event, Emitter<GameState> emit) {
    scoreMs += event.pointsCurrentRound;

    if(roundIndex < (gameData.length))
    {
      emit(RoundState(scoreMs, gameData[roundIndex]));
      roundIndex++;
    }
    else
    {
      emit(ResultState(scoreMs));
    }
  }

  FutureOr<void> _onStartGame(StartGame event, Emitter<GameState> emit) {
    roundIndex = 0;
    scoreMs = 0;
    gameData =  [
      const VideoData('assets/gewitter.mp4', 6550, 'Take a photo of the lightning!'),
      const VideoData('assets/Torschuss.mp4', 4260, 'Take a photo, when to goalkeeper touches the ball!'),
      const ModelData('assets/model1/', 'Capture a photo of a smiling model!', 7, Duration(milliseconds: 800), Duration(milliseconds: 1000)),
      const VideoData('assets/gepardenJagd.mp4', 10530, 'As soon as the cheetah touches the antelope, \ntake a photo!'),
      const ModelData('assets/Fußball/', 'Capture a photo when all team members are smiling!', 7, Duration(milliseconds: 2000), Duration(milliseconds: 2800)),
      const VideoData('assets/Nescar.mp4', 6160, 'Take a photo, when the winner crosses the finish line!'),
      const ModelData('assets/familie1/', 'Take a photo on which all family members are smiling!', 10, Duration(milliseconds: 1000), Duration(milliseconds: 1200)),
      const VideoData('assets/Skispringen.mp4', 8000, 'Take a photo, when the skier touches the ground!')
    ];
    _onNextRound(const NextRound(0), emit);
  }

  FutureOr<void> _onRestartGame(RestartGame event, Emitter<GameState> emit) {
    emit(const StartState());
  }
}
