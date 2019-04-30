import 'package:flutter/foundation.dart';

class Item {
  final int id;
  final String body;

  Item({@required this.id, @required this.body});

  //this function takes parameters and ensures that a new object is created instead of mutating it.
  Item copyWith({int id, String body}) {
    return Item(
        //if received id and body is null we take previous
        id: id ?? this.id,
        body: body ?? this.body);
  }

  Item.fromJson(Map json)
      : body = json['body'],
        id = json['id'];

  Map toJson() => {"id": id, 'body': body};
}

class AppState {
  //entire state of application will be represented by this class
  final List<Item> items;

  AppState({@required this.items});

  //named Constructor to make initial state
  //its just an empty list
  AppState.initialState() : items = List.unmodifiable(<Item>[]);

  //create a from Json function to retrieve from shared prefs
  //here we take out data from key "items" then we convert that into a list through as List
  //after that wwe convert each item into object of Items class through map
  //and then put them back again by toList()
  AppState.fromJson(Map json)
      : items = (json['items'] as List).map((i) => Item.fromJson(i)).toList();

//create a toJson function to save the appState
  Map toJson() => {'items': items};
}
