//this file will contain pure function to create new states
import 'package:practice/model/model.dart';
import 'package:practice/redux/actions.dart';


//this function gets called every time we commit a change to our store
//we take a state and an action as parameter and return a new state
AppState appStateReducer(AppState state,action)
{
  return AppState(
    items: itemReducer(state.items, action),
  );
}

//we can create specific reducer to allow us to manipulate only specific data like our list of items

//then we can chain these reducers with our parent reducer

List<Item> itemReducer(List<Item> state,action)
{
  //here return a new list by first adding all the previous daa and then the new action
  //.. is called cascade operator
  if(action is AddItemAction)
    {
      return []
        ..addAll(state)
        ..add(Item (id: action.id, body: action.item));
      //this will return a list with all the original state along with the new item
    }

  if(action is RemoveItemAction)
    {
      //here first we will create our original list
      return List.unmodifiable(List.from(state)..remove(action.item));
    }
  if(action is RemoveItemsAction)
    {
      //for this action we just need to return an empty list
      //here we can do two things
      //return [];
      return List.unmodifiable(<Item>[]);
    }
  if(action is LoadedItemsAction)
    {
      //this is the same items list that we mentioned in our actions class
      return action.items;
    }
  //if no action gets through the reducer the original state is returned
  return state;
}