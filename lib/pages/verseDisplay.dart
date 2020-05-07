import 'package:flutter/material.dart';
import '../services/verseAPI.dart';
import '../models/verse.dart';
import 'package:flutter/cupertino.dart';

class VerseDisplay extends StatefulWidget {
  final version;
  final book;
  final chapter;
  final verse;
  // Receive the selected verse from the verse selection
  VerseDisplay(this.version, this.book, this.chapter, this.verse);
  
  @override
  State<StatefulWidget> createState() {
    return VerseDisplayState(version, book, chapter, verse);
  }
}

class VerseDisplayState extends State<VerseDisplay> {

  String version; // version stays the same
  VerseDisplayState(versionInput, book, chapter, verse) {   // Initialize verse from verse selection
    version = versionInput;
    final selectedVerse = VerseAPI().getVerseNum(version, book, chapter, verse);
    selectedVerse.then((response) {
      setState(() {
        
        changeVerse(response);
        this._progressBarActive = false;
      }); 
    });
  }
  
  List<Verse> verses = [];

  // change verses to display when next or previous button is pressed
  void changeVerse(VerseResponse response) {
    verses = [
      response.prev,
      response.curr,
      response.next
    ];
  }

  void displayPreviousVerse() {
    // if there is no previous verse:
    if (verses[0] == null) {
      throw("ToDo: go to last verse of previous chapter");
    } else {
      final previousVerse = VerseAPI().getVerseNum(version, verses[0].book, verses[0].chapter, verses[0].verse);
      previousVerse.then((response) {
        setState(() {
          changeVerse(response);
          this._progressBarActive = false;
        }); 
      });
    }
  }

  void displayNextVerse() {
    // if there is no next verse:
    if (verses[2] == null) {
      throw("ToDo: go to first verse of next chapter");
    } else {
      final nextVerse = VerseAPI().getVerseNum(version, verses[2].book, verses[2].chapter, verses[2].verse);
      nextVerse.then((response) {
        setState(() {
          changeVerse(response);
          this._progressBarActive = false;
        }); 
      });
    }
  }

  Widget verseTemplate(verse) {
    if (verse == null) {
      return Text("");
    }
    return Card(
      margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              '${verse.book} ${verse.chapter}:${verse.verse}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.purple[800]
              )
            ),
            SizedBox(height: 6.0),
            Text(
              verse.text,
              style: TextStyle(
                fontSize: 14.0,
                // Renderflex for verses that are too long?
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _progressBarActive = true;

  Widget getBody() {
    if (_progressBarActive) {
      return 
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(),
                Text("Loading verses"),
              ],
            ),
          ),
        );
    } else {
      return 
        Column(
          children: <Widget>[
            Column(
              children: verses.map((verse) => verseTemplate(verse)).toList(),
            ),   
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ButtonTheme(
                  minWidth: 160.0,
                  colorScheme: ColorScheme.dark(),
                  // To change to iOS, replace 'RaisedButton' with ;CupertinoButton;
                  // and import 'package:flutter/cupertino.dart';
                  child: CupertinoButton(
                    color: Colors.purple[800],
                    child: Text('Previous'),
                    onPressed: () {
                      setState(() {
                        this._progressBarActive = true;
                      });
                      displayPreviousVerse();
                    },
                  ),
                ),
                SizedBox(width: 12.0),
                ButtonTheme(
                  minWidth: 160.0,
                  colorScheme: ColorScheme.dark(),
                  child: CupertinoButton(
                    color: Colors.purple[800],
                    child: Text('Next'),
                    onPressed: () {
                      setState(() {
                        this._progressBarActive = true;
                      });
                      displayNextVerse();              
                    },
                  ),
                ),
              ],
            )
          ],
        );
    }
  }
  @override
  Widget build (BuildContext ctxt) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Verses'),
        /*
        title: new Text(
          verses[1].book + ' ' + verses[1].chapter.toString() + ':' + verses[1].verse.toString()
        ),
        */
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: getBody()
    );
  }
}

