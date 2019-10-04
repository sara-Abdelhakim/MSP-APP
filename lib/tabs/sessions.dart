import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';


class Sessions extends StatefulWidget {
  @override
  _SessionsState createState() => _SessionsState();
}

class _SessionsState extends State<Sessions> {
  List data;
  List userData;

  Future getData() async {
    http.Response response = await http.get(
        "https://my-json-server.typicode.com/salah-rashad/msp-json/sessions");
    data = json.decode(response.body);
    setState(() {
      userData = data;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          padding: EdgeInsets.all(16.0),
          itemCount: userData == null ? 0 : userData.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              color: Colors.white,
              elevation: 1.0,
              margin: EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Colors.black)),
              child: InkWell(
                onTap:() async {
                  var url = userData[index]["url"] ;
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
                child:  Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                      children: <Widget>[
//
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white70),
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Image.network(
                        userData[index]["image"],
                        fit: BoxFit.cover,
                        alignment: Alignment.centerRight,
                        width: 100.0,
                        height: 60.0,
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(30.0)),
                    new Text(
                      " ${userData[index]["title"]}",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 15.0,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ]),
                ),
              ),


            );
          }),
    );
  }
}
