// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'create.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

bool check = true;

class _HomeState extends State<Home> {
  @override
  void initState() {
    getData();
    super.initState();
  }

  List myData = [];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        floatingActionButton: FloatingActionButton(
          // elevation: 2,
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => CreatePage()));
          },
          child: Icon(Icons.add_outlined),
        ),
        backgroundColor: Color(0xff303642),
        appBar: AppBar(
          backgroundColor: Color(0xff303642),
          title: Column(
            children: [
              Container(
                  margin: EdgeInsets.only(top: 20),
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    "Welcome back !",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontFamily: 'elsayed'),
                  )),
              Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(bottom: 10),
                  margin: EdgeInsets.only(bottom: 15),
                  child: Text(
                    "eng elsayed ebed",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        fontFamily: 'elsayed'),
                  )),
            ],
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(1.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 20, left: 10),
                    child: Text(
                      DateFormat().add_MMMMEEEEd().format((DateTime.now())),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: Container(
                        margin: EdgeInsets.only(top: 20),
                        child: IconButton(
                          onPressed: () {
                            getData();
                          },
                          icon: Icon(Icons.refresh_sharp),
                          color: Colors.white,
                          style: ButtonStyle(
                              backgroundColor:
                                  WidgetStatePropertyAll(Color(0xff3D4552)),
                              side: WidgetStatePropertyAll(
                                  BorderSide(style: BorderStyle.none))),
                        )),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Expanded(
                  child: ListView.builder(
                      itemCount: myData.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> data =
                            myData.reversed.toList()[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            padding: EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Color(0xff3D4552),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  maxLines: 1,
                                  data['title'],
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'elsayed',
                                      fontSize: 20,
                                      decoration: data["is_completed"]
                                          ? TextDecoration.lineThrough
                                          : TextDecoration.none,
                                      decorationThickness: 5,
                                      decorationColor: Colors.brown),
                                ),
                                Text(
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  data['description'],
                                  style: TextStyle(
                                      color: Color(0xffa6a3a3),
                                      fontFamily: 'elsayed',
                                      fontSize: 16),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "status : ",
                                      style: TextStyle(
                                          color: Color(0xffa6b6de),
                                          fontFamily: 'elsayed'),
                                    ),
                                    Text(
                                      data['is_completed'].toString(),
                                      style: TextStyle(
                                          color: Color(0xff728aba),
                                          fontFamily: 'elsayed',
                                          fontSize: 16),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      DateFormat.yMMMEd().format(
                                          DateTime.parse(data['created_at'])),
                                      style: TextStyle(
                                          color: Color(0xffa8a5a5),
                                          fontFamily: 'elsayed',
                                          fontSize: 16),
                                    ),
                                    SizedBox(
                                      width: 60,
                                    ),
                                    InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      CreatePage(
                                                        itemData: data,
                                                      )));
                                        },
                                        child: SvgPicture.asset(
                                          "assets/icons/file-edit.svg",
                                          color: Color(0xff666666),
                                          width: 21,
                                        )),
                                    SizedBox(width: 10),
                                    InkWell(
                                        onTap: () {
                                          print('delete');
                                        },
                                        child: SvgPicture.asset(
                                          "assets/icons/trash.svg",
                                          color: Color(0xff666666),
                                        )),
                                    Checkbox(
                                      value: data['is_completed'],
                                      onChanged: (value) {
                                        check(value!, data["_id"],
                                            data["title"], data["description"]);
                                      },
                                      checkColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          side: BorderSide(color: Colors.red),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      // activeColor: Colors.white,
                                      hoverColor: Colors.white,
                                      side: BorderSide(color: Colors.red),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      })),
            ],
          ),
        ),
      ),
    );
  }

  // get
  Future<void> getData() async {
    var url = Uri.parse('https://api.nstack.in/v1/todos');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      setState(() {
        myData = json['items'];
      });
    }
  }

  //check box
  check(bool check, String _id, String title, String des) async {
    final id = _id;
    final body = {
      "title": title,
      "description": des,
      "is_completed": check,
    };
    final url = Uri.parse('https://api.nstack.in/v1/todos/$id');
    final response = await http.put(url,
        headers: {'Content-Type': 'application/json'}, body: jsonEncode(body));
    print(response.statusCode);
  }
}
