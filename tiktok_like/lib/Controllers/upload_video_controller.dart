import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:tiktok_like/constants.dart';
import 'package:tiktok_like/models/video.dart';
import 'package:video_compress/video_compress.dart';

// Toggle: if false, we bypass Firebase Storage and write directly to Firestore only.
const bool kUseStorageForVideos = false;

class UploadVideoController extends GetxController {
  _compressVideo(String videoPath) async {
    final compressedVideo = await VideoCompress.compressVideo(
      videoPath,
      quality: VideoQuality.MediumQuality,
    );
    return compressedVideo!.file;
  }

  Future<String> _uploadVideoToStorage(String id, String videoPath) async {
    Reference ref = firebaseStorage.ref().child('videos').child(id);

    UploadTask uploadTask = ref.putFile(await _compressVideo(videoPath));
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  _getThumbnail(String videoPath) async {
    final thumbnail = await VideoCompress.getFileThumbnail(videoPath);
    return thumbnail;
  }

  Future<String> _uploadImageToStorage(String id, String videoPath) async {
    Reference ref = firebaseStorage.ref().child('thumbnails').child(id);
    UploadTask uploadTask = ref.putFile(await _getThumbnail(videoPath));
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  // upload video
  uploadVideo(String songName, String caption, String videoPath) async {
    try {
      if (firebaseAuth.currentUser == null) {
        Get.snackbar('Error Uploading Video', 'User is not logged in');
        return;
      }

      final String uid = firebaseAuth.currentUser!.uid;

      // fetch current user doc (for username & profilePhoto)
      final DocumentSnapshot userDoc = await firestore
          .collection('users')
          .doc(uid)
          .get();

      // generate a new doc ref to avoid needing read permission on the collection
      final docRef = firestore.collection('videos').doc();
      final String newId = docRef.id;

      String videoUrl = '';
      String thumbnail = '';

      if (kUseStorageForVideos) {
        // upload assets when storage is enabled
        videoUrl = await _uploadVideoToStorage(newId, videoPath);

        try {
          thumbnail = await _uploadImageToStorage(newId, videoPath);
        } catch (e) {
          // proceed even if thumbnail generation fails
          thumbnail = '';
          // ignore: avoid_print
          print('Thumbnail generation/upload failed: $e');
        }
      } else {
        // Firestore-only path (no storage): keep placeholders
        videoUrl = '';
        thumbnail = '';
      }

      // safe extraction with fallbacks if user document is missing
      final Map<String, dynamic> userMap =
          (userDoc.data() as Map<String, dynamic>?) ?? <String, dynamic>{};
      final String username = (userMap['name'] as String?) ?? 'Unknown';
      final String profilePhoto = (userMap['profilePhoto'] as String?) ??
          'https://www.pngitem.com/pimgs/m/150-1503945_transparent-user-png-default-user-image-png-png.png';

      Video video = Video(
        username: username,
        uid: uid,
        id: newId,
        likes: [],
        commentCount: 0,
        shareCount: 0,
        songName: songName,
        caption: caption,
        videoUrl: videoUrl,
        profilePhoto: profilePhoto,
        thumbnail: thumbnail,
      );

      await docRef.set(video.toJson());
      Get.back();
      Get.snackbar('Success', 'Video uploaded successfully');
    } catch (e) {
      Get.snackbar('Error Uploading Video', e.toString());
    }
  }
}
