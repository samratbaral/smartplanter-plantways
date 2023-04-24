import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../screens/plant_page.dart';

enum MenuOption { edit, delete }

class PlantCard extends StatelessWidget {
  const PlantCard({
    Key? key,
    required this.plantName,
    required this.potName,
    required this.potMac,
    required this.potConnection,
    required this.potSensorData,
    required this.name,
    required this.description,
    this.color = const Color(0xFF7553F6),
    this.iconSrc = "assets/icons/code.svg",
    required this.temperature,
    required this.soil,
    required this.humidity,
    required this.light,
    required this.water,
  }) : super(key: key);

  final String plantName, potName, potMac;
  final List<String> potConnection;
  final Set<String> potSensorData;

  final String name, description, iconSrc;
  final Color color;
  final String soil, temperature, humidity, light, water;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return PlantPage(
                  plantName: plantName,
                  potName: potName,
                  potMac: potMac,
                  potConnection: potConnection,
                  potSensorData: potSensorData,
                  name: name,
                  temperature: temperature,
                  humidity: humidity,
                  light: light,
                  water: water,
                  iconSrc: iconSrc,
                  soil: soil);
            },
          ),
        );
      },
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          height: 220,
          width: 380,
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.all(Radius.circular(65)),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Text(
                  name,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Colors.white, fontWeight: FontWeight.w600),
                ),
                SvgPicture.asset(iconSrc),
                const Padding(
                  padding: EdgeInsets.only(top: 1, bottom: 1),
                  child: Text(
                    //change the temp humid light water to the values and not string
                    "Plants Overview",
                    style: TextStyle(
                      color: Colors.white54,
                    ),
                  ),
                ),
                const Text(
                  "Temperature: 44 F",
                  style: TextStyle(
                    color: Colors.white38,
                  ),
                ),
                const Text(
                  "Humidity : 40%",
                  style: TextStyle(
                    color: Colors.white38,
                  ),
                ),
                const Text(
                  "Light : 10%",
                  style: TextStyle(
                    color: Colors.white38,
                  ),
                ),
                const Text(
                  "Water : 100%",
                  style: TextStyle(
                    color: Colors.white38,
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
