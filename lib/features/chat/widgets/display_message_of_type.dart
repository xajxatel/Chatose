// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:audioplayers/audioplayers.dart';
import 'package:chatose/features/chat/widgets/video_player_item.dart';
import 'package:flutter/material.dart';

import 'package:chatose/common/enums/message_enum.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DisplayMessageOfType extends StatelessWidget {
  final String message;
  final MessageEnum type;
  Color? fontColor = Colors.white;
  DisplayMessageOfType({
    Key? key,
    required this.message,
    required this.type,
    this.fontColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isPlaying = false;
    final AudioPlayer audioPlayer = AudioPlayer();

    return type == MessageEnum.text
        ? Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: fontColor,
            ),
          )
        : type == MessageEnum.gif
            ? CachedNetworkImage(imageUrl: message)
            : type == MessageEnum.audio
                ? StatefulBuilder(builder: (context, setState) {
                    return IconButton(
                        constraints: const BoxConstraints(minWidth: 70),
                        onPressed: () async {
                          if (isPlaying) {
                            audioPlayer.pause();
                          } else {
                            audioPlayer.play(UrlSource(message));
                          }
                          setState(
                            () {
                              isPlaying = !isPlaying;
                            },
                          );
                        },
                        icon: Icon(isPlaying
                            ? Icons.pause_circle
                            : Icons.play_arrow_rounded));
                  })
                : type == MessageEnum.video
                    ? VideoPlayerItem(videoUrl: message)
                    : CachedNetworkImage(imageUrl: message);
  }
}
