import 'dart:io';

import 'package:chatose/common/enums/message_enum.dart';
import 'package:chatose/common/providers/message_reply_provider.dart';
import 'package:chatose/common/utils/utils.dart';
import 'package:chatose/features/chat/controller/chat_controller.dart';
import 'package:chatose/features/chat/widgets/message_reply_preview.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class BottomChatField extends ConsumerStatefulWidget {
  final String receiverUserId;
  const BottomChatField({super.key, required this.receiverUserId});

  @override
  ConsumerState<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends ConsumerState<BottomChatField> {
  bool isShowSendButton = false;
  FlutterSoundRecorder? _soundRecorder;
  bool isRecorderInitialized = false;
  bool isRecording = false;
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    _soundRecorder = FlutterSoundRecorder();
    super.initState();
    openAudio();
  }

  void openAudio() async {
    final permissionStatus = await Permission.microphone.request();

    if (permissionStatus != PermissionStatus.granted) {
      throw RecordingPermissionException('Mic permission denied');
    }
    await _soundRecorder!.openRecorder();
    isRecorderInitialized = true;
  }

  void sendTextMessage() async {
    if (isShowSendButton) {
      ref.read(chatControllerProvider).sentTextMessage(
          context, _messageController.text.trim(), widget.receiverUserId);

      setState(() {
        _messageController.clear();
        isShowSendButton = false;
      });
    } else {
      if (!isRecorderInitialized) return;

      var tempDir = await getTemporaryDirectory();
      var path = "${tempDir.path}/flutter_sound.aac";
      if (isRecording) {
        await _soundRecorder!.stopRecorder();
        sendFileMessage(MessageEnum.audio, File(path));
      } else {
        await _soundRecorder!.startRecorder(toFile: path);
      }

      setState(() {
        isRecording = !isRecording;
      });
    }
  }

  void sendFileMessage(MessageEnum messageEnum, File file) async {
    ref.read(chatControllerProvider).sentFileMessage(
        context: context,
        file: file,
        messageEnum: messageEnum,
        receiverUserId: widget.receiverUserId);
  }

  void selectImage() async {
    File? image;

    image = await pickImageFromGallery(context);

    if (image != null) {
      sendFileMessage(MessageEnum.image, image);
    }
  }

  void selectVideo() async {
    File? video;

    video = await pickVideoFromGallery(context);

    if (video != null) {
      sendFileMessage(MessageEnum.video, video);
    }
  }

  void selectGIF() async {
    final gif = await pickGIF(context);

    if (gif != null) {
      ref.read(chatControllerProvider).sendGIFMessage(
          context: context,
          gifUrl: gif.url,
          receiverUserId: widget.receiverUserId);
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _soundRecorder!.closeRecorder();
    isRecorderInitialized = false;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messageReply = ref.watch(messageReplyProvider);
    final isShowMessageReply = messageReply != null;
    return Column(
      children: [
        isShowMessageReply ? const MessageReplyPreview() : const SizedBox(),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: TextField(
                  controller: _messageController,
                  onChanged: (value) {
                    setState(() {
                      if (value.isEmpty) {
                        isShowSendButton = false;
                      } else {
                        isShowSendButton = true;
                      }
                    });
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.black45,
                    prefixIcon: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: IconButton(
                          onPressed: selectGIF,
                          icon: const Icon(
                            Icons.gif,
                            color: Colors.grey,
                          )),
                    ),
                    suffixIcon: SizedBox(
                      width: 200,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: selectImage,
                            icon: const Icon(
                              Icons.camera_alt,
                              color: Colors.grey,
                            ),
                          ),
                          IconButton(
                            onPressed: selectVideo,
                            icon: const Icon(
                              Icons.videocam,
                              color: Colors.grey,
                            ),
                          ),
                          IconButton(
                            onPressed: sendTextMessage,
                            icon: Icon(
                              isShowSendButton
                                  ? Icons.send
                                  : isRecording
                                      ? Icons.stop
                                      : Icons.mic,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    hintText: 'Type a message!',
                    border: const OutlineInputBorder(
                      borderSide: const BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
