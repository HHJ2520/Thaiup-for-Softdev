import 'package:flutter/material.dart';

class Firstpage extends StatefulWidget {
  const Firstpage({super.key});
  @override
  State<Firstpage> createState() => _Firstpage();
}

class _Firstpage extends State<Firstpage> {
  int num1 = 1;
  int num2 = 2;
  int num3 = 3;
  void _calculate_m() {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 213, 229, 242),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Image.asset("image/p.png")]),
            Text(
              "เลือกเนื้อหาที่ต้องการเรียน",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 5, 5, 5),
                letterSpacing: 1.2,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SizedBox(
                  width: 120,
                  child: FloatingActionButton.extended(
                    key: ValueKey('cha_second_page'),
                    onPressed: () {
                      Navigator.pushNamed(context, '/second', arguments: num1);
                    },
                    label: const Text("คำศัพท์"),
                  ),
                ),
                SizedBox(
                  width: 120,
                  child: FloatingActionButton.extended(
                    key: ValueKey('sara_second_page'),
                    onPressed: () {
                      Navigator.pushNamed(context, '/second', arguments: num2);
                    },
                    label: const Text("สระ"),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SizedBox(
                  width: 120,
                  child: FloatingActionButton.extended(
                    key: ValueKey('payok_second_page'),
                    onPressed: () {
                      Navigator.pushNamed(context, '/payokpange',
                          arguments: num3);
                    },
                    label: const Text("ประโยค"),
                  ),
                ),
                SizedBox(
                  width: 120,
                  child: FloatingActionButton.extended(
                    key: ValueKey('flashpage'),
                    onPressed: () {
                      Navigator.pushNamed(context, '/flashcard',
                          arguments: num2);
                    },
                    label: const Text("Flashcard"),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/aboutpage');
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 3, horizontal: 20),
                    child: Image.asset(
                      'image/ques.png',
                      width: 50,
                      height: 50,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
