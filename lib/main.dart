import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Weather App'),
        ),
        body: WeatherWidget(),
      ),
    );
  }
}

class WeatherWidget extends StatefulWidget {
  @override
  _WeatherWidgetState createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  String weather = 'Loading...';

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

Future<void> fetchWeather() async {
  try {
    final response = await http.get(Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?q=Bergen,no&appid=ca602af39dbd3d74f9b0e5b35212144b&units=metric'
    ));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        weather = 'Temperature: ${data['main']['temp']}°C';
      });
    } else {
      setState(() {
        weather = 'Failed to load weather data: ${response.statusCode}';
      });
    }
  } catch (e) {
    setState(() {
      weather = 'Error: $e';
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(weather),
    );
  }
}