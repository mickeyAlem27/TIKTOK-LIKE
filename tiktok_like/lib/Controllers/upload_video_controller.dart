import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'dart:io';

import 'package:tiktok_like/constants.dart';
import 'package:tiktok_like/models/video.dart';
import 'package:video_compress/video_compress.dart';


class UploadVideoController extends GetxController {
_compressVideo(String videopath) async {
  final compressedVideo = await VideoCompress.compressVideo(
    videopath,
    quality: VideoQuality.MediumQuality,
  );
  return compressedVideo!.file;
}

Future<String> _uploadVideoToStorage(String id, String videopath) async {
  Reference ref = firebaseStorage.ref().child("videos").child(id);
  UploadTask uploadTask = ref.putFile(await _compressVideo(videopath));
  TaskSnapshot snap = await uploadTask;
  String downloadUrl = await snap.ref.getDownloadURL();
  return downloadUrl;
}

_getThumbnail(String videopath) async {
  final thumbnail = await VideoCompress.getFileThumbnail(videopath);
  return thumbnail;
}

Future<String> _uploadImageToStorage(String id, String imagepath) async {
  Reference ref = firebaseStorage.ref().child("thumbnails").child(id);
  UploadTask uploadTask = ref.putFile(await _getThumbnail(imagepath));
  TaskSnapshot snap = await uploadTask;
  String downloadUrl = await snap.ref.getDownloadURL();
  return downloadUrl;
}

//upload video function
uploadVideo(String songName, String caption, String videopath) async {
  try {
    String uid = firebaseAuth.currentUser!.uid;
    DocumentSnapshot userDoc = await firestore
        .collection('users')
        .doc(uid)
        .get();
    //get id
    var allDocs = await firestore.collection('videos').get();
    int len = allDocs.docs.length;
    String videoUrl = await _uploadVideoToStorage("Video $len", videopath);
    String thumbnail = await _uploadImageToStorage("Image $len", videopath);

    Video video = Video(
      username: (userDoc.data()! as Map<String, dynamic>)['name'],
      uid: uid,
      id: "Video $len",
      like: [],
      commentCount: 0,
      shareCount: 0,
      songName: songName,
      caption: caption,
      videoUrl: videoUrl,
      thumbnail: thumbnail,
      profilePhoto: (userDoc.data()! as Map<String, dynamic>)['profilePhoto'],
    );
    await firestore.collection('videos').doc('Video $len').set(video.toJson());
    Get.back();
    Get.snackbar("Success", "Video uploaded successfully");
  } catch (e) {
    Get.snackbar("Error uploading video", e.toString());
  }
}

// // GetX Controller wrapper to be used from UI code
// class UploadVideoController extends GetxController {
//   Future<void> uploadVideo(String songName, String caption, String videopath) async {
//     try {
//       final String uid = firebaseAuth.currentUser!.uid;
//       final DocumentSnapshot userDoc = await firestore.collection('users').doc(uid).get();

//       final allDocs = await firestore.collection('videos').get();
//       final int len = allDocs.docs.length;

//       final String videoUrl = await _uploadVideoToStorage("Video $len", videopath);
//       final String thumbnail = await _uploadImageToStorage("Image $len", videopath);

//       final video = Video(
//         username: (userDoc.data()! as Map<String, dynamic>)['name'],
//         uid: uid,
//         id: "Video $len",
//         like: [],
//         commentCount: 0,
//         shareCount: 0,
//         songName: songName,
//         caption: caption,
//         videoUrl: videoUrl,
//         thumbnail: thumbnail,
//         profilePhoto: (userDoc.data()! as Map<String, dynamic>)['profilePhoto'],
//       );

//       await firestore.collection('videos').doc('Video $len').set(video.toJson());
//       Get.back();
//       Get.snackbar("Success", "Video uploaded successfully");
//     } catch (e) {
//       Get.snackbar("Error uploading video", e.toString());
//     }
//   }
// }

}