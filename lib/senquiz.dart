import 'dart:async';
// import 'dart:ffi';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class SenQuiz extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<SenQuiz> {
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  //  CollectionReference _question = FirebaseFirestore.instance.collection("voice_question_payok");
  String show = "";
  int _questionIndex = 0;
  int _totalScore = 0;
  String? selectedAnswer;
  int choice = 0;
  Color con = Color.fromARGB(255, 69, 39, 160);
  List<dynamic> _questions = [];
  List<dynamic> sum = [];
  final random = Random();
  String ans = "";
  int k = 0;

  void _answerQuestion(int score) {
    setState(() {
      ans = "";
      show = "";
      k = 0;
      _totalScore += score;
      _questionIndex++;
      selectedAnswer = null;
      con = Color.fromARGB(255, 69, 39, 160);
    });
  }

  void _restartQuiz() {
    setState(() {
      _questionIndex = 0;
      _totalScore = 0;
      selectedAnswer = null; // Reset selected answer
      con = Color.fromARGB(255, 69, 39, 160);
    });
  }

  Future<void> _fetchQuestions() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    CollectionReference questionsRef = firestore.collection('Quiz_sentence');

    try {
      QuerySnapshot querySnapshot = await questionsRef.get();
      querySnapshot.docs.forEach((doc) {
        _questions.add((doc.data()));
      });

      querySnapshot.docs.forEach((doc) {
        sum.add((doc.data()));
      });

      _questions.forEach((question) {
        question["correct_order"].shuffle(random);
      });
      _questions.shuffle(random);
      setState(() {});
    } catch (error) {
      print('Error fetching questions: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchQuestions();
    // _question.add({
    //   'pic': 'ฉันไปกินข้าว',
    //   'correct_order': ['ฉัน','ไป','กิน','ข้าว'],
    // },);
  }

  Widget build(BuildContext context) {
    return FutureBuilder(
        future: firebase,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(
                title: Text("erro"),
              ),
              body: Center(
                child: Text("${snapshot.error}"),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Color.fromARGB(255, 69, 39, 160),
                title: Text(
                  'Quiz',
                  style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                ),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  key: ValueKey('backButton'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              body: _questionIndex < _questions.length
                  ? Quiz(
                      ans: ans,
                      sum: sum,
                      show: show,
                      questionIndex: _questionIndex,
                      questions: _questions..shuffle,
                      answerQuestion: _answerQuestion,
                      selectedAnswer: selectedAnswer,
                      choice: choice,
                      onAnswerSelected: (String answer) {
                        setState(() {
                          selectedAnswer = answer;
                        });
                      },
                      choiceselect: (int cha) {
                        setState(() {
                          if (k == 0) {
                            sum[cha]["correct_order"].forEach((question) {
                              ans += question;
                            });
                            k = 1;
                          }

                          choice = cha;
                        });
                      },
                      sho: (String cha) {
                        setState(() {
                          show += cha;
                        });
                      },
                      reshow: () {
                        setState(() {
                          show = "";
                        });
                      },
                      con: con,
                      colorc: (Color pop) {
                        setState(() {
                          con = pop;
                        });
                      },
                    )
                  : Result(_totalScore, _questions.length, _restartQuiz),
            );
          }
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}

// ignore: must_be_immutable
class Quiz extends StatelessWidget {
  final String quq = 'รูปภาพที่เห็นนี้คืออะไร';
  String? resultText;
  final Color? con;
  String buto = "Submit";
  final String show;
  final Function(String) sho;
  final int questionIndex;
  final List<dynamic> questions;
  final Function(int) answerQuestion;
  final Function(int) choiceselect;
  final int choice;
  final String? selectedAnswer;
  final void Function(String) onAnswerSelected;
  final Function(Color) colorc;
  final Function reshow;
  final List<dynamic> sum;
  String ans;
  Quiz(
      {required this.questionIndex,
      required this.questions,
      required this.answerQuestion,
      required this.selectedAnswer,
      required this.onAnswerSelected,
      required this.choiceselect,
      required this.choice,
      required this.con,
      required this.colorc,
      required this.show,
      required this.sho,
      required this.reshow,
      required this.sum,
      required this.ans});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 30,
        ),
        Expanded(
          child: Center(
              child: Image.network(
            questions[questionIndex]['pic'] as String,
            width: 350,
            height: 350,
            fit: BoxFit.cover,
          )),
        ),
        SizedBox(
          height: 30,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(quq),
            SizedBox(
              height: 8,
            ),
            Text(
              show,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (int i = 0;
                    i < questions[questionIndex]['correct_order'].length;
                    i += 2)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width *
                            0.3, // กำหนดความกว้างของตัวเลือก
                        child: ChoiceButton(
                          choiceIndex: i,
                          onSelect: () {
                            sho(questions[questionIndex]['correct_order'][i]
                                as String);
                            onAnswerSelected(show);
                            choiceselect(questionIndex);
                          },
                          text: questions[questionIndex]['correct_order'][i]
                              as String,
                          colo: selectedAnswer ==
                                  questions[questionIndex]['correct_order'][i]
                              ? const Color.fromARGB(255, 186, 218, 255)
                              : const Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                      if (i + 1 <
                          questions[questionIndex]['correct_order'].length)
                        SizedBox(
                          width: MediaQuery.of(context).size.width *
                              0.3, // กำหนดความกว้างของตัวเลือก
                          child: ChoiceButton(
                            choiceIndex: i + 1,
                            onSelect: () {
                              sho(questions[questionIndex]['correct_order']
                                  [i + 1] as String);
                              onAnswerSelected(show);
                              choiceselect(questionIndex);
                            },
                            text: questions[questionIndex]['correct_order']
                                [i + 1] as String,
                            colo: selectedAnswer ==
                                    questions[questionIndex]['correct_order']
                                        [i + 1]
                                ? const Color.fromARGB(255, 186, 218, 255)
                                : const Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                    ],
                  ),
              ],
            ),
          ],
        ),
        Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (resultText != null)
                    Text(
                      resultText!,
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ElevatedButton(
                    key: ValueKey('resort'),
                    onPressed: () {
                      reshow();
                      for (var question in questions) {
                        print(question);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 69, 39, 160)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 8.0),
                      child: Text(
                        "เรียงประโยคใหม่",
                        style: TextStyle(
                            fontSize: 15.0,
                            color: Color.fromARGB(255, 255, 255, 255)),
                      ),
                    ),
                  ),
                  SizedBox(height: 3.0),
                  ElevatedButton(
                    key: ValueKey('submitsort'),
                    onPressed: () {
                      Future.delayed(Duration(seconds: 1), () {
                        if (questions[questionIndex]['ans'] as String == show as String) {
                          answerQuestion(1);
                        } else {
                          answerQuestion(0);
                        }
                      });

                      colorc(questions[questionIndex]['ans'] as String == show as String
                          ? Color.fromARGB(255, 77, 255, 0)
                          : Color.fromARGB(255, 255, 0, 0));
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: con),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 32.0),
                      child: Text(
                        buto,
                        style: TextStyle(
                            fontSize: 18.0,
                            color: Color.fromARGB(255, 255, 255, 255)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ChoiceButton extends StatelessWidget {
  final String text;
  final VoidCallback onSelect; // เพิ่มพารามิเตอร์ onSelect แบบ VoidCallback
  final Color colo;
  final int choiceIndex;
  const ChoiceButton(
      {required this.text,
      required this.onSelect,
      required this.colo,
      required this.choiceIndex});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        key: ValueKey('choice_sortsen${choiceIndex}'),
        onPressed: onSelect, // เรียกใช้งานฟังก์ชัน onSelect เมื่อปุ่มถูกกด
        child: Text(text),
        style: ElevatedButton.styleFrom(backgroundColor: colo),
      ),
    );
  }
}

class Result extends StatelessWidget {
  final int totalScore;
  final int totalQuestions;
  final Function restartQuiz;

  Result(this.totalScore, this.totalQuestions, this.restartQuiz);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'You have completed the quiz!',
            style: TextStyle(fontSize: 20),
          ),
          Text(
            'Your Score: $totalScore out of $totalQuestions',
            style: TextStyle(fontSize: 18),
          ),
          ElevatedButton(
            key: ValueKey('restartquiz'),
            onPressed: () => restartQuiz(),
            child: Text('Restart Quiz'),
          ),
        ],
      ),
    );
  }
}
