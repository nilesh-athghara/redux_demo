import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:practice/model/model.dart';
import 'package:practice/redux/reducer.dart';
import 'package:practice/redux/actions.dart';
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

Middleware<AppState> _loadFromPrefs(AppState state)
{
  //these functions will return middleware closures of AppState type
  //here we can clearly see that a signature of Middleware is returned
  return (Store<AppState> store, action, NextDispatcher next)
  {
    next(action);
    loadFromPrefs().then((state)=>store.dispatch(LoadedItemsAction(state.items)));
  };
}

Middleware<AppState> _saveToPrefs(AppState state)
{
  return (Store<AppState> store, action, NextDispatcher next)
  {
    next(action);
    saveToPrefs(store.state);
  };
}

//after writing specific middleware types we will create a list of our middleware's
//this will return a list of middleware's at the main screen
//when our application loads up and there are no states
//for our safety we create an empty state here
List<Middleware<AppState>> appStateMiddleware([AppState state = const AppState(items: [])])
{
  final loadItems=_loadFromPrefs(state);
  final saveItems=_saveToPrefs(state);
  return [
    TypedMiddleware<AppState,AddItemAction>(saveItems),
    TypedMiddleware<AppState,RemoveItemsAction>(saveItems),
    TypedMiddleware<AppState,RemoveItemAction>(saveItems),
    TypedMiddleware<AppState,GetItemsAction>(loadItems),
  ];
}


void saveToPrefs(AppState state)async
{
  SharedPreferences prefs=await SharedPreferences.getInstance();
  await prefs.setString('itemState', json.encode(state.toJson()));
}

Future<AppState> loadFromPrefs()async
{
  SharedPreferences prefs=await SharedPreferences.getInstance();
  String appStateString= prefs.getString('itemState');
  if(appStateString!=null)
    {
      return AppState.fromJson(json.decode(appStateString));
    }
  return AppState.initialState();
}

//now create an actual middleware function
//here next dispatcher is a piece of function that we will call to chain this middle ware
//to another middle ware if required or to our reducer
//void appStateMiddleware(Store <AppState> store,action, NextDispatcher next)async
//{
//  next(action);
//  if(action is AddItemAction ||
//  action is RemoveItemAction||
//  action is RemoveItemsAction)
//    {
//      saveToPrefs(store.state);
//    }
//  if(action is GetItemsAction)
//    {
//      //here we take the saved data and dispatch it to our reducer
//      await loadFromPrefs().then((state)=> store.dispatch(LoadedItemsAction(state.items)));
//    }
//}