import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:reproject/theme.dart';

class LyricalPage extends StatefulWidget {
  final String email;

  const LyricalPage({super.key, required this.email});

  @override
  _LyricalPageState createState() => _LyricalPageState();
}

class _LyricalPageState extends State<LyricalPage>
    with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> chantLyrics = [];
  int _currentLyricIndex = 0;
  // late Timer _timer;
  bool isLoading = true;
  bool isPlaying = false;
  late AudioPlayer _audioPlayer;
  String? _songPath;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  late StreamSubscription _positionSubscription;
  String _currentChantId = "defaultChantId";
  bool isEventStarted = false;
  final Color primaryColor = const Color(0xFF90C02A);

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    Firebase.initializeApp();
    _fetchLyricsFromFirebase(_currentChantId);
    _setupAudioPlayerListeners();
  }

  @override
  void dispose() {
    // _timer.cancel();
    _audioPlayer.dispose();
    _positionSubscription.cancel();
    super.dispose();
  }

  void _setupAudioPlayerListeners() {
    _positionSubscription = _audioPlayer.positionStream.listen((Duration p) {
      setState(() {
        _position = p;
      });
      if (_currentLyricIndex < chantLyrics.length - 1 &&
          p.inSeconds >= chantLyrics[_currentLyricIndex]['timestamp']) {
        setState(() {
          _currentLyricIndex++;
        });
      }
    });

    _audioPlayer.durationStream.listen((Duration? d) {
      setState(() {
        _duration = d ?? Duration.zero;
      });
    });
  }

  Future<void> _fetchLyricsFromFirebase(String chantId) async {
    final user = FirebaseAuth.instance.currentUser;
    print('dgfdfdfdfdfdfdfdfdfdfdfdfdf${user!.email}');

    try {
      final snapshot =
          await FirebaseFirestore.instance
              .collection('lyrics')
              .where('chantId', isEqualTo: chantId)
              .get();

      chantLyrics =
          snapshot.docs
              .map(
                (doc) => {'lyric': doc['lyric'], 'timestamp': doc['timestamp']},
              )
              .toList();

      setState(() {
        isLoading = false;
      });
    } catch (error) {
      print("Error fetching lyrics: $error");
    }
  }

  Future<void> _uploadSongToFirebase() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
      );
      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        final fileName = result.files.single.name;

        final storageRef = FirebaseStorage.instance.ref().child(
          'songs/$fileName',
        );
        await storageRef.putFile(file);
        final downloadUrl = await storageRef.getDownloadURL();

        print('Uploaded! URL: $downloadUrl');
        setState(() {
          _songPath = result.files.single.path;
        });
      }
    } catch (error) {
      print('Upload error: $error');
    }
  }

  Future<void> _togglePlayPause() async {
    if (isPlaying) {
      await _audioPlayer.pause();
    } else {
      if (_songPath != null) {
        await _audioPlayer.setAudioSource(
          AudioSource.uri(Uri.file(_songPath!)),
        );
        await _audioPlayer.play();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("No song selected! Please wait for a new event!"),
          ),
        );
        return;
      }
    }

    setState(() {
      isPlaying = !isPlaying;
    });
  }

  void _startLiveEvent() {
    setState(() {
      isEventStarted = true;
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Live event started!")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text(
          "Lyrical Page",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      body:
      // isLoading
      //     ? const Center(
      //       child: CircularProgressIndicator(color: AppColors.primary),
      //     )
      Stack(
        children: [
          //image
          Image.asset(
            "lib/assets/saudi_league_flag.jpg",
            height: MediaQuery.of(context).size.height,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                // Dropdown Chant Selector
                // Container(
                //   padding: const EdgeInsets.symmetric(
                //     horizontal: 12,
                //     vertical: 8,
                //   ),

                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(10),
                //     color: Colors.white,
                //     border: Border.all(color: Colors.white),
                //   ),
                //   child: DropdownButton<String>(
                //     value: _currentChantId,
                //     underline: const SizedBox(),
                //     isExpanded: true,
                //     iconEnabledColor: primaryColor,
                //     onChanged: (String? newChantId) {
                //       if (newChantId != null) _switchChant(newChantId);
                //     },
                //     items:
                //         <String>['defaultChantId', 'chant2', 'chant3']
                //             .map(
                //               (String value) => DropdownMenuItem<String>(
                //                 value: value,
                //                 child: Text(
                //                   value,
                //                   style: TextStyle(color: primaryColor),
                //                 ),
                //               ),
                //             )
                //             .toList(),
                //   ),
                // ),
                if (isEventStarted)
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      '🎉 Live Event Started!',
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                const SizedBox(height: 200),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    textAlign: TextAlign.center,
                    'Balaongana al vent, Un crit valent...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 35,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),

                // Lyrics Display
                // Expanded(
                //   child: ListView.builder(
                //     itemCount: chantLyrics.length,
                //     itemBuilder: (context, index) {
                //       return ListTile(
                //         title: Text(
                //           chantLyrics[index]['lyric'],
                //           style: TextStyle(
                //             color:
                //                 index == _currentLyricIndex
                //                     ? primaryColor
                //                     : Colors.black87,
                //             fontSize: 18,
                //             fontWeight:
                //                 index == _currentLyricIndex
                //                     ? FontWeight.bold
                //                     : FontWeight.normal,
                //           ),
                //         ),
                //       );
                //     },
                //   ),
                // ),
                const SizedBox(height: 50),

                Slider(
                  value: _position.inSeconds.toDouble(),
                  max:
                      _duration.inSeconds.toDouble() > 0
                          ? _duration.inSeconds.toDouble()
                          : 1,
                  activeColor: primaryColor,
                  onChanged: (value) {
                    final position = Duration(seconds: value.toInt());
                    _audioPlayer.seek(position);
                  },
                ),

                const SizedBox(height: 60),
                GestureDetector(
                  onTap: _togglePlayPause,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white.withValues(alpha: 0.9),
                    child: Icon(
                      Icons.play_arrow,
                      size: 50,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 50),

                // Control Buttons
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //   children: [
                //     _buildButton(
                //       "Play/Pause",
                //       _togglePlayPause,
                //       enabled: isEventStarted,
                //     ),
                //     _buildButton("Upload Song", _uploadSongToFirebase),
                //   ],
                // ),
                const SizedBox(height: 30),

                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                //   children: [
                //     _buildButton("Add New Lyric", _addLyricFileToFirebase),
                //     _buildButton(
                //       "Start Live Event",
                //       _startLiveEvent,
                //       backgroundColor: Colors.redAccent,
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(
    String label,
    VoidCallback onPressed, {
    bool enabled = true,
    Color? backgroundColor,
  }) {
    return ElevatedButton(
      onPressed: enabled ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(label),
    );
  }

  void _switchChant(String chantId) {
    setState(() {
      _currentChantId = chantId;
      _currentLyricIndex = 0;
      isLoading = true;
    });
    _fetchLyricsFromFirebase(chantId);
  }

  Future<void> _addLyricFileToFirebase() async {
    try {
      setState(() {
        isLoading = true;
      });

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['txt'],
      );
      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        final fileContent = await file.readAsString();
        final lines = fileContent.split('\n');

        for (int i = 0; i < lines.length; i++) {
          String line = lines[i].trim();
          if (line.isNotEmpty) {
            final timestampEndIndex = line.indexOf(']');
            if (timestampEndIndex != -1) {
              final timestampStr = line.substring(1, timestampEndIndex);
              final text = line.substring(timestampEndIndex + 1).trim();
              final timestamp = int.tryParse(timestampStr);

              if (timestamp != null) {
                await FirebaseFirestore.instance.collection('lyrics').add({
                  'chantId': 'defaultChantId',
                  'lyric': text,
                  'timestamp': timestamp,
                });
              }
            }
          }
        }

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Lyrics added successfully!")));
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("No file selected")));
      }
    } catch (error) {
      print("Upload lyric error: $error");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to upload lyrics")));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}

// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:just_audio/just_audio.dart'; // For audio streaming
// import 'package:file_picker/file_picker.dart';
// import 'package:reproject/feature/FixturePage/fixture_page.dart';
// import 'package:reproject/feature/Homepage/home_page.dart';
// import 'package:reproject/feature/PuzzlePage/puzzle_page.dart';
// import 'package:reproject/feature/SignInPage/sign_in_page.dart';
// import 'package:reproject/feature/TeamsPage/team_page.dart';
// import 'package:reproject/feature/TicketsPage/tickets_page.dart';
// import 'package:reproject/feature/TifoPage/tifo_page.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'dart:io';

// class LyricalPage extends StatefulWidget {
//   final String email;

//   const LyricalPage({super.key, required this.email});

//   @override
//   _LyricalPageState createState() => _LyricalPageState();
// }

// class _LyricalPageState extends State<LyricalPage> with SingleTickerProviderStateMixin {
//   List<Map<String, dynamic>> chantLyrics = [];
//   int _currentLyricIndex = 0;
//   late Timer _timer;
//   bool isLoading = true;
//   bool isPlaying = false;
//   late AudioPlayer _audioPlayer;
//   String? _songPath;
//   Duration _duration = Duration.zero;
//   Duration _position = Duration.zero;
//   late StreamSubscription _positionSubscription;
//   String _currentChantId = "defaultChantId"; // Add chantId to manage different chants
//   bool isEventStarted = false;

//   @override
//   void initState() {
//     super.initState();
//     _audioPlayer = AudioPlayer();
//     Firebase.initializeApp();
//     _fetchLyricsFromFirebase(_currentChantId); // Load chant lyrics based on chantId
//     _setupAudioPlayerListeners();
//   }

//   @override
//   void dispose() {
//     _timer.cancel();
//     _audioPlayer.dispose();
//     _positionSubscription.cancel();
//     super.dispose();
//   }

//   void _setupAudioPlayerListeners() {
//     _positionSubscription = _audioPlayer.positionStream.listen((Duration p) {
//       setState(() {
//         _position = p;
//       });
//       if (_currentLyricIndex < chantLyrics.length - 1 &&
//           p.inSeconds >= chantLyrics[_currentLyricIndex]['timestamp']) {
//         setState(() {
//           _currentLyricIndex++;
//         });
//       }
//     });
//     _audioPlayer.durationStream.listen((Duration? d) {
//       setState(() {
//          _duration = d ?? Duration.zero;
//       });
//     });
//   }

//   Future<void> _fetchLyricsFromFirebase(String chantId) async {
//     try {
//       final snapshot = await FirebaseFirestore.instance
//           .collection('lyrics')
//           .where('chantId', isEqualTo: chantId) // Filter by chantId
//           .get();
//       chantLyrics = snapshot.docs.map((doc) => {
//         'lyric': doc['lyric'],
//         'timestamp': doc['timestamp'],
//       }).toList();
//       setState(() {
//         isLoading = false;
//       });
//     } catch (error) {
//       print("Error fetching lyrics from Firebase: $error");
//     }
//   }

//   Future<void> _uploadSongToFirebase() async {
//     try {
//       FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.audio);
//       if (result != null && result.files.single.path != null) {
//         final file = File(result.files.single.path!);
//         final fileName = result.files.single.name;

//         final storageRef = FirebaseStorage.instance.ref().child('songs/$fileName');
//         await storageRef.putFile(file);
//         final downloadUrl = await storageRef.getDownloadURL();

//         print('File uploaded successfully! URL: $downloadUrl');
//         setState(() {
//           _songPath = result.files.single.path;
//         });
//       }
//     } catch (error) {
//       print('Error uploading file: $error');
//     }
//   }

//   // This is the main function when the Play button is pressed
//   Future<void> _togglePlayPause() async {
//     if (isPlaying) {
//       await _audioPlayer.pause();
//     } else {
//       if (_songPath != null) {
//        await _audioPlayer.setAudioSource(AudioSource.uri(Uri.file(_songPath!)));
//        await _audioPlayer.play();
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("No song selected! Please wait for a new event!"))
//         );
//         return;
//       }
//     }
//     setState(() {
//       isPlaying = !isPlaying;
//     });
//   }

//   // Admin functions
//   void _startLiveEvent() {
//     setState(() {
//       isEventStarted = true;
//     });
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Live event has started!")));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Lyrical Page')),
//       body: isLoading
//           ? Center(child: CircularProgressIndicator())
//           : Column(
//               children: [
//                 // Dropdown or buttons to switch between different chants
//                 DropdownButton<String>(
//                   value: _currentChantId,
//                   onChanged: (String? newChantId) {
//                     if (newChantId != null) {
//                       _switchChant(newChantId);
//                     }
//                   },
//                   items: <String>['defaultChantId', 'chant2', 'chant3']
//                       .map<DropdownMenuItem<String>>((String value) {
//                     return DropdownMenuItem<String>(
//                       value: value,
//                       child: Text(value),
//                     );
//                   }).toList(),
//                 ),

//                 // Show event status
//                 if (isEventStarted)
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Text(
//                       'Live Event Started!',
//                       style: TextStyle(color: Colors.green, fontSize: 20),
//                     ),
//                   ),

//                 // Show Lyrics
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: chantLyrics.length,
//                     itemBuilder: (context, index) {
//                       return ListTile(
//                         title: Text(
//                           chantLyrics[index]['lyric'],
//                           style: TextStyle(
//                             color: index == _currentLyricIndex ? Colors.blueAccent : Colors.black,
//                             fontSize: 18,
//                             fontWeight: index == _currentLyricIndex ? FontWeight.bold : FontWeight.normal,
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//                 Slider(
//                   value: _position.inSeconds.toDouble(),
//                   max: _duration.inSeconds.toDouble(),
//                   onChanged: (value) {
//                     final position = Duration(seconds: value.toInt());
//                     _audioPlayer.seek(position);
//                   },
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     // Play/Pause Button
//                     ElevatedButton(
//                       onPressed: isEventStarted ? _togglePlayPause : null, // Disable Play/Pause until event starts
//                       child: Text(isPlaying ? 'Pause' : 'Play'),
//                     ),
//                     // Upload Song Button (for admin to upload song)
//                     ElevatedButton(
//                       onPressed: _uploadSongToFirebase,
//                       child: Text('Upload Song'),
//                     ),
//                   ],
//                 ),
//                 // Admin option to add a new lyric
//                 ElevatedButton(
//                   onPressed: () {
//                     _addLyricFileToFirebase();
//                   },
//                   child: Text('Add New Lyric'),
//                 ),
//                 // Start live event button
//                 ElevatedButton(
//                   onPressed: _startLiveEvent,
//                   child: Text('Start Live Event'),
//                 ),
//               ],
//             ),
//     );
//   }

//   void _switchChant(String chantId) {
//     setState(() {
//       _currentChantId = chantId;
//       _currentLyricIndex = 0;
//       isLoading = true;
//     });
//     _fetchLyricsFromFirebase(chantId); // Load new chant lyrics
//   }

//   Future<void> _addLyricFileToFirebase() async {
//     try {
//       setState(() {
//         isLoading = true;
//       });

//       // Step 1: Pick the file using the file picker
//       FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['txt']);
//       if (result != null && result.files.single.path != null) {
//         // Step 2: Get the file path
//         final filePath = result.files.single.path!;
//         final file = File(filePath);
//         final fileContent = await file.readAsString();

//         // Step 3: Split the file content into lines
//         final lines = fileContent.split('\n');

//         // Step 4: Process each line and upload to Firebase
//         for (int i = 0; i < lines.length; i++) {
//           String line = lines[i].trim();
//           if (line.isNotEmpty) {
//             // Step 5: Parse the timestamp and the text
//             final timestampEndIndex = line.indexOf(']');
//             if (timestampEndIndex != -1) {
//               final timestampStr = line.substring(1, timestampEndIndex); // Get the timestamp (excluding '[' and ']')
//               final text = line.substring(timestampEndIndex + 1).trim(); // Get the lyric text

//               // Convert the timestamp to an integer
//               final timestamp = int.tryParse(timestampStr);

//               if (timestamp != null) {
//                 //Step 6: Upload the lyric to Firebase Firestore
//                 await FirebaseFirestore.instance.collection('lyrics').add({
//                   'chantId': 'defaultChantId', // Replace with dynamic chantId if needed
//                   'lyric': text,
//                   'timestamp': timestamp, // The parsed timestamp
//                 });
//               }
//             }
//           }
//         }

//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Lyrics added successfully!")));
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("No file selected")));
//       }
//     } catch (error) {
//       print("Error uploading lyric file: $error");
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to upload lyrics")));
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
// }
