import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tampere_events/screens/country_screen.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/src/widgets/single_child_scroll_view.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  TextEditingController controller = TextEditingController();
  TextEditingController textFieldController = TextEditingController();

  double? latitude = 0;
  double? longitude = 0;

  String noCityName = "";

  var now = new DateTime.now();
  var formatter = new DateFormat('dd.MM.yyyy');
  late String formattedDate = formatter.format(now);

  FocusNode myFocusNode = new FocusNode();

  void startLocation() async {
    if (await Permission.location.request().isGranted) {
      // Either the permission was already granted before or the user just granted it.
      Location location = Location();
      location.onLocationChanged.listen((LocationData currentLocation) {
        setState(() {
          latitude = currentLocation.latitude;
          longitude = currentLocation.longitude;
        });
      });
    }
  }

  void _sendDataToDistanceScreen(BuildContext context) {
    String textToSend = textFieldController.text;
    if (textToSend != "") {
      setState(() {
        noCityName = "";
      });
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CountryScreen(
                text: "$textToSend", lat: latitude, long: longitude),
          ));
    } else {
      setState(() {
        noCityName = "Please enter Country name";
      });
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          appBarTheme: AppBarTheme(
        backgroundColor: Color.fromARGB(255, 164, 191, 215),
        foregroundColor: Color.fromARGB(255, 6, 30, 137),
        //here you can give the text color
      )),
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            "Countries App",
            style: TextStyle(fontSize: 30),
            textAlign: TextAlign.center,
          ),
          centerTitle: true,
        ),
        body: Center(
          child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                    Color(0xFF232a42),
                    Color(0xFF678fb5),
                  ])),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 0),
                    child: Text(
                      "Today: $formattedDate \n",
                      style: const TextStyle(
                          height: 0.8,
                          fontSize: 14,
                          color: Color.fromARGB(255, 254, 254, 254),
                          fontStyle: FontStyle.italic),
                    ),
                  ),
                  Text(
                    "Implemented by Dmitrii Bacherikov, v1.0",
                    style: const TextStyle(
                        height: 0.1,
                        fontSize: 14,
                        color: Color.fromARGB(255, 254, 254, 254),
                        fontStyle: FontStyle.italic),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 15, bottom: 10),
                      child: Container(
                          width: 460,
                          //decoration:
                          //BoxDecoration(color: Color.fromARGB(255, 200, 239, 205)),
                          child: Column(children: [
                            Text(
                              "To use all features, start GPS service",
                              style: const TextStyle(
                                  fontStyle: FontStyle.italic,
                                  height: 1.5,
                                  fontSize: 20,
                                  color: Color.fromARGB(255, 93, 190, 181)),
                            ),
                          ]))),

                  //GPS coordinates
                  Row(children: [
                    Container(
                      margin: const EdgeInsets.all(10.0),
                      width: 10,
                    ),
                    Container(
                        margin: const EdgeInsets.all(10.0),
                        //color: Color.fromARGB(255, 61, 77, 128),
                        width: 150,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 61, 77, 128),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(children: [
                          Text('Latitude',
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 93, 158, 233),
                                  fontSize: 20)),
                          Padding(
                              padding: EdgeInsets.fromLTRB(0, 15, 0,
                                  0), //apply padding to all four sides
                              child: Text("$latitude",
                                  style: const TextStyle(
                                      color: Color.fromARGB(255, 189, 206, 245),
                                      fontSize: 20)))
                        ])),
                    Container(
                      margin: const EdgeInsets.all(10.0),
                      width: 0,
                    ),
                    Container(
                        margin: const EdgeInsets.all(10.0),
                        //color: Color.fromARGB(255, 61, 77, 128),
                        width: 150,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 61, 77, 128),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(children: [
                          Text('Longitude',
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 93, 158, 233),
                                  fontSize: 20)),
                          Padding(
                              padding: EdgeInsets.fromLTRB(0, 15, 0,
                                  0), //apply padding to all four sides
                              child: Text("$longitude",
                                  style: const TextStyle(
                                      color: Color.fromARGB(255, 189, 206, 245),
                                      fontSize: 20)))
                        ])),
                  ]),

                  //Button and checkbox in one row
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.fromLTRB(20, 10, 10, 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ConstrainedBox(
                          constraints:
                              BoxConstraints.tightFor(width: 180, height: 45),
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll<Color>(
                                        Color.fromARGB(255, 93, 190, 181)),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25),
                                        side: BorderSide(
                                            color: Color.fromARGB(
                                                255, 33, 41, 79))))),
                            onPressed: () {
                              startLocation();
                            },
                            child: Text("Start GPS service",
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontSize: 16)),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(10.0),
                          width: 20,
                        ),
                        (latitude != 0)
                            ? Container(
                                margin: const EdgeInsets.all(10.0),
                                color: Color.fromARGB(255, 50, 234, 13),
                                width: 30,
                                height: 30,
                              )
                            : Container(
                                margin: const EdgeInsets.all(10.0),
                                color: Color.fromARGB(255, 234, 39, 13),
                                width: 30,
                                height: 30,
                              ),
                      ],
                    ),
                  ),

                  //After the button with checkbox
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                            color: Color.fromARGB(255, 146, 235, 225))),
                    child: TextField(
                      style: const TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 16),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: "Enter country name",
                          labelStyle: TextStyle(
                              color: myFocusNode.hasFocus
                                  ? Color.fromARGB(255, 132, 192, 242)
                                  : Color.fromARGB(255, 119, 240, 228))),
                      controller: textFieldController,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(noCityName,
                        style: const TextStyle(
                            color: Color.fromARGB(255, 234, 81, 81),
                            fontStyle: FontStyle.italic,
                            fontSize: 20)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 0),
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints.tightFor(width: 180, height: 45),
                      child: ElevatedButton(
                          onPressed: () {
                            _sendDataToDistanceScreen(context);
                          },
                          style: ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll<Color>(
                                  Color.fromARGB(255, 93, 190, 181)),
                              shape:
                                  MaterialStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          side: BorderSide(
                                              color: Color.fromARGB(
                                                  255, 33, 41, 79))))),
                          child: Text("Show info",
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  fontSize: 16))),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
