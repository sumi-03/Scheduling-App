import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:my_project/secret/secrets.dart';
import 'package:my_project/const/colors.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherInfo extends StatefulWidget {
  const WeatherInfo({Key? key}) : super(key: key);

  @override
  _WeatherInfoState createState() => _WeatherInfoState();
}

class _WeatherInfoState extends State<WeatherInfo> {
  String temperature = '';
  String description = '';
  String cityName = '';

  @override
  void initState() {
    super.initState();
    getLocationAndWeather();
  }

  Future<void> getLocationAndWeather() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 위치 서비스가 활성화되어 있는지 확인
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // 사용자에게 위치 서비스를 활성화하라는 안내 대화 상자를 표시
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Location Services Disabled'),
            content: const Text('Please enable location services.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(); // 대화 상자 닫기
                },
              ),
            ],
          );
        },
      );
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission(); //이 부분에서 팝업창이 뜸
      if (permission == LocationPermission.denied) {
        // 권한이 거부되었다는 메시지를 표시
        _showPermissionDialog(context, 'Location permissions are denied');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showPermissionDialog(context,
          'Location permissions are permanently denied, we cannot request permissions.');
      return;
    }

    // 권한이 허용되었을 때의 로직 실행
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    await getWeather(position.latitude, position.longitude);
  }

  void _showPermissionDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Permission Denied'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('Settings'),
              onPressed: () {
                openAppSettings(); // 앱 설정 페이지 열기
                Navigator.of(context).pop(); // 대화 상자 닫기
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> getWeather(double lat, double lon) async {
    final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(
        () {
          temperature = data['main']['temp'].toString();
          description = data['weather'][0]['description'];
          cityName = data['name'];
        },
      );
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  @override
  Widget build(BuildContext context) {
    final textStyle1 = TextStyle(
        fontWeight: FontWeight.w800, color: deepGreenColor, fontSize: 15.0);
    final textStyle2 = TextStyle(
        fontWeight: FontWeight.w800, color: deepPinkColor, fontSize: 25.0);
    final textStyle3 = TextStyle(
        fontWeight: FontWeight.w800, color: blackColor, fontSize: 15.0);

    return Container(
      margin: const EdgeInsets.all(20.0),
      child: temperature.isEmpty
          ? null
          : Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    cityName,
                    textAlign: TextAlign.center,
                    style: textStyle1,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    '$temperature°C',
                    textAlign: TextAlign.center,
                    style: textStyle2,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    description,
                    textAlign: TextAlign.center,
                    style: textStyle3,
                  ),
                ),
              ],
            ),
    );
  }
}
