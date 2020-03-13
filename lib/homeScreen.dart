import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:async';
import 'dart:typed_data';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:flutter_svg/flutter_svg.dart';

const baseUrl = "https://melange2020.in";

class API {
  static Future getUsers() {
    var url = "https://melange2020.in/Reg/data.json";
    print(http.get(url));
    return http.get(url);
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController idd = new TextEditingController();
  String barcode = '';
  Uint8List bytes = Uint8List(200);
  var users = new List<User>();

  _getUsers() {
    API.getUsers().then((response) {
      var o = response;
      //print(o.body.toString().substring(3));
      o = o.body.toString().substring(3);
      setState(() {
        Iterable list = json.decode(o);
        users = list.map((model) => User.fromJson(model)).toList();
      });
    });
  }

  initState() {
    super.initState();
    _getUsers();
  }

  whatever() async {
    /*var the = await http.get("https://melange2020.in/Reg/data.json");
    print(the.body);*/
    /*var file = the.toString();
    var bytes = File(file).readAsBytesSync();
    var decoder = SpreadsheetDecoder.decodeBytes(bytes, update: true);

    for (var table in decoder.tables.keys) {
      print(table);
      print(decoder.tables[table].maxCols);
      print(decoder.tables[table].maxRows);
      for (var row in decoder.tables[table].rows) {
        print("$row");
      }
    }*/
    /* var newer = await http.get("https://melange2020.in/Reg/data.json");
    print(newer.body);

    var json = await jsonDecode(newer.body);
    print('Howdy, ${json['Name']}');*/
  }

  //String cameraResult;
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: /*new Text('Melange 2020', ),*/ Image.asset(
          'assets/Melange 2020 Logo Black.png',
          width: 150.0,
        ),
      ),
      body: new Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            /*SizedBox(
              width: 200,
              height: 200,
              child: Image.memory(bytes),
            ),*/
            Padding(
              padding: const EdgeInsets.only(top: 20.0, left: 90.0, right: 90.0, bottom: 10.0),
              child: TextFormField(
                controller: idd,
                  textCapitalization: TextCapitalization.characters,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter Participant\'s Name';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.panorama_vertical),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    labelText: 'Booking ID',
                  )),
            ),/*
            barcode.isEmpty ? Text("Scan QR Code!") : Text('RESULT  $barcode'),*/
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Container(
                width: MediaQuery.of(context).size.width / 3,
                height: MediaQuery.of(context).size.width / 5,
                child: FlatButton(
                  color: Colors.blue,
                  onPressed: _scan,
                  child: Text(
                    "SCAN",
                    style: TextStyle(color: Colors.white, fontSize: 30.0),
                  ),
                ),
              ),
            ),


            /*
            RaisedButton(onPressed: _scanPhoto, child: Text("Scan Photo")),
            RaisedButton(onPressed: _generateBarCode, child: Text("Generate Barcode")),*/
          ],
        ),
      ),
    );
  }

  Future _scan() async {
    if(idd.text==""){
      String barcode = await scanner.scan();
      setState(() => this.barcode = barcode);
    }
    else{
      setState(() {
        this.barcode = idd.text;
      });
    }
    /*
    var newer;
    newer = await http.get("https://melange2020.in/Reg/data.json");*/
    /*newer = newer.body.toString().substring(3);*/
/*    print(newer.body);*/
/*
    var newer = await http.get("https://melange2020.in/Reg/data.json");
    print(newer.body.substring(3));
    var json = await jsonDecode(newer.body.substring(3));
    print('Howdy, ${json[0]['Name']}');*/

    print(users);
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => tuy(users, barcode, bytes)));
  }

/*  Future _scanPhoto() async {
    String barcode = await scanner.scanPhoto();
    setState(() => this.barcode = barcode);
  }
*/
  Future _generateBarCode() async {
    Uint8List result = await scanner
        .generateBarCode('https://github.com/leyan95/qrcode_scanner');
    this.setState(() => this.bytes = result);
  }
/*
   doQR() async{

    String cameraScanResult = await scanner.scan();

    setState(() {
      cameraResult = cameraScanResult;
    });
    return cameraScanResult;
  }*/
}

class User {
  String id;
  String name;
  String email;
  var college;
  var event;
  var g;
  var phone;

  var price;

  User(String id, String name, String email, var college, var event, var g,
      var price, var phone) {
    this.id = id;
    this.name = name;
    this.email = email;
    this.college = college;
    this.event = event;
    this.g = g;
    this.price = price;
    this.phone = phone;
  }

  User.fromJson(Map json)
      : id = json['TCFRegistrationId'],
        name = json['Name'],
        email = json['Email'],
        college = json['College'],
        event = json['Ticket name'],
        g = json['Gender'],
        price = json['TicketPrice'],
        phone = json['ContactNo'];

  Map toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'college': college,
      'event': event,
      'g': g,
      'price': price,
      'phone': phone
    };
  }
}

class tuy extends StatefulWidget {
  var users, bar, bytes;

  tuy(var users, var bar, var bytes) {
    this.users = users;
    this.bar = bar;
    this.bytes = bytes;
  }

  @override
  _tuyState createState() => _tuyState(users, bar, bytes);
}

class _tuyState extends State<tuy> {
  var users, bar, bytes;

  _tuyState(var users, var bar, var bytes) {
    this.users = users;
    this.bar = bar;
    this.bytes = bytes;
  }

  Future _generateBarCode() async {
    Uint8List result = await scanner
        .generateBarCode('https://github.com/leyan95/qrcode_scanner');
    this.setState(() => res = result);
  }

  Uint8List res;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: Image.asset(
            'assets/Melange 2020 Logo Black.png',
            color: Colors.black,
            width: MediaQuery.of(context).size.width / 2.5,
          ),
          leading: FlatButton(
            child: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Container(
          color: Colors.white,
          child: ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              print(users[index].id);
              if (users[index].id == bar) {
                print(bar);
                print("**************************");

                return /*ListTile(title: Text(users[index].name))*/
                    Container(
                  color: Colors.white,
                  padding: EdgeInsets.only(top: 0.0),
                  height: MediaQuery.of(context).size.height / 1.2,
                  child: Stack(
                    children: <Widget>[
                      Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width / 1.2,
                          height: MediaQuery.of(context).size.height / 1.1,
                          child:
                              /*SvgPicture.asset(
                            'assets/ticket.svg',*/ /*
                            color: Colors.blueAccent,*/ /*
                          ),*/
                              Image.asset('assets/ticket1.png'),
                        ),
                      ),
                      Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width / 1,
                          height: MediaQuery.of(context).size.height / 1.5,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              5),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(
                                            Icons.face,
                                            color: Colors.white,
                                          ),
                                          SizedBox(
                                            width: 40,
                                          ),
                                          Expanded(
                                            child: Text(
                                              users[index].name,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w300,
                                                  fontSize: 30),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              5),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(
                                            Icons.card_membership,
                                            color: Colors.white,
                                          ),
                                          SizedBox(
                                            width: 40,
                                          ),
                                          Text(
                                            users[index].event.toString().toUpperCase(),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 23),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              5),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(
                                            Icons.panorama_vertical,
                                            color: Colors.white,
                                          ),
                                          SizedBox(
                                            width: 40,
                                          ),
                                          Text(
                                            users[index].id,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w300,
                                              color: Colors.white,
                                              fontSize: 25,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              5),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(
                                            Icons.phone,
                                            color: Colors.white,
                                          ),
                                          SizedBox(
                                            width: 40,
                                          ),
                                          Text(
                                            users[index].phone,
                                            style:
                                                TextStyle(color: Colors.white, fontSize: 18),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              5),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(
                                            Icons.help_outline,
                                            color: Colors.white,
                                          ),
                                          SizedBox(
                                            width: 40,
                                          ),
                                          Text(
                                            users[index].g,
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              5),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(
                                            Icons.home,
                                            color: Colors.white,
                                          ),
                                          SizedBox(
                                            width: 40,
                                          ),
                                          Text(
                                            users[index].college,
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                    /*
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text('Mail ID: ' + users[index].email),*/
                                    /*SizedBox(
                                      height: MediaQuery.of(context).size.height/5,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: */ /*MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              5*/ /*0),
                                      child: Wrap(
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                        children: <Widget>[
                                          Icon(Icons.monetization_on),
                                          SizedBox(
                                            width: 40,
                                          ),
                                          Text(
                                            users[index].price,
                                            style: TextStyle(
                                              fontSize: 30,
                                              color: Colors.red
                                            ),

                                          ),
                                        ],
                                      ),
                                    ),*/
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              20,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: MediaQuery.of(context).size.height / 1.65,
                        left: MediaQuery.of(context).size.width / 2.8,
                        child: FlatButton(
                          color: Colors.white,
                          child: Text('Scan Another!'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => HomeScreen()));
                return null;
              }
            },
          ),
        ),
      ),
    );
  }
}
