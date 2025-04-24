import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../CameraWidget/camera_widget.dart';

class TifoPage extends StatefulWidget {
  final String email;

  const TifoPage({super.key, required this.email});

  @override
  _TifoPageState createState() => _TifoPageState();
}

class _TifoPageState extends State<TifoPage> {
  late VideoPlayerController _villiarsController;

  @override
  void initState() {
    super.initState();
    _villiarsController = VideoPlayerController.asset(
      'lib/assets/Villiars.mp4',
    );
  }

  @override
  void dispose() {
    _villiarsController.dispose();
    super.dispose();
  }

  void _handlePictureTaken(String path) {
    print("Picture taken at: $path");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C222D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF90C02A),
        centerTitle: true,
        foregroundColor: Colors.white,
        title: const Text(
          "Digital Tifo",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        // actions: [
        //   TextButton.icon(
        //     icon: const Icon(Icons.account_circle, color: Colors.white),
        //     label: Text(
        //       widget.email,
        //       style: const TextStyle(color: Colors.white),
        //     ),
        //     onPressed: () {
        //       Get.snackbar("Logged in as", widget.email);
        //     },
        //   ),
        // ],
      ),
      body: Stack(
        children: [CameraWidget(onPictureTaken: _handlePictureTaken)],
      ),
    );
  }
}






// // import 'package:reproject/feature/PuzzlePage/puzzle_page.dart';
// // import 'package:reproject/feature/LyricalPage/lyrical_page.dart';
// import 'package:flutter/material.dart';
// import 'package:reproject/feature/FixturePage/fixture_page.dart';
// import 'package:reproject/feature/LyricalPage/lyrical_page.dart';
// import 'package:reproject/feature/PuzzlePage/puzzle_page.dart';
// import 'package:reproject/feature/TeamsPage/team_page.dart';
// import 'package:reproject/feature/TicketsPage/tickets_page.dart';
// import 'package:video_player/video_player.dart';
// import 'package:get/get.dart';
// import 'package:reproject/feature/Homepage/home_page.dart';
// // import 'package:reproject/feature/FixturePage/fixture_page.dart';
// // import 'package:reproject/feature/TeamsPage/team_page.dart';
// import 'package:reproject/feature/SignInPage/sign_in_page.dart';
// import 'package:reproject/feature/CameraWidget/camera_widget.dart';


// class TifoPage extends StatefulWidget {
//   final String email; // Add email parameter

//   const TifoPage({super.key, required this.email}); // Receive the email


//   @override
//   _TifoPageState createState() => _TifoPageState();
// }

//   void _handlePictureTaken(String path) {
//     print("Picture taken at: $path");
//     // You can navigate to another screen or display the image here
//   }

// class _TifoPageState extends State<TifoPage> {
//   late VideoPlayerController _villiarsController;


//   @override
//   void initState() {
//     super.initState();
//     _villiarsController =  VideoPlayerController.asset('lib/assets/Villiars.mp4');
//   }

//   @override
//   void dispose() {
//     _villiarsController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "Digital Tifo",
//           style: TextStyle(fontSize: 20, color: Colors.white),
//         ),
//         backgroundColor: Colors.deepPurple,
//         actions: [
//           // Show logged-in user's email
//           TextButton.icon(
//             icon: const Icon(Icons.account_circle, color: Colors.white),
//             label: Text(
//               widget.email, // Show the user's email
//               style: const TextStyle(color: Colors.white),
//             ),
//             onPressed: () {
//               Get.snackbar("Logged in as", widget.email);
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
//                  color: Color.fromRGBO(28, 34, 45, 1),
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
//                   Get.to(() => PuzzlePage(email: widget.email)); // Add navigation to Fantasy page
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
//       body: CameraWidget(onPictureTaken: _handlePictureTaken),
//     );
//   }
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
// }
