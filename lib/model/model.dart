import 'package:flutter/foundation.dart';

class Item {
  final int id;
  final String body;
  final bool completed;

  Item({@required this.id, @required this.body, this.completed = false});

  //this function takes parameters and ensures that a new object is created instead of mutating it.
  Item copyWith({int id, String body,bool completed}) {
    return Item(
        //if received id and body is null we take previous
        id: id ?? this.id,
        body: body ?? this.body,
        completed: completed ?? this.completed);
  }

  Item.fromJson(Map json)
      : body = json['body'],
        id = json['id'],
        completed = json['completed'];

  Map toJson() => {"id": id, 'body': body, 'completed': completed};

  //to get actual data instead on instance of class
//we can override to string functions
  @override
  String toString() {
    return toJson().toString();
  }
}

class AppState {
  //entire state of application will be represented by this class
  final List<Item> items;

  const AppState({@required this.items});

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

  @override
  String toString() {
    return toJson().toString();
  }
}
