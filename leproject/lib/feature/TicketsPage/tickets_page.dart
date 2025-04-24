import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:reproject/theme.dart';

import '../../models/ticket.dart';
import '../../services/ticket_service.dart';

class TicketsPage extends StatelessWidget {
  final String email;
  final bool isback;
  final TicketService ticketService = TicketService();

  TicketsPage({super.key, required this.email, this.isback = false});

  Future<void> purchaseTicket(BuildContext context, String ticketId) async {
    try {
      await ticketService.purchaseTicket(email, ticketId, 1);
      String qrData = jsonEncode({'ticketId': ticketId, 'quantity': 1});
      _showPurchaseSuccessDialog(context, qrData);
    } catch (e) {
      _showErrorDialog(context, 'Error purchasing ticket: ${e.toString()}');
    }
  }

  void _showPurchaseSuccessDialog(BuildContext context, String qrData) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text('Purchase Successful!'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Your tickets have been purchased.'),
                const SizedBox(height: 20),
                QrImageView(
                  data: qrData,
                  version: QrVersions.auto,
                  size: 180.0,
                ),
              ],
            ),
            actions: [
              ElevatedButton(
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
            ],
          ),
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text('Error'),
            content: Text(message),
            actions: [
              TextButton(
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  String _generateRandomQRCodeData() {
    int randomNumber = Random().nextInt(100000);
    return 'Random QR Code Data: $randomNumber';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar:
            isback
                ? AppBar(
                  leading: GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  automaticallyImplyLeading: false,

                  foregroundColor: Colors.white,
                  centerTitle: true,
                  elevation: 0,
                  title: const Text(
                    "Tickets",
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: const Color(0xFF90C02A),
                )
                : null,
        body: Stack(
          children: [
            // Background image
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                // image: DecorationImage(
                //   image: AssetImage('lib/assets/ticketsbackground.jpg'),
                //   fit: BoxFit.cover,
                // ),
              ),
            ),
            // Semi-transparent blur overlay
            // BackdropFilter(
            //   filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            //   child: Container(color: Colors.black.withOpacity(0.4)),
            // ),
            // Main content
            Column(
              children: [
                SizedBox(height: 20),

                Text(
                  'Available Tickets',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 0),
                Expanded(
                  child: StreamBuilder<List<Ticket>>(
                    stream: ticketService.getTickets(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF90C02A),
                          ),
                        );
                      }

                      if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            'Error fetching tickets: ${snapshot.error}',
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }

                      final tickets = snapshot.data;

                      if (tickets == null || tickets.isEmpty) {
                        return Center(
                          child: QrImageView(
                            data: _generateRandomQRCodeData(),
                            version: QrVersions.auto,
                            size: 180.0,
                          ),
                        );
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: tickets.length,
                        itemBuilder: (context, index) {
                          final ticket = tickets[index];
                          return _buildTicketCard(ticket, context);
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                // QrImageView(
                //   data: _generateRandomQRCodeData(),
                //   version: QrVersions.auto,
                //   size: 160.0,
                // ),
                // const SizedBox(height: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTicketCard(Ticket ticket, BuildContext context) {
    return Card(
      elevation: 8,
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Colors.white.withOpacity(0.85),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 7, horizontal: 9),
              width: double.infinity,
              decoration: BoxDecoration(color: AppColors.primary),
              child: Text(
                ticket.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      spacing: 2,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 20,
                              color: Colors.black87,
                            ),
                            const SizedBox(width: 6),
                            Expanded(child: Text(ticket.eventLocation)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              size: 20,
                              color: Colors.black87,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${ticket.eventDate.toLocal().toString().split(' ')[0]}  ${ticket.eventDate.hour}:${ticket.eventDate.minute.toString().padLeft(2, '0')}',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  //price
                  Row(
                    children: [
                      const Icon(
                        Icons.attach_money,
                        size: 20,
                        color: Colors.black87,
                      ),
                      // const SizedBox(width: 3),
                      Text(
                        ticket.price.toStringAsFixed(2),
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  onPressed: () => purchaseTicket(context, ticket.id),
                  icon: const Icon(Icons.shopping_cart_outlined, size: 18),
                  label: const Text('Purchase'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0xFF90C02A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}


// import 'dart:convert';
// import 'dart:math';
// import 'package:get/get.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:qr_flutter/qr_flutter.dart';
// import 'package:reproject/feature/FixturePage/fixture_page.dart';
// import 'package:reproject/feature/Homepage/home_page.dart';
// import 'package:reproject/feature/LyricalPage/lyrical_page.dart';
// import 'package:reproject/feature/PuzzlePage/puzzle_page.dart';
// import 'package:reproject/feature/SignInPage/sign_in_page.dart';
// import 'package:reproject/feature/TeamsPage/team_page.dart';
// import 'package:reproject/feature/TifoPage/tifo_page.dart';
// import '../../services/ticket_service.dart';
// import '../../models/ticket.dart';

// class TicketsPage extends StatelessWidget {
//   final String email;
//   final TicketService ticketService = TicketService();

//   TicketsPage({Key? key, required this.email}) : super(key: key);

//   Future<void> purchaseTicket(BuildContext context, String ticketId) async {
//     try {
//       await ticketService.purchaseTicket(email, ticketId, 1);
//       // Show success message with QR code
//       String qrData = jsonEncode({'ticketId': ticketId, 'quantity': 1});
//       _showPurchaseSuccessDialog(context, qrData);
//     } catch (e) {
//       _showErrorDialog(context, 'Error purchasing ticket: ${e.toString()}');
//     }
//   }

//   void _showPurchaseSuccessDialog(BuildContext context, String qrData) {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text('Purchase Successful!'),
//         content: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const SizedBox(height: 20),
//               const Text('Your tickets have been purchased.'),
//             ],
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: const Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showErrorDialog(BuildContext context, String message) {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text('Error'),
//         content: Text(message),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: const Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }

//   String _generateRandomQRCodeData() {
//     int randomNumber = Random().nextInt(100000);
//     return 'Random QR Code Data: $randomNumber';
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "Tickets",
//           style: TextStyle(fontSize: 20, color: Colors.white),
//         ),
//         backgroundColor: Colors.deepPurple,
//         actions: [
//           TextButton.icon(
//             icon: const Icon(Icons.account_circle, color: Colors.white),
//             label: Text(
//               email,
//               style: const TextStyle(color: Colors.white),
//             ),
//             onPressed: () {
//               Get.snackbar("Logged in as", email);
//             },
//           ),
//         ],
//       ),
//       drawer: _buildDrawer(),
//       body: Stack(
//         children: [
//           // Background Image
//           Container(
//             decoration: BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage('lib/assets/ticketsbackground.jpg'), // Path to your image
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           // Main Content
//           Column(
//             children: [
//               Expanded(
//                 child: StreamBuilder<List<Ticket>>(
//                   stream: ticketService.getTickets(),
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return Center(child: CircularProgressIndicator());
//                     }

//                     if (snapshot.hasError) {
//                       return Center(child: Text('Error fetching tickets: ${snapshot.error}'));
//                     }

//                     final tickets = snapshot.data;

//                     if (tickets == null || tickets.isEmpty) {
//                       return Center(
//                         child: QrImageView(
//                           data: _generateRandomQRCodeData(),
//                           version: QrVersions.auto,
//                           size: 200.0,
//                         ),
//                       );
//                     }

//                     return ListView.builder(
//                       itemCount: tickets.length,
//                       itemBuilder: (context, index) {
//                         final ticket = tickets[index];
//                         return _buildTicketCard(ticket, context);
//                       },
//                     );
//                   },
//                 ),
//               ),
//               Center(
//                 child: QrImageView(
//                   data: _generateRandomQRCodeData(),
//                   version: QrVersions.auto,
//                   size: 200.0,
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(80, 80, 0, 80),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTicketCard(Ticket ticket, BuildContext context) {
//     return Card(
//       color: const Color.fromRGBO(255, 255, 255, 0.7),
//       child: ListTile(
//         title: Text(ticket.title),
//         subtitle: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Location: ${ticket.eventLocation}'),
//             Text('Date: ${ticket.eventDate.toLocal().toString().split(' ')[0]} ${ticket.eventDate.hour}:${ticket.eventDate.minute.toString().padLeft(2, '0')}'),
//             Text('Price: \$${ticket.price}'),
//           ],
//         ),
//         trailing: ElevatedButton(
//           onPressed: () => purchaseTicket(context, ticket.id),
//           child: const Text('Purchase'),
//         ),
//       ),
//     );
//   }
//       Widget _buildDrawer() {
//     return Drawer(
//         child: Container(
//           color: const Color.fromRGBO(28, 34, 45, 1),
//           child: ListView(
//             children: [
//               const DrawerHeader(
//                 decoration: BoxDecoration(
//                   color: const Color.fromRGBO(28, 34, 45, 1),
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
//                   Get.to(() => HomePage(email: email));
//                 },
//               ),
//               _buildDrawerItem(
//                 icon: Icons.flag,
//                 text: 'Tifo',
//                 onTap: () {
//                   Get.to(() => TifoPage(email: email));
//                 },
//               ),
//                _buildDrawerItem(
//                 icon: Icons.music_note_sharp,
//                 text: 'Lyrical',
//                 onTap: () {
//                   Get.to(() => LyricalPage(email: email));
//                 },
//               ),
//               _buildDrawerItem(
//                 icon: Icons.question_mark_rounded,
//                 text: 'Puzzle',
//                 onTap: () {
//                   Get.to(() => PuzzlePage(
//                       email: email)); // Add navigation to Fantasy page
//                 },
//               ),
//               _buildDrawerItem(
//                 icon: Icons.schedule_send,
//                 text: 'Fixtures',
//                 onTap: () {
//                   Get.to(() => FixturePage(email: email));
//                 },
//               ),
//               _buildDrawerItem(
//                 icon: Icons.people,
//                 text: 'Teams',
//                 onTap: () {
//                   Get.to(() => TeamsPages(email: email));
//                 },
//               ),
//               _buildDrawerItem(
//                 icon: Icons.confirmation_number,
//                 text: 'Tickets',
//                 onTap: () {
//                   Get.to(() => TicketsPage(email: email));
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