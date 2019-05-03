//this file contain all the actions performed in our application
import 'package:practice/model/model.dart';


//create classes for actions


class AddItemAction{
  //when building these actions we need to think about what type of data we need to expose to our ui to allow these changes to happen
  static int _id = 0;
  final String item;
  AddItemAction(this.item)
  {
    _id++;
  }

  //getter method to get the id
  int get id => _id;
}

class RemoveItemAction
{
  final Item item;
  RemoveItemAction(this.item);

}

class RemoveItemsAction
{
  //this action will remove all items i.e it will completely clear the appState
  //here we don't need any specific details like item or key
  //so we leave this empty for now

}

//to work with middle wares we need two functions
//1.one action that will we dispatched from user interface to middleware
//2. another action that gets dispatched from our middle to our reducer

//this will be called from ui
class GetItemsAction
{
  //since it wont require any specific data to load items we leave it empty
}

//this will be called from middleware
class LoadedItemsAction
{
  final List <Item> items;
  LoadedItemsAction(this.items);
}

class ItemCompletedAction
{
  final Item item;
  ItemCompletedAction(this.item);
}