import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_button_app/game_bloc.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({Key? key, required this.score}) : super(key: key);

  final int score;

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
            context.read<GameBloc>().add(RestartGame());
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
        child: Card(
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Not bad!\nYou missed the desired moments by $score ms overall.',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
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
