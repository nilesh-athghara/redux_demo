import "package:flutter/material.dart";
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:practice/model/model.dart';
import 'package:practice/redux/reducer.dart';
import 'package:practice/redux/actions.dart';
import 'package:practice/redux/middleware.dart';

//three major points for flutter
//1. Single source of truth--whole state of application is stored in a store
//2. state is im-mutable i.e it can only be re-drawn, changes cant be made
//3. changes to the state is made by pure functions i.e these functions have no side effects
//i.e they take an previous state and action to produce a new state
void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyApp createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    //here we will create a store that will store our application state and we will wrap material app with it
    final Store<AppState> store =
        Store<AppState>(appStateReducer, initialState: AppState.initialState(),
            //here we have a middleware tag which accepts a list of middleware
            middleware: appStateMiddleware());
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Redux Demo",
        //to load initial state we will use store builder
        //it is like a store connector but instead of using a viewModel and using
        //specific functions it will accept the whole state
        home: StoreBuilder<AppState>(
          builder: (BuildContext context, Store<AppState> store) =>
              MyHomePage(store),
          onInit: (store) => store.dispatch(GetItemsAction()),
        ),
        theme: ThemeData.dark(),
      ),
    );
  }
}

//after setting up the store and the store provider
//we will have to add store connectors to proliferate the store down the structure

class MyHomePage extends StatefulWidget {
  final Store<AppState> store;

  MyHomePage(this.store);

  @override
  _MyHomePage createState() => _MyHomePage();
}

class _MyHomePage extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Redux Examples"),
        ),
        body: StoreConnector<AppState, _ViewModel>(
          //this _ViewModel is just a middle piece that connects our ui and store
          //converter is a function that will take up the store and convert it into the _ViewModel
          //that we want to pass down the tree
          converter: (Store<AppState> store) {
            return _ViewModel.create(store);
          },
          builder: (BuildContext context, _ViewModel viewModel) {
            return Container(
              child: Column(
                children: <Widget>[
                  AddItemWidget(viewModel),
                  Expanded(
                    child: ItemListWidget(viewModel),
                  ),
                  RemoveItemsButtonWidget(viewModel),
                ],
              ),
            );
          },
        ));
  }
}

class _ViewModel {
  //here we will define what we want to expose form our store to this ui
  final List<Item> items;
  final Function(String) onAddItem;
  final Function(Item) onRemoveItem;
  final Function() onRemoveItems;

  //now we will set up constructors
  _ViewModel(
      {this.items, this.onAddItem, this.onRemoveItem, this.onRemoveItems});

  //create a factory constructor to allow us
  //to take in the store and create a _ViewModel class object
  factory _ViewModel.create(Store<AppState> store) {
    _onAddItem(String body) {
      store.dispatch(AddItemAction(body));
    }

    _onRemoveItem(Item item) {
      store.dispatch(RemoveItemAction(item));
    }

    _onRemoveItems() {
      store.dispatch(RemoveItemsAction());
    }

    //every time this method is called we will return a new _ViewModel instance from our factory
    return _ViewModel(
        items: store.state.items,
        onAddItem: _onAddItem,
        onRemoveItem: _onRemoveItem,
        onRemoveItems: _onRemoveItems);
  }
}

class AddItemWidget extends StatefulWidget {
  final _ViewModel model;

  AddItemWidget(this.model);

  @override
  _AddItemWidget createState() => _AddItemWidget();
}

class _AddItemWidget extends State<AddItemWidget> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(hintText: "Add an Item"),
        onSubmitted: (String content) {
          widget.model.onAddItem(content);
          controller.text = " ";
        },
      ),
    );
  }
}

class ItemListWidget extends StatelessWidget {
  final _ViewModel model;

  ItemListWidget(this.model);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: model.items.map((Item item) {
        return ListTile(
          title: Text(item.body),
          trailing: IconButton(
              onPressed: () {
                model.onRemoveItem(item);
              },
              icon: Icon(
                Icons.delete,
                color: Colors.white,
              )),
        );
      }).toList(),
    );
  }
}

class RemoveItemsButtonWidget extends StatelessWidget {
  final _ViewModel model;

  RemoveItemsButtonWidget(this.model);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Text(
        "Delete all items",
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        model.onRemoveItems();
      },
    );
  }
}
