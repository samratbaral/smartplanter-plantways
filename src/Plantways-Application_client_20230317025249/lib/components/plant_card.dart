import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../screens/plant_page.dart';

class PlantCard extends StatelessWidget {
  const PlantCard({
    Key? key,
    required this.name,
    required this.description,
    this.color = const Color(0xFF7553F6),
    this.iconSrc = "assets/icons/code.svg",
    required this.temperature,
    required this.humidity,
    required this.light,
    required this.water,
  }) : super(key: key);

  final String name, description, iconSrc;
  final Color color;
  final String temperature, humidity, light, water;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return PlantPage(
                name: name,
                temperature: temperature,
                humidity: humidity,
                light: light,
                water: water,
                iconSrc: iconSrc,
              );
            },
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        height: 180,
        width: 380,
        decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.all(Radius.circular(50)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 6, right: 8),
                child: Column(
                  children: [
                    Text(
                      name,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 12, bottom: 8),
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
                    // const Spacer(),
                    // Row(
                    //   children: List.generate(
                    //     2,(index) => Transform.translate(
                    //       offset: Offset((-10 * index).toDouble(), 0),
                    //       child: CircleAvatar(
                    //         radius: 27,
                    //         backgroundImage: AssetImage(
                    //           "assets/Sensors/Test/Sensor ${index + 1}.png",
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
            SvgPicture.asset(iconSrc),
          ],
        ),
      ),
    );
  }
}
