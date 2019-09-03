import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:msp_app/ui/colors.dart';
import 'package:url_launcher/url_launcher.dart';

const baseUrl = "https://my-json-server.typicode.com/salah-rashad/msp-json";

class API {
  static Future getUsers() {
    var url = baseUrl + "/events";
    return http.get(url);
  }
}

class Event {
  final int id;
  final String title;
  final String time;
  final String location;
  final String mapUrl;
  final String description;
  final String image;
  final String formUrl;
  final int price;
  final List<Topic> topics;

  Event({
    this.id,
    this.title,
    this.time,
    this.location,
    this.mapUrl,
    this.description,
    this.image,
    this.formUrl,
    this.price,
    this.topics,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    var list = json['topics'] as List;
    print(list.runtimeType); //returns List<dynamic>
    List<Topic> topicsList = list.map((i) => Topic.fromJson(i)).toList();

    return Event(
      id: json['id'],
      title: json['title'],
      time: json['time'],
      location: json['location'],
      mapUrl: json['map_url'],
      description: json['description'],
      image: json['image'],
      formUrl: json['form_url'],
      price: json['ticket_price'],
      topics: topicsList,
    );
  }
}

class Topic {
  final String title;
  final String sName;
  final String sDesc;

  Topic({this.title, this.sName, this.sDesc});

  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      title: json['topic_title'],
      sName: json['speaker_name'],
      sDesc: json['speaker_desc'],
    );
  }
}

class Events extends StatefulWidget {
  final Future<Event> event;

  Events({Key key, this.event}) : super(key: key);

  @override
  _EventsState createState() => _EventsState();
}

class _EventsState extends State<Events> {
  var events = new List<Event>();
  Future<Event> event;

  _getEvents() {
    API.getUsers().then((response) {
      setState(() {
        Iterable list = json.decode(response.body);
        events = list.map((model) => Event.fromJson(model)).toList();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _getEvents();
  }

  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemBuilder: (BuildContext context, int i) => EventItem(events[i], i),
      itemCount: events.length,
    );
  }
}

class EventItem extends StatelessWidget {
  const EventItem(this.event, this.i);

  final Event event;
  final int i;

  Widget _buildEventCard(BuildContext context, Event event) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: purple)),
      child: Container(
        padding: EdgeInsets.only(top: 16, bottom: 16),
        child: ExpansionTile(
          title: Text(event.title),
          leading: Image.network(
            event.image,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
          ),
          children: <Widget>[
            Container(
                padding: EdgeInsets.only(top: 32, right: 16, left: 16),
                child: Column(
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width / 4,
                          child: Text(
                            "Description".toUpperCase(),
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.black.withOpacity(0.5)),
                          ),
                        ),
                        Flexible(
                          child: Text(
                            event.description,
                            maxLines: 10,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width / 4,
                          child: Text(
                            "Date & Time".toUpperCase(),
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.black.withOpacity(0.5)),
                          ),
                        ),
                        Flexible(
                          child: Text(
                            event.time,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width / 4,
                          child: Text(
                            "Location".toUpperCase(),
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.black.withOpacity(0.5)),
                          ),
                        ),
                        Flexible(
                            child: GestureDetector(
                          onTap: () => launchURL(
                              "https://goo.gl/maps/zTFDqmuYrSQ3wQHu9"),
                          child: Text(
                            event.location,
                            style: TextStyle(
                                color: blue,
                                decoration: TextDecoration.underline),
                          ),
                        ))
                      ],
                    ),
                    SizedBox(
                      height: 32,
                    ),
                    ExpansionTile(
                      title: Text(
                        "Topics".toUpperCase(),
                        style: TextStyle(fontSize: 14),
                      ),
                      leading: Icon(Icons.library_books),
                      backgroundColor: Colors.black.withOpacity(0.1),
                      children: <Widget>[
                        ListView.builder(
                          padding: EdgeInsets.all(16),
                          itemBuilder: (BuildContext context, int i) =>
                              _buildTopicItem(context, event, i),
                          itemCount: event.topics.length,
                        ),
                      ],
                    ),
                    ButtonTheme(
                      child: ButtonBar(
                        alignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          RichText(
                            text: TextSpan(style: TextStyle(color: Colors.black),
                              children: [
                              TextSpan(text: "Ticket Price: ".toUpperCase()),
                                TextSpan(text: event.price.toString(), style: TextStyle(color: green, fontSize: 18)),
                                TextSpan(text: " L.E"),
                              ],
                            ),
                          ),
                          RaisedButton(
                            colorBrightness: Brightness.dark,
                            color: purple,
                            child: Text(
                              'Enroll'.toUpperCase(),
                              style: TextStyle(color: white),
                            ),
                            onPressed: () => launchURL(event.formUrl),
                          ),
                        ],
                      ),
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }

  Widget _buildTopicItem(BuildContext context, Event event, int index) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: <Widget>[
          Text(event.topics[index].title),
          Text(event.topics[index].sName),
          Text(event.topics[index].sDesc),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildEventCard(context, event);
  }
}

launchURL(String url) async {
  String mUrl = url;
  if (await canLaunch(mUrl)) {
    await launch(mUrl);
  } else {
    throw 'Could not launch $mUrl';
  }
}
