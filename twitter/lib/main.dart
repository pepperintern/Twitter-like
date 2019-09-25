import 'dart:ui';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Twitter-like',
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      home: Login(),
      routes: <String, WidgetBuilder>{
        '/myHomePage': (_) => new MyHomePage(),
        '/login': (_) => new Login(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Center(
          child: Text("ホーム"),
        ),
      ),
      body: _tweetList()
    );
  }

  Widget _tweetList() {
    return ListView.builder(
        itemBuilder: (BuildContext context, int) {
          return Container(
            decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: Colors.black)
              ),
            ),
            child: ListTile(
                leading: Text("name"),
                title: Text("text")
            ),
          );
        }
    );
  }
}

class Login extends StatefulWidget {
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: Center(
            child: Text("ログイン"),
          ),
        ),
        body: Column(children: <Widget>[_login(), _submitButton()]));
  }

  Widget _login() {
    return Padding(
      padding: EdgeInsets.only(top: 80.0, right: 30.0, left: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextField(
            keyboardType: TextInputType.text,
            style: Theme.of(context).textTheme.display1,
            decoration: InputDecoration(
              labelText: "お名前",
              labelStyle: Theme.of(context).textTheme.display1,
            ),
          )
        ],
      ),
    );
  }

  Widget _submitButton() {
    return Padding(
      padding: EdgeInsets.only(top: 100.0),
      child:
      RaisedButton(
      child: Text("Submit"),
      onPressed: () {
        Navigator.of(context).pushNamed("/myHomePage");
      },),
    );
  }
}
