// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerItem extends StatefulWidget {
  final String videoUrl;
  const VideoPlayerItem({
    Key? key,
    required this.videoUrl,
  }) : super(key: key);

  @override
  State<VideoPlayerItem> createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late VideoPlayerController _videoPlayer;
  bool isPlay = false;

  @override
  void initState() {
    _videoPlayer = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((value) {
        _videoPlayer.setVolume(0.5);
      });
    super.initState();
  }

  @override
  void dispose() {
   
    _videoPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(
        children: [
          VideoPlayer(_videoPlayer),
          Align(
              alignment: Alignment.center,
              child: IconButton(
                  onPressed: () {
                    if (isPlay) {
                      _videoPlayer.pause();
                    } else {
                      _videoPlayer.play();
                    }
                    setState(() {
                      isPlay = !isPlay;
                    });
                  },
                  icon: isPlay
                      ? const Icon(Icons.pause_circle)
                      : const Icon(Icons.play_circle))),
        ],
      ),
    );
  }
}
