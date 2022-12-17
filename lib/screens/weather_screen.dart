import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings, avoid_print, prefer_const_literals_to_create_immutables

class WeatherScreen extends StatefulWidget {
  final String cityName;
  const WeatherScreen({Key? key, required this.cityName}) : super(key: key);

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  String cityName = "Unknown";
  String weatherDescription = "Unknown";
  String title = "Weather";
  String temperature = "0";
  String wind = "0";
  String picLink = '';

  void initState() {
    super.initState();
    fetchWeather();
  }

  void fetchWeather() async {
    Uri uri = Uri.parse('https://api.openweathermap.org/data/2.5/weather?q=' +
        widget.cityName +
        '&&units=metric&appid=074b75db09f642a43b002b9c115ce653');
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      var weatherData = json.decode(response.body);
      setState(() {
        picLink = "http://openweathermap.org/img/w/" +
            weatherData['weather'][0]['icon'] +
            ".png";
        title = "Weather in " + widget.cityName;
        weatherDescription = weatherData['weather'][0]['description'];
        temperature = (weatherData['main']['temp']).toString() + " °C";
        wind = weatherData['wind']['speed'].toString() + " m/s";
        cityName = weatherData['name'];
      });
    }
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
            title: Text(title, style: TextStyle(fontSize: 30)),
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
              child: Column(
                children: [
                  picLink != ""
                      ? Image.network(
                          picLink,
                          fit: BoxFit.fitHeight,
                          height: 120,
                        )
                      : Text("Waiting for an image..."),

                  Padding(padding: const EdgeInsets.only(top: 20)),
                  Text.rich(
                    TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: "Description: ",
                          style: TextStyle(
                            fontFamily: "Serif",
                            fontSize: 20,
                            color: Color.fromARGB(255, 234, 194, 15),
                          ),
                        ),
                        TextSpan(
                          text: weatherDescription,
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

                  Text.rich(
                    TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: "Temperature: ",
                          style: TextStyle(
                            fontFamily: "Serif",
                            fontSize: 20,
                            color: Color.fromARGB(255, 234, 194, 15),
                          ),
                        ),
                        TextSpan(
                          text: temperature,
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

                  Text.rich(
                    TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: "Wind: ",
                          style: TextStyle(
                            fontFamily: "Serif",
                            fontSize: 20,
                            color: Color.fromARGB(255, 234, 194, 15),
                          ),
                        ),
                        TextSpan(
                          text: wind,
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
                  //Image.asset(height: 70, 'images/02d.png'),

                  //Another button to open the 2nd screen
                ],
              ),
            ),
          ),
        ));
  }
}
