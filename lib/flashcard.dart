import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class FlashcardPage extends StatefulWidget {
  @override
  _FlashcardPageState createState() => _FlashcardPageState();
}

class _FlashcardPageState extends State<FlashcardPage> {
  int _currentIndex = 0;
  bool _showWord = false;
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  // List<Map<String, String>> _flashcards = [
  //   {'word': 'Word 1', 'image': 'image/p.png'},
  //   {'word': 'Word 2', 'image': 'image/2ndimage.png'},
  //   {'word': 'Word 3', 'image': 'assets/word3.jpg'},
  // ];
  List<dynamic> _flashcards = [];
  void toggleWordVisibility() {
    setState(() {
      _showWord = !_showWord;
    });
  }

  void nextFlashcard() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _flashcards.length;
      _showWord = false;
    });
  }

  Future<void> _fetchQuestions() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    CollectionReference questionsRef = firestore.collection('flashcards');

    try {
      QuerySnapshot querySnapshot = await questionsRef.get();
      querySnapshot.docs.forEach((doc) {
        _flashcards.add((doc.data()));
      });
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
                title: Text('Flashcards'),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  key: ValueKey('backButton'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              body: GestureDetector(
                key: ValueKey('showvocap'),
                onTap: toggleWordVisibility,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: NetworkImage(
                                _flashcards[_currentIndex]['image']),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      _showWord
                          ? Text(
                              _flashcards[_currentIndex]['word'],
                              style: TextStyle(fontSize: 24),
                            )
                          : SizedBox(),
                    ],
                  ),
                ),
              ),
              floatingActionButton: FloatingActionButton(
                key: ValueKey('nextflash'),
                onPressed: nextFlashcard,
                child: Icon(Icons.arrow_forward),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.active ||
              _flashcards.isEmpty) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
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
