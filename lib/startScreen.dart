import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_button_app/game_bloc.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget captureButton() => Positioned(
          top: MediaQuery.of(context).size.height / 2 - 35,
          right: MediaQuery.of(context).size.width / 20,
          child: Container(
            width: 70.0,
            height: 70.0,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black54,
            ),
            child: IconButton(
              onPressed: () {
                context.read<GameBloc>().add(StartGame());
              },
              icon: const Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 55,
              ),
            ),
          ),
        );

    Widget userNotification() => Positioned(
      top: MediaQuery.of(context).size.height / 2 - 100,
      left: MediaQuery.of(context).size.width / 10,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.75,
        height: 200,
        child: const Card(
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Imagine you are an photographer and have to take \nthe perfect shot.\nTry to miss the desired moment by the least milliseconds.\nThe missed milliseconds get summed up and build your score.\nTry to reach the lowest score possible and be the best \nphotographer!',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return Scaffold(
      body: Center(
        child: Stack(
          children: <Widget>[
            userNotification(),
            captureButton(),
          ],
        ),
      ),
    );
  }
}
