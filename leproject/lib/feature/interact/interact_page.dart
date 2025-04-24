import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reproject/theme.dart';

class InteractPage extends StatelessWidget {
  const InteractPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Text('Interact', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: AppColors.primary,
      ),
    );
  }
}
