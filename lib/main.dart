// @dart=2.9

import 'package:flutter/material.dart';
import 'package:tampere_events/screens/main_screen.dart';
import 'package:tampere_events/screens/country_screen.dart';
import 'package:tampere_events/screens/weather_screen.dart';
import 'dart:convert';
// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings, avoid_print, prefer_const_literals_to_create_immutables

void main() {
  runApp(MaterialApp(
      //theme: new ThemeData(
      //    scaffoldBackgroundColor: Color.fromARGB(255, 221, 72, 72)),
      title: "Countries App",
      initialRoute: '/',
      routes: {
        '/': (context) => const MainScreen(),
        '/country': (context) => const CountryScreen(),
        '/weather': (context) => const WeatherScreen(),
      }));
}
