import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String selectedCity = 'Bergen'; 

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBarWithDropdown(
          selectedCity: selectedCity,
          onCityChanged: (String newCity) {
            setState(() {
              selectedCity = newCity;
            });
          },
        ),
        body: Center(
          child: WeatherWidget(city: selectedCity), 
        ),
      ),
    );
  }
}

class AppBarWithDropdown extends StatelessWidget implements PreferredSizeWidget {
  final String selectedCity;
  final Function(String) onCityChanged;

  AppBarWithDropdown({required this.selectedCity, required this.onCityChanged});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          Text('Rainy or Sunny'),
          Spacer(),
          DropdownButton<String>(
            value: selectedCity,
            icon: Icon(Icons.arrow_downward, color: Colors.white),
            dropdownColor: Colors.blue,
            underline: SizedBox(),
            items: <String>['Bergen', 'Oslo', 'Stavanger', 'Trondheim', 'Drammen', 'Fredrikstad', 'Skien', 'Kristiansand', 'Tønsberg', 'Ålesund']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, style: TextStyle(color: Colors.black)),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                onCityChanged(newValue); 
              }
            },
          ),
        ],
      ),
    );
  }
}

class WeatherWidget extends StatefulWidget {
  final String city;

  WeatherWidget({required this.city});

  @override
  _WeatherWidgetState createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  String weather = 'Loading...';
  String iconUrl = '';
  String cityName = '';

  @override
  void initState() {
    super.initState();
    fetchWeather(widget.city); 
  }

  @override
  void didUpdateWidget(WeatherWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.city != widget.city) {
      fetchWeather(widget.city); 
    }
  }

  Future<void> fetchWeather(String city) async {
    final apiKey = 'ca602af39dbd3d74f9b0e5b35212144b';
    final url =
        'https://api.openweathermap.org/data/2.5/weather?q=$city,no&appid=$apiKey&units=metric';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final weatherDescription = data['weather'][0]['description'];
      final iconCode = data['weather'][0]['icon'];
      final cityFromResponse = data['name'];

      setState(() {
        cityName = '$cityFromResponse, NO';
        weather = '${data['main']['temp']}°C\n$weatherDescription';
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
    return Container(
      padding: EdgeInsets.all(16),
      width: 300,
      height: 300,
      decoration: BoxDecoration(
        color: Colors.blue[400],
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'Weather for $cityName',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                weather.split("\n")[0],
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              SizedBox(width: 8),
              if (iconUrl.isNotEmpty)
                Image.network(iconUrl, width: 50, height: 50),
            ],
          ),
          Text(
            weather.split("\n")[1],
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ],
      ),
    );
  }
}