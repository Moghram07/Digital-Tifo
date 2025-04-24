import 'package:animate_do/animate_do.dart'; // For animation effects
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart'; // Import your SignUpPage
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // For navigation
import 'package:reproject/constants.dart';
import 'package:reproject/feature/SignInPage/sign_in_page.dart'; // Adjust the path to your file structure
import 'package:reproject/feature/SignUpPage/sign_up_page.dart';
import 'package:reproject/feature/bottomNavigation/bottom_navigation.dart';
import 'package:reproject/theme.dart';

import 'firebase_options.dart';

// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;

    return GetMaterialApp(
      // Use GetMaterialApp for navigation
      title: 'Our Tifo App',
      debugShowCheckedModeBanner: false, // Disable the debug banner
      theme: ThemeData(
        // primarySwatch: AppColors.,z
        scaffoldBackgroundColor: const Color.fromARGB(
          255,
          34,
          30,
          30,
        ), // Background color
      ),
      home:
          auth.currentUser == null
              ? MyHomePage()
              : BottomNavigationScreen(email: auth.currentUser!.email!),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool tonext = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: -80,
            left: -80,
            child: CircleAvatar(
              radius: 280,
              backgroundColor: AppColors.primary,
            ),
          ),
          // Positioned(
          //   bottom: -90,
          //   left: -120,
          //   child: CircleAvatar(
          //     radius: 100,
          //     backgroundColor: AppColors.primary,
          //   ),
          // ),
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Constants.horizontalPadding,
              ),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 50),
                  Image.asset(
                    'lib/assets/ourlogo.png',
                    // fit: BoxFit.fitHeight,
                    // height: 200,
                  ),
                  FadeIn(
                    // Fade-in effect for the welcome text
                    duration: const Duration(seconds: 2),
                    child: const Text(
                      "Welcome to Our Tifo!",
                      style: TextStyle(
                        fontSize: 30,
                        // color: Color.fromARGB(255, 0, 0, 0),
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 120),

                  // Spacer(),
                  FadeInLeft(
                    // Bounce-in effect for the Sign Up button
                    duration: const Duration(seconds: 1),
                    child: ElevatedButton(
                      onPressed: () {
                        // Action for Sign Up
                        Get.to(() => SignUpPage());
                      },
                      style: ElevatedButton.styleFrom(
                        // padding: const EdgeInsets.symmetric(
                        //   horizontal: 120,
                        //   vertical: 15,
                        // ),
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.buttontextcolor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  FadeInRight(
                    // Bounce-in effect for the Sign In button
                    duration: const Duration(seconds: 1),
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate to the SignInPage when the Sign In button is pressed
                        Get.to(() => SignInPage());
                      },
                      style: ElevatedButton.styleFrom(
                        // padding: const EdgeInsets.symmetric(
                        //   horizontal: 120,
                        //   vertical: 15,
                        // ),
                        backgroundColor: AppColors.primary,
                        // Solid red button
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.buttontextcolor,
                        ),
                      ),
                    ),
                  ),
                  // SizedBox(height: 150),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
