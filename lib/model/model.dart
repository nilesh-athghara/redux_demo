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
}

class AppState {
  //entire state of application will be represented by this class
  final List<Item> items;

  AppState({@required this.items});

  //named Constructor to make initial state
  //its just an empty list
  AppState.initialState() : items = List.unmodifiable(<Item>[]);
}
