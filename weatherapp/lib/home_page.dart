import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weatherapp/daily_weather_card_page.dart';
import 'package:weatherapp/search_page.dart';
import 'package:http/http.dart' as http;

class WeatherApp extends StatefulWidget {
  const WeatherApp({super.key});

  @override
  State<WeatherApp> createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  String location = "Giresun";
  String ikon = "10d";
  double? temperature;
  int? stasusCode;
  final String key = "3396e5f8efc2a6e94ce253c58e725b69";
  String background = "c";
  Position? devicePosition;
  Position? devicePosition2;
  var weatherData;
  var weatherData2;

  List<String> icons = [];
  List<double> tempatur = [];
  List<String> dates = [];

  Future<void> getWeatherData() async {
    weatherData = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$location&appid=$key&units=metric&lang=tr'));

    final weatherDataParsed = jsonDecode(weatherData.body);

    setState(() {
      temperature = weatherDataParsed['main']['temp'];
      location = weatherDataParsed['name'];
      background = weatherDataParsed['weather'][0]['main'];
      ikon = weatherDataParsed['weather'][0]['icon'];
    });
  }

  Future<void> getWearherDataWithLonLan() async {
    if (devicePosition2 != null) {
      weatherData2 = await http.get(Uri.parse(
          "https://api.openweathermap.org/data/2.5/weather?lat=${devicePosition2!.latitude}&lon=${devicePosition2!.longitude}&appid=$key&units=metric&lang=tr"));
      final weatherDataParsed = jsonDecode(weatherData2.body);
      setState(() {
        temperature = weatherDataParsed['main']['temp'];
        location = weatherDataParsed['name'];
        background = weatherDataParsed['weather'][0]['main'];
        ikon = weatherDataParsed['weather'][0]['icon'];
      });
    }
  }

  Future<void> getDeviceLocation() async {
    try {
      Position devicePosition = await _determinePosition();
      devicePosition2 = devicePosition;
      // ignore: empty_catches
    } catch (e) {}
  }

  Future<void> getFiveDaysData() async {
    var forecastData = await http.get(Uri.parse(
        "https://api.openweathermap.org/data/2.5/forecast?lat=${devicePosition2!.latitude}&lon=${devicePosition2!.longitude}&appid=$key&units=metric"));
    final forecastDataParsed = jsonDecode(forecastData.body);
    print("tempatur2: $tempatur");
    print("icons2: $icons");
    print("dates2: $dates");
    setState(() {
      tempatur.clear();
      icons.clear();
      dates.clear();
      for (int i = 7; i < 40; i = i + 8) {
        tempatur.add(forecastDataParsed['list'][i]['main']['temp']);
        icons.add(forecastDataParsed['list'][i]['weather'][0]['icon']);
        dates.add(forecastDataParsed['list'][i]['dt_txt']);
      }
      print("tempatur: $tempatur");
      print("icons: $icons");
      print("dates: $dates");
    });
  }

  Future<void> getSearchFiveDaysData() async {
    var forecastData = await http.get(Uri.parse(
        "https://api.openweathermap.org/data/2.5/forecast?q=$location&appid=$key&units=metric"));
    final forecastDataParsed = jsonDecode(forecastData.body);

    setState(() {
      tempatur.clear();
      icons.clear();
      dates.clear();
      for (int i = 7; i < 40; i = i + 8) {
        tempatur.add(forecastDataParsed['list'][i]['main']['temp']);
        icons.add(forecastDataParsed['list'][i]['weather'][0]['icon']);
        dates.add(forecastDataParsed['list'][i]['dt_txt']);
      }
      print("tempatur: $tempatur");
      print("icons: $icons");
      print("dates: $dates");
    });
  }

  void initStateData() async {
    await getDeviceLocation();
    await getWearherDataWithLonLan();
    await getFiveDaysData();
  }

  @override
  void initState() {
    initStateData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/$background.jpg"),
          fit: BoxFit.cover, // Full Arka plan image yapmak
        ),
      ),
      child: (temperature == null || devicePosition2 == null)
          ? const Scaffold(
              backgroundColor: Colors.transparent,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(child: CircularProgressIndicator()),
                    Text("Verinin alınması bekleniyor..."),
                  ],
                ),
              ),
            )
          : Scaffold(
              backgroundColor: Colors.transparent,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: 150,
                      child: Image.network(
                          "https://openweathermap.org/img/wn/$ikon@4x.png"),
                    ),
                    Text(
                      "${temperature?.round()}°",
                      style: const TextStyle(
                          fontFamily: "PoppinsBold",
                          fontSize: 50,
                          fontWeight: FontWeight.bold),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          location,
                          style: const TextStyle(
                              fontFamily: "PoppinsBold",
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          onPressed: () async {
                            final selectCity = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SearchPage(),
                              ),
                            );
                            location = selectCity;
                            await getWeatherData();
                            await getSearchFiveDaysData();
                          },
                          icon: const Icon(
                            Icons.search,
                            size: 30,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                    buildWeatherCard(context)
                  ],
                ),
              ),
            ),
    );
  }

  Widget buildWeatherCard(BuildContext context) {
    List<DailyWeatherCard> cards = [];
    for (int i = 0; i < 5; i++) {
      cards.add(
        DailyWeatherCard(
          ikon2: icons[i],
          temperature2: tempatur[i],
          date2: dates[i],
        ),
      );
    }
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.19,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: cards,
      ),
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
}
