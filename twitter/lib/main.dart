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
      // home: MyHomePage(),
      routes: <String, WidgetBuilder>{
        // '/MyHomePage': (_) => new MyHomePage(),
        '/Login': (_) => new Login(),
      },
    );
  }
}

// class MyHomePage extends StatefulWidget{
//   MyHomePageState createState() => MyHomePageState();
// }

// class MyHomePageState extends State<MyHomePage>{
//   @override
//   Widget build(BuildContext context){
//     return Scaffold(
//       appBar: new AppBar(
//         title: Center(
//           child: Text("ホーム"),
//         ),
//       ),
//       body: null,//ここにツイートリストを表示する
//     );
//   }
// }

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
      body: _login(), //ここにログイン画面を入れる。
    );
  }
  Widget _login(){ Padding(
      padding: _padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextField(
            keyboardType: TextInputType.text,
            style: Theme.of(context).textTheme.body1,
            decoration: InputDecoration(
              labelText: "お名前",
              labelStyle: Theme.of(context).textTheme.display1,
            ),
          )
        ],
      ),
    );

}
}