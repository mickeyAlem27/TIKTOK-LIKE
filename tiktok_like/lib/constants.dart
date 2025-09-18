import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:tiktok_like/Controllers/auth_controller.dart';
import 'package:tiktok_like/views/screens/auth/add_video_screen.dart';

const pages = [
 Text('HomeScreen'),
  Text('SearchScreen'),
  AddVideoScreen(),
  Text('ProfileScreen'),
  Text('MessageScreen'),
];
// COLORS
const backgroundColor = Colors.black;
var buttonColor = Colors.red[400];
const borderColor = Colors.grey;

//Firebase
var firebaseAuth = FirebaseAuth.instance;
var firebaseStorage = FirebaseStorage.instance;
var firestore = FirebaseFirestore.instance;

  // controller 
  var authController = AuthController.instance;
