import 'package:flutter/material.dart';

class Aboutpage extends StatefulWidget {
  const Aboutpage({super.key});
  @override
  State<Aboutpage> createState() => _Aboutpage();
}

class _Aboutpage extends State<Aboutpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 213, 229, 242),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 213, 229, 242),
        title: Text('About page'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 50),
            Text(
              "Thai up app",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 5, 5, 5),
                letterSpacing: 1.2,
                fontFamily: 'Kanit',
              ),
            ),
            SizedBox(height: 30),
            Text(
              "แอปนี้เป็นแอปที่ทำมาเพื่อฝึกการทำ App ในรายวิชา SOFTWARE DEV PRACTICE II ซึ่งทำมาเพื่อการแก้ปัญหาหรือช่วยเกี่ยวกับการเรียนรู้ภาษาไทย โดยกลุ่มเป้าหมายหลักในการเรียนรู้นี้คือแม่บ้านที่ขาดโอกาสหรือใครๆก็ตามที่ยังไม่คล่องในการใช้ภาษาไทย",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.normal,
                color: Color.fromARGB(255, 5, 5, 5),
                letterSpacing: 1.2,
                fontFamily: 'Kanit',
              ),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  "จัดทำโดย",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 5, 5, 5),
                    letterSpacing: 1.2,
                    fontFamily: 'Kanit',
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  "นายกวินท์ ทองจันทร์",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                    color: Color.fromARGB(255, 5, 5, 5),
                    letterSpacing: 1.2,
                    fontFamily: 'Kanit',
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  "นายอัษฎาวุธ เวทการ",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                    color: Color.fromARGB(255, 5, 5, 5),
                    letterSpacing: 1.2,
                    fontFamily: 'Kanit',
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  "อาจารย์ที่ปรึกษา",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 5, 5, 5),
                    letterSpacing: 1.2,
                    fontFamily: 'Kanit',
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  "นายโสภณ อภิรมย์วรการ",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                    color: Color.fromARGB(255, 5, 5, 5),
                    letterSpacing: 1.2,
                    fontFamily: 'Kanit',
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
