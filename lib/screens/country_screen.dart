import 'package:flutter/material.dart';
import 'dart:math';
//import 'package:hello_tamk/screens/device_api_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tampere_events/screens/weather_screen.dart';

class CountryScreen extends StatefulWidget {
  final String text;
  final double? lat;
  final double? long;
  const CountryScreen(
      {Key? key, required this.text, required this.lat, required this.long})
      : super(key: key);

  @override
  State<CountryScreen> createState() => _CountryScreenState();
}

class _CountryScreenState extends State<CountryScreen> {
  Map<String, dynamic>? fetchedData;

  String someText = 'loading...';
  String country = 'loading...';
  String capital = 'loading...';
  String language = 'loading...';
  String currency = 'loading...';
  String population = 'loading...';
  String flagLink = '';
  String distance = '0';
  String weatherButtonText = 'Weather';

  void initState() {
    super.initState();
    fetchCountryData();
  }

  double distanceToCountry(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  void fetchCountryData() async {
    Uri uri = Uri.parse(
        'http://restcountries.com/v3.1/name/' + widget.text + '?fullText=true');
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      setState(() {
        var fetchedData = jsonDecode(response.body);
        someText = "Fetched";
        country = fetchedData![0]["name"]["common"];
        capital = fetchedData![0]["capital"][0];
        var language_key = fetchedData![0]["languages"].keys.toList()[0];
        language = fetchedData![0]["languages"][language_key];
        currency = fetchedData![0]["currencies"].keys.toList()[0];
        population =
            (fetchedData![0]["population"] / 1000000).toStringAsFixed(1) +
                " million";
        flagLink = fetchedData![0]["flags"]["png"];

        if (widget.lat != 0) {
          distance = distanceToCountry(
                      widget.lat,
                      widget.long,
                      fetchedData![0]["capitalInfo"]["latlng"][0],
                      fetchedData![0]["capitalInfo"]["latlng"][1])
                  .toStringAsFixed(0) +
              " km";
        } else {
          distance = 'No GPS location yet';
        }
        weatherButtonText = "Weather in " + capital;
        //someText = fetchedData!['list'][2]['main']['temp'].toStringAsFixed(1);
      });
    } else {
      country = "Didn't fetch";
    }
  }

  void _sendDataToWeatherScreen(BuildContext context) {
    // if (capital != "loading...") {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WeatherScreen(cityName: capital),
        ));

    //}
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            appBarTheme: AppBarTheme(
          backgroundColor: Color.fromARGB(255, 137, 166, 193),
          foregroundColor: Color.fromARGB(255, 6, 30, 137),
          //here you can give the text color
        )),
        home: Scaffold(
            appBar: AppBar(
              title: Text("Country", style: TextStyle(fontSize: 30)),
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                iconSize: 20.0,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              centerTitle: true,
            ),
            body: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                      Color(0xFF232a42),
                      Color(0xFF678fb5),
                    ])),
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                child: Align(
                    alignment: Alignment.center,
                    child: Column(children: [
                      //Image.network(flagLink),
                      flagLink != ""
                          ? Image.network(
                              flagLink,
                              fit: BoxFit.fitHeight,
                              height: 120,
                            )
                          : Text("Waiting for an image..."),
                      Padding(
                          padding: const EdgeInsets.only(top: 30, bottom: 20)),

                      Text.rich(
                        TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: "Country: ",
                              style: TextStyle(
                                fontFamily: "Serif",
                                fontSize: 20,
                                color: Color.fromARGB(255, 234, 194, 15),
                              ),
                            ),
                            TextSpan(
                              text: country,
                              style: TextStyle(
                                fontFamily: "Serif",
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 190, 228, 20),
                                fontSize: 24,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(padding: const EdgeInsets.only(top: 20)),
                      //Capital
                      Text.rich(
                        TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: "Capital: ",
                              style: TextStyle(
                                fontFamily: "Serif",
                                fontSize: 20,
                                color: Color.fromARGB(255, 234, 194, 15),
                              ),
                            ),
                            TextSpan(
                              text: capital,
                              style: TextStyle(
                                fontFamily: "Serif",
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 190, 228, 20),
                                fontSize: 24,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(padding: const EdgeInsets.only(top: 20)),

                      //Language
                      Text.rich(
                        TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: "Language: ",
                              style: TextStyle(
                                fontFamily: "Serif",
                                fontSize: 20,
                                color: Color.fromARGB(255, 234, 194, 15),
                              ),
                            ),
                            TextSpan(
                              text: language,
                              style: TextStyle(
                                fontFamily: "Serif",
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 190, 228, 20),
                                fontSize: 24,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(padding: const EdgeInsets.only(top: 20)),

                      //Currency
                      Text.rich(
                        TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: "Currency: ",
                              style: TextStyle(
                                fontFamily: "Serif",
                                fontSize: 20,
                                color: Color.fromARGB(255, 234, 194, 15),
                              ),
                            ),
                            TextSpan(
                              text: currency,
                              style: TextStyle(
                                fontFamily: "Serif",
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 190, 228, 20),
                                fontSize: 24,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(padding: const EdgeInsets.only(top: 20)),

                      //Population
                      Text.rich(
                        TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: "Population: ",
                              style: TextStyle(
                                fontFamily: "Serif",
                                fontSize: 20,
                                color: Color.fromARGB(255, 234, 194, 15),
                              ),
                            ),
                            TextSpan(
                              text: population,
                              style: TextStyle(
                                fontFamily: "Serif",
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 190, 228, 20),
                                fontSize: 24,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(padding: const EdgeInsets.only(top: 20)),

                      //Distance
                      Text.rich(
                        TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: "Distance: ",
                              style: TextStyle(
                                fontFamily: "Serif",
                                fontSize: 20,
                                color: Color.fromARGB(255, 234, 194, 15),
                              ),
                            ),
                            TextSpan(
                              text: distance,
                              style: TextStyle(
                                fontFamily: "Serif",
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 190, 228, 20),
                                fontSize: 24,
                              ),
                            ),
                          ],
                        ),
                      ),

                      //Weather button
                      Padding(
                        padding: const EdgeInsets.only(top: 50, bottom: 0),
                        child: ConstrainedBox(
                          constraints:
                              BoxConstraints.tightFor(width: 200, height: 45),
                          child: ElevatedButton(
                              onPressed: () {
                                _sendDataToWeatherScreen(context);
                              },
                              style: ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll<Color>(
                                      Color.fromARGB(255, 93, 190, 181)),
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          side: BorderSide(
                                              color: Color.fromARGB(
                                                  255, 33, 41, 79))))),
                              child: Text("$weatherButtonText",
                                  style: const TextStyle(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      fontSize: 16))),
                        ),
                      ),
                    ])))));
  }
}
