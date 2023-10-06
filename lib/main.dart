import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:one_button_app/game_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_button_app/resultScreen.dart';
import 'package:one_button_app/startScreen.dart';
import 'package:one_button_app/videoPlayerScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

    return MaterialApp(
      home: BlocProvider(
        create: (context) => GameBloc(),
        child: BlocBuilder<GameBloc, GameState>(
          builder: (context, state) {
            if(state is StartState) {
              return const StartScreen();
            } else if(state is RoundState) {
              if (state.data is VideoData) {
                VideoData data = state.data as VideoData;
                Key key = Key(data.videoPath);
                return VideoPlayerScreen(key: key, data: data, score: state.score);
              } else if (state.data is ModelData) {
                return const Placeholder();
              }  else {
                throw UnimplementedError();
              }
            } else if(state is ResultState) {
              return ResultScreen(score: state.score);
            } else {
              throw UnimplementedError();
            }
          },
        ),
      ),
    );
  }
}

