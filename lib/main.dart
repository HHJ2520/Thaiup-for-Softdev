import 'package:flutter/material.dart';
import 'package:tesgf/payokpange.dart';
import 'package:tesgf/quiz_sara.dart';
import 'package:tesgf/voic_payok.dart';
import 'package:tesgf/voic_sara.dart';
import 'aboutpage.dart';
import 'firstpage.dart';
import 'flashcard.dart';
import 'secon.dart';
import 'quiz.dart';
import 'senquiz.dart';
import 'voic.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() {
  runApp(const MyApp());
  WidgetsFlutterBinding.ensureInitialized();

  Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 130, 208, 242)),
        useMaterial3: true,
      ),
      home: const Firstpage(),
      routes: {
        '/second': (context) => const Second(),
        '/first': (context) => const Firstpage(),
        '/quiz': (context) => QuizPage(),
        '/voic': (context) => voic(),
        '/sentence': (context) => SenQuiz(),
        '/voic_sara': (context) => voic_sara(),
        '/voic_payok': (context) => voic_payok(),
        '/payokpange': (context) => payokpang(),
        '/flashcard': (context) => FlashcardPage(),
        '/quiz_sara': (context) => Quizsara(),
        '/aboutpage': (context) => const Aboutpage(),
      },
    );
  }
}
