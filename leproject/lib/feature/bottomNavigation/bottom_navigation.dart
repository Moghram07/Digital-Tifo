import 'package:flutter/material.dart';
import 'package:reproject/feature/Homepage/home_page.dart';
import 'package:reproject/feature/TeamsPage/team_page.dart';
import 'package:reproject/feature/TicketsPage/tickets_page.dart';
import 'package:reproject/feature/settings/setting_screen.dart';

class BottomNavigationScreen extends StatefulWidget {
  const BottomNavigationScreen({super.key, required this.email});
  final String email;

  @override
  _BottomNavigationScreenState createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomePage(email: widget.email),
      TeamsPages(email: widget.email),
      TicketsPage(email: widget.email),
      SettingsPage(email: widget.email),
    ];
    return Scaffold(
      body: pages[_currentIndex],
      // Wrap in Container to control height and background
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8)],
        ),
        height: 80, // increased height

        child: BottomNavigationBar(
          iconSize: 27,
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
          type: BottomNavigationBarType.fixed,

          // backgroundColor: Colors.red, // let Container show through
          // elevation: 0,
          selectedItemColor: const Color.fromARGB(255, 149, 207, 23),
          unselectedItemColor: Colors.grey[400],
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: Colors.white,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: 'Teams',
              backgroundColor: Colors.white,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.confirmation_number),
              label: 'Tickets',
              backgroundColor: Colors.white,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu),
              label: 'Options',
              backgroundColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
