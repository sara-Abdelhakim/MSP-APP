import 'dart:convert';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:msp_app/ui/colors.dart';

const baseUrl = "https://my-json-server.typicode.com/salah-rashad/msp-json";

//Future<Event> fetchPost() async {
//  final response =
//  await http.get('https://my-json-server.typicode.com/salah-rashad/msp-json/events');
//
//  if (response.statusCode == 200) {
//    // If server returns an OK response, parse the JSON.
//    return Event.fromJson(json.decode(response.body));
//  } else {
//    // If that response was not OK, throw an error.
//    throw Exception('Failed to load post');
//  }
//}

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
  final String description;
  final String image;
  final String formUrl;
  final int price;

  Event({
    this.id,
    this.title,
    this.time,
    this.location,
    this.description,
    this.image,
    this.formUrl,
    this.price,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      title: json['title'],
      time: json['time'],
      location: json['location'],
      description: json['description'],
      image: json['image'],
      formUrl: json['formUrl'],
      price: json['ticket_price'],
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
//    event = fetchPost();
    _getEvents();
  }

  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int i) => EventItem(events[i]),
      itemCount: events.length,
    );
  }
}
//const loremIpsum = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";

class EventItem extends StatelessWidget {
  const EventItem(this.event);

  final Event event;

  Widget _buildEventCard(BuildContext context, Event event) {
    return ExpandableNotifier(
        child: ScrollOnExpand(
      scrollOnExpand: false,
      scrollOnCollapse: true,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 150,
                width: MediaQuery.of(context).size.width,
                child: Container(
                  child: Image.network(
                    event.image,
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                  ),
                ),
              ),
              ScrollOnExpand(
                scrollOnExpand: true,
                scrollOnCollapse: false,
                child: ExpandablePanel(
                  tapHeaderToExpand: true,
                  tapBodyToCollapse: true,
                  headerAlignment: ExpandablePanelHeaderAlignment.center,
                  header: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            event.title,
                            style: Theme.of(context).textTheme.body2,
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            event.time,
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      )),
                  collapsed: Text(
                    event.description,
                    softWrap: true,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  expanded: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(
                            bottom: 16,
                          ),
                          child: Text(
                            event.description,
                            softWrap: true,
                            overflow: TextOverflow.fade,
                          )),
                    ],
                  ),
                  builder: (_, collapsed, expanded) {
                    return Padding(
                      padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                      child: Expandable(
                        collapsed: collapsed,
                        expanded: expanded,
                        crossFadePoint: 0,
                      ),
                    );
                  },
                ),
              ),
              ButtonTheme.bar(
                child: ButtonBar(
                  alignment: MainAxisAlignment.start,
                  children: <Widget>[
                    FlatButton(
                      child: Text(
                        'Enroll'.toUpperCase(),
                        style: TextStyle(color: purple),
                      ),
                      onPressed: () {
                        /* ... */
                      },
                    ),
                    FlatButton(
                      child: Text(
                        'Location'.toUpperCase(),
                        style: TextStyle(color: blue.withOpacity(0.5)),
                      ),
                      onPressed: () {
                        /* ... */
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    ));
//        TextStyle headerStyle = TextStyle(
//          fontSize: 18.0, fontWeight: FontWeight.w500, color: primaryColor);

//        return ConfigurableExpansionTile(
//            headerExpanded: Expanded(
//                child: Container(
//                    padding: EdgeInsets.only(left: 16, right: 16),
//                    height: 80,
//                    child: Row(
//                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                        children: <Widget>[
//                            Text(
//                                event.title.toUpperCase(),
//                                style: headerStyle,
//                            ),
//                            Icon(
//                                Icons.keyboard_arrow_down,
//                                color: Color(0xFF757575),
//                            ),
//                        ],
//                    ),
//                ),
//            ),
//            header: Expanded(
//                child: Container(
//                    padding: EdgeInsets.only(left: 16, right: 16),
//                    height: 80,
//                    child: Row(
//                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                        children: <Widget>[
//                            Text(
//                                event.title.toUpperCase(),
//                                style: headerStyle,
//                            ),
//                            Icon(
//                                Icons.keyboard_arrow_right,
//                                color: Color(0xFF757575),
//                            ),
//                        ],
//                    ),
//                ),
//            ),
//            children: [
//                Card(
//                    margin: EdgeInsets.only(left: 18, right: 18),
//                    child: Column(
//                        children: event.children.map(headTiles).toList(),
//                    ),
//                )
//            ],
//        );
  }

  @override
  Widget build(BuildContext context) {
    return _buildEventCard(context, event);
  }
}
