import 'package:flutter/material.dart';

class CustomLogo extends StatelessWidget{
  const CustomLogo({super.key});
  @override
  Widget build(BuildContext context) {
   return Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(70)),
                    child: Image.asset(
                      'assets/images/logo.png',
                      //width: 30,
                      height: 30,
                    ),
                  ),
                );
  }

}