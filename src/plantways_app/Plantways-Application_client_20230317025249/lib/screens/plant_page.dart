import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_todo/components/stat_card.dart';

class PlantPage extends StatelessWidget {
  const PlantPage({
    super.key,
    required this.plantName,
    required this.potName,
    required this.potMac,
    required this.potConnection,
    required this.potSensorData,
    // required this.name,
    // required this.temperature,
    // required this.humidity,
    // required this.light,
    // required this.water,
    // required this.soil,
   // this.iconSrc = "assets/icons/code.svg",
  });
  final String plantName, potName, potMac;
  final List<String> potConnection;
  final Set<String> potSensorData;
 // final String name, iconSrc;
 // final String soil, temperature, humidity, light, water;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plant Overview'),
        backgroundColor: const Color.fromARGB(255, 130, 197, 91),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    potName, // changed from name
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                //SvgPicture.asset(iconSrc),
              ],
            ),
            const SizedBox(height: 30),
            // StatCard(
            //     soil: soil,
            //     temperature: temperature,
            //     humidity: humidity,
            //     light: light,
            //     water: water),

            // Text(
            //   'Temperature: $temperature',
            //   style: const TextStyle(
            //     fontSize: 20,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
            // const SizedBox(height: 20),
            // Text(
            //   'Humidity: $humidity',
            //   style: const TextStyle(
            //     fontSize: 20,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
            // const SizedBox(height: 20),
            // Text(
            //   'Light: $light',
            //   style: const TextStyle(
            //     fontSize: 20,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
            // const SizedBox(height: 20),
            // Text(
            //   'Water: $water',
            //   style: const TextStyle(
            //     fontSize: 20,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
