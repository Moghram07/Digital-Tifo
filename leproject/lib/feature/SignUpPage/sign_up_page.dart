import 'package:firebase_auth/firebase_auth.dart'; // Firebase Auth import
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reproject/constants.dart';
import 'package:reproject/feature/SignInPage/sign_in_page.dart';
import 'package:reproject/theme.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  bool isLoading = false;

  // Firebase Auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // This function validates the email format using a regular expression.
  bool _validateEmail(String email) {
    String pattern =
        r'^[a-zA-Z0-9._%+-]+@[a-zAZ0-9.-]+\.[a-zA-Z]{2,}$'; // Basic email format
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(email);
  }

  // This function validates the phone number format using a regex.
  bool _validatePhoneNumber(String phone) {
    String pattern = r'^\+?[1-9]\d{1,14}$'; // Basic international phone format
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(phone);
  }

  // Firebase sign-up method
  Future<void> _signUp(BuildContext context) async {
    // Prepare the data
    String fullName = fullNameController.text;
    String email = emailController.text;
    String password = passwordController.text;
    String country = countryController.text;
    String phone = phoneController.text;

    // Validate the email format before proceeding
    if (!_validateEmail(email)) {
      _showDialog(
        context,
        "Invalid Email",
        "Please enter a valid email address.",
      );
      return;
    }

    // Validate the phone number format before proceeding
    if (!_validatePhoneNumber(phone)) {
      _showDialog(
        context,
        "Invalid Phone Number",
        "Please enter a valid phone number.",
      );
      return;
    }

    setState(() {
      isLoading = true; // Set loading to true
    });

    try {
      // Create user using Firebase Authentication
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      // If sign up is successful, show a success message
      setState(() {
        isLoading = false;
      });

      _showDialog(context, "Success", "User registered successfully!");
      Get.to(() => SignInPage()); // Navigate to Sign In Page

      // Optionally, you can also store additional user data (name, phone, country) in Firestore or Realtime Database here.
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });

      // Handle FirebaseAuthException (e.g., email already in use, weak password, etc.)
      if (e.code == 'weak-password') {
        setState(() {
          isLoading = false;
        });
        _showDialog(context, "Weak Password", "The password is too weak.");
      } else if (e.code == 'email-already-in-use') {
        setState(() {
          isLoading = false;
        });
        _showDialog(
          context,
          "Email Already In Use",
          "An account already exists for that email.",
        );
      } else {
        setState(() {
          isLoading = false;
        });
        _showDialog(context, "Error", e.message ?? "Something went wrong.");
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      _showDialog(
        context,
        "Error",
        "Failed to connect to the server. Try again later.",
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Helper method to show a dialog
  void _showDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(title),
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
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    countryController.dispose();
    phoneController.dispose();
    super.dispose();
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
      //     "Sign Up",
      //     style: TextStyle(
      //       fontSize: 25,
      //       color: AppColors.textcolorforgreenbg,
      //       fontWeight: FontWeight.w700,
      //     ),
      //   ),
      //   backgroundColor: AppColors.primary,
      // ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double screenWidth = constraints.maxWidth;
          double screenHeight = constraints.maxHeight;

          return Container(
            width: screenWidth,
            height: screenHeight,
            color: Colors.white,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      color: Colors.white,
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
                          // const SizedBox(height: 20),
                          // Text(
                          //   "Please Sign In here",
                          //   style: TextStyle(
                          //     fontSize: 20,
                          //     color: Colors.grey[700],
                          //   ),
                          //   textAlign: TextAlign.center,
                          // ),
                          // const SizedBox(height: 20),
                          // const Text(
                          //   "Create an account by filling out the form below",
                          //   style: TextStyle(fontSize: 16, color: Colors.grey),
                          //   textAlign: TextAlign.center,
                          // ),
                          const SizedBox(height: 20),
                          _buildTextField(fullNameController, 'Full Name'),
                          const SizedBox(height: 10),
                          _buildTextField(emailController, 'Email'),
                          const SizedBox(height: 10),
                          _buildTextField(
                            passwordController,
                            'Password',
                            obscureText: true,
                          ),
                          const SizedBox(height: 10),
                          _buildTextField(countryController, 'Country'),
                          const SizedBox(height: 10),
                          _buildTextField(phoneController, 'Phone Number'),
                          const SizedBox(height: 20),
                          isLoading
                              ? const CircularProgressIndicator(
                                color: AppColors.primary,
                              )
                              : ElevatedButton(
                                onPressed: () {
                                  _signUp(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  foregroundColor: Colors.white,
                                  backgroundColor: AppColors.primary,
                                  minimumSize: Size(screenWidth * 0.8, 50),
                                ),
                                child: const Text(
                                  'Sign Up',
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
                              Get.to(() => SignInPage());
                            },
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  //
                                  TextSpan(
                                    text: 'Already have a account? ',
                                    style: TextStyle(
                                      color: AppColors.textcolorforwhhitebg,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'SignIn',

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
          );
        },
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hintText, {
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: AppColors.textfieldfillcolor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
