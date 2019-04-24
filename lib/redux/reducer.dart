//this file will contain pure function to create new states
import 'package:practice/model/model.dart';
import 'package:practice/redux/actions.dart';


//this function gets called every time we commit a change to our store
//we take a state and an action as parameter and return a new state
AppState appStateReducer(AppState state,action)
{
  return AppState();
}

//we can create specific reducer to allow us to manipulate only specific data like our list of items

//then we can chain these reducers with our parent reducer

List<Item> itemReducer(List<Item> state,action)
{


}