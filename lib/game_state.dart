part of 'game_bloc.dart';

abstract class GameState extends Equatable {
  const GameState();
}

class StartState extends GameState {
  const StartState();

  @override
  List<Object?> get props => [];
}

class ResultState extends GameState {
  const ResultState(this.score);

  final int score;

  @override
  List<Object?> get props => [score];
}

class RoundState extends GameState {
  const RoundState(this.score, this.data);

  final int score;
  final GameData data;

  @override
  List<Object?> get props => [score, data];
}

abstract class GameData extends Equatable {
  const GameData();
}

class VideoData extends GameData {
  final String videoPath;
  final int momentInMs;
  final String instructions;

  const VideoData(this.videoPath, this.momentInMs, this.instructions);

  @override
  List<Object?> get props => [videoPath, momentInMs, instructions];
}

class ModelData extends GameData {
  final String imageDirectory;
  final String instructions;
  final int numberOfImages;
  final Duration minimumToNextImage;
  final Duration maximumToNextImage;

  const ModelData(
    this.imageDirectory,
    this.instructions,
    this.numberOfImages,
    this.minimumToNextImage,
    this.maximumToNextImage,
  );

  @override
  List<Object?> get props => [
        imageDirectory,
        instructions,
        numberOfImages,
        minimumToNextImage,
        maximumToNextImage,
      ];
}
