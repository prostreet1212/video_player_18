import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:video_player_18/widgets/play_panel.dart';
import 'package:video_player_18/widgets/rewind_panel.dart';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({Key? key}) : super(key: key);

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController? _controller;
  bool isShow = false;
  Duration position = const Duration(milliseconds: 0);

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
        'http://kdrc.ru/wp-content/uploads/2023/03/korn.mp4');
    _controller!.addListener(() {});
    _controller!.setLooping(false);
    _controller!.initialize().then((value) => setState(() {}));
    _controller!.play();
  }

  Stream<Duration> updateSeeker() async* {
    final newPosition = await _controller!.position;
    setState(() {
      position = newPosition!;
    });
    yield position;
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Video Player'),
          centerTitle: true,
        ),
        body: Container(
          color: const Color.fromARGB(95, 217, 212, 212),
          child: Center(
            child: _controller!.value.isInitialized
                ? AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Stack(
                      children: [
                        GestureDetector(
                          child: VideoPlayer(_controller!),
                          onTap: () {
                            setState(() {
                              isShow = !isShow;
                            });
                          },
                        ),
                        isShow
                            ? RewindPanel(
                                controller: _controller,
                                position: position,
                                onUpdateSeeker: updateSeeker)
                            : Container(),
                        isShow
                            ? PlayPanel(controller: _controller)
                            : Container()
                      ],
                    ),
                  )
                : AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Container(
                      color: Colors.grey,
                      child: const Center(
                        child: Text(
                          'Loading...',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
        ));
  }
}
