import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

Widget pumpControlCard(String status, VoidCallback onToggle) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          offset: const Offset(0, 5),
          color: const Color.fromARGB(255, 50, 44, 44).withOpacity(0.2),
          spreadRadius: 2,
          blurRadius: 5,
        ),
      ],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: status == 'ON' ? Colors.green : Colors.red,
                shape: BoxShape.circle,
              ),
              child: Icon(
                CupertinoIcons.bolt,
                color: Colors.white,
              ),
            ),
            Text(
              status == 'ON' ? 'Pump ON' : 'Pump OFF',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: onToggle,
          style: ElevatedButton.styleFrom(
            backgroundColor: status == 'ON' ? Colors.red : Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            status == 'ON' ? 'Turn OFF' : 'Turn ON',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
    ),
  );
}
