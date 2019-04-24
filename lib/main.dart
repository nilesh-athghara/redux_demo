import "package:flutter/material.dart";


//three major points for flutter
//1. Single source of truth--whole state of application is stored in a store
//2. state is im-mutable i.e it can only be re-drawn, changes cant be made
//3. changes to the state is made by pure functions i.e these functions have no side effects
//i.e they take an previous state and action to produce a new state
void main()
{
  runApp(new MaterialApp(home: new MyApp(),));
}

class MyApp extends StatefulWidget{
  @override
  MyHomePage createState()=>new MyHomePage();
}

class MyHomePage extends State<MyApp >
{
  @override
  Widget build(BuildContext context)
  {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Redux Examples"),
      ),
      body: new Container(
        padding: new EdgeInsets.all(16.0),
        child: new Center(
          child: new Column(
            children: <Widget>[

            ],
          ),
        ),
      ),
    );
  }
}