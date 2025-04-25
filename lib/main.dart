import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_agri_app/pages/main_view.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const MainPageNavBottom(),
        theme: ThemeData(
          primarySwatch: Colors.lightBlue,
        ));
  }
}
