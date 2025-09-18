import 'package:flutter/material.dart';
import 'package:tiktok_like/constants.dart';

class TextInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final bool isObscure;
  final String label;

  const TextInputField({
    Key?key,required this.controller,
    required this.hintText,
    required this.icon,
    this.isObscure=false,
    required this.label}) : super(key:key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        labelText: label,
        labelStyle: const TextStyle(fontSize: 20),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: borderColor),
        
        ),
        ),
       obscureText: isObscure,
        );
  }     
}









      
  
  

