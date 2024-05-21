// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:todo_app/pages/home.dart';

void main (){
  runApp(const Todo());
}

class Todo extends StatelessWidget {
  const Todo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:Home(),
      // theme: ThemeData(useMaterial3: false),
    );
  }
}
