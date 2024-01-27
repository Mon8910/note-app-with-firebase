import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class Notifications extends StatefulWidget{
  const Notifications({super.key});
  @override
  State<Notifications> createState() {
    return _Notifications();
   
  }
}
class _Notifications extends State<Notifications>{
  getTokens()async{
    String? tokens=await FirebaseMessaging.instance.getToken();
    print('===============');
    print(tokens);
  }
  myRequestpremisions()async{
    FirebaseMessaging messaging = FirebaseMessaging.instance;

NotificationSettings settings = await messaging.requestPermission(
  alert: true,
  announcement: false,
  badge: true,
  carPlay: false,
  criticalAlert: false,
  provisional: false,
  sound: true,
);

print('User granted permission: ${settings.authorizationStatus}');
  }
  @override
  void initState() {
    myRequestpremisions();
    getTokens();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
   return Scaffold(appBar: AppBar(title:const Text('Notifications'),),
   body: const Column(
    children: [],
   ),);
  }

}