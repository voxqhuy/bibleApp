import 'dart:convert';
import '../models/verse.dart';
import 'package:http/http.dart' as http;

class VerseAPI {

  String baseUrl = "http://rordonez.pythonanywhere.com/bible/api/v1.0/";

  Future<List<String>> getVersions() async {
    // make the request

    final response = await http.get(baseUrl + 'versions');

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      return json.decode(response.body).cast<String>();
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
  }

  Future<List<String>> getBooks(String version) async {
  // make the request

    final response = await http.get(baseUrl + version + '/books');

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      List<dynamic> something =  json.decode(response.body);
      List<String> result = something.map((element) => element[1].toString()).toList();
      return result;
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
  }

  Future<List<int>> getChapters(String version, String book) async {
  // make the request

    final response = await http.get(baseUrl + version + '/' + book + '/chapters');

      if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      int chapter = json.decode(response.body);
      List<int> chapters = [];
      for (int i=1; i <= chapter; i++) {
        chapters += [i];
      }
      return chapters;
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
  }

    Future<List<int>> getVerses(String version, String book, int chapter) async {
  // make request

    final response = await http.get(baseUrl + version + '/' + book + '/' + chapter.toString() + '/verses');

      if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      int numVerses = json.decode(response.body);
      List<int> verses = [];
      for (int i=1; i <= numVerses; i++) {
        verses += [i];
      }
      return verses;
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
  }



  Future<VerseResponse> getVerseNum(String version, String book, int chapter, int verse) async {
    // make the request

    final response = await http.get(baseUrl + version + '/' + book + '/' + chapter.toString() + '/' + verse.toString());
    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      return VerseResponse.fromJson(json.decode(response.body));
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
  }
  
}