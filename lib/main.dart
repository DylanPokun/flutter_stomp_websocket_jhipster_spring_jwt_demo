import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

import 'shared/global_config.dart' as conf;

void main() => runApp(MyApp());

dynamic onConnect(StompClient client, StompFrame frame) {
  client.subscribe(
      destination: "/topic/tracker",
      callback: (StompFrame frame) {
        //List<dynamic> result = json.decode(frame.body);
        print(frame);
        print(frame.body);
      });

  Timer.periodic(Duration(seconds: 10), (_) {
    client.send(
        destination: "/topic/activity",
        body: json.encode({"page": "Hello Flutter !"}));
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final title = 'STOMP-WebSocket-JHipster Demo';

    return MaterialApp(
      title: title,
      home: MyHomePage(title: title),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  MyHomePage({Key key, @required this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isAuthenticated = false;
  String token;
  StompClient stompClient;

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> authData = {
      'username': conf.USERNAME,
      'password': conf.PASSWORD,
      'rememberMe': conf.REMEMBER_ME
    };
    if (!isAuthenticated) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Container(
          padding: EdgeInsets.all(10.0),
          child: Center(
            child: RaisedButton(
              textColor: Colors.white,
              child: Text('Login with ' + conf.USERNAME + "@" + conf.PASSWORD),
              color: Colors.deepOrange[900],
              onPressed: () =>
                  PostLogin(authData).request().then((var authData) {
                print(authData);
                token = authData["id_token"];
                if (token != null && token.length > 1) {
                  stompClient = StompClient(
                      config: StompConfig(
                          url: conf.WS_URL + token, onConnect: onConnect));
                  stompClient.activate();
                  setState(() {
                    isAuthenticated = true;
                  });
                }
              }),
            ),
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child:
              Text("Connected ! Sending message to backend every 10 seconds"),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class PostLogin {
  Map<String, dynamic> _authData;

  PostLogin(this._authData);

  Future<Map<String, dynamic>> request() async {
    http.Response response = await http.post(
      conf.SERVER_AUTH_URL,
      body: json.encode(_authData),
      headers: {'Content-Type': 'application/json'},
    );

    return json.decode(response.body);
  }
}
