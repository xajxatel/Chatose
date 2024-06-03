import 'dart:io';

import 'package:enough_giphy_flutter/enough_giphy_flutter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Size getUserScreenSize(BuildContext context) {
  return MediaQuery.of(context).size;
}

const String defaultProfileImage =
    "https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png";

void showSnackBar({required BuildContext context, required String content}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(content)));
}

Future<File?> pickImageFromGallery(BuildContext context) async {
  File? image;
  try {
    final pickedimage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedimage != null) {
      image = File(pickedimage.path);
    }
  } catch (e) {
    showSnackBar(context: context, content: e.toString());
  }

  return image;
}

Future<File?> pickVideoFromGallery(BuildContext context) async {
  File? video;
  try {
    final pickedvideo =
        await ImagePicker().pickVideo(source: ImageSource.gallery);

    if (pickedvideo != null) {
      video = File(pickedvideo.path);
    }
  } catch (e) {
    showSnackBar(context: context, content: e.toString());
  }

  return video;
}

Future<GiphyGif?> pickGIF(BuildContext context) async {
  GiphyGif? gif;

  try {
    gif = await Giphy.getGif(
        context: context, apiKey: '56w37tsSBF6DWWXfCn069Cij7Tqr8mZ9');
  } catch (e) {
    showSnackBar(context: context, content: e.toString());
  }

  return gif;
}
