part of 'game_bloc.dart';

abstract class GameEvent extends Equatable {
  const GameEvent();
}

class NextRound extends GameEvent {
  const NextRound(this.pointsCurrentRound);

  final int pointsCurrentRound;

  @override
  List<Object?> get props => [pointsCurrentRound];
}

class StartGame extends GameEvent {
  @override
  List<Object?> get props => [];
}

class RestartGame extends GameEvent {
  @override
  List<Object?> get props => [];
}