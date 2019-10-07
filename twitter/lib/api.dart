import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';


// トップページの情報をpostでrequestする処理の準備
class User {
  final int id;
  final String name;
  final String email;

  User({this.id, this.name, this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
      };
}

TextEditingController namectl = new TextEditingController();
TextEditingController emailctl = new TextEditingController();

Future<String> sendUserData(
    TextEditingController namectl, TextEditingController emailctl) async {
  var user = new User(
    name: namectl.text,
    email: emailctl.text,
  );

  var url = "http://localhost:8080/user";
  
  final response = await http.post(url,
      body: json.encode(user.toJson()),
      headers: {"Content-Type": "application/json"});

// serverからの処理
  if (response.statusCode == 200) {
    return response.body;
    // Do something if needed
  } else {
    throw Exception('Failed to load post');
  }
}




//　投稿ページの投稿をpostでrequestする処理の準備
class Post {
  final String message;

  Post({this.message});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      message: json['message'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'message': message,
  };
}

TextEditingController postctl = new TextEditingController();
Future<String> sendPostData(TextEditingController postctl) async {
  var message = new Post(
    message: postctl.text,
  );

  var url = "http://localhost:8080/post";

  // print(json.encode(message.toJson()));
  final response = await http.post(url,
      body: json.encode(message.toJson()),
      headers: {"Content-Type": "application/json"});

// serverからの処理
  if (response.statusCode == 200) {
    return response.body;
    // Do something if needed
  } else {
    throw Exception('Failed to load post');
  }
}