import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:practice/model/model.dart';
import 'package:practice/redux/reducer.dart';
import 'package:practice/redux/actions.dart';
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

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
void appStateMiddleware(Store <AppState> store,action, NextDispatcher next)async
{
  next(action);
  if(action is AddItemAction ||
  action is RemoveItemAction||
  action is RemoveItemsAction)
    {
      saveToPrefs(store.state);
    }
  if(action is GetItemsAction)
    {
      //here we take the saved data and dispatch it to an action
      await loadFromPrefs().then((state)=> store.dispatch(LoadedItemsAction(state.items)));
    }
}