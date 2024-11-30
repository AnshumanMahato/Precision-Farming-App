import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter_agri_app/getter_functions/get_functions.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    /*  appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: AppBar(
            title: Text(
              'Agri-App',
              style: TextStyle(
                  fontSize: 30,
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 3.4
                    ..color = const Color.fromARGB(255, 73, 67, 67)),
              textAlign: TextAlign.center,
            ),
            elevation: 4,
            backgroundColor: const Color.fromARGB(255, 211, 138, 236)),
      ), */
      
      body: ListView(
        padding: const EdgeInsets.only(top: 0),
        children: [
          Container(
            padding: const EdgeInsets.only(top: 35),
            color: const Color.fromARGB(255, 145, 164, 248),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 157, 239, 241),
                  borderRadius:
                      BorderRadius.only(topLeft: Radius.circular(900))),
              child: GridView.count(
                padding: const EdgeInsets.only(bottom: 80),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 40,
                mainAxisSpacing: 30,
                children: [
                  itemDashboard('Temparature', getTemp(0), CupertinoIcons.thermometer,
                      Colors.deepOrange),
                  itemDashboard(
                      'Soil Moisture', getSoilmoisture(0), CupertinoIcons.drop, Colors.blue),
                  itemDashboard('Daylight', getDaylight('temp'), CupertinoIcons.cloud_sun,
                      const Color.fromARGB(255, 255, 186, 59)),
                  itemDashboard(
                      'Humidity', getHumidity(0), CupertinoIcons.wind, Colors.deepPurple),
                  //Need to add action-listener/on-tap method on the wigdets below.
                  itemDashboard(
                      'On Switch', '', CupertinoIcons.bolt, Colors.grey),
                  itemDashboard('Off Switch', '', CupertinoIcons.bolt_slash,
                      Colors.grey),
                  
                ],
              ),
            ),
          ),
          const SizedBox(height: 20)
        ],
      ),
    );
  }

  itemDashboard(
          String title, String reading, IconData iconData, Color background) =>
      Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  offset: const Offset(0, 5),
                  color: Theme.of(context).primaryColor.withOpacity(.2),
                  spreadRadius: 2,
                  blurRadius: 5)
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: background,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(iconData, color: Colors.white)),
                Text(reading)
              ],
            ),
            const SizedBox(height: 8),
            Text(title.toUpperCase(),
                style: Theme.of(context).textTheme.titleMedium)
          ],
        ),
      );
}
