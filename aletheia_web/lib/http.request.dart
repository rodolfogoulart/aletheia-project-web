import 'dart:convert';

import 'package:aletheia_web/model/data.cards.dart';
import 'package:http/http.dart' as http;

//git api
// https://api.github.com/repos/rodolfogoulart/aletheia-project-web/contents/aletheia_web/data/dataCards.json

//editor
//https://jsonformatter.org/json-editor

Future<(String, int)> request(url, path) async {
  try {
    //need to take out the https://
    var uri = Uri.https(url, path);

    var result = await http.get(uri);
    return (result.body, result.statusCode);
  } catch (e) {
    return ('', 404);
  }
}

Future<List<DataCards>?> requestDataCards() async {
  var data =
      await request('raw.githubusercontent.com', '/rodolfogoulart/aletheia-project-web/main/aletheia_web/data/dataCards.json');
  if (data.$2 == 404) return null;
  // DataCards
  List<DataCards> cards = (jsonDecode(data.$1) as List).map((e) => DataCards.fromMap(e)).toList();

  return cards;
}

Future<String?> requestDataBody() async {
  var data = await request('raw.githubusercontent.com', '/rodolfogoulart/aletheia-project-web/main/aletheia_web/data/body.txt');
  if (data.$2 == 404) return null;
  return data.$1;
}

Future<String?> requestDataBottom() async {
  var data = await request('raw.githubusercontent.com', '/rodolfogoulart/aletheia-project-web/main/aletheia_web/data/bottom.txt');
  if (data.$2 == 404) return null;
  return data.$1;
}
