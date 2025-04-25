import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_agri_app/providers/farm_provider.dart';
import 'package:flutter_agri_app/pages/main_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => FarmProvider()),
          // Add other providers here if needed
        ],
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: const MainPageNavBottom(),
            theme: ThemeData(
              primarySwatch: Colors.lightBlue,
            )));
  }
}
