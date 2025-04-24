// import 'dart:convert';
// import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../WebviewWidget/webview_widget.dart';

class FixturePage extends StatefulWidget {
  final String email;

  const FixturePage({super.key, required this.email});

  @override
  _FixturePageState createState() => _FixturePageState();
}

class _FixturePageState extends State<FixturePage> {
  List<dynamic> fixtures = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchFixtures(); // Call the API when the page loads
  }

  Future<void> _fetchFixtures() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://bpl-fan-engagement-platform-app.onrender.com/api/auth/get-fixtures',
        ),
      );
      if (response.statusCode == 200) {
        setState(() {
          fixtures = json.decode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        Get.snackbar(
          "Error",
          "Failed to load fixtures: ${response.statusCode}",
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      Get.snackbar("Error", "An error occurred: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Match Fixtures",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        backgroundColor: Color(0xFF90C02A),
        // actions: [
        //   TextButton.icon(
        //     icon: const Icon(Icons.account_circle, color: Colors.white),
        //     label: Text(
        //       widget.email,
        //       style: const TextStyle(color: Colors.white),
        //     ),
        //     onPressed: () {
        //       // Get.snackbar("Logged in as", widget.email);
        //     },
        //   ),
        // ],
      ),
      body: Container(
        color: Colors.white,
        child: WebViewPage(
          url:
              "https://www.fotmob.com/leagues/536/matches/saudi-pro-league?group=by-date",
        ),
      ),
    );
  }
}

// import 'package:http/http.dart' as http;
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:reproject/feature/Homepage/home_page.dart';
// import 'package:reproject/feature/TeamsPage/team_page.dart';
// import 'package:reproject/feature/LyricalPage/lyrical_page.dart';
// import 'package:reproject/feature/TicketsPage/tickets_page.dart';
// import 'package:reproject/feature/SignInPage/sign_in_page.dart';
// import 'package:reproject/feature/WebviewWidget/webview_widget.dart';
// import 'package:reproject/feature/TifoPage/tifo_page.dart';
// import 'package:reproject/feature/PuzzlePage/puzzle_page.dart';

// class FixturePage extends StatefulWidget {
//   final String email;

//   const FixturePage({super.key, required this.email});

//   @override
//   _FixturePageState createState() => _FixturePageState();
// }

// class _FixturePageState extends State<FixturePage> {
//   List<dynamic> fixtures = [];
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _fetchFixtures(); // Call the API when the page loads
//   }

//   Future<void> _fetchFixtures() async {
//     try {
//       final response = await http.get(Uri.parse(
//           'https://bpl-fan-engagement-platform-app.onrender.com/api/auth/get-fixtures'));
//       if (response.statusCode == 200) {
//         setState(() {
//           fixtures = json.decode(response.body);
//           isLoading = false;
//         });
//       } else {
//         setState(() {
//           isLoading = false;
//         });
//         Get.snackbar(
//             "Error", "Failed to load fixtures: ${response.statusCode}");
//       }
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//       });
//       Get.snackbar("Error", "An error occurred: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "Match Fixtures",
//           style: TextStyle(fontSize: 20, color: Colors.white),
//         ),
//         backgroundColor: Colors.deepPurple,
//         actions: [
//           TextButton.icon(
//             icon: const Icon(Icons.account_circle, color: Colors.white),
//             label: Text(
//               widget.email,
//               style: const TextStyle(color: Colors.white),
//             ),
//             onPressed: () {
//               Get.snackbar("Logged in as", widget.email);
//             },
//           ),
//         ],
//       ),
//       drawer: _buildDrawer(),
//       body: Container(
//         color: Colors.white,
//         padding: const EdgeInsets.all(20.0),
//         child: WebViewPage(url: "https://www.fotmob.com/leagues/536/matches/saudi-pro-league?group=by-date")),
//     );
//   }

//   Widget _buildDrawer() {
//     return Drawer(
//       child: Container(
//         color: const Color.fromRGBO(28, 34, 45, 1),
//         child: ListView(
//           children: [
//             const DrawerHeader(
//               decoration: BoxDecoration(
//                color: Color.fromRGBO(28, 34, 45, 1),
//               ),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     'Digital Tifo',
//                     style: TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                   SizedBox(height: 10),
//                   CircleAvatar(
//                     radius: 40,
//                     backgroundImage: AssetImage('lib/assets/ourlogo.png'),
//                   ),
//                 ],
//               ),
//             ),
//             _buildDrawerItem(
//               icon: Icons.home,
//               text: 'HomePage',
//               onTap: () {
//                 Get.to(() => HomePage(email: widget.email));
//               },
//             ),
//             _buildDrawerItem(
//               icon: Icons.flag,
//               text: 'Tifo',
//               onTap: () {
//                 Get.to(() => TifoPage(email: widget.email));
//               },
//             ),
//             _buildDrawerItem(
//               icon: Icons.music_note_sharp,
//               text: 'Lyrical',
//               onTap: () {
//                 Get.to(() => LyricalPage(email: widget.email));
//               },
//             ),
//             _buildDrawerItem(
//               icon: Icons.question_mark_rounded,
//               text: 'Puzzle',
//               onTap: () {
//                 Get.to(() => PuzzlePage(email: widget.email));
//               },
//             ),
//             _buildDrawerItem(
//               icon: Icons.schedule_send,
//               text: 'Fixtures',
//               onTap: () {
//                 Get.to(() => FixturePage(email: widget.email));
//               },
//             ),
//             _buildDrawerItem(
//               icon: Icons.people,
//               text: 'Teams',
//               onTap: () {
//                 Get.to(() => TeamsPages(email: widget.email));
//               },
//             ),
//             _buildDrawerItem(
//               icon: Icons.confirmation_number,
//               text: 'Tickets',
//               onTap: () {
//                 Get.to(() => TicketsPage(email: widget.email));
//               },
//             ),
//             const Divider(),
//             _buildDrawerItem(
//               icon: Icons.logout,
//               text: 'Sign Out',
//               onTap: () {
//                 Get.to(() => SignInPage()); // Add Sign Out logic
//               },
//             ),
//           ],
//         ),
//       ),
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
//         style: const TextStyle(
//           color: Color.fromRGBO(255, 255, 255, 0.9),
//           fontSize: 16, // Adjust size as needed
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//       onTap: onTap,
//     );
//   }
// }
