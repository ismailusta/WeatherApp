import 'package:flutter/material.dart';

class DailyWeatherCard extends StatelessWidget {
  const DailyWeatherCard({
    super.key,
    required this.ikon2,
    required this.temperature2,
    required this.date2,
  });
  final String ikon2;
  final double temperature2;
  final String date2;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      child: SizedBox(
        width: 100,
        child: Column(
          children: <Widget>[
            Image.network("https://openweathermap.org/img/wn/$ikon2.png"),
            Text(
              "${temperature2.round()}°",
              style: const TextStyle(
                fontFamily: "PoppinsBold",
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(date2),
          ],
        ),
      ),
    );
  }
}
