import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String selectedCity = '';
  final String key = "3396e5f8efc2a6e94ce253c58e725b69";
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/search.jpg"),
          fit: BoxFit.cover, // Full Arka plan image yapmak
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          //Geri tuşu için
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: TextField(
                  onChanged: (value) {
                    selectedCity = value;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                    hintText: "Şehir Seçiniz",
                    hintStyle:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.normal),
                  ),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      fontFamily: "PoppinsBold"),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  var response = await http.get(Uri.parse(
                      'https://api.openweathermap.org/data/2.5/weather?q=$selectedCity&appid=$key&units=metric&lang=tr'));
                  if (response.statusCode == 200) {
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context, selectedCity);
                  } else {
                    showCustomAlertDialog();
                  }
                },
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.transparent),
                  elevation: MaterialStatePropertyAll(0),
                ),
                child: const Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.navigate_before,
                        size: 50,
                        color: Color.fromARGB(255, 255, 0, 0),
                      ),
                      Text(
                        "Geri Dön",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> showCustomAlertDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // kullanıcı dışarı tıkladığında kapatılmasın
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Warning",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.red, fontSize: 30, fontWeight: FontWeight.bold),
          ),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  "Aradığınız değer bulunamadı tekrar deneyiniz.",
                  style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontFamily: "PoppinsBold",
                      fontSize: 15),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Tamam'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
