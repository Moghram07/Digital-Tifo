import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reproject/feature/FixturePage/fixture_page.dart';
import 'package:reproject/feature/LyricalPage/lyrical_page.dart';
import 'package:reproject/feature/PuzzlePage/puzzle_page.dart';
import 'package:reproject/feature/SignInPage/sign_in_page.dart';
import 'package:reproject/feature/TicketsPage/tickets_page.dart';
import 'package:reproject/feature/TifoPage/tifo_page.dart';
import 'package:reproject/feature/buyfoodanddrinks/buy_food_and_deinks.dart';
import 'package:reproject/feature/flashlightshow/flash_light_show.dart';
import 'package:reproject/feature/interact/interact_page.dart';

const Color primaryColor = Color(0xFF90C02A);

class SettingsPage extends StatelessWidget {
  final String email;
  const SettingsPage({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,

      //   backgroundColor: primaryColor,
      //   foregroundColor: Colors.white,
      //   title: const Text(
      //     'Settings',
      //     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
      //   ),
      //   centerTitle: true,
      // ),
      body: ListView(
        children: [
          const SizedBox(height: 20),
          Center(
            child: Column(
              children: [
                Image.asset('lib/assets/ourlogo.png', height: 170),
                const SizedBox(height: 10),
                Text(
                  'Email: $email',
                  style: const TextStyle(
                    fontSize: 19,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          _buildSettingItem(
            Icons.flag,
            'Tifo',
            () => Get.to(() => TifoPage(email: email)),
          ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 20.0),
          //   child: Divider(color: const Color.fromARGB(255, 161, 161, 161)),
          // ),
          //
          _buildSettingItem(
            Icons.light,
            'Flashlight Show',
            () {
              Get.to(() => FlashLightShow());
            },
            // () => Get.to(() => TifoPage(email: email)),
          ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 20.0),
          //   child: Divider(color: const Color.fromARGB(255, 161, 161, 161)),
          // ),
          //
          //
          _buildSettingItem(
            Icons.music_note,
            'Support',
            () => Get.to(() => LyricalPage(email: email)),
          ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 20.0),
          //   child: Divider(color: const Color.fromARGB(255, 161, 161, 161)),
          // ),
          //
          _buildSettingItem(
            Icons.install_desktop_sharp,
            'Interact',
            () => Get.to(() => InteractPage()),
          ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 20.0),
          //   child: Divider(color: const Color.fromARGB(255, 161, 161, 161)),
          // ),
          _buildSettingItem(
            Icons.extension,
            'Play',
            () => Get.to(() => PuzzlePage(email: email)),
          ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 20.0),
          //   child: Divider(color: const Color.fromARGB(255, 161, 161, 161)),
          // ),
          _buildSettingItem(
            Icons.schedule,
            'Fixtures',
            () => Get.to(() => FixturePage(email: email)),
          ),
          _buildSettingItem(
            Icons.confirmation_number,
            'Buy Tickets',
            () => Get.to(() => TicketsPage(email: email, isback: true)),
          ),
          _buildSettingItem(
            Icons.food_bank_outlined,
            'Buy Food & Drinks',
            () {
              Get.to(() => BuyFoodAndDeinks());
            },
            // () => Get.to(() => TicketsPage(email: email)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Divider(color: const Color.fromARGB(255, 161, 161, 161)),
          ),
          _buildSettingItem(Icons.logout, 'Sign Out', () async {
            await FirebaseAuth.instance.signOut();
            Get.offAll(() => SignInPage());
          }),
        ],
      ),
    );
  }

  Widget _buildSettingItem(IconData icon, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
        child: Row(
          children: [
            Icon(icon, color: primaryColor, size: 30),
            SizedBox(width: 8),
            Text(title, style: const TextStyle(fontSize: 16)),
            Spacer(),
            const Icon(Icons.arrow_forward_ios, size: 20),
          ],
        ),
      ),
    );
    // return ListTile(
    //   leading: Icon(icon, color: primaryColor, size: 30),
    //   title: Text(title, style: const TextStyle(fontSize: 16)),
    //   trailing: const Icon(Icons.arrow_forward_ios, size: 20),
    //   onTap: onTap,
    // );
  }
}
