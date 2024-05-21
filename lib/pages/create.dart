// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, avoid_print
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class CreatePage extends StatefulWidget {
  Map? itemData;
  CreatePage({super.key,this.itemData});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  TextEditingController titlecon = TextEditingController();
  TextEditingController descon = TextEditingController();
  bool isEdit =false;
@override
  void initState() {
    // TODO: implement initState
  isEdit = true;
  final data = widget.itemData;
    if(widget.itemData != null){
titlecon.text = data!["title"];
descon.text = data["description"];
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff303642),
      appBar: AppBar(
        backgroundColor: Color(0xff4e4c67),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 10, left: 3),
                child: Text(
                  "Task Title",
                  style: TextStyle(color: Colors.white, fontFamily: 'elsayed'),
                ),
              ),
              Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: TextField(
                    controller: titlecon,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(8)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.amber)),
                    ),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontFamily: 'elsayed'),
                  )),
              Container(
                  margin: EdgeInsets.only(top: 10, bottom: 10, left: 3),
                  child: Text("Task Description",
                      style: TextStyle(
                          color: Colors.white, fontFamily: 'elsayed'))),
              TextField(
                controller: descon,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide(color: Colors.red)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.amber)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.white))),
                style: TextStyle(
                    color: Colors.white, fontSize: 17, fontFamily: 'elsayed'),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        widget.itemData != null ? updateData() : postData();
                      },
                      child: Text(
                      widget.itemData != null ?"Update" :"create",
                        style: TextStyle(
                            fontFamily: 'elsayed',
                            color: Colors.white,
                            fontSize: 18),
                      ),
                      style: ButtonStyle(
                        shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7),
                          ),
                        ),
                        // backgroundColor:
                        backgroundColor:
                        WidgetStatePropertyAll(Color(0xffFF7461)),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  //post
  Future<void> postData() async {
    final body = {
      "title": titlecon.text,
      "description": descon.text,
      "is_completed": "false"
    };
    var url = Uri.parse('https://api.nstack.in/v1/todos');
    var response = await http.post(url,
        headers: {'Content-Type': 'application/json'}, body: jsonEncode(body));
    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("created"),
            backgroundColor: Colors.green,
          ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("something error "),
            backgroundColor: Colors.red,
          ));
    }
    //   var response = await http.post(url, body: {
    //     "title": "string",
    //     "description": "string",
    //     "is_completed": "false"
    //   });
    // print('Response status: ${response.statusCode}');
    //   print('Response body: ${response.body}');
    // }
  }

//put
  updateData() async {
    final id = widget.itemData!["_id"];
    final body = {
      "title": titlecon.text,
      "description": descon.text,
      "is_completed": "false"};

    final url = Uri.parse("https://api.nstack.in/v1/todos/$id");
    final response = await http.put(url, body: jsonEncode(body),
        headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("updated"),
            backgroundColor: Colors.green,
          ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("something error "),
            backgroundColor: Colors.red,
          ));
    }
  }

}