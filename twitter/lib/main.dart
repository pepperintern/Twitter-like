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
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.refresh,
              ),
              onPressed: () {
                getData();
              }),
        ],
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
                  onPressed: () async {
                    await sendPostData(postctl);
                    getData();
                    postctl.clear();
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
      data = json.decode(response.body);
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
            title: Text("${data[index]["message"]}"),
            trailing: Text("${data[index]["created_at"]}"),
          ),
        );
      },
    ));
  }
}

class Login extends StatefulWidget {
  LoginState createState() => LoginState();
}
class LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("ログイン")),
        body: _loginform());
  }
  Widget _loginform(){
    return Form( 
          key: _formKey,
          child:Container(
          margin: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: namectl,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    hintText: "name.....", labelText: 'Post name'),
              ),
              TextFormField(
                controller: emailctl,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    hintText: "email.......", labelText: 'Post email'),
              ),
              new RaisedButton(
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    sendUserData(namectl, emailctl);
                    Navigator.of(context).pushNamed("/myHomePage");
                  }
                },
                child: const Text("送信"),
              )
            ],
          ),
        ));
  }
}
