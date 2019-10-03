import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:twitter/api.dart';

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
      body: Column(children: <Widget>[
        _tweetList(),
        _postTweet(),
      ]),
    );
  }

  Widget _postTweet() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.only(bottom: 50.0, left: 30),
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: postctl,
                  style: Theme.of(context).textTheme.body1,
                  decoration: InputDecoration(
                    hintText: "いまなにしてる？",
                    hintStyle: Theme.of(context).textTheme.display1,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                child: RaisedButton(
                  child: Text("送信"),
                  onPressed: () {
                    sendPostData(postctl);
                    // setState(() {
                    //   getData();
                    // });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List data;

  Future getData() async {
    http.Response response = await http.get("http://localhost:8080/posts");
    data = json.decode(response.body);
    setState(() {
      getData();
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  Widget _tweetList() {
    return Expanded(
        child: ListView.builder(
      itemCount: data == null ? 0 : data.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.black)),
          ),
          child: ListTile(
              title: Text("${data[index]["message"]}")),
        );
      },
    ));
  }
}

class Login extends StatefulWidget {
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  // TextEditingController namectl = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("ログイン")),
        body: new Container(
          margin: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: new Column(
            children: <Widget>[
              new TextField(
                controller: namectl,
                decoration: InputDecoration(
                    hintText: "name.....", labelText: 'Post name'),
              ),
              new TextField(
                controller: emailctl,
                decoration: InputDecoration(
                    hintText: "email.......", labelText: 'Post email'),
              ),
              new RaisedButton(
                onPressed: () async {
                  sendUserData(namectl, emailctl);
                  Navigator.of(context).pushNamed("/myHomePage");
                },
                child: const Text("送信"),
              )
            ],
          ),
        ));
  }

  final _nameController = TextEditingController();

  Widget _login() {
    return Padding(
      padding: EdgeInsets.only(top: 80.0, right: 30.0, left: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextFormField(
            controller: _nameController,
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
      padding: EdgeInsets.only(top: 150.0),
      child: SizedBox(
        width: 200.0,
        height: 60.0,
        child: RaisedButton(
          child: Text(
            "Submit",
            style: new TextStyle(fontSize: 24),
          ),
          onPressed: () {
            Navigator.of(context).pushNamed("/myHomePage");
          },
        ),
      ),
    );
  }
}
