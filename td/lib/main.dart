import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:td/Home_page.dart';

void main() async {
  await Hive.initFlutter();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      scrollBehavior: MaterialScrollBehavior(),
      home: HomePage(),
    );
  }
}
