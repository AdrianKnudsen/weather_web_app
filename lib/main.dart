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
  String iconUrl = '';
  String cityName = 'Bergen City';

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  Future<void> fetchWeather() async {
    final apiKey = 'ca602af39dbd3d74f9b0e5b35212144b'; 
    final city = 'Bergen,no';
    final url = 'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final weatherDescription = data['weather'][0]['description'];
      final iconCode = data['weather'][0]['icon'];

      setState(() {
        weather = 'Temperature: ${data['main']['temp']}°C\nDescription: $weatherDescription';
        iconUrl = 'http://openweathermap.org/img/wn/$iconCode@2x.png'; 
      });
    } else {
      setState(() {
        weather = 'Failed to load weather data';
        iconUrl = '';
      });
    }
  }

@override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            cityName,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          if (iconUrl.isNotEmpty)
            Image.network(iconUrl, width: 100, height: 100),
          Text(weather, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}