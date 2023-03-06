import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PlayPanel extends StatefulWidget {
  const PlayPanel({Key? key, required this.controller}) : super(key: key);
  final VideoPlayerController? controller;

  @override
  State<PlayPanel> createState() => _PlayPanelState();
}

class _PlayPanelState extends State<PlayPanel> {
  Future goToPosition(Duration seconds) async {
    Duration? currentPosition = await widget.controller!.position;
    Duration? newPosition = currentPosition! + seconds;
    await widget.controller!.seekTo(newPosition);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            iconSize: 45,
            color: Colors.white70,
            icon: const Icon(
              Icons.replay_10,
            ),
            onPressed: () async {
              setState(() {
                goToPosition(const Duration(seconds: -10));
              });
            },
          ),
          IconButton(
            iconSize: 45,
            color: Colors.white70,
            icon: Icon(widget.controller!.value.isPlaying
                ? Icons.pause
                : Icons.play_arrow),
            onPressed: () {
              setState(() {
                widget.controller!.value.isPlaying
                    ? widget.controller!.pause()
                    : widget.controller!.play();
              });
            },
          ),
          IconButton(
            iconSize: 45,
            color: Colors.white70,
            icon: const Icon(Icons.forward_10),
            onPressed: () async {
              setState(() {
                goToPosition(const Duration(seconds: 10));
              });
            },
          ),
        ],
      ),
    );
  }
}
