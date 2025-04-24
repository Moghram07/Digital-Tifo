import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reproject/theme.dart';
import 'package:video_player/video_player.dart';

class HomePage extends StatefulWidget {
  final String email;

  const HomePage({super.key, required this.email});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late VideoPlayerController _controller;
  final Color primaryColor = const Color(0xFF90C02A);
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.blue,
        statusBarBrightness: Brightness.dark,
        systemStatusBarContrastEnforced: true,
        // systemNavigationBarColor: Colors.purple,
      ),
    );
    _controller = VideoPlayerController.asset('lib/assets/intro.mp4')
      ..initialize().then((_) {
        _controller.setVolume(0.0);
        _controller.play();
        _controller.setLooping(true);
        setState(() {});
      });

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_animationController);
    _animationController.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F4F4),
        // appBar: AppBar(
        //   systemOverlayStyle: SystemUiOverlayStyle(
        //     statusBarColor: AppColors.primary,
        //   ),
        //   automaticallyImplyLeading: false,
        //   centerTitle: true,
        //   backgroundColor: Colors.white,
        //   // foregroundColor: Colors.white,
        //   // flexibleSpace: Container(
        //   //   decoration: const BoxDecoration(
        //   //     gradient: LinearGradient(
        //   //       colors: [Color(0xFF90C02A), Color(0xFF6FA822)],
        //   //       begin: Alignment.topLeft,
        //   //       end: Alignment.bottomRight,
        //   //     ),
        //   //   ),
        //   // ),
        //   elevation: 8,
        //   title: const Text(
        //     "Home",
        //     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        //   ),
        //   // actions: [
        //   //   TextButton.icon(
        //   //     icon: const Icon(Icons.account_circle, color: Colors.white),
        //   //     label: Text(
        //   //       widget.email,
        //   //       style: const TextStyle(color: Colors.white),
        //   //     ),
        //   //     onPressed: () {
        //   //       // Get.snackbar("Logged in as", widget.email);
        //   //     },
        //   //   ),
        //   // ],
        // ),
        // drawer: Drawer(
        //   backgroundColor: Colors.black,
        //   child: ListView(
        //     padding: EdgeInsets.zero,
        //     children: [
        //       DrawerHeader(
        //         decoration: BoxDecoration(
        //           gradient: LinearGradient(colors: [primaryColor, Colors.green.shade700]),
        //         ),
        //         child: Column(
        //           mainAxisAlignment: MainAxisAlignment.center,
        //           children: [
        //             const Text(
        //               'Digital Tifo',
        //               style: TextStyle(fontSize: 26, color: Colors.white, fontWeight: FontWeight.bold),
        //             ),
        //             const SizedBox(height: 10),
        //             CircleAvatar(radius: 40, backgroundImage: const AssetImage('lib/assets/ourlogo.png')),
        //           ],
        //         ),
        //       ),
        //       _buildDrawerItem(Icons.flag, 'Tifo', () => Get.to(() => TifoPage(email: widget.email))),
        //       _buildDrawerItem(Icons.music_note, 'Lyrical', () => Get.to(() => LyricalPage(email: widget.email))),
        //       _buildDrawerItem(Icons.extension, 'Puzzle', () => Get.to(() => PuzzlePage(email: widget.email))),
        //       _buildDrawerItem(Icons.schedule, 'Fixtures', () => Get.to(() => FixturePage(email: widget.email))),
        //       _buildDrawerItem(Icons.people, 'Teams', () => Get.to(() => TeamsPages(email: widget.email))),
        //       _buildDrawerItem(Icons.confirmation_number, 'Tickets', () => Get.to(() => TicketsPage(email: widget.email))),
        //       const Divider(color: Colors.white54),
        //       _buildDrawerItem(Icons.logout, 'Sign Out', () => Get.offAll(() =>  SignInPage())),
        //     ],
        //   ),
        // ),
        body: SingleChildScrollView(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                const SizedBox(height: 10),
                Hero(
                  tag: 'logo',
                  child: Image.asset('lib/assets/ourlogo.png', height: 200),
                ),
                // const SizedBox(height: 20),
                const Text(
                  "Welcome to Our Tifo!",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child:
                      _controller.value.isInitialized
                          ? ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: AspectRatio(
                              aspectRatio: _controller.value.aspectRatio,
                              child: VideoPlayer(_controller),
                            ),
                          )
                          : const SizedBox(
                            height: 200,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                ),
                const SizedBox(height: 20),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 20.0),
                //   child: Align(
                //     alignment: Alignment.centerLeft,
                //     child: const Text(
                //       "Featured",
                //       style: TextStyle(
                //         fontSize: 20,
                //         fontWeight: FontWeight.bold,
                //         color: Colors.black87,
                //       ),
                //       textAlign: TextAlign.start,
                //     ),
                //   ),
                // ),
                // const SizedBox(height: 10),

                // _buildFeatureRow(),
                // const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget _buildDrawerItem(IconData icon, String text, VoidCallback onTap) {
  //   return ListTile(
  //     leading: Icon(icon, color: primaryColor),
  //     title: Text(
  //       text,
  //       style: const TextStyle(color: Colors.white, fontSize: 16),
  //     ),
  //     onTap: onTap,
  //   );
  // }

  Widget _buildFeatureRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _glassFeatureCard(
            title: "Best Player",
            imagePath: 'lib/assets/ronaldo.jpg',
          ),
          _glassFeatureCard(
            title: "tel:@luckyman19930026",
            imagePath: 'lib/assets/quiz.png',
          ),
          _glassFeatureCard(
            title: "Best Coach",
            imagePath: 'lib/assets/tifoplayer.jpg',
          ),
        ],
      ),
    );
  }

  Widget _glassFeatureCard({required String title, required String imagePath}) {
    return Container(
      width: 100,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.asset(
              imagePath,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            width: 100,
            height: 40,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.9),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(16),
              ),
            ),
            child: Center(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// // import 'package:reproject/feature/Fixture/fixture_page.dart';
// import 'package:video_player/video_player.dart';
//
// import '../FixturePage/fixture_page.dart';
// import '../LyricalPage/lyrical_page.dart';
// import '../PuzzlePage/puzzle_page.dart';
// import '../SignInPage/sign_in_page.dart';
// import '../TeamsPage/team_page.dart';
// import '../TicketsPage/tickets_page.dart';
// import '../TifoPage/tifo_page.dart';
// // import 'package:reproject/feature/Quiz/quiz_page.dart';
//
// class HomePage extends StatefulWidget {
//   final String email; // Add email parameter
//
//   const HomePage({super.key, required this.email}); // Receive the email
//
//   @override
//   _HomePageState createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   late VideoPlayerController _controller;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.asset('lib/assets/intro.mp4')
//       ..initialize().then((_) {
//         _controller.setVolume(0.0); // Mute the video
//         _controller.play();
//         _controller.setLooping(true);
//         setState(() {});
//       });
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "Dashboard",
//           style: TextStyle(fontSize: 20, color: Colors.white),
//         ),
//         backgroundColor: Colors.deepPurple,
//         // backgroundColor: const Color.fromARGB(255, 11, 79, 14),
//         actions: [
//           // Add a button to show the logged-in user's email
//           TextButton.icon(
//             icon: const Icon(Icons.account_circle, color: Colors.white),
//             label: Text(
//               widget.email, // Show the user's email
//               style: const TextStyle(color: Colors.white),
//             ),
//             onPressed: () {
//               Get.snackbar("Logged in as ", widget.email);
//             },
//           ),
//         ],
//       ),
//       drawer: Drawer(
//         child: Container(
//           color: const Color.fromRGBO(28, 34, 45, 1),
//           child: ListView(
//             children: [
//               const DrawerHeader(
//                 decoration: BoxDecoration(
//                   color: Color.fromRGBO(28, 34, 45, 1)
//                 ),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       'Digital Tifo',
//                       style: TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                     SizedBox(height: 10),
//                     CircleAvatar(
//                       radius: 40,
//                       backgroundImage: AssetImage('lib/assets/ourlogo.png'),
//                     ),
//                   ],
//                 ),
//               ),
//               _buildDrawerItem(
//                 icon: Icons.home,
//                 text: 'HomePage',
//                 onTap: () {
//                   Get.to(() => HomePage(email: widget.email));
//                 },
//               ),
//               _buildDrawerItem(
//                 icon: Icons.flag,
//                 text: 'Tifo',
//                 onTap: () {
//                   Get.to(() => TifoPage(email: widget.email));
//                 },
//               ),
//                _buildDrawerItem(
//                 icon: Icons.music_note_sharp,
//                 text: 'Lyrical',
//                 onTap: () {
//                   Get.to(() => LyricalPage(email: widget.email));
//                 },
//               ),
//               _buildDrawerItem(
//                 icon: Icons.question_mark_rounded,
//                 text: 'Puzzle',
//                 onTap: () {
//                   Get.to(() => PuzzlePage(
//                       email: widget.email)); // Add navigation to Fantasy page
//                 },
//               ),
//               _buildDrawerItem(
//                 icon: Icons.schedule_send,
//                 text: 'Fixtures',
//                 onTap: () {
//                   Get.to(() => FixturePage(email: widget.email));
//                 },
//               ),
//               _buildDrawerItem(
//                 icon: Icons.people,
//                 text: 'Teams',
//                 onTap: () {
//                   Get.to(() => TeamsPages(email: widget.email));
//                 },
//               ),
//               _buildDrawerItem(
//                 icon: Icons.confirmation_number,
//                 text: 'Tickets',
//                 onTap: () {
//                   Get.to(() => TicketsPage(email: widget.email));
//                 },
//               ),
//               const Divider(),
//               _buildDrawerItem(
//                 icon: Icons.logout,
//                 text: 'Sign Out',
//                 onTap: () {
//                   Get.to(() => SignInPage()); // Add Sign Out logic
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//       body: Container(
//         color: Colors.white,
//         height:  MediaQuery.of(context).size.height,
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(20, 30, 20, 10),
//                 child: Image.asset('lib/assets/ourlogo.png', height: 120),
//               ),
//               const Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                 child: Text(
//                   "Welcome to Our Tifo!",
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                     color: Color.fromARGB(255, 0, 0, 0),
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 30),
//                 child: _controller.value.isInitialized
//                     ? AspectRatio(
//                         aspectRatio: _controller.value.aspectRatio,
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(15),
//                           child: VideoPlayer(_controller),
//                         ),
//                       )
//                     : const SizedBox(
//                         height: 200,
//                         child: Center(child: CircularProgressIndicator()),
//                       ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 30),
//                 child: OverflowBar(
//                   alignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     _buildFeatureButton(
//                       'Best Player',
//                       'lib/assets/ronaldo.jpg',
//                       () {
//                         //Get.to(() => LivePage());
//                       },
//                     ),
//                     _buildFeatureButton(
//                       'tel:@luckyman19930026',
//                       'lib/assets/quiz.png',
//                       () {
//                         //Get.to(() => LivePage());
//                       },
//                     ),
//                     _buildFeatureButton(
//                       'Best Coach',
//                       'lib/assets/tifoplayer.jpg',
//                       () {
//                         //Get.to(() => QuizPage(email: widget.email));
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDrawerItem(
//       {required IconData icon,
//       required String text,
//       required VoidCallback onTap}) {
//     return ListTile(
//       leading: Icon(icon, color: Color.fromRGBO(255, 255, 255, 0.9)),
//       title: Text(
//         text,
//         style: const TextStyle(color: Color.fromRGBO(255, 255, 255, 0.9),
//         fontSize: 16, // Adjust size as needed
//         fontWeight: FontWeight.bold,
//         ),
//       ),
//       onTap: onTap,
//     );
//   }
//
//   Widget _buildFeatureButton(
//       String title, String imagePath, VoidCallback onTap) {
//     return Column(
//       children: [
//         Image.asset(imagePath, width: 100, height: 100),
//         Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(15),
//             gradient: const LinearGradient(
//               colors: [Colors.yellow, Colors.orange],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//           width: 160,
//           margin: const EdgeInsets.symmetric(vertical: 10),
//           child: TextButton(
//             onPressed: onTap,
//             child: Text(
//               title,
//               style: const TextStyle(color: Colors.black, fontSize: 16),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
