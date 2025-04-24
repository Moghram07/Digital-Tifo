import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reproject/constants.dart';
import 'package:reproject/feature/ForgetPassword/forget_password.dart';
import 'package:reproject/feature/SignUpPage/sign_up_page.dart';
import 'package:reproject/feature/bottomNavigation/bottom_navigation.dart';
import 'package:reproject/theme.dart'; // Import your HomePage

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool isLoading = false;

  Future<void> _login(BuildContext context) async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || !email.contains('@')) {
      showErrorDialog(context, "Please enter a valid email.");
      return;
    }

    if (password.isEmpty) {
      showErrorDialog(context, "Please enter your password.");
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      setState(() {
        isLoading = false;
      });
      Get.to(() => BottomNavigationScreen(email: email));
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("..................................");
      print(e.toString());
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'user-not-found':
            showErrorDialog(context, "No user found for that email.");
            break;
          case 'wrong-password':
            showErrorDialog(context, "Incorrect password. Please try again.");
            break;
          case 'invalid-email':
            showErrorDialog(context, "The email address is not valid.");
            break;
          case 'user-disabled':
            showErrorDialog(context, "This user has been disabled.");
            break;
          case 'too-many-requests':
            showErrorDialog(
              context,
              "Too many login attempts. Try again later.",
            );
            break;
          case 'operation-not-allowed':
            showErrorDialog(
              context,
              "Email/password accounts are not enabled.",
            );
            break;
          default:
            print(e);

            showErrorDialog(
              context,
              "An unknown error occurred. Please try again.",
            );
        }
      } else {
        setState(() {
          isLoading = false;
        });
        showErrorDialog(context, "An error occurred. Please try again.");
      }
    }
  }

  void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  foregroundColor: Colors.white,
                  backgroundColor: AppColors.primary,
                  // minimumSize: Size(screenWidth * 0.8, 50),
                ),
                child: const Text(
                  "OK",
                  style: TextStyle(color: AppColors.buttontextcolor),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   leading: GestureDetector(
      //     onTap: () {
      //       Get.back();
      //     },
      //     child: Icon(Icons.arrow_back, color: Colors.white),
      //   ),
      //   title: Text(
      //     "Sign In",
      //     style: TextStyle(
      //       fontSize: 25,
      //       color: AppColors.textcolorforgreenbg,
      //       fontWeight: FontWeight.w700,
      //     ),
      //   ),
      //   backgroundColor: AppColors.primary,
      // ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            // SizedBox(height: 400),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Constants.horizontalPadding,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                      ),
                      Image.asset('lib/assets/ourlogo.png', height: 240),
                      const SizedBox(height: 0),
                      // const Text(
                      //   "Welcome to Our Tifo!",
                      //   style: TextStyle(
                      //     fontSize: 18,
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      //   textAlign: TextAlign.center,
                      // ),
                      // const SizedBox(height: 20),
                      // Text(
                      //   "Please Sign In here",
                      //   style: TextStyle(fontSize: 20, color: Colors.grey[700]),
                      //   textAlign: TextAlign.center,
                      // ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          hintText: 'Email',
                          filled: true,
                          fillColor: const Color.fromARGB(255, 219, 219, 219),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          filled: true,
                          fillColor: AppColors.textfieldfillcolor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            Get.to(() => ForgetPassword());
                          },
                          child: const Text(
                            "Forgot Password?",
                            style: TextStyle(
                              fontSize: 16,
                              color: Color.fromARGB(255, 17, 126, 216),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      isLoading
                          ? CircularProgressIndicator(color: AppColors.primary)
                          : ElevatedButton(
                            onPressed: () {
                              _login(context);
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              foregroundColor: Colors.white,
                              backgroundColor: AppColors.primary,
                              minimumSize: const Size(double.infinity, 50),
                            ),
                            child: const Text(
                              'Sign In',
                              style: TextStyle(
                                color: AppColors.buttontextcolor,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          // Uncomment when the SignUpPage is ready
                          Get.to(() => SignUpPage());
                        },
                        child: RichText(
                          text: TextSpan(
                            children: [
                              //
                              TextSpan(
                                text: 'Dont have an account? ',
                                style: TextStyle(
                                  color: AppColors.textcolorforwhhitebg,
                                ),
                              ),
                              TextSpan(
                                text: 'SignUp',

                                style: TextStyle(
                                  // decoration: TextDecoration.underline,
                                  color: AppColors.primary,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
