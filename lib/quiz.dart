import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  // CollectionReference _question =
  //     FirebaseFirestore.instance.collection("voice_question_payok");
  int _questionIndex = 0;
  int _totalScore = 0;
  String? selectedAnswer;
  int choice = 0;
  Color con = Color.fromARGB(255, 69, 39, 160);
  List<dynamic> _questions = [];

  void _answerQuestion(int score) {
    setState(() {
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

    CollectionReference questionsRef = firestore.collection('question');

    try {
      final random = Random();
      QuerySnapshot querySnapshot = await questionsRef.get();
      querySnapshot.docs.forEach((doc) {
        _questions.add((doc.data()));
      });
      // _questions.forEach((question) {
      //   question["answers"].shuffle(random);
      // });
      // _questions.shuffle(random);
      setState(() {});
    } catch (error) {
      print('Error fetching questions: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchQuestions();
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
                      questionIndex: _questionIndex,
                      questions: _questions,
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
                          choice = cha;
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
  final String correctAnswer = 'Choice 1';
  String? resultText;
  final Color? con;
  String buto = "Submit";

  final int questionIndex;
  final List<dynamic> questions;
  final Function(int) answerQuestion;
  final Function(int) choiceselect;
  final int? choice;
  final String? selectedAnswer;
  final void Function(String) onAnswerSelected;
  final Function(Color) colorc;
  FlutterTts flutterTts = FlutterTts();

  Quiz(
      {required this.questionIndex,
      required this.questions,
      required this.answerQuestion,
      required this.selectedAnswer,
      required this.onAnswerSelected,
      required this.choiceselect,
      required this.choice,
      required this.con,
      required this.colorc});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          child: Image.network(
            questions[questionIndex]['pic'],
            width: 400,
            height: 400,
            fit: BoxFit.contain,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("รูปภาพที่เห็นนี้คืออะไร"),
            SizedBox(
              height: 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (int i = 0;
                    i < questions[questionIndex]['answers'].length;
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
                            choiceselect(i);
                            onAnswerSelected(questions[questionIndex]['answers']
                                [i]['text'] as String);
                          },
                          text: questions[questionIndex]['answers'][i]['text']
                              as String,
                          colo: selectedAnswer ==
                                  questions[questionIndex]['answers'][i]['text']
                              ? const Color.fromARGB(255, 186, 218, 255)
                              : const Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                      if (i + 1 < questions[questionIndex]['answers'].length)
                        SizedBox(
                          width: MediaQuery.of(context).size.width *
                              0.3, // กำหนดความกว้างของตัวเลือก
                          child: ChoiceButton(
                            choiceIndex: i + 1,
                            onSelect: () {
                              choiceselect(i + 1);
                              onAnswerSelected(questions[questionIndex]
                                  ['answers'][i + 1]['text'] as String);
                            },
                            text: questions[questionIndex]['answers'][i + 1]
                                ['text'] as String,
                            colo: selectedAnswer ==
                                    questions[questionIndex]['answers'][i + 1]
                                        ['text']
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
                    key: ValueKey('submit_picquiz'),
                    onPressed: () {
                      Future.delayed(Duration(seconds: 1), () {
                        answerQuestion(questions[questionIndex]['answers']
                            [choice]['score'] as int);
                      });

                      colorc(1 ==
                              questions[questionIndex]['answers'][choice]
                                  ['score'] as int
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
        key: ValueKey('choice_pic${choiceIndex}'),
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
