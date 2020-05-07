import 'package:bible_app_mobile/pages/verseDisplay.dart';
import 'package:flutter/material.dart';
import 'services/verseAPI.dart';
import 'package:flutter/cupertino.dart';


Future<void> main() async {
  runApp(MyApp());
} 

class MyApp extends StatelessWidget {

  
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    
    
    return MaterialApp(
      title: 'Flutter Bible App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: MyHomePage(title: 'Flutter Bible App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final VerseAPI verseAPI = VerseAPI();

  Future<List<String>> versions;
  Future<List<String>> books;
  Future<List<int>> chapters;
  Future<List<int>> verses;
 
  String versionselect;
  String bookselect;
  int chapterselect;
  int verseselect;

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override void initState() {

    widget.versions = widget.verseAPI.getVersions();
    widget.versions.then( (versions){
      widget.versionselect = versions[0];

      widget.books = widget.verseAPI.getBooks(widget.versionselect);
      widget.books.then( (books){
        widget.bookselect = books[0];

        widget.chapters = widget.verseAPI.getChapters(widget.versionselect, widget.bookselect);
        widget.chapters.then( (chapters) {
          widget.chapterselect = chapters[0];

          widget.verses = widget.verseAPI.getVerses(widget.versionselect, widget.bookselect, widget.chapterselect);
          widget.verses.then( (verses) {
            widget.verseselect = verses[0];

          });
        });

      });
    });

    super.initState();
  }

  // an example of a function
  void versionChanged(version) {
    setState(() {
      widget.versionselect = version;
      
      widget.books = widget.verseAPI.getBooks(widget.versionselect);
      widget.books.then( (books){
        bookChanged(books[0]);

      });

    });
  }

  void bookChanged(book) {
    setState(() {
      widget.bookselect = book;
      widget.chapters = widget.verseAPI.getChapters(widget.versionselect, widget.bookselect);
      widget.chapters.then( (chapters) {
        chapterChanged(chapters[0].toString());
      });
    });
  }

  void chapterChanged(chapter) {
    setState(() {
      widget.chapterselect = int.parse(chapter);
      widget.verses = widget.verseAPI.getVerses(widget.versionselect, widget.bookselect, widget.chapterselect);
      widget.verses.then( (verses) {
        verseChanged(verses[0].toString());
      });
    });
  }

  void verseChanged(verse) {
    setState(() {
      widget.verseselect = int.parse(verse);
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Verse Selection'),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: <Widget>[
          // Version Row
          //Text("Please Reselect Version On intital Load"),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            Text("Version: ",
            
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.purple[800]
              )

            ),
          ]),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[          
              FutureBuilder<List<String>>(
                future: widget.versions, // a previously-obtained Future<String> or null
                builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
                  var versiondropdown;

                  if (snapshot.hasData) {
                    versiondropdown = DropdownButton<String>(
                    value: widget.versionselect,
                    items: snapshot.data.map((String value) {
                      return new DropdownMenuItem<String>(
                        value: value,
                        child: new Text(value,
                          textAlign: TextAlign.center,
                        
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {

                        print("User selected ${value}");
                        versionChanged(value);

                      },
                    );
                    
                  } else if (snapshot.hasError) {
                    versiondropdown = Text("Error");
                  } else {
                    versiondropdown = Text("Populating");
                  }
                  
                  return versiondropdown;
                },
              ), 
            ]),
          ),
          // Book Row
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            Text("Book: ",
            
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.purple[800]
                )
            
            ),
          ]),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[          
              FutureBuilder<List<String>>(
                future: widget.books, // a previously-obtained Future<String> or null
                builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
                  var bookdropdown;

                  if (snapshot.hasData) {
                    bookdropdown = DropdownButton<String>(
                    value: widget.bookselect,
                    items: snapshot.data.map((String value) {
                      return new DropdownMenuItem<String>(

                        value: value,
                        child: new Text(value),
                        
/* Centers the text but is not completely centered on page
                        value: value,
                        child: Container(child: 
                        Text(value),
                        width: 160,
                        alignment: Alignment.center,
                        ),
*/
                      );
                    }).toList(),
                    onChanged: (value) {

                        print("User selected ${value}");
                        bookChanged(value);

                      },
                    );
                    
                  } else if (snapshot.hasError) {
                    bookdropdown = Text("Error");
                  } else {
                    bookdropdown = Text("Populating");
                  }
                  
                  return bookdropdown;
                },
              ), 
            ]),
          ),
          // Chapter Row
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            Text("Chapter: ",

              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.purple[800]
              ),
            ),
          ]),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              FutureBuilder<List<int>>(
                future: widget.chapters, // a previously-obtained Future<String> or null
                builder: (BuildContext context, AsyncSnapshot<List<int>> snapshot) {
                  var dropdown;

                  if (snapshot.hasData) {
                    dropdown = DropdownButton<String>(
                    value: widget.chapterselect.toString(),
                    items: snapshot.data.map((int value) {
                      return new DropdownMenuItem<String>(
                        value: value.toString(),
                        child: new Text(value.toString()),
                      );
                    }).toList(),
                    onChanged: (value) {

                        print("User selected ${value}");
                        chapterChanged(value);

                      },
                    );
                    
                  } else if (snapshot.hasError) {
                    dropdown = Text("Error");
                  } else {
                    dropdown = Text("Populating");
                  }
                  
                  return dropdown;
                },
              ), 
            ]),
          ),
          // Verse Row
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            Text("Verse: ",

            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.purple[800]
              )
            ),
          ]),

          Padding(
            padding: const EdgeInsets.only(top: 8.0, right: 8.0, bottom: 20.0, left: 8.0),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              FutureBuilder<List<int>>(
                future: widget.verses, // a previously-obtained Future<String> or null
                builder: (BuildContext context, AsyncSnapshot<List<int>> snapshot) {
                  var tdropdown;

                  if (snapshot.hasData) {
                    tdropdown = DropdownButton<String>(
                    value: widget.verseselect.toString(),
                    items: snapshot.data.map((int value) {
                      return new DropdownMenuItem<String>(
                        value: value.toString(),
                        child: new Text(value.toString(), textAlign: TextAlign.center), 
                      );
                    }).toList(),
                    onChanged: (value) {

                        print("User selected ${value}");
                        verseChanged(value);

                      },
                    );
                    
                  } else if (snapshot.hasError) {
                    tdropdown = Text("Error");
                  } else {
                    tdropdown = Text("Populating");
                  }
                  
                  return tdropdown;
                },
              ), 
            ]),
          ),
/* Original Verse Selection Button
          RaisedButton(
            child: Text('Open Verse'),
            //textColor: Colors.white,
            padding: const EdgeInsets.all(12.0),
            color: Colors.deepPurple[200],
            onPressed: () {
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => VerseDisplay(widget.versionselect, widget.bookselect, widget.chapterselect, widget.verseselect))
              );
            },
          ),
          */
// Used this to match buttons on Verse View
          ButtonTheme(
            minWidth: 160.0,
            colorScheme: ColorScheme.dark(),
            // To change to iOS, replace 'RaisedButton' with ;CupertinoButton;
            // and import 'package:flutter/cupertino.dart';
            child: CupertinoButton(
              color: Colors.purple[800],
              child: Text('Find Verse'),
              onPressed: () {

                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => VerseDisplay(widget.versionselect, widget.bookselect, widget.chapterselect, widget.verseselect))
          );

              },
            ),
          ),
              
          Text("Please reselect version on intital load",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15.0,
              color: Colors.deepOrangeAccent
              )
          ),

        ],)
        
      ), 
    );
  }
}

