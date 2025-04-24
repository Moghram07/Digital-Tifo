import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reproject/theme.dart';

class BuyFoodAndDeinks extends StatelessWidget {
  const BuyFoodAndDeinks({super.key});

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
        title: Text(
          'Buy Food And Drinks',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
      ),
    );
  }
}
