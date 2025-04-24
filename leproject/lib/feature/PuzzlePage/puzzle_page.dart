import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../CameraWidget/camera_widget.dart';

class PuzzlePage extends StatefulWidget {
  final String email;
  const PuzzlePage({super.key, required this.email});

  @override
  _PuzzlePageState createState() => _PuzzlePageState();
}

void _handlePictureTaken(String path) {
  print("Picture taken at: $path");
}

class _PuzzlePageState extends State<PuzzlePage> {
  List<String> selectedPlayers = [];
  String teamName = "";
  int matchdayScore = 0;
  int totalScore = 0;
  int ranking = 0;
  String team1Name = '';
  String team2Name = '';
  List<String> team1Players = [];
  List<String> team2Players = [];
  bool canCreateTeam = true;
  Duration countdownDuration = const Duration();
  Timer? countdownTimer;
  late DateTime nextDay;

  final Color primaryColor = const Color(0xFF90C02A);
  final Color darkBackground = const Color(0xFF1C222D);

  @override
  void initState() {
    super.initState();
    nextDay = _getNextDay();
    _initializeCountdown();
    _checkIfTeamCreated();
    _fetchUserScoreAndRanking();
    _fetchFixtureAndPlayers();
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    super.dispose();
  }

  DateTime _getNextDay() {
    return DateTime.now().add(const Duration(days: 1)).toUtc();
  }

  void _initializeCountdown() {
    DateTime now = DateTime.now();
    DateTime endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);
    setState(() {
      countdownDuration = endOfDay.difference(now);
    });

    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (countdownDuration.inSeconds > 0) {
          countdownDuration = countdownDuration - const Duration(seconds: 1);
        } else {
          timer.cancel();
          _initializeCountdown();
        }
      });
    });
  }

  Future<void> _fetchUserScoreAndRanking() async {
    try {
      var scoreResponse = await http.get(
        Uri.parse(
          'https://bpl-fan-engagement-platform-app.onrender.com/api/auth/get-user-score?email=${widget.email}',
        ),
      );

      if (scoreResponse.statusCode == 200) {
        var scoreData = jsonDecode(scoreResponse.body);
        setState(() {
          matchdayScore = scoreData['point'];
          totalScore = scoreData['totalPoint'];
          teamName = scoreData['teamname'];
        });
      }

      var rankingResponse = await http.get(
        Uri.parse(
          'https://bpl-fan-engagement-platform-app.onrender.com/api/auth/get-user-ranking?email=${widget.email}',
        ),
      );
      if (rankingResponse.statusCode == 200) {
        var rankingData = jsonDecode(rankingResponse.body);
        setState(() {
          ranking = rankingData['rank'];
        });
      }
    } catch (error) {
      print('Error fetching user score and ranking: $error');
    }
  }

  Future<void> _fetchFixtureAndPlayers() async {
    try {
      var fixtureResponse = await http.get(
        Uri.parse(
          'https://bpl-fan-engagement-platform-app.onrender.com/api/auth/get-next-day-fixture',
        ),
      );

      if (fixtureResponse.statusCode == 200) {
        var fixtureData = jsonDecode(fixtureResponse.body);
        setState(() {
          team1Name = fixtureData['team1'];
          team2Name = fixtureData['team2'];
        });

        var team1Response = await http.get(
          Uri.parse(
            'https://bpl-fan-engagement-platform-app.onrender.com/api/auth/get-players/$team1Name',
          ),
        );
        var team2Response = await http.get(
          Uri.parse(
            'https://bpl-fan-engagement-platform-app.onrender.com/api/auth/get-players/$team2Name',
          ),
        );

        if (team1Response.statusCode == 200 &&
            team2Response.statusCode == 200) {
          setState(() {
            team1Players = List<String>.from(
              jsonDecode(team1Response.body)['players'],
            );
            team2Players = List<String>.from(
              jsonDecode(team2Response.body)['players'],
            );
          });
        }
      }
    } catch (error) {
      print('Error fetching fixture or players: $error');
    }
  }

  Future<void> _checkIfTeamCreated() async {
    try {
      var response = await http.get(
        Uri.parse(
          'https://bpl-fan-engagement-platform-app.onrender.com/api/auth/check-next-day-team?email=${widget.email}',
        ),
      );

      if (response.statusCode == 200) {
        setState(() {
          canCreateTeam = false;
        });
      }
    } catch (error) {
      print('Error checking next day team: $error');
      setState(() {
        canCreateTeam = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBackground,
      appBar: AppBar(
        centerTitle: true,
        foregroundColor: Colors.white,
        title: const Text(
          "Puzzle",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        backgroundColor: primaryColor,
        elevation: 4,
      ),
      body: ClipRRect(
        borderRadius: BorderRadius.circular(0),
        child: CameraWidget(onPictureTaken: _handlePictureTaken),
      ),
    );
  }
}

// import 'package:reproject/feature/FixturePage/fixture_page.dart';
// import 'package:reproject/feature/Homepage/home_page.dart';
// import 'package:reproject/feature/LyricalPage/lyrical_page.dart';
// import 'package:reproject/feature/SignInPage/sign_in_page.dart';
// import 'package:reproject/feature/TeamsPage/team_page.dart';
// import 'package:reproject/feature/TicketsPage/tickets_page.dart';
// import 'package:reproject/feature/TifoPage/tifo_page.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'dart:async';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:reproject/feature/CameraWidget/camera_widget.dart';

// class PuzzlePage extends StatefulWidget {
//   final String email;

//   const PuzzlePage({super.key, required this.email});

//   @override
//   _PuzzlePageState createState() => _PuzzlePageState();
// }

// void _handlePictureTaken(String path) {
//     print("Picture taken at: $path");
//     // You can navigate to another screen or display the image here
//   }

// class _PuzzlePageState extends State<PuzzlePage> {
//   List<String> selectedPlayers = [];
//   String teamName = "";
//   int matchdayScore = 0;
//   int totalScore = 0;
//   int ranking = 0;
//   String team1Name = '';
//   String team2Name = '';
//   List<String> team1Players = [];
//   List<String> team2Players = [];
//   bool canCreateTeam = true;
//   Duration countdownDuration = const Duration();
//   Timer? countdownTimer;
//   late DateTime nextDay;

//   @override
//   void initState() {
//     super.initState();
//     nextDay = _getNextDay();
//     _initializeCountdown();
//     _checkIfTeamCreated(); // Check if the team is already created
//     _fetchUserScoreAndRanking();
//     _fetchFixtureAndPlayers();
//   }

//   @override
//   void dispose() {
//     countdownTimer?.cancel();
//     super.dispose();
//   }

//   DateTime _getNextDay() {
//     return DateTime.now().add(const Duration(days: 1)).toUtc();
//   }

//   void _initializeCountdown() {
//     DateTime now = DateTime.now();
//     DateTime endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);
//     setState(() {
//       countdownDuration = endOfDay.difference(now);
//     });

//     countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       setState(() {
//         if (countdownDuration.inSeconds > 0) {
//           countdownDuration = countdownDuration - const Duration(seconds: 1);
//         } else {
//           timer.cancel();
//           _initializeCountdown(); // Reset the countdown after the day ends
//         }
//       });
//     });
//   }

//   Future<void> _fetchUserScoreAndRanking() async {
//     try {
//       var scoreResponse = await http.get(Uri.parse(
//           'https://bpl-fan-engagement-platform-app.onrender.com/api/auth/get-user-score?email=${widget.email}'));

//       if (scoreResponse.statusCode == 200) {
//         var scoreData = jsonDecode(scoreResponse.body);
//         setState(() {
//           matchdayScore = scoreData['point'];
//           totalScore = scoreData['totalPoint'];
//           teamName = scoreData['teamname'];
//         });
//       }

//       var rankingResponse = await http.get(Uri.parse(
//           'https://bpl-fan-engagement-platform-app.onrender.com/api/auth/get-user-ranking?email=${widget.email}'));
//       if (rankingResponse.statusCode == 200) {
//         var rankingData = jsonDecode(rankingResponse.body);
//         setState(() {
//           ranking = rankingData['rank'];
//         });
//       }
//     } catch (error) {
//       print('Error fetching user score and ranking: $error');
//     }
//   }

//   Future<void> _fetchFixtureAndPlayers() async {
//     try {
//       var fixtureResponse = await http.get(Uri.parse(
//           'https://bpl-fan-engagement-platform-app.onrender.com/api/auth/get-next-day-fixture'));

//       if (fixtureResponse.statusCode == 200) {
//         var fixtureData = jsonDecode(fixtureResponse.body);
//         setState(() {
//           team1Name = fixtureData['team1'];
//           team2Name = fixtureData['team2'];
//         });

//         var team1Response = await http.get(Uri.parse(
//             'https://bpl-fan-engagement-platform-app.onrender.com/api/auth/get-players/$team1Name'));
//         var team2Response = await http.get(Uri.parse(
//             'https://bpl-fan-engagement-platform-app.onrender.com/api/auth/get-players/$team2Name'));

//         if (team1Response.statusCode == 200 &&
//             team2Response.statusCode == 200) {
//           setState(() {
//             team1Players =
//                 List<String>.from(jsonDecode(team1Response.body)['players']);
//             team2Players =
//                 List<String>.from(jsonDecode(team2Response.body)['players']);
//           });
//         } else {
//           print("Failed to fetch players for one or both teams.");
//         }
//       } else {
//         print("Failed to fetch the fixture.");
//       }
//     } catch (error) {
//       print('Error fetching fixture or players: $error');
//     }
//   }

//   Future<void> _checkIfTeamCreated() async {
//     try {
//       var response = await http.get(
//         Uri.parse(
//             'https://bpl-fan-engagement-platform-app.onrender.com/api/auth/check-next-day-team?email=${widget.email}'),
//       );

//       if (response.statusCode == 200) {
//         setState(() {
//           canCreateTeam = false;
//         });
//       }
//     } catch (error) {
//       print('Error checking next day team: $error');
//       setState(() {
//         canCreateTeam = true;
//       });
//     }
//   }


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Puzzle",
//         style: TextStyle(fontSize: 20, color: Colors.white)),
//         backgroundColor: Colors.deepPurple,
//       ),
//       drawer: _buildDrawer(),
//       body: CameraWidget(onPictureTaken: _handlePictureTaken)
//     );
//   }

//     Widget _buildDrawer() {
//     return Drawer(
//         child: Container(
//           color: const Color.fromRGBO(28, 34, 45, 1),
//           child: ListView(
//             children: [
//               const DrawerHeader(
//                 decoration: BoxDecoration(
//                   color: Color.fromRGBO(28, 34, 45, 1),
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
//       );
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
