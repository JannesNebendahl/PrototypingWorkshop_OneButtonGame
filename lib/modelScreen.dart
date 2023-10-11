import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'game_bloc.dart';

class ModelScreen extends StatefulWidget {
  const ModelScreen({Key? key, required this.data, required this.score})
      : super(key: key);

  final ModelData data;
  final int score;

  @override
  State<ModelScreen> createState() => _ModelScreenState();
}

class _ModelScreenState extends State<ModelScreen> {
  bool imageShown = false;
  bool capturedPhoto = false;
  int imageIndex = 1;
  Random random = Random();
  late Timer _timer;
  final Stopwatch _stopwatch = Stopwatch();
  bool enablePhotoCapturing = false;
  int fines = 0;
  static const int fine = 1000;
  late String imagePath;

  @override
  void initState() {
    imagePath = '${widget.data.imageDirectory}$imageIndex.jpg';
    super.initState();
  }

  void startTimer() {
    final randomDuration = widget.data.minimumToNextImage +
        Duration(
            seconds: random.nextInt(widget.data.maximumToNextImage.inSeconds -
                widget.data.minimumToNextImage.inSeconds +
                1));

    _timer = Timer.periodic(randomDuration, (timer) {
      _timer.cancel();
      setState(() {
        imageIndex++;
        imagePath = '${widget.data.imageDirectory}$imageIndex.jpg';
      });
      if (imageIndex == widget.data.numberOfImages) {
        _stopwatch.start();
        setState(() {
          enablePhotoCapturing = true;
        });
      } else {
        startTimer();
      }
    });
  }

  Widget image() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imagePath),
        ],
      );

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
            onPressed: () async {
              if (imageShown) {
                if (enablePhotoCapturing) {
                  _stopwatch.stop();
                  setState(() {
                    imageShown = false;
                    capturedPhoto = true;
                  });
                } else {
                  fines += fine;
                  setState(() {
                    showToastMessage();
                  });
                }
              } else {
                if (capturedPhoto) {
                  context.read<GameBloc>().add(NextRound(
                      (_stopwatch.elapsedMilliseconds).abs() + fines));
                } else {
                  startTimer();
                  setState(() {
                    imageShown = true;
                  });
                }
              }
            },
            icon: imageShown
                ? const Icon(
                    Icons.camera,
                    color: Colors.white,
                    size: 55,
                  )
                : const Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 55,
                  ),
          ),
        ),
      );

  Widget userNotification() => imageShown
      ? Container()
      : capturedPhoto
          ? Positioned(
              top: MediaQuery.of(context).size.height / 2 - 50,
              right: MediaQuery.of(context).size.width / 2 - 180,
              child: SizedBox(
                width: 300,
                height: 100,
                child: Card(
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Missed it by ${_stopwatch.elapsedMilliseconds} ms\n + $fines ms of fines',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : Positioned(
              top: MediaQuery.of(context).size.height / 2 - 75,
              right: MediaQuery.of(context).size.width / 2 - 280,
              child: SizedBox(
                width: 500,
                height: 150,
                child: Card(
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${widget.data.instructions}\nYou get a fine of $fine ms for each mistaken photo.',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );

  Widget scoreCard() => Positioned(
        top: MediaQuery.of(context).size.height / 10 - 25,
        left: MediaQuery.of(context).size.width / 20,
        child: SizedBox(
          width: 170,
          height: 50,
          child: Card(
            color: Colors.white60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Score: ${widget.score}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget restartButton() => Positioned(
        top: MediaQuery.of(context).size.height / 10 - 25,
        right: MediaQuery.of(context).size.width / 20,
        child: SizedBox(
          width: 100,
          height: 50,
          child: Card(
            color: Colors.white60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    context.read<GameBloc>().add(RestartGame());
                  },
                  child: const Text(
                    'Restart',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  void showToastMessage() {
    Fluttertoast.showToast(
      msg: 'Fine of $fine ms',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.white,
      textColor: Colors.black,
      fontSize: 20.0,
    );
  }

  Widget debugInfo() => Positioned(
        bottom: MediaQuery.of(context).size.height / 10 - 25,
        left: MediaQuery.of(context).size.width / 20,
        child: SizedBox(
          width: 150,
          height: 50,
          child: Card(
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    context.read<GameBloc>().add(RestartGame());
                  },
                  child: Text(
                    '${_stopwatch.elapsedMilliseconds}',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: <Widget>[
            Center(child: image()),
            restartButton(),
            scoreCard(),
            userNotification(),
            //debugInfo(),
            captureButton(),
          ],
        ),
      ),
    );
  }
}
