import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_agri_app/pages/graphs.dart';
import 'package:flutter_agri_app/pages/home_page.dart';

class MainPageNavBottom extends StatefulWidget {
  const MainPageNavBottom({super.key});

  @override
  State<MainPageNavBottom> createState() =>
      _MainPageNavBottomState();
}

class _MainPageNavBottomState
    extends State<MainPageNavBottom> {
  int _selectedIndex = 0;
  final pages = [

    MyHomePage(),
    Graphs()

  ];
  final ScrollController _homeController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
            title: Text(
              'Agriculture',
              style: TextStyle(
                  fontSize: 30,
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 3.4
                    ..color = const Color.fromARGB(255, 73, 67, 67)),
              textAlign: TextAlign.center,
            ),
            elevation: 4,
            backgroundColor: const Color.fromARGB(255, 10, 194, 169)),
      ),

      body: pages[_selectedIndex],

      bottomNavigationBar: SizedBox(
        height: 70,
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.graph_circle),
              label: 'Graphs',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: (int index) {
            switch (index) {
              case 0:
                // only scroll to top when current index is selected.
                if (_selectedIndex == index) {
                  _homeController.animateTo(
                    0.0,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeOut,
                  );
                }
              case 1:
                //showModal(context);
            }
            setState(
              () {
                _selectedIndex = index;
              },
            );
          },
        ),
      ),
    );
  }
}