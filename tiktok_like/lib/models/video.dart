import 'package:cloud_firestore/cloud_firestore.dart';

class Video {
  String username;
  String uid;
  String id;
  List like;
  int commentCount;
  int shareCount;
  String songName;
  String caption;
  String videoUrl;
  String thumbnail;
  String profilePhoto;

  Video({
    required this.username,
    required this.uid,
    required this.id,
    required this.like,
    required this.commentCount,
    required this.shareCount,
    required this.songName,
    required this.caption,
    required this.videoUrl,
    required this.thumbnail,
    required this.profilePhoto,
  });
  Map<String, dynamic > toJson() =>{
    "username":username,
    "uid":uid,
    "id":id,
    "like":like,
    "commentCount":commentCount,
    "shareCount":shareCount,
    "songName":songName,
    "caption":caption,
    "videoUrl":videoUrl,
    "thumbnail":thumbnail,
    "profilePhoto":profilePhoto,
  };
  static Video fromSnap(DocumentSnapshot snap){
    var snapData = snap.data() as Map<String,dynamic>;
   
   return Video (
  username:snapData['username'],
   uid:snapData['uid'],
   id:snapData['id'],
   like:snapData['like'],
   commentCount:snapData['commentCount'],
   shareCount:snapData['shareCount'],
   songName:snapData['songName'],
   caption:snapData['caption'],
   videoUrl:snapData['videoUrl'],
   thumbnail:snapData['thumbnail'],
   profilePhoto:snapData['profilePhoto'],);
    
  }
}
