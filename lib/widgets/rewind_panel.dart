import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'custom_track_shape.dart';

class RewindPanel extends StatelessWidget {
  const RewindPanel(
      {Key? key,
      required this.controller,
      required this.position,
      required this.onUpdateSeeker})
      : super(key: key);

  final VideoPlayerController? controller;
  final Duration position;
  final Function onUpdateSeeker;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        height: 70,
        child: Padding(
            padding: const EdgeInsets.only(right: 20, left: 20),
            child: StreamBuilder<Duration>(
                stream: onUpdateSeeker(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      if (snapshot.hasData) {
                        return Column(
                          children: [
                            SliderTheme(
                              data: SliderThemeData(
                                trackShape: CustomTrackShape(),
                              ),
                              child: Slider(
                                activeColor: Colors.white70,
                                inactiveColor: Colors.white70,
                                thumbColor: Colors.white70,
                                onChangeStart: (_) => controller!.pause(),
                                onChangeEnd: (_) => controller!.play(),
                                onChanged: (value) => controller!.seekTo(
                                    Duration(milliseconds: value.toInt())),
                                value: snapshot.data!.inMilliseconds.toDouble(),
                                min: 0,
                                max: controller!.value.duration.inMilliseconds
                                    .toDouble(),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  position.toString().substring(2, 7),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  controller!.value.duration
                                      .toString()
                                      .substring(2, 7),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ],
                        );
                      } else {
                        return Container();
                      }
                    case ConnectionState.none:
                      return const Text('none');
                    case ConnectionState.done:
                      return const Text('done');
                    case ConnectionState.active:
                      return Container();
                  }
                })),
      ),
    );
  }
}
