import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_button_app/game_bloc.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({Key? key, required this.data, required this.score})
      : super(key: key);

  final VideoData data;
  final int score;

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _videoController;
  int capturedMomentMs = 0;
  bool capturedPhoto = false;
  bool videoIsRunning = false;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.asset(widget.data.videoPath)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  Widget video() => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      _videoController.value.isInitialized
          ? AspectRatio(
              aspectRatio: _videoController.value.aspectRatio,
              child: VideoPlayer(_videoController),
            )
          : const CircularProgressIndicator(),
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
              if (videoIsRunning) {
                final stopMoment = await _videoController.position;
                capturedMomentMs =
                    stopMoment != null ? stopMoment.inMilliseconds : 0;
                await _videoController.pause();
                setState(() {
                  videoIsRunning = false;
                  capturedPhoto = true;
                });
              } else {
                if (capturedPhoto) {
                  context.read<GameBloc>().add(
                      NextRound((capturedMomentMs - widget.data.momentInMs).abs()));
                } else {
                  await _videoController.play();
                  setState(() {
                    videoIsRunning = true;
                  });
                }
              }
            },
            icon: videoIsRunning
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

  Widget userNotification() => videoIsRunning
      ? Container()
      : capturedPhoto
          ? Positioned(
              top: MediaQuery.of(context).size.height / 2 - 25,
              right: MediaQuery.of(context).size.width / 2 - 180,
              child: SizedBox(
                width: 300,
                height: 50,
                child: Card(
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Missed it by ${capturedMomentMs - widget.data.momentInMs} ms',
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
              top: MediaQuery.of(context).size.height / 2 - 50,
              right: MediaQuery.of(context).size.width / 2 - 280,
              child: SizedBox(
                width: 500,
                height: 100,
                child: Card(
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.data.instructions,
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
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width: 20),
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
            color: Colors.white,
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
                    '$capturedMomentMs',
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
    _videoController.setVolume(0);

    return Scaffold(
      body: Center(
        child: Stack(
          children: <Widget>[
            video(),
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

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }
}
