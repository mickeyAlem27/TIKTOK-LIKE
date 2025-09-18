import 'package:flutter/material.dart';
import 'package:tiktok_like/Controllers/auth_controller.dart';

import 'package:tiktok_like/constants.dart';
import 'package:tiktok_like/views/screens/auth/login_screen.dart';
import 'package:tiktok_like/views/widgets/text_input_field.dart';
class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  final TextEditingController _usernamecontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'TIKTOK LIKE',
              style: TextStyle(
                fontSize: 25,
                color: buttonColor,
                fontWeight: FontWeight.w900,
              ),
            ),
            const Text(
              'Register ',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
            ),

            const SizedBox(height: 15),

           Stack(
              children: [
                const CircleAvatar(
                  radius: 64,
                  backgroundImage: NetworkImage(
                      'https://www.pngitem.com/pimgs/m/150-1503945_transparent-user-png-default-user-image-png-png.png'),
                  backgroundColor: Colors.black,
                ),
                Positioned(
                  bottom: -10,
                  left: 80,
                  child: IconButton(
                    onPressed: () => authController.pickImage(),
                    icon: const Icon(
                      Icons.add_a_photo,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: TextInputField(
                controller: _usernamecontroller,
                hintText: 'Password',
                icon: Icons.person,
                label: 'username',
              ),
            ),
              const SizedBox(height: 25),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: TextInputField(
                controller: _emailcontroller,
                hintText: 'Email',
                icon: Icons.email,
                label: 'Email',
              ),
            ),
            const SizedBox(height:25),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: TextInputField(
                controller: _passwordcontroller,
                hintText: 'Password',
                icon: Icons.lock,
                label: 'Password',
                isObscure: true,
              ),
            ),

            const SizedBox(height: 25),

            Container(
              width: MediaQuery.of(context).size.width - 40,
              height: 50,
              decoration: BoxDecoration(color: buttonColor),
              child: InkWell(
                onTap: () =>authController.registerUser(
                  _usernamecontroller.text,
                  _emailcontroller.text,
                  _passwordcontroller.text,
                 authController.profilePhoto
                ),

                child: const Center(
                  child: Text(
                    'Register',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Already have an account? ',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                  ),
                  child: Text(
                    'Login',
                    style: TextStyle(fontSize: 20, color: buttonColor),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
