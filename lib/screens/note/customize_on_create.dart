import 'package:flutter/material.dart';

class CustomizeOnCreate extends StatelessWidget {
  CustomizeOnCreate({super.key, required this.initialColor});

  Color initialColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 233, 233, 233),
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        iconTheme: IconThemeData(color: Colors.black54),
        elevation: 4,
        title: Text(
          'Customize Note',
          style: TextStyle(color: const Color.fromARGB(255, 32, 5, 5)),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            SizedBox(height: 10),
            Text('Note Color'),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // light blue accent
                InkWell(
                  onTap: () {
                    initialColor = Colors.white;

                    if (initialColor == Colors.white) {
                      print('color is white');
                    } else {
                      print('is not white');
                    }
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                InkWell(
                  onTap: () {
                    initialColor = Colors.redAccent;
                    if (initialColor == Colors.redAccent) {
                      print('color is redaccent');
                    } else {
                      print('is not white');
                    }
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                InkWell(
                  onTap: () {
                    initialColor = Colors.lightGreenAccent;
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.lightGreenAccent,
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                InkWell(
                  onTap: () {
                    initialColor = Colors.purple;
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.purple,
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                InkWell(
                  onTap: () {
                    initialColor = Colors.amberAccent;
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.amberAccent,
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                InkWell(
                  onTap: () {
                    initialColor = Colors.deepOrangeAccent;
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.deepOrangeAccent,
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.pop(context, initialColor);
              },
              child: Container(
                alignment: Alignment.center,
                width: 120,
                height: 50,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black54,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  // note color
                  color: Colors.blueAccent,
                  border: Border.all(color: Colors.black, width: 1.5),
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                child: Text(
                  'Save Changes',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
