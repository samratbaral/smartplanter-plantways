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
    // required this.name,
    // required this.description,
    this.color = const Color.fromRGBO(
        41, 171, 135, 1.0),
   // this.iconSrc = "assets/icons/code.svg",
    // required this.temperature,
    // required this.soil,
    // required this.humidity,
    // required this.light,
    // required this.water,
  }) : super(key: key);

  final String plantName, potName, potMac;
  final List<String> potConnection;
  final Set<String> potSensorData;

 // final String name, description, iconSrc;
  final Color color;
 // final String soil, temperature, humidity, light, water;

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
                  // name: name,
                  // temperature: temperature,
                  // humidity: humidity,
                  // light: light,
                  // water: water,
                  // iconSrc: iconSrc,
                 /* soil: soil*/);
            },
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            height: 220,
            width: 380,
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.all(Radius.circular(85)),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Text(
                    ' SmartPlanter: $potName ($plantName)', //changed this from name
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                  //SvgPicture.asset(iconSrc),
                  const Padding(
                    padding: EdgeInsets.only(top: 25, bottom: 10),
                    child: Text(
          //                 const potSensor = {
          //   "Low Humidity",
          //   "Low Light",
          //   "Dry Soil",
          //   "Low Level",
          //   "Good Temperature"
          // };
                      //change the temp humid light water to the values and not string
                      "Plant Overview",
                      style: TextStyle(
                        color: Colors.white54,
                      ),
                    ),
                  ),
                  Text(
                  'Soil: ${potSensorData.elementAt(0)}',
                    style: const TextStyle(
                      color: Colors.white54,
                    ),
                  ),
                   Text(
                    'Temperature: ${potSensorData.elementAt(1)}',
                    style: const TextStyle(
                      color: Colors.white54,
                    ),
                  ),
                   Text(
                     'Humidity: ${potSensorData.elementAt(2)}',
                    style: const TextStyle(
                      color: Colors.white54,
                    ),
                  ),
                   Text(
                     'Tank Level: ${potSensorData.elementAt(3)}',
                    style: const TextStyle(
                      color: Colors.white54,
                    ),
                  ),
                   Text(
                     'Sunlight: ${potSensorData.elementAt(4)}',
                    style: const TextStyle(
                      color: Colors.white54,
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
