class VerseResponse {
  final Verse prev, curr, next;

  VerseResponse({this.prev, this.curr, this.next});

  VerseResponse.fromJson(Map<String, dynamic> json)
  // Helps with Edge Case for Start of Bible
    : prev = (json['prev'] != null) ? Verse.fromJson(json['prev']) : null,
      curr = Verse.fromJson(json['curr']),
  // Helps with Edge Case for End of Bible
      next = (json['next'] != null) ? Verse.fromJson(json['next']) : null;
}

class Verse {
  final String book;
  final int chapter;
  final int verse;
  final String text;

  Verse({this.book, this.chapter, this.verse, this.text});

  Verse.fromJson(Map<String, dynamic> json)
    : book = json['book'],
      chapter = json['chapter'],
      verse = json['verse'],
      text = json['text'];
}